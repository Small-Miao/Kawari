//! 独立 C# 副本控制器：有界 JSON 通道、非阻塞轮询和按实例取消。
use super::*;
use mlua::{MultiValue, ObjectLike};
use serde::{Deserialize, Serialize};
use serde_json::{Value as Json, json};
use std::{
    io::{BufRead, BufReader, Read, Write},
    path::Path,
    process::{Child, Command, Stdio},
    sync::mpsc::{self, Receiver, SyncSender},
};

const MAX_FRAME: usize = 1024 * 1024;
const METHODS: &[&str] = &[
    "spawn_actor",
    "spawn_event_object",
    "despawn",
    "set_targetable",
    "set_visible",
    "move_actor",
    "slide_actor",
    "set_target",
    "set_model_state",
    "set_actor_owner",
    "set_ai_enabled",
    "cast",
    "begin_cast",
    "end_cast",
    "interrupt_cast",
    "cancel_pending",
    "play_action",
    "play_action_targeted",
    "play_timeline",
    "play_actor_timelines",
    "object_animation",
    "projection_death",
    "gain_effect",
    "remove_effect",
    "aoe_circle",
    "aoe_donut",
    "aoe_rect",
    "aoe_cone",
    "raidwide",
    "knockback",
    "attract",
    "attract_custom",
    "tether",
    "tether_cancel",
    "set_target_icon",
    "set_bgm",
    "map_effect",
    "setup_map_effects",
    "director_event",
    "set_weather",
    "set_limit_break",
    "set_director_flag",
    "actor_presentation",
    "arm_hit_trigger",
    "set_reset_on_deaggro",
    "reset_encounter",
    "complete_duty",
];

#[derive(Debug, Clone, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Config {
    pub executable: String,
    #[serde(default)]
    pub args: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
#[serde(deny_unknown_fields)]
struct Operation {
    method: String,
    args: Vec<Json>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct Reply {
    version: u32,
    seq: u64,
    commands: Vec<Operation>,
    #[serde(default)]
    state: Json,
}

#[derive(Debug)]
struct Worker {
    child: Arc<Mutex<Child>>,
    send: SyncSender<Vec<u8>>,
    receive: Receiver<Result<Reply, String>>,
}

impl Drop for Worker {
    fn drop(&mut self) {
        // 不等待脚本退出；kill 会唤醒后台阻塞读取，由后台线程回收进程。
        let _ = self.child.lock().kill();
    }
}

impl Worker {
    fn start(config: &Config) -> Result<Self, String> {
        let mut command = Command::new(&config.executable);
        command
            .args(&config.args)
            .stdin(Stdio::piped())
            .stdout(Stdio::piped());
        #[cfg(windows)]
        {
            use std::os::windows::process::CommandExt;
            command.creation_flags(0x08000000); // CREATE_NO_WINDOW
        }
        std::fs::create_dir_all("target/mechanicsim").map_err(|e| e.to_string())?;
        let log = format!(
            "target/mechanicsim/controller-{:016x}.log",
            fastrand::u64(..)
        );
        command.stderr(Stdio::from(
            std::fs::File::create(&log).map_err(|e| e.to_string())?,
        ));
        let mut child = command
            .spawn()
            .map_err(|e| format!("启动 C# 控制器失败: {e}"))?;
        let mut input = child.stdin.take().unwrap();
        let mut output = BufReader::new(child.stdout.take().unwrap());
        let child = Arc::new(Mutex::new(child));
        let cleanup = child.clone();
        let (send, requests) = mpsc::sync_channel::<Vec<u8>>(1);
        let (responses, receive) = mpsc::sync_channel(1);
        std::thread::spawn(move || {
            for request in requests {
                let result = (|| -> Result<Reply, String> {
                    input.write_all(&request).map_err(|e| e.to_string())?;
                    input.write_all(b"\n").map_err(|e| e.to_string())?;
                    input.flush().map_err(|e| e.to_string())?;
                    let mut bytes = Vec::new();
                    output
                        .by_ref()
                        .take((MAX_FRAME + 1) as u64)
                        .read_until(b'\n', &mut bytes)
                        .map_err(|e| e.to_string())?;
                    if bytes.is_empty() || bytes.len() > MAX_FRAME || bytes.last() != Some(&b'\n') {
                        return Err("控制器退出或响应超出长度上限".into());
                    }
                    serde_json::from_slice(&bytes).map_err(|e| e.to_string())
                })();
                let failed = result.is_err();
                if responses.send(result).is_err() || failed {
                    break;
                }
            }
            drop(input);
            let mut child = cleanup.lock();
            let _ = child.kill();
            let _ = child.wait();
        });
        tracing::info!("独立 C# 副本控制器已启动，日志 {log}");
        Ok(Self {
            child,
            send,
            receive,
        })
    }
}

#[derive(Debug)]
pub struct Controller {
    config: Config,
    worker: Option<Worker>,
    sequence: u64,
    pending: Option<(u64, Instant)>,
    ready: bool,
    stopped: bool,
    events: Vec<Json>,
    event_error: Option<String>,
}

impl Controller {
    pub fn disabled(error: String) -> Self {
        Self {
            config: Config {
                executable: String::new(),
                args: vec![],
            },
            worker: None,
            sequence: 0,
            pending: None,
            ready: false,
            stopped: false,
            events: vec![],
            event_error: Some(error),
        }
    }

    pub fn is_running(&self) -> bool {
        self.worker.is_some()
    }

    pub fn restart(&mut self) {
        self.reset();
        self.stopped = false;
    }
    pub fn for_content(content: &str) -> Result<Option<Self>, String> {
        let path = format!("resources/controllers/{content}.json");
        if !Path::new(&path).exists() {
            return Ok(None);
        }
        let config: Config =
            serde_json::from_slice(&std::fs::read(path).map_err(|e| e.to_string())?)
                .map_err(|e| e.to_string())?;
        if !Path::new(&config.executable).is_absolute() {
            return Err("控制器程序必须使用绝对路径".into());
        }
        Ok(Some(Self {
            config,
            worker: None,
            sequence: 0,
            pending: None,
            ready: false,
            stopped: false,
            events: vec![],
            event_error: None,
        }))
    }

    pub fn reset(&mut self) {
        self.worker = None;
        self.pending = None;
        self.ready = false;
        self.events.clear();
        self.event_error = None;
    }

    pub fn event(&mut self, value: Json) {
        if self.stopped {
            return;
        }
        if self.events.len() >= 4096 {
            self.event_error = Some("控制器事件队列已满".into());
        } else {
            self.events.push(value);
        }
    }

    pub fn stop(&mut self) {
        self.stopped = true;
        self.reset();
    }

    fn poll(&mut self, director: &mut DirectorData, now: Instant) -> Result<(), String> {
        if self.stopped {
            return Ok(());
        }
        if let Some(error) = self.event_error.take() {
            return Err(error);
        }
        if self.worker.is_none() {
            self.worker = Some(Worker::start(&self.config)?);
        }
        let worker = self.worker.as_ref().unwrap();
        if let Some((seq, sent)) = self.pending {
            match worker.receive.try_recv() {
                Ok(reply) => {
                    let reply = reply?;
                    validate_reply(&reply, seq)?;
                    apply(director, &reply.commands).map_err(|e| e.to_string())?;
                    director.vars.insert(
                        "controller.state".into(),
                        EncounterVar::Str(reply.state.to_string()),
                    );
                    self.pending = None;
                    self.ready = true;
                }
                Err(mpsc::TryRecvError::Empty) => {
                    let timeout = if self.ready { 2.0 } else { 30.0 };
                    if now.saturating_duration_since(sent).as_secs_f64() > timeout {
                        return Err(format!("控制器响应超过 {timeout} 秒，已取消本轮"));
                    }
                    return Ok(());
                }
                Err(mpsc::TryRecvError::Disconnected) => return Err("控制器通信已断开".into()),
            }
        }
        // 终止/重置指令由本 tick 的任务阶段处理，不能再发下一帧。
        if director.tasks.iter().any(|t| {
            matches!(
                t,
                LuaDirectorTask::ResetEncounter | LuaDirectorTask::CompleteDuty { .. }
            )
        }) {
            return Ok(());
        }
        self.sequence += 1;
        let actors: Vec<_> = director
            .current_actors
            .iter()
            .map(|a| {
                json!({
                    "id":a.id.0,"player":a.is_player,"hp":a.hp,"maxHp":a.max_hp,"job":a.class_job,
                    "pos":a.position.0.to_array(),"rotation":a.rotation,"target":a.target.0,
                    "enmity":a.enmity.iter().map(|id|id.0).collect::<Vec<_>>()
                })
            })
            .collect();
        let statuses: Vec<_> = director.runtime.effects.iter().flat_map(|(actor, effects)| {
            effects.iter().filter(|s|s.effect_id != 0).map(move |s|json!({
                "actor":actor.0,"id":s.effect_id,"param":s.param,"duration":s.duration,"source":s.source_actor_id.0
            }))
        }).collect();
        let bindings: HashMap<_, _> = director
            .helpers
            .iter()
            .map(|(key, id)| (key, id.0))
            .collect();
        let frame = json!({"version":1,"seq":self.sequence,"time":director.elapsed_secs,
            "battle":director.battle_started_at.is_some(),"actors":actors,"bindings":bindings,"statuses":statuses,
            "events":self.events});
        let bytes = serde_json::to_vec(&frame).map_err(|e| e.to_string())?;
        if bytes.len() > MAX_FRAME {
            return Err("副本快照超出长度上限".into());
        }
        worker.send.try_send(bytes).map_err(|e| e.to_string())?;
        self.events.clear();
        self.pending = Some((self.sequence, now));
        Ok(())
    }
}

fn validate_reply(reply: &Reply, expected: u64) -> Result<(), String> {
    if reply.version != 1 || reply.seq != expected || reply.commands.len() > 512 {
        return Err("控制器协议版本、序号或指令数量不正确".into());
    }
    for operation in &reply.commands {
        if !METHODS.contains(&operation.method.as_str()) || operation.args.len() > 16 {
            return Err(format!("不允许的原生操作: {}", operation.method));
        }
    }
    Ok(())
}

fn argument(lua: &Lua, value: &Json, bindings: &HashMap<String, ObjectId>) -> mlua::Result<Value> {
    Ok(match value {
        Json::Null => Value::Nil,
        Json::Bool(v) => Value::Boolean(*v),
        Json::Number(n) => {
            if let Some(v) = n.as_i64() {
                Value::Integer(v)
            } else {
                Value::Number(n.as_f64().unwrap())
            }
        }
        Json::String(s) => Value::String(lua.create_string(s)?),
        Json::Array(values) => {
            let table = lua.create_table()?;
            for (i, v) in values.iter().enumerate() {
                table.set(i + 1, argument(lua, v, bindings)?)?;
            }
            Value::Table(table)
        }
        Json::Object(values) if values.len() == 1 && values.contains_key("actor") => {
            let key = values["actor"]
                .as_str()
                .ok_or_else(|| mlua::Error::runtime("演员引用应为字符串"))?;
            Value::Integer(
                bindings
                    .get(key)
                    .ok_or_else(|| mlua::Error::runtime(format!("找不到演员 {key}")))?
                    .0 as i64,
            )
        }
        Json::Object(values) => {
            let table = lua.create_table()?;
            for (key, v) in values {
                table.set(key.as_str(), argument(lua, v, bindings)?)?;
            }
            Value::Table(table)
        }
    })
}

fn apply(director: &mut DirectorData, operations: &[Operation]) -> mlua::Result<()> {
    let mut draft = director.create_lua_director();
    // 按命令创建短作用域，确保同帧后续指令能引用刚创建的演员。
    for operation in operations {
        let args = operation
            .args
            .iter()
            .map(|v| argument(&director.lua.0, v, &draft.helpers))
            .collect::<mlua::Result<Vec<_>>>()?;
        director.lua.0.scope(|scope| {
            let data = scope.create_userdata_ref_mut(&mut draft)?;
            data.call_method::<()>(operation.method.as_str(), MultiValue::from_vec(args))
        })?;
    }
    // 全部参数验证成功才提交，失败时不遗留半个批次的实体/伤害。
    if draft.helpers.len() > 4096 {
        return Err(mlua::Error::runtime("控制器演员注册表超过 4096 项"));
    }
    for task in &draft.tasks {
        let pose = match task {
            LuaDirectorTask::SpawnScriptActor(actor) => Some((actor.position, actor.rotation)),
            LuaDirectorTask::MoveActor {
                position, rotation, ..
            }
            | LuaDirectorTask::SlideActor {
                position, rotation, ..
            } => Some((*position, *rotation)),
            _ => None,
        };
        if pose.is_some_and(|(position, rotation)| !position.0.is_finite() || !rotation.is_finite())
        {
            return Err(mlua::Error::runtime("控制器提交了无效坐标"));
        }
    }
    director.apply_lua_director(draft);
    Ok(())
}

impl DirectorData {
    pub fn controller_command(&mut self, action: &str) -> String {
        if self.external.is_none() {
            return "当前副本由 Lua 控制。".into();
        }
        match action {
            "reset" | "reload" => {
                self.external.as_mut().unwrap().restart();
                self.reset_encounter();
                "C# 控制器已重置，将重新编译定义并初始化木桩。".into()
            }
            "stop" => {
                self.external.as_mut().unwrap().stop();
                self.reset_encounter();
                "C# 控制器已停止，已取消读条、延时任务并清理实体和状态。".into()
            }
            _ => {
                if let Some(EncounterVar::Str(error)) = self.vars.get("controller.error") {
                    return format!("C# 控制器错误：{error}；详情见 target/mechanicsim 日志。");
                }
                if let Some(EncounterVar::Str(state)) = self.vars.get("controller.state")
                    && let Ok(value) = serde_json::from_str::<Json>(state)
                {
                    let node = value["nodes"]
                        .as_array()
                        .and_then(|nodes| nodes.iter().find(|n| n["isCurrent"] == true));
                    return format!(
                        "C#：{} | {} / {} | {}",
                        value["selectedTimelineName"].as_str().unwrap_or(""),
                        node.and_then(|n| n["phaseName"].as_str()).unwrap_or(""),
                        node.and_then(|n| n["nodeName"].as_str())
                            .unwrap_or("等待开战"),
                        value["status"].as_str().unwrap_or("")
                    );
                }
                if self.external.as_ref().unwrap().stopped {
                    "C# 控制器已停止。".into()
                } else {
                    "C# 控制器正在初始化。".into()
                }
            }
        }
    }

    pub fn advance_external(&mut self, now: Instant) {
        let Some(mut controller) = self.external.take() else {
            return;
        };
        if let Err(error) = controller.poll(self, now) {
            tracing::error!("C# 副本控制器停止: {error}");
            controller.stop();
            self.reset_encounter();
            self.vars
                .insert("controller.error".into(), EncounterVar::Str(error));
        }
        self.external = Some(controller);
    }
}

/// C# 拥有副本逻辑；Lua 仅提供现有服务器操作的参数验证和任务接口。
pub const ENTRY: &str = r#"
function onSetup(d) d:set_director_flag(1) end
function onEnterZone() end
function onActorDeath() end
function onTalk() end
function onEventActionCast() end
function onGimmickAccessor() end
function onVariantVote() end
"#;

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn rejects_old_sequence_unknown_operations_and_oversize_batch() {
        let mut reply = Reply {
            version: 1,
            seq: 2,
            commands: vec![],
            state: Json::Null,
        };
        assert!(validate_reply(&reply, 1).is_err());
        reply.seq = 1;
        reply.commands.push(Operation {
            method: "execute_lua".into(),
            args: vec![],
        });
        assert!(validate_reply(&reply, 1).is_err());
        reply.commands.clear();
        assert!(validate_reply(&reply, 1).is_ok());
        reply.commands = (0..513)
            .map(|_| Operation {
                method: "set_bgm".into(),
                args: vec![json!(1)],
            })
            .collect();
        assert!(validate_reply(&reply, 1).is_err());
    }
    #[test]
    fn commands_are_atomic_and_references_are_local() {
        let mut d = super::super::tests::director();
        let commands = vec![
            Operation {
                method: "set_bgm".into(),
                args: vec![json!(964)],
            },
            Operation {
                method: "set_targetable".into(),
                args: vec![json!({"actor":"missing"}), json!(true)],
            },
        ];
        assert!(apply(&mut d, &commands).is_err());
        assert!(d.tasks.is_empty());
        d.helpers.insert("boss".into(), ObjectId(123));
        assert!(
            apply(
                &mut d,
                &[Operation {
                    method: "set_targetable".into(),
                    args: vec![json!({"actor":"boss"}), json!(true)]
                }]
            )
            .is_ok()
        );
        assert_eq!(d.tasks.len(), 1);
    }

    #[test]
    #[ignore = "先运行 C# P2 八人和单人烟雾测试，验证其真实输出批次"]
    fn native_p2_recorded_commands() {
        let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        for name in ["p2", "p2-solo"] {
            let path = root.join(format!("target/ultimate-analysis/{name}-commands.json"));
            let replies: Vec<Reply> =
                serde_json::from_slice(&std::fs::read(path).unwrap()).unwrap();
            let mut d = super::super::tests::director();
            let mut count = 0;
            for (i, reply) in replies.iter().enumerate() {
                validate_reply(reply, i as u64 + 1).unwrap();
                apply(&mut d, &reply.commands)
                    .unwrap_or_else(|e| panic!("{name} 第 {} 帧: {e}", i + 1));
                count += d.tasks.len();
                d.tasks.clear();
            }
            assert!(count > 100);
        }
    }

    #[test]
    #[ignore = "先构建 tools/MechanicSimController；显式运行真实 C# 进程联调"]
    fn native_csharp_roundtrip_and_reset() {
        let root = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("../..")
            .canonicalize()
            .unwrap();
        let executable =
            root.join("tools/MechanicSimController/bin/Debug/net10.0/MechanicSimController.exe");
        assert!(executable.exists(), "请先构建 C# 宿主");
        let config = Config {
            executable: executable.to_string_lossy().into(),
            args: vec![
                "--config".into(),
                root.join("tools/MechanicSimController/Examples/native-demo.json")
                    .to_string_lossy()
                    .into(),
            ],
        };
        let mut d = super::super::tests::director();
        d.external = Some(Controller {
            config: config.clone(),
            worker: None,
            sequence: 0,
            pending: None,
            ready: false,
            stopped: false,
            events: vec![],
            event_error: None,
        });
        d.current_actors.push(ActorSnapshot {
            id: ObjectId(100),
            is_player: true,
            is_boss: false,
            enmity: vec![],
            position: Position(Vec3::new(100.0, 0.0, 100.0)),
            rotation: 0.0,
            hp: 10000,
            max_hp: 10000,
            class_job: 19,
            target: ObjectId::default(),
        });
        let until = Instant::now() + Duration::from_secs(30);
        while !d.helpers.contains_key("dummy") {
            d.advance_external(Instant::now());
            assert!(Instant::now() < until, "初始化超时: {:?}", d.vars);
            assert!(!d.vars.contains_key("controller.error"), "{:?}", d.vars);
            std::thread::sleep(Duration::from_millis(10));
        }
        let dummy = d.helpers["dummy"];
        assert!(d.tasks.iter().any(|t|matches!(t,LuaDirectorTask::SpawnScriptActor(a) if a.position.0==Vec3::new(100.0,0.0,100.0))));
        d.current_actors.push(ActorSnapshot {
            id: dummy,
            is_player: false,
            is_boss: true,
            enmity: vec![ObjectId(100)],
            position: Position(Vec3::new(100.0, 0.0, 100.0)),
            rotation: 0.0,
            hp: 10000,
            max_hp: 10000,
            class_job: 0,
            target: ObjectId(100),
        });
        d.battle_started_at = Some(Instant::now());
        // 从零时刻开始，再推进至施法完成；每步等到宿主确认了对应帧。
        for time in [0.0, 2.0, 3.0, 7.0] {
            d.elapsed_secs = time;
            let start_sequence = d.external.as_ref().unwrap().sequence;
            while d.external.as_ref().unwrap().sequence < start_sequence + 3 {
                d.advance_external(Instant::now());
                assert!(Instant::now() < until, "联调超时");
                assert!(!d.vars.contains_key("controller.error"), "{:?}", d.vars);
                std::thread::sleep(Duration::from_millis(10));
            }
        }
        assert!(
            d.tasks
                .iter()
                .any(|t| matches!(t,LuaDirectorTask::CastBar{source_id,..} if *source_id==dummy))
        );
        assert!(d.tasks.iter().any(
            |t| matches!(t,LuaDirectorTask::ResolveAoe(a) if a.damage==100 && a.source_id==dummy)
        ));
        assert!(d.tasks.iter().any(|t|matches!(t,LuaDirectorTask::GainEffect{actor_id,id,..} if *actor_id==ObjectId(100) && *id==2911)));
        d.reset_encounter();
        assert!(d.external.as_ref().unwrap().worker.is_none());
        assert!(d.helpers.is_empty());
        assert!(d.battle_started_at.is_none());
        // 超时后停止此控制器，并取消战斗，不会反复自动启动有问题的脚本。
        d.external.as_mut().unwrap().worker = Some(Worker::start(&config).unwrap());
        d.external.as_mut().unwrap().pending = Some((1, Instant::now() - Duration::from_secs(31)));
        d.advance_external(Instant::now());
        assert!(d.external.as_ref().unwrap().stopped);
        assert!(d.external.as_ref().unwrap().worker.is_none());
        assert!(d.vars.contains_key("controller.error"));
    }
}
