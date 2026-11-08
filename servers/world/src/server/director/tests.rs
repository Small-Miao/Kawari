//! 无需游戏数据或在线玩家的副本生命周期与 Lua 兼容性回归。
use super::*;

pub(super) fn director() -> DirectorData {
    DirectorData {
        external: None,
        script_path: None,
        runtime: Default::default(),
        id: Default::default(),
        flag: 0,
        data: [0; 10],
        lua: KawariLua(Lua::new()),
        tasks: vec![],
        bosses: HashMap::new(),
        shortcut_poprange_id: None,
        battle_started_at: None,
        pending_battle_start: false,
        elapsed_secs: 0.0,
        last_tick_at: None,
        scheduler: vec![],
        deaggro_since: None,
        vars: HashMap::new(),
        player_vars: HashMap::new(),
        helpers: HashMap::new(),
        omen_helpers: vec![],
        omen_rr: 0,
        clones: vec![],
        current_actors: vec![],
    }
}

fn actors() -> (Instance, ObjectId, ObjectId) {
    let mut instance = Instance {
        director: Some(director()),
        ..Default::default()
    };
    let (source, player) = (ObjectId(1), ObjectId(2));
    for id in [source, player] {
        instance.insert_empty_actor(id);
        let common = instance.find_actor_mut(id).unwrap().get_common_spawn_mut();
        common.health_points = 1000;
        common.max_health_points = 1000;
    }
    let common = instance
        .find_actor(source)
        .unwrap()
        .get_common_spawn()
        .clone();
    instance.actors.insert(
        source,
        NetworkedActor::Npc {
            state: NpcState::Stay,
            navmesh_path: Default::default(),
            navmesh_path_lerp: 0.0,
            navmesh_target: None,
            last_position: None,
            spawn_position: Vec3::ZERO,
            spawn: SpawnNpc {
                common,
                ..Default::default()
            },
            timeline: kawari::common::Timeline {
                autoattack_action_id: 0,
                timeline_always_plays: false,
                timepoints: vec![],
                on_death: vec![],
            },
            timeline_position: 0,
            hate_list: HashMap::new(),
            currently_invulnerable: false,
            ai_paused: false,
            targetable: true,
            visible: true,
            cast_locked: false,
            status_effects: Default::default(),
        },
    );
    (instance, source, player)
}

fn pending(instance: &Instance, source: ObjectId) -> PendingAoe {
    PendingAoe {
        rules: Default::default(),
        guard: Some(
            instance
                .director
                .as_ref()
                .unwrap()
                .runtime
                .guard(source, source),
        ),
        completes_cast: false,
        cast_token: None,
        omen_caster: None,
        omen_token: None,
        shape: AoeShape::Everyone,
        origin: Default::default(),
        rotation: 0.0,
        delay: 1.0,
        action_id: 18470,
        damage: 100,
        source_id: source,
        effect_source: None,
    }
}

#[test]
fn ultimate_replays_have_complete_action_classification_and_execute_lua_timeline() {
    let root =
        std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../resources/scripts/content");
    for content in ["r1fz", "n4gw", "z3oz"] {
        let d = director();
        let evidence=std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../tools/ultimate-evidence");
        d.lua.0.globals().set("EVIDENCE_DIR",evidence.to_string_lossy().replace('\\', "/")).unwrap();
        d.lua
            .0
            .globals()
            .set("CONTENT_DIR", root.to_string_lossy().replace('\\', "/"))
            .unwrap();
        d.lua.0.load(format!(r#"
            local data=dofile(EVIDENCE_DIR..'/{content}_data.lua')
            local rules=dofile(CONTENT_DIR..'/ultimate/{content}_rules.lua')
            local seen={{}}
            for _,e in ipairs(data.events) do
                if e.action then assert(rules.actions[e.action], '未分类 '..e.action);seen[e.action]=true end
            end
            assert(#data.events>500)
            dofile(CONTENT_DIR..'/{content}.lua')
        "#)).exec().unwrap();
        let mut ld = d.create_lua_director();
        for (i, job) in [19, 21, 24, 28, 20, 22, 23, 25].into_iter().enumerate() {
            ld.actors.push(ActorSnapshot {
                id: ObjectId(100 + i as u32),
                enmity: vec![],
                is_player: true,
                is_boss: false,
                position: Position(Vec3::new(90.0 + i as f32 * 2.0, 0.0, 102.0)),
                rotation: 0.0,
                hp: 100000,
                max_hp: 100000,
                class_job: job,
                target: ObjectId::default(),
            });
        }
        let call = |ld: &mut LuaDirector, name: &str, t: f64| {
            d.lua
                .0
                .scope(|scope| {
                    let ud = scope.create_userdata_ref_mut(ld)?;
                    let f: Function = d.lua.0.globals().get(name)?;
                    if name == "onTick" {
                        f.call::<()>((ud, 0.125, t))
                    } else {
                        f.call::<()>(ud)
                    }
                })
                .unwrap();
        };
        let drain = |ld: &mut LuaDirector| {
            let tasks = std::mem::take(&mut ld.tasks);
            for task in &tasks {
                match task {
                    LuaDirectorTask::SpawnScriptActor(a) => {
                        if a.boss && a.base != 11744 {
                            assert!(a.layout > 1_000_000 && a.layout != a.base);
                            assert!(a.model.is_some_and(|m| m > 0));
                        }
                        ld.actors.push(ActorSnapshot {
                            id: a.id,
                            enmity: vec![ObjectId(100), ObjectId(101)],
                            is_player: false,
                            is_boss: a.boss,
                            position: a.position,
                            rotation: a.rotation,
                            hp: a.hp,
                            max_hp: a.hp,
                            class_job: 0,
                            target: ObjectId(100),
                        });
                    }
                    LuaDirectorTask::DespawnActor { actor_id } => {
                        ld.actors.retain(|a| a.id != *actor_id)
                    }
                    LuaDirectorTask::MoveActor {
                        actor_id,
                        position,
                        rotation,
                    } => {
                        if let Some(a) = ld.actors.iter_mut().find(|a| a.id == *actor_id) {
                            a.position = *position;
                            a.rotation = *rotation;
                        }
                    }
                    _ => {}
                }
            }
            tasks
        };
        call(&mut ld, "onSetup", 0.0);
        assert_eq!(ld.flag, 1, "录像的 Director 初始化标志必须保留");
        let expected_maps: Vec<Vec<u16>> = d
            .lua
            .0
            .load(format!(
                r#"
            local data=dofile(EVIDENCE_DIR..'/{content}_data.lua')
            local result={{}}
            for _,e in ipairs(data.initial_maps) do
                assert(e.recording_ms < data.start_ms)
                result[#result+1]={{e.index,e.state,e.timeline}}
            end
            return result
        "#
            ))
            .eval()
            .unwrap();
        let actual_maps: Vec<_> = ld
            .tasks
            .iter()
            .filter_map(|t| match t {
                LuaDirectorTask::MapEffect {
                    index,
                    state,
                    timeline_id,
                } => Some(vec![*index as u16, *state, *timeline_id]),
                _ => None,
            })
            .collect();
        assert_eq!(
            actual_maps, expected_maps,
            "{content} 入场必须只恢复转场前快照"
        );
        assert!(!ld.tasks.iter().any(|t| matches!(
            t,
            LuaDirectorTask::ScriptDirectorEvent { .. }
                | LuaDirectorTask::CastBar { .. }
                | LuaDirectorTask::ResolveAoe(_)
        )));
        assert!(
            drain(&mut ld)
                .iter()
                .any(|t| matches!(t, LuaDirectorTask::ArmHitTrigger(_)))
        );
        call(&mut ld, "onTick", 999.0);
        assert!(
            drain(&mut ld).is_empty(),
            "{content} 未触发木桩不得播放过场"
        );
        call(&mut ld, "onBattleStart", 0.0);
        assert!(
            drain(&mut ld)
                .iter()
                .any(|t| matches!(t, LuaDirectorTask::DespawnActor { .. }))
        );
        let mut hits = 0;
        let mut maps = 0;
        let mut casts = 0;
        let mut presentations = 0;
        let mut delayed_omens = 0;
        let mut weather_changes = 0;
        let mut synchronized_timelines = 0;
        let mut object_spawns = 0;
        let mut object_animations = 0;
        let mut live_objects = std::collections::HashSet::new();
        let mut callbacks: Vec<PendingSchedule> = vec![];
        let mut fired_callbacks = 0;
        for tick in 0..3200 {
            let time = tick as f64 / 8.0;
            ld.elapsed_secs = time;
            callbacks.append(&mut ld.pending_schedule);
            let (due, future): (Vec<_>, Vec<_>) = callbacks
                .into_iter()
                .partition(|event| event.at_secs <= time);
            callbacks = future;
            for event in due {
                assert!(event.repeat.is_none());
                let callback: Function = d.lua.0.registry_value(&event.callback).unwrap();
                d.lua
                    .0
                    .scope(|scope| callback.call::<()>(scope.create_userdata_ref_mut(&mut ld)?))
                    .unwrap();
                d.lua.0.remove_registry_value(event.callback).unwrap();
                fired_callbacks += 1;
            }
            call(&mut ld, "onTick", time);
            for task in drain(&mut ld) {
                match task {
                    LuaDirectorTask::SendActorControl {
                        actor_id, category: ActorControlCategory::EObjAnimation { .. },
                    } => {
                        assert!(live_objects.contains(&actor_id), "物件动画必须引用本实例已生成物件");
                        object_animations += 1;
                    }
                    LuaDirectorTask::SpawnScriptObject(object) => {
                        object_spawns += 1;
                        assert!(live_objects.insert(object.entity_id));
                        assert_eq!(object.base_id, 0x1EBBF7);
                        assert_eq!(object.extra_flags, 4);
                        assert_eq!(object.args1, 4);
                        assert!(object.position.0.is_finite());
                    }
                    LuaDirectorTask::DespawnActor { actor_id } => {
                        live_objects.remove(&actor_id);
                    }
                    LuaDirectorTask::ResolveAoe(a) => {
                        assert!(a.origin.0.is_finite());
                        assert!(a.rotation.is_finite());
                        if a.damage > 0 {
                            hits += 1;
                        }
                    }
                    LuaDirectorTask::MapEffect { index, state, timeline_id } => {
                        if content == "z3oz" {
                            assert!(!(12..=19).contains(&index) || (state, timeline_id) != (4, 8),
                                "陨石未死亡时不得按录像时间播放爆碎");
                        }
                        maps += 1;
                    }
                    LuaDirectorTask::CastBar {
                        omen_delay,
                        position,
                        spell_id,
                        ..
                    } => {
                        casts += 1;
                        assert!(position.is_some_and(|p| p.0.is_finite()));
                        assert!(spell_id.is_some());
                        if omen_delay > 0 {
                            delayed_omens += 1;
                        }
                    }
                    LuaDirectorTask::SetWeather { .. } => weather_changes += 1,
                    LuaDirectorTask::ScriptDirectorEvent { .. } => presentations += 1,
                    LuaDirectorTask::PlayActorTimelines { actors, timelines } => {
                        synchronized_timelines += 1;
                        for (actor, timeline) in actors
                            .into_iter()
                            .zip(timelines)
                            .take_while(|(a, _)| *a != ObjectId::default())
                        {
                            assert!(
                                ld.actors.iter().any(|a| a.id == actor),
                                "演出演员必须已生成"
                            );
                            assert!(timeline > 0);
                        }
                    }
                    LuaDirectorTask::SendActorControl {
                        category: ActorControlCategory::HideActor {},
                        ..
                    } => {
                        panic!("三本录像没有 415，不能在读条前自行隐藏演员");
                    }
                    _ => {}
                }
            }
        }
        assert!(hits > 100, "{content} hit count {hits}");
        assert!(live_objects.is_empty(), "{content} 场景物件必须按录像删除");
        assert_eq!(object_spawns, if content == "n4gw" { 18 } else { 0 });
        assert_eq!(object_animations, if content == "n4gw" { 54 } else { 0 });
        assert!(casts > 10, "{content}");
        assert!(presentations > 2, "{content}");
        assert_eq!(
            synchronized_timelines,
            if content == "r1fz" { 2 } else { 1 },
            "{content} 必须播放原录像的同步转场动画"
        );
        assert!(
            delayed_omens > 0 && weather_changes > 0,
            "{content} 预兆与场景天气不能丢失"
        );
        assert!(callbacks.is_empty() && ld.pending_schedule.is_empty());
        if content == "z3oz" {
            assert_eq!(fired_callbacks, 3, "潜能转换、小彗星和大陨石独立结算");
            let effects: mlua::Table = d.lua.0.load(
                "return dofile(EVIDENCE_DIR..'/z3oz_data.lua').death_effects"
            ).eval().unwrap();
            let mut count = 0;
            for pair in effects.pairs::<String, mlua::Table>() {
                let (key, effect) = pair.unwrap();
                let actor = ld.helpers[&key];
                let index: u8 = effect.get("index").unwrap();
                for repeated in [false, true] {
                    d.lua.0.scope(|scope| {
                        let f: Function = d.lua.0.globals().get("onActorDeath")?;
                        // 小怪回调参数是布局键而非 BNpcBase；必须通过实例演员 ID 识别。
                        f.call::<()>((scope.create_userdata_ref_mut(&mut ld)?, 9561321_u32, Position::default(), actor.0))
                    }).unwrap();
                    let events = drain(&mut ld);
                    if repeated { assert!(events.is_empty()); }
                    else { assert!(matches!(&events[..], [LuaDirectorTask::MapEffect { index: i, state: 4, timeline_id: 8 }] if *i == index)); }
                }
                count += 1;
            }
            assert_eq!(count, 8, "两颗陨石和六颗彗星分别关联破坏效果");
        }
        if content != "r1fz" {
            assert!(maps > 0, "{content}");
        }
        ld.helpers.clear();
        ld.actors.retain(|a| a.is_player);
        call(&mut ld, "onReset", 0.0);
        assert!(
            drain(&mut ld)
                .iter()
                .any(|t| matches!(t, LuaDirectorTask::ArmHitTrigger(_)))
        );
    }
}

#[test]
fn director_flag_change_without_variable_change_is_synchronized() {
    let mut d = director();
    let mut ld = d.create_lua_director();
    ld.flag = 1;
    d.apply_lua_director(ld);
    assert_eq!(d.flag, 1);
    assert!(matches!(
        d.tasks.as_slice(),
        [LuaDirectorTask::SendVariables]
    ));
    assert_eq!(d.create_lua_director().flag, 1);
    assert!(matches!(
        d.build_var_segment().data,
        ServerZoneIpcData::DirectorVars { flag: 1, .. }
    ));
    d.tasks.clear();
    d.apply_lua_director(d.create_lua_director());
    assert!(d.tasks.is_empty());
}

#[test]
fn explicit_cast_destination_and_target_survive_lua_conversion() {
    let d = director();
    let mut ld = d.create_lua_director();
    d.lua
        .0
        .scope(|scope| {
            d.lua
                .0
                .globals()
                .set("d", scope.create_userdata_ref_mut(&mut ld)?)?;
            d.lua
                .0
                .load("d:begin_cast(12, 28060, 6.6, 34, 20, {x=91,y=2,z=109}, 28061)")
                .exec()
        })
        .unwrap();
    assert!(matches!(ld.tasks.as_slice(), [LuaDirectorTask::CastBar {
        source_id: ObjectId(12), action_id: 28060, target_id: ObjectId(34),
        omen_delay: 20, spell_id: Some(28061), position: Some(p), ..
    }] if p.0 == Vec3::new(91.0,2.0,109.0)));
}

#[test]
fn tower_failure_and_sharing_use_current_positions() {
    let (mut instance, source, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let mut a = pending(&instance, source);
    a.shape = AoeShape::Circle { radius: 3.0 };
    a.origin = Position(Vec3::new(50.0, 0.0, 50.0));
    a.rules.min_players = 2;
    a.rules.max_players = Some(2);
    a.rules.failure_damage = 500;
    resolve_aoe(network.clone(), &mut instance, a);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        500
    );
    instance.insert_empty_actor(ObjectId(3));
    let p = instance
        .find_actor_mut(ObjectId(3))
        .unwrap()
        .get_common_spawn_mut();
    p.health_points = 1000;
    p.max_health_points = 1000;
    let mut a = pending(&instance, source);
    a.damage = 200;
    a.rules.split = true;
    a.rules.min_players = 2;
    resolve_aoe(network, &mut instance, a);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        400
    );
    assert_eq!(
        instance
            .find_actor(ObjectId(3))
            .unwrap()
            .get_common_spawn()
            .health_points,
        900
    );
}

#[test]
fn hit_trigger_starts_once_and_aggro_is_also_allowed() {
    let (mut instance, source, player) = actors();
    instance.director.as_mut().unwrap().runtime.hit_trigger = Some(source);
    notify_attack_hit(&mut instance, player, source, 0);
    assert!(
        instance
            .director
            .as_ref()
            .unwrap()
            .battle_started_at
            .is_none()
    );
    notify_attack_hit(&mut instance, player, source, 1);
    let began = instance.director.as_ref().unwrap().battle_started_at;
    assert!(began.is_some());
    notify_attack_hit(&mut instance, player, source, u32::MAX);
    assert_eq!(instance.director.as_ref().unwrap().battle_started_at, began);
    let d = instance.director.as_mut().unwrap();
    d.battle_started_at = None;
    d.runtime.hit_trigger = Some(source);
    d.bosses.insert(
        11744,
        DirectorBoss {
            state: DirectorBossState::Open,
            actor_id: source,
            wall_id: 0,
            line_id: 0,
            place_name: 0,
        },
    );
    d.on_actor_aggro(11744);
    assert!(d.battle_started_at.is_some());
}

#[test]
fn god_mode_blocks_damage_death_and_preserves_barriers_until_disabled() {
    let (mut instance, _, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let actor = instance.find_actor_mut(player).unwrap();
    let NetworkedActor::Player { combat_state, .. } = actor else {
        panic!()
    };
    combat_state.god_mode = true;
    actor
        .status_effects_mut()
        .unwrap()
        .add_barrier(297, 0, 30.0, 250, player, 1000);
    assert_eq!(actor.apply_damage(u32::MAX), 0);
    assert_eq!(actor.get_common_spawn().health_points, 1000);
    assert_eq!(actor.status_effects().unwrap().barrier_amount(), 250);
    crate::server::action::kill_actor(network.clone(), &mut instance, player);
    assert_ne!(
        instance.find_actor(player).unwrap().get_common_spawn().mode,
        kawari::common::CharacterMode::Dead
    );
    // 防御旁路写入，HP 同步前也不能向客户端广播死亡血量。
    instance
        .find_actor_mut(player)
        .unwrap()
        .get_common_spawn_mut()
        .health_points = 0;
    update_actor_hp_mp(network, &mut instance, player);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
    let actor = instance.find_actor_mut(player).unwrap();
    let NetworkedActor::Player { combat_state, .. } = actor else {
        panic!()
    };
    combat_state.god_mode = false;
    assert_eq!(actor.apply_damage(500), 250);
    assert_eq!(actor.get_common_spawn().health_points, 750);
}

#[test]
fn god_mode_survives_unmitigated_mechanics_and_magic_number_expiry() {
    let (mut instance, source, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let NetworkedActor::Player { combat_state, .. } = instance.find_actor_mut(player).unwrap()
    else {
        panic!()
    };
    combat_state.god_mode = true;
    let mut a = pending(&instance, source);
    a.damage = 9999999;
    a.rules.unmitigated = true;
    a.rules.min_players = 8;
    a.rules.status = 3532;
    a.rules.status_duration = 6.0;
    resolve_aoe(network.clone(), &mut instance, a);
    crate::server::limit_break::expire_magic_number(network, &mut instance, player);
    let actor = instance.find_actor(player).unwrap();
    assert_eq!(actor.get_common_spawn().health_points, 1000);
    assert_ne!(
        actor.get_common_spawn().mode,
        kawari::common::CharacterMode::Dead
    );
    assert_eq!(
        crate::server::action::apply_target_player_mitigation(
            100000,
            Some(actor),
            DamageType::Magic
        ),
        0
    );
}

#[test]
fn proximity_trigger_waits_for_player_to_finish_loading() {
    let (mut instance, source, player) = actors();
    instance.director.as_mut().unwrap().runtime.hit_trigger = Some(source);
    encounter_tick(&mut instance, Instant::now());
    assert!(
        instance
            .director
            .as_ref()
            .unwrap()
            .battle_started_at
            .is_none()
    );
    instance.commenced_actors.insert(player);
    encounter_tick(&mut instance, Instant::now());
    assert!(
        instance
            .director
            .as_ref()
            .unwrap()
            .battle_started_at
            .is_some()
    );
    assert!(
        instance
            .director
            .as_ref()
            .unwrap()
            .runtime
            .hit_trigger
            .is_none()
    );
}

#[test]
fn ultimate_limit_break_checks_job_consumes_gauge_and_refunds_only_once() {
    use crate::server::limit_break;
    use kawari::ipc::zone::ActionRequest;
    let (mut instance, _, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    instance
        .find_actor_mut(player)
        .unwrap()
        .get_common_spawn_mut()
        .class_job = 19;
    instance.director.as_mut().unwrap().start_battle();
    limit_break::set_gauge(&mut network.lock(), &mut instance, 30000);
    gain_effect_instance(
        network.clone(),
        ClientId::default(),
        &mut instance,
        player,
        3446,
        0,
        0.0,
        player,
        true,
    );
    assert!(!limit_break::allowed(&instance, player, 208));
    let req = ActionRequest {
        action_id: 199,
        action_type: ActionType::Action,
        target: ObjectTypeId {
            object_id: player,
            object_type: ObjectTypeKind::None,
        },
        ..Default::default()
    };
    assert!(limit_break::execute(
        network.clone(),
        &mut instance,
        player,
        &req
    ));
    assert_eq!(
        instance
            .director
            .as_ref()
            .unwrap()
            .runtime
            .limit_break_gauge,
        Some(30000)
    );
    assert!(
        instance
            .find_actor(player)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(3446)
            .is_none()
    );
    assert!(
        instance
            .find_actor(player)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(3448)
            .is_some()
    );
    assert!(
        crate::server::action::apply_target_player_mitigation(
            1000,
            instance.find_actor(player),
            DamageType::Magic
        ) <= 200
    );
    assert!(limit_break::execute(
        network.clone(),
        &mut instance,
        player,
        &req
    ));
    assert_eq!(
        instance
            .director
            .as_ref()
            .unwrap()
            .runtime
            .limit_break_gauge,
        Some(0)
    );
    assert!(!limit_break::allowed(&instance, player, 199));
}

#[test]
fn healer_limit_break_cleanses_magic_number_and_revives() {
    use crate::server::limit_break;
    use kawari::{common::CharacterMode, ipc::zone::ActionRequest};
    let (mut instance, _, healer) = actors();
    let dead = ObjectId(3);
    let network = Arc::new(Mutex::new(NetworkState::default()));
    instance
        .find_actor_mut(healer)
        .unwrap()
        .get_common_spawn_mut()
        .class_job = 24;
    instance.insert_empty_actor(dead);
    let p = instance
        .find_actor_mut(dead)
        .unwrap()
        .get_common_spawn_mut();
    p.health_points = 0;
    p.max_health_points = 1000;
    p.mode = CharacterMode::Dead;
    gain_effect_instance(
        network.clone(),
        ClientId::default(),
        &mut instance,
        healer,
        3532,
        0,
        6.0,
        ObjectId::default(),
        true,
    );
    instance.director.as_mut().unwrap().start_battle();
    limit_break::set_gauge(&mut network.lock(), &mut instance, 30000);
    let req = ActionRequest {
        action_id: 208,
        action_type: ActionType::Action,
        target: ObjectTypeId {
            object_id: healer,
            object_type: ObjectTypeKind::None,
        },
        ..Default::default()
    };
    limit_break::execute(network, &mut instance, healer, &req);
    assert!(
        instance
            .find_actor(healer)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(3532)
            .is_none()
    );
    let p = instance.find_actor(dead).unwrap().get_common_spawn();
    assert_eq!(p.health_points, 1000);
    assert_eq!(p.mode, CharacterMode::Normal);
}

#[test]
fn forsaken_death_blocks_raise_but_not_godmode_and_prison_blocks_lb() {
    use crate::server::limit_break;
    use kawari::ipc::zone::ActionRequest;
    let (mut instance, source, doomed) = actors();
    let healer = ObjectId(3);
    let immune = ObjectId(4);
    let ordinary_dead = ObjectId(5);
    let network = Arc::new(Mutex::new(NetworkState::default()));
    for id in [healer, immune, ordinary_dead] {
        instance.insert_empty_actor(id);
        let p = instance.find_actor_mut(id).unwrap().get_common_spawn_mut();
        p.max_health_points = 1000;
        p.health_points = if id == ordinary_dead { 0 } else { 1000 };
        p.class_job = 24;
    }
    if let NetworkedActor::Player { combat_state, .. } = instance.find_actor_mut(immune).unwrap() {
        combat_state.god_mode = true;
    }
    let mut hit = pending(&instance, source);
    hit.damage = 9999999;
    hit.rules.targets = Some(vec![doomed, immune]);
    hit.rules.unmitigated = true;
    hit.rules.death_status = 5144;
    resolve_aoe(network.clone(), &mut instance, hit);
    assert!(!instance.find_actor(doomed).unwrap().can_be_raised());
    assert!(instance.find_actor(immune).unwrap().can_be_raised());
    assert_eq!(instance.find_actor(immune).unwrap().get_common_spawn().health_points, 1000);
    assert!(instance.director.as_ref().unwrap().runtime.owned_effects.contains_key(&(doomed, 5144)));

    instance.director.as_mut().unwrap().start_battle();
    limit_break::set_gauge(&mut network.lock(), &mut instance, 30000);
    gain_effect_instance(network.clone(), ClientId::default(), &mut instance, healer, 2165, 0, 0.0, source, true);
    assert!(instance.find_actor(healer).unwrap().is_time_stopped());
    assert!(!limit_break::allowed(&instance, healer, 208));
    remove_effect_instance(network.clone(), &mut instance, healer, 2165);
    assert!(limit_break::allowed(&instance, healer, 208));
    let request = ActionRequest {
        action_id: 208, action_type: ActionType::Action,
        target: ObjectTypeId { object_id: healer, object_type: ObjectTypeKind::None },
        ..Default::default()
    };
    limit_break::execute(network, &mut instance, healer, &request);
    assert_eq!(instance.find_actor(doomed).unwrap().get_common_spawn().health_points, 0);
    assert_eq!(instance.find_actor(ordinary_dead).unwrap().get_common_spawn().health_points, 1000);
}

#[test]
fn polarizing_color_only_marks_front_player_and_magic_number_expires() {
    let (mut instance, source, first) = actors();
    let second = ObjectId(3);
    let network = Arc::new(Mutex::new(NetworkState::default()));
    instance.insert_empty_actor(second);
    for (id, z) in [(first, 1.0), (second, 2.0)] {
        let p = instance.find_actor_mut(id).unwrap().get_common_spawn_mut();
        p.health_points = 1000;
        p.max_health_points = 1000;
        p.position = Position(Vec3::new(0.0, 0.0, z));
    }
    let mut a = pending(&instance, source);
    a.shape = AoeShape::Rect {
        length: 100.0,
        width: 6.0,
    };
    a.rules.first_status = 4164;
    a.rules.first_status_duration = 16.0;
    a.rules.status = 2941;
    a.rules.status_duration = 1.0;
    resolve_aoe(network.clone(), &mut instance, a);
    assert!(
        instance
            .find_actor(first)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(4164)
            .is_some()
    );
    assert!(
        instance
            .find_actor(second)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(4164)
            .is_none()
    );
    assert!(
        instance
            .find_actor(second)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(2941)
            .is_some()
    );
    let mut a = pending(&instance, source);
    a.rules.status = 3532;
    a.rules.status_duration = 6.0;
    resolve_aoe(network.clone(), &mut instance, a);
    remove_effect_instance(network.clone(), &mut instance, first, 3532);
    crate::server::limit_break::expire_magic_number(network.clone(), &mut instance, first);
    assert!(
        instance
            .find_actor(first)
            .unwrap()
            .get_common_spawn()
            .health_points
            > 0
    );
    crate::server::limit_break::expire_magic_number(network, &mut instance, second);
    assert_eq!(
        instance
            .find_actor(second)
            .unwrap()
            .get_common_spawn()
            .health_points,
        0
    );
}

#[test]
fn interrupted_damage_does_not_land_but_new_damage_does() {
    let (mut instance, source, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let old = pending(&instance, source);
    interrupt_actor(network.clone(), &mut instance, source);
    resolve_aoe(network.clone(), &mut instance, old);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
    let next = pending(&instance, source);
    resolve_aoe(network, &mut instance, next);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        900
    );
}

#[test]
fn helper_interrupt_and_actor_reuse_do_not_resurrect_old_damage() {
    let (mut instance, source, player) = actors();
    let helper = ObjectId(3);
    instance.insert_empty_actor(helper);
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let mut old = pending(&instance, source);
    old.effect_source = Some(helper);
    old.guard = Some(
        instance
            .director
            .as_ref()
            .unwrap()
            .runtime
            .guard(source, helper),
    );
    instance
        .director
        .as_mut()
        .unwrap()
        .runtime
        .begin_omen(helper, 18470);
    interrupt_actor(network.clone(), &mut instance, helper);
    assert!(
        !instance
            .director
            .as_ref()
            .unwrap()
            .runtime
            .omens
            .contains_key(&helper)
    );
    resolve_aoe(network.clone(), &mut instance, old);
    let old = pending(&instance, source);
    let saved = instance.find_actor(source).unwrap().clone();
    network.lock().remove_actor(&mut instance, source);
    instance.actors.insert(source, saved);
    resolve_aoe(network, &mut instance, old);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
}

#[test]
fn boss_interrupt_cancels_its_active_omen_helpers() {
    let (mut instance, source, _) = actors();
    let helper = ObjectId(3);
    instance.insert_empty_actor(helper);
    let runtime = &mut instance.director.as_mut().unwrap().runtime;
    runtime.begin_omen(helper, 18470);
    runtime.omen_sources.insert(helper, source);
    let guard = runtime.guard(source, helper);
    interrupt_actor(
        Arc::new(Mutex::new(NetworkState::default())),
        &mut instance,
        source,
    );
    let runtime = &instance.director.as_ref().unwrap().runtime;
    assert!(runtime.omens.is_empty());
    assert!(runtime.omen_sources.is_empty());
    assert!(!runtime.valid(guard, source, helper));
}

#[test]
fn only_matching_cast_completion_releases_npc_lock() {
    let (mut instance, source, _) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    instance
        .director
        .as_mut()
        .unwrap()
        .runtime
        .begin_cast(source, 100);
    if let Some(NetworkedActor::Npc { cast_locked, .. }) = instance.find_actor_mut(source) {
        *cast_locked = true;
    }
    let aoe = pending(&instance, source);
    resolve_aoe(network.clone(), &mut instance, aoe);
    assert!(matches!(
        instance.find_actor(source),
        Some(NetworkedActor::Npc {
            cast_locked: true,
            ..
        })
    ));
    let mut completion = pending(&instance, source);
    completion.completes_cast = true;
    completion.damage = 0;
    completion.cast_token = Some(instance.director.as_ref().unwrap().runtime.casts[&source].0);
    instance
        .director
        .as_mut()
        .unwrap()
        .runtime
        .begin_cast(source, 200);
    resolve_aoe(network.clone(), &mut instance, completion.clone());
    assert!(matches!(
        instance.find_actor(source),
        Some(NetworkedActor::Npc {
            cast_locked: true,
            ..
        })
    ));
    completion.cast_token = Some(instance.director.as_ref().unwrap().runtime.casts[&source].0);
    resolve_aoe(network, &mut instance, completion);
    assert!(matches!(
        instance.find_actor(source),
        Some(NetworkedActor::Npc {
            cast_locked: false,
            ..
        })
    ));
}

#[test]
fn map_effect_preserves_replay_state_and_timeline_words() {
    use binrw::BinWrite;
    use std::io::Cursor;
    let mut bytes = Cursor::new(Vec::new());
    ServerZoneIpcData::DirectorMapEffect {
        handler_id: HandlerId(0x80037586),
        state: 64,
        timeline_id: 128,
        index: 2,
    }
    .write_le(&mut bytes)
    .unwrap();
    assert_eq!(
        bytes.into_inner(),
        vec![
            0x86, 0x75, 0x03, 0x80, 0x40, 0, 0x80, 0, 2, 0, 0, 0, 0, 0, 0, 0
        ]
    );
}

#[test]
fn reset_and_completion_discard_old_damage() {
    let (mut instance, source, player) = actors();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let old = pending(&instance, source);
    instance.director.as_mut().unwrap().reset_encounter();
    instance.director.as_mut().unwrap().start_battle();
    resolve_aoe(network.clone(), &mut instance, old);
    let after_reset = pending(&instance, source);
    instance.director.as_mut().unwrap().stop_timeline();
    resolve_aoe(network, &mut instance, after_reset);
    assert_eq!(
        instance
            .find_actor(player)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
}

#[test]
fn reset_preserves_cleanup_and_on_reset_tasks() {
    let mut director = director();
    let boss = ObjectId(10);
    director.runtime.reset_bosses.push(boss);
    director
        .runtime
        .owned_effects
        .insert((ObjectId(20), 700), boss);
    director.tasks.push(LuaDirectorTask::GainEffect {
        actor_id: boss,
        id: 700,
        param: 0,
        duration: 1.0,
        source: boss,
    });
    director
        .lua
        .0
        .load("function onReset(d) d:map_effect(1, 32, 16) end")
        .exec()
        .unwrap();
    director.reset_encounter();
    assert!(
        !director
            .tasks
            .iter()
            .any(|t| matches!(t, LuaDirectorTask::GainEffect { .. }))
    );
    assert!(
        director
            .tasks
            .iter()
            .any(|t| matches!(t, LuaDirectorTask::RestoreBoss { actor_id } if *actor_id == boss))
    );
    assert!(
        director
            .tasks
            .iter()
            .any(|t| matches!(t, LuaDirectorTask::RemoveEffect { id: 700, .. }))
    );
    assert!(director.tasks.iter().any(|t| matches!(
        t,
        LuaDirectorTask::MapEffect {
            state: 16,
            timeline_id: 32,
            ..
        }
    )));
}

#[test]
fn restore_snapshot_restores_hp_position_and_cancels_actor_tasks() {
    let (mut instance, source, _) = actors();
    let baseline = instance.find_actor(source).unwrap().clone();
    instance
        .director
        .as_mut()
        .unwrap()
        .runtime
        .initial_bosses
        .insert(source, baseline);
    let common = instance
        .find_actor_mut(source)
        .unwrap()
        .get_common_spawn_mut();
    common.health_points = 0;
    common.position = Position(Vec3::new(50.0, 0.0, 50.0));
    instance.insert_task(
        ClientId::default(),
        source,
        Duration::from_secs(10),
        QueuedTaskData::ResetCombo,
    );
    restore_boss(
        Arc::new(Mutex::new(NetworkState::default())),
        &mut instance,
        source,
    );
    assert_eq!(
        instance
            .find_actor(source)
            .unwrap()
            .get_common_spawn()
            .health_points,
        1000
    );
    assert_eq!(
        instance.find_actor(source).unwrap().position(),
        Position::default()
    );
    assert!(instance.queued_task.is_empty());
}

#[test]
fn lua_old_calls_new_controls_and_range_checks() {
    let lua = Lua::new();
    let d = lua.create_userdata(LuaDirector::default()).unwrap();
    lua.globals().set("d", d.clone()).unwrap();
    lua.load(
        r#"
        d:map_effect(1, 2)
        d:map_effect(2, 128, 64)
        d:gain_effect(1, 700, 0, 10)
        d:gain_effect(1, 700, 0, 10, 2)
        d:set_model_state(1, 20)
        d:set_animation_state(1, 1, 7)
        d:tether(1, 2, 89)
        d:tether_cancel(1, 89)
        d:set_target_icon(2, 7)
        d:set_target(1, 2)
        assert(not pcall(function() d:map_effect(256, 1) end))
        assert(not pcall(function() d:map_effect(1, 65536) end))
        assert(not pcall(function() d:cast(1, 2, 0/0) end))
        assert(not pcall(function() d:gain_effect(1, 700, 0, -1) end))
    "#,
    )
    .exec()
    .unwrap();
    let d = d.borrow::<LuaDirector>().unwrap();
    assert!(matches!(
        d.tasks[0],
        LuaDirectorTask::MapEffect { state: 1, .. }
    ));
    assert!(matches!(
        d.tasks[1],
        LuaDirectorTask::MapEffect {
            state: 64,
            timeline_id: 128,
            ..
        }
    ));
    assert!(matches!(
        d.tasks[3],
        LuaDirectorTask::GainEffect {
            source: ObjectId(2),
            ..
        }
    ));
    assert!(matches!(
        d.tasks[6],
        LuaDirectorTask::SendActorControl {
            category: ActorControlCategory::Tether {
                tether_id: 0,
                from_actor_id: 89,
                to_actor_id: 2,
                ..
            },
            ..
        }
    ));
}

#[test]
fn buff_refresh_to_permanent_cancels_expiry_and_emits_callbacks() {
    let (mut instance, source, player) = actors();
    instance.director.as_mut().unwrap().start_battle();
    let network = Arc::new(Mutex::new(NetworkState::default()));
    let (sender, mut receiver) = tokio::sync::mpsc::channel(32);
    network.lock().clients.insert(
        ClientId::default(),
        (
            crate::ClientHandle {
                id: ClientId::default(),
                channel: sender,
                actor_id: player,
                content_id: 0,
                account_id: 0,
            },
            Default::default(),
        ),
    );
    gain_effect_instance(
        network.clone(),
        ClientId::default(),
        &mut instance,
        player,
        700,
        3,
        10.0,
        source,
        true,
    );
    assert!(
        matches!(receiver.try_recv().unwrap(), FromServer::ActorControlSelf(ActorControlCategory::GainEffect { effect_id: 700, source_actor_id, .. }) if source_actor_id == source)
    );
    match receiver.try_recv().unwrap() {
        FromServer::PacketSegment(packet, actor) => {
            assert_eq!(actor, player);
            let ServerZoneIpcData::StatusEffectList(list) = packet.data else {
                panic!("缺少状态列表同步")
            };
            assert_eq!(list.statuses[0].effect_id, 700);
            assert_eq!(list.statuses[0].source_actor_id, source);
        }
        _ => panic!("缺少状态列表包"),
    }
    assert_eq!(instance.queued_task.len(), 1);
    gain_effect_instance(
        network.clone(),
        ClientId::default(),
        &mut instance,
        player,
        700,
        4,
        0.0,
        source,
        true,
    );
    assert!(instance.queued_task.is_empty());
    let statuses = instance
        .find_actor(player)
        .unwrap()
        .status_effects()
        .unwrap();
    assert_eq!(statuses.get(700).unwrap().source_actor_id, source);
    assert_eq!(statuses.get(700).unwrap().duration, 0.0);
    assert!(!statuses.is_dirty());
    remove_effect_instance(network, &mut instance, player, 700).unwrap();
    assert!(
        instance
            .find_actor(player)
            .unwrap()
            .status_effects()
            .unwrap()
            .get(700)
            .is_none()
    );
    let director = instance.director.as_mut().unwrap();
    assert_eq!(director.runtime.status_changes.len(), 3);
    director
        .lua
        .0
        .load(
            r#"
        gains = 0; losses = 0
        function onStatusGain(d, actor, id, param, duration, source)
            assert(actor == 2 and id == 700 and source == 1); gains = gains + 1
        end
        function onStatusLose(d, actor, id, param, duration, source)
            assert(param == 4); losses = losses + 1
        end
    "#,
        )
        .exec()
        .unwrap();
    director.dispatch_status_changes();
    assert_eq!(director.lua.0.globals().get::<u32>("gains").unwrap(), 2);
    assert_eq!(director.lua.0.globals().get::<u32>("losses").unwrap(), 1);
}
