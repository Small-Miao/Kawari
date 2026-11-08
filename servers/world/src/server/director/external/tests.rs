//! C# 桥接的批次原子性、协议边界和真实子进程回归。
use super::*;

fn director() -> DirectorData {
    super::super::tests::director()
}
fn op(method: &str, args: Json) -> Operation {
    Operation {
        method: method.into(),
        args: args.as_array().unwrap().clone(),
    }
}
fn spawn() -> Operation {
    op(
        "spawn_actor",
        json!(["actor",{"base":9020,"name":1,"hp":10000,"pos":{"x":100,"y":0,"z":100}}]),
    )
}

#[test]
fn batch_validation_is_atomic_and_resolves_new_actors() {
    let mut d = director();
    let batch = vec![
        spawn(),
        op("set_targetable", json!([{"actor":"actor"},true])),
    ];
    let draft = prepare(&d, &batch, false).unwrap();
    assert!(d.helpers.is_empty() && d.tasks.is_empty());
    d.apply_lua_director(draft);
    assert!(d.helpers.contains_key("actor"));
    let before = d.helpers.clone();
    let tasks = d.tasks.len();
    assert!(
        prepare(
            &d,
            &[
                spawn(),
                op("set_targetable", json!([{"actor":"missing"},true]))
            ],
            false
        )
        .is_err()
    );
    assert_eq!(d.helpers, before);
    assert_eq!(d.tasks.len(), tasks);
    assert!(
        prepare(
            &d,
            &[op("move_actor", json!([1,{"x":1e99,"y":0,"z":0},0,true]))],
            false
        )
        .is_err()
    );
}

#[test]
fn reply_rejects_wrong_sequence_unbounded_or_unknown_operations() {
    let mut reply = Reply {
        version: 1,
        seq: 2,
        commands: vec![],
        state: Json::Null,
    };
    assert!(validate_reply(&reply, 1).is_err());
    reply.seq = 1;
    reply.commands.push(op("execute_lua", json!(["invalid"])));
    assert!(validate_reply(&reply, 1).is_err());
    reply.commands = vec![spawn(); 4097];
    assert!(validate_reply(&reply, 1).is_err());
    reply.commands = vec![spawn()];
    assert!(validate_reply(&reply, 1).is_ok());
}

#[test]
fn reset_discards_old_reply_and_stop_drops_queues() {
    let mut c = Controller::new(Config {
        executable: "missing".into(),
        args: vec![],
        flag: 0,
    });
    c.event(json!({"kind":"death"}));
    c.stop();
    assert!(c.events.is_empty() && c.pending.is_none() && c.stopped);
    c.event(json!({"kind":"death"}));
    assert!(c.events.is_empty());
    c.reset();
    assert!(!c.stopped && !c.ready);
}

#[test]
fn encounter_tick_polls_external_before_battle() {
    let mut d = director();
    // 显式错误能确认外层真实 tick 已调用控制器，避免仅测试内部轮询遗漏启动门槛。
    d.external = Some(Controller::disabled("entry-poll-probe".into()));
    let mut instance = Instance {
        director: Some(d),
        ..Default::default()
    };
    let player = ObjectId(1);
    instance.insert_empty_actor(player);
    let common = instance
        .find_actor_mut(player)
        .unwrap()
        .get_common_spawn_mut();
    common.health_points = 1000;
    common.max_health_points = 1000;
    encounter_tick(&mut instance, Instant::now());
    let d = instance.director.as_ref().unwrap();
    assert!(
        matches!(d.vars.get("controller.error"), Some(EncounterVar::Str(value)) if value == "entry-poll-probe")
    );
    assert!(d.battle_started_at.is_none());
}

#[test]
#[ignore = "需要 Release C# 宿主；从真实 encounter_tick 验证五绝入场木桩"]
fn real_instance_entry_initializes_all_five_dummies_before_combat() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    for content in ["d2az", "z3oy", "r1fz", "n4gw", "z3oz"] {
        let config = Config {
            executable: root
                .join("controllers/EncounterHost/bin/Release/net10.0/EncounterHost.exe")
                .to_string_lossy()
                .into(),
            args: vec![
                "--definitions".into(),
                root.join("resources/encounters/Definitions")
                    .to_string_lossy()
                    .into(),
                "--content".into(),
                content.into(),
            ],
            flag: 1,
        };
        let mut d = director();
        d.external = Some(Controller::new(config));
        let mut instance = Instance {
            director: Some(d),
            ..Default::default()
        };
        encounter_tick(&mut instance, Instant::now());
        assert!(
            instance
                .director
                .as_ref()
                .unwrap()
                .external
                .as_ref()
                .unwrap()
                .worker
                .is_none(),
            "空实例不得启动进程"
        );
        let player = ObjectId(1);
        instance.insert_empty_actor(player);
        {
            let common = instance
                .find_actor_mut(player)
                .unwrap()
                .get_common_spawn_mut();
            common.health_points = 10000;
            common.max_health_points = 10000;
            common.position = Position(Vec3::new(100.0, 0.0, 80.0));
        }
        encounter_tick(&mut instance, Instant::now());
        assert!(
            instance
                .director
                .as_ref()
                .unwrap()
                .external
                .as_ref()
                .unwrap()
                .worker
                .is_some(),
            "{content} 入场没有启动 C#，不能等待尚未生成的木桩开战"
        );
        let wait_for_dummy = |instance: &mut Instance| {
            let deadline = Instant::now() + Duration::from_secs(30);
            loop {
                encounter_tick(instance, Instant::now());
                let d = instance.director.as_ref().unwrap();
                assert!(
                    !d.vars.contains_key("controller.error"),
                    "{content}: {:?}",
                    d.vars
                );
                if let Some(id) = d.helpers.get("trigger") {
                    return *id;
                }
                assert!(Instant::now() < deadline, "{content} 木桩生成超时");
                std::thread::sleep(Duration::from_millis(10));
            }
        };
        let dummy = wait_for_dummy(&mut instance);
        let d = instance.director.as_ref().unwrap();
        assert!(d.battle_started_at.is_none());
        assert_eq!(d.elapsed_secs, 0.0);
        assert!(d.tasks.iter().any(|task| matches!(task, LuaDirectorTask::SpawnScriptActor(actor) if actor.id == dummy && actor.base == 11744 && actor.visible && actor.targetable && actor.hp > 0)));
        assert!(
            d.tasks
                .iter()
                .any(|task| matches!(task, LuaDirectorTask::ArmHitTrigger(id) if *id == dummy))
        );
        assert!(
            d.tasks
                .iter()
                .any(|task| matches!(task, LuaDirectorTask::SetupMapEffects { .. }))
        );
        // 重置后仍未开战，也必须继续轮询以创建新木桩；手动停止则不得自行重启。
        if content == "d2az" {
            instance
                .director
                .as_mut()
                .unwrap()
                .controller_command("reset");
            assert_ne!(wait_for_dummy(&mut instance), dummy);
            instance
                .director
                .as_mut()
                .unwrap()
                .controller_command("stop");
            encounter_tick(&mut instance, Instant::now());
            let d = instance.director.as_ref().unwrap();
            assert!(d.helpers.is_empty() && d.external.as_ref().unwrap().worker.is_none());
        }
    }
}

#[test]
#[ignore = "先运行 EncounterHost.Tests，验证生成的所有实际原生批次"]
fn validate_csharp_full_encounter_trace() {
    let path = Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../target/ultimate-analysis/csharp-commands.jsonl");
    let mut d = director();
    let mut count = 0;
    for (line, text) in BufReader::new(std::fs::File::open(path).unwrap())
        .lines()
        .enumerate()
    {
        let text = text.unwrap();
        if text.is_empty() {
            d = director();
            continue;
        }
        let reply: Reply = serde_json::from_str(&text).unwrap();
        validate_reply(&reply, reply.seq).unwrap();
        let draft = prepare(&d, &reply.commands, false)
            .unwrap_or_else(|e| panic!("第 {} 行原生批次无效: {e}", line + 1));
        d.apply_lua_director(draft);
        d.tasks.clear();
        count += 1;
    }
    assert!(count > 50000, "应完整验证所有单人及八人时间轴");
}

fn until(d: &mut DirectorData, condition: impl Fn(&DirectorData) -> bool) {
    let deadline = Instant::now() + Duration::from_secs(45);
    loop {
        d.advance_external(Instant::now());
        if condition(d) {
            return;
        }
        assert!(
            !d.vars.contains_key("controller.error"),
            "控制器失败: {:?}",
            d.vars
        );
        assert!(Instant::now() < deadline, "等待 C# 实例超时");
        std::thread::sleep(Duration::from_millis(10));
    }
}

#[test]
#[ignore = "需要先构建 Release C# 宿主；实际编译九条时间轴并验证重载、重置、停止"]
fn real_host_initializes_resets_and_keeps_old_worker_on_bad_reload() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let config = Config {
        executable: root
            .join("controllers/EncounterHost/bin/Release/net10.0/EncounterHost.exe")
            .to_string_lossy()
            .into(),
        args: vec![
            "--definitions".into(),
            root.join("resources/encounters/Definitions")
                .to_string_lossy()
                .into(),
            "--content".into(),
            "z3oz".into(),
        ],
        flag: 1,
    };
    let mut d = director();
    d.external = Some(Controller::new(config));
    until(&mut d, |d| d.external.as_ref().unwrap().ready);
    assert!(d.helpers.contains_key("trigger"));
    let original = d
        .external
        .as_ref()
        .unwrap()
        .worker
        .as_ref()
        .unwrap()
        .child
        .lock()
        .id();
    let actors = d.helpers.clone();
    // 无效目录只影响候选进程，当前实例应继续响应。
    let mut invalid = d.external.as_ref().unwrap().config.clone();
    invalid.args[1] = root.join("target/does-not-exist").to_string_lossy().into();
    d.external.as_mut().unwrap().candidate = Some(Box::new(Controller::new(invalid)));
    until(&mut d, |d| d.vars.contains_key("controller.reload_error"));
    assert_eq!(
        d.external
            .as_ref()
            .unwrap()
            .worker
            .as_ref()
            .unwrap()
            .child
            .lock()
            .id(),
        original
    );
    assert_eq!(actors, d.helpers);
    assert!(d.controller_command("status").contains("重载失败"));
    d.controller_command("reset");
    assert!(!d.helpers.contains_key("trigger"));
    until(&mut d, |d| d.helpers.contains_key("trigger"));
    assert_ne!(actors.get("trigger"), d.helpers.get("trigger"));
    d.controller_command("reload");
    until(&mut d, |d| d.external.as_ref().unwrap().candidate.is_none());
    assert_ne!(
        d.external
            .as_ref()
            .unwrap()
            .worker
            .as_ref()
            .unwrap()
            .child
            .lock()
            .id(),
        original
    );
    assert!(d.helpers.contains_key("trigger"));
    d.controller_command("stop");
    assert!(d.helpers.is_empty());
    assert!(d.external.as_ref().unwrap().worker.is_none());
}
