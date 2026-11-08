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
    "despawn_registered",
    "hide_actor",
    "set_animation_state",
    "stop_encounter",
    "abandon_duty",
    "finish_gimmick",
    "hide_eobj",
    "show_eobj",
    "delete_eobj",
    "spawn_eobj",
    "spawn_bnpc",
    "spawn_treasure",
    "spawn_boss",
    "spawn_omen_pool",
    "set_data",
    "log_message",
    "event_action",
    "use_shortcut",
    "update_shortcut",
    "play_cutscene",
    "variant_vote_route",
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
    pub flag: u8,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
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
        std::fs::create_dir_all("target/encounters").map_err(|e| e.to_string())?;
        let log = format!(
            "target/encounters/controller-{:016x}.log",
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

fn validate_reply(reply: &Reply, expected: u64) -> Result<(), String> {
    if reply.version != 1 || reply.seq != expected || reply.commands.len() > 4096 {
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

fn prepare(
    director: &DirectorData,
    operations: &[Operation],
    fresh: bool,
) -> mlua::Result<LuaDirector> {
    let mut draft = director.create_lua_director();
    if fresh {
        draft.helpers.clear();
        draft.bosses.clear();
        draft.vars.clear();
        draft.player_vars.clear();
        draft.omen_helpers.clear();
        draft.clones.clear();
    }
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
    Ok(draft)
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct Manifest {
    host: String,
    definitions: String,
    #[serde(default, rename = "resource_data")]
    _resource_data: HashMap<u16, String>,
    contents: HashMap<String, Entry>,
}
#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct Entry {
    definition: String,
    flag: u8,
}

#[derive(Debug)]
pub struct Controller {
    config: Config,
    worker: Option<Worker>,
    sequence: u64,
    pending: Option<(u64, Instant)>,
    ready: bool,
    stopped: bool,
    discard_pending: bool,
    events: Vec<Json>,
    error: Option<String>,
    initial_scene: Vec<Operation>,
    state: Json,
    candidate: Option<Box<Controller>>,
}

impl Controller {
    fn new(config: Config) -> Self {
        Self {
            config,
            worker: None,
            sequence: 0,
            pending: None,
            ready: false,
            stopped: false,
            discard_pending: false,
            events: vec![],
            error: None,
            initial_scene: vec![],
            state: Json::Null,
            candidate: None,
        }
    }
    pub fn disabled(error: String) -> Self {
        let mut result = Self::new(Config {
            executable: String::new(),
            args: vec![],
            flag: 0,
        });
        result.error = Some(error);
        result
    }
    pub fn for_content(content: &str) -> Result<Option<Self>, String> {
        let path = Path::new("resources/encounters/manifest.json");
        let manifest: Manifest = serde_json::from_slice(
            &std::fs::read(path).map_err(|e| format!("副本清单读取失败: {e}"))?,
        )
        .map_err(|e| e.to_string())?;
        let Some(entry) = manifest.contents.get(content) else {
            return Ok(None);
        };
        let executable = std::fs::canonicalize(&manifest.host)
            .map_err(|e| format!("C# 宿主未构建 {}: {e}", manifest.host))?;
        let definitions =
            std::fs::canonicalize(&manifest.definitions).map_err(|e| e.to_string())?;
        Ok(Some(Self::new(Config {
            executable: executable.to_string_lossy().into(),
            args: vec![
                "--definitions".into(),
                definitions.to_string_lossy().into(),
                "--content".into(),
                entry.definition.clone(),
            ],
            flag: entry.flag,
        })))
    }
    pub fn flag(&self) -> u8 {
        self.config.flag
    }
    pub fn event(&mut self, value: Json) {
        if self.stopped {
            return;
        }
        if self.events.len() >= 4096 {
            self.error = Some("C# 事件队列已满".into())
        } else {
            self.events.push(value)
        }
    }
    pub fn reset(&mut self) {
        self.candidate = None;
        self.events.clear();
        self.error = None;
        if self.stopped {
            self.worker = None;
            self.pending = None;
            self.ready = false;
            self.stopped = false;
        } else if self.worker.is_some() {
            self.discard_pending = self.pending.is_some();
            self.events.push(json!({"kind":"reset"}));
        }
    }
    pub fn stop(&mut self) {
        self.worker = None;
        self.pending = None;
        self.events.clear();
        self.candidate = None;
        self.stopped = true;
    }
    fn receive(&mut self, now: Instant) -> Result<Option<Reply>, String> {
        let Some((seq, sent)) = self.pending else {
            return Ok(None);
        };
        let worker = self.worker.as_ref().ok_or("C# 通道已丢失")?;
        match worker.receive.try_recv() {
            Ok(reply) => {
                let reply = reply?;
                validate_reply(&reply, seq)?;
                self.pending = None;
                Ok(Some(reply))
            }
            Err(mpsc::TryRecvError::Empty) => {
                let timeout = if self.ready { 2.0 } else { 30.0 };
                if now.saturating_duration_since(sent).as_secs_f64() > timeout {
                    Err(format!("C# 响应超过 {timeout} 秒"))
                } else {
                    Ok(None)
                }
            }
            Err(mpsc::TryRecvError::Disconnected) => Err("C# 控制器通信断开".into()),
        }
    }
    fn send(&mut self, director: &DirectorData, now: Instant, fresh: bool) -> Result<(), String> {
        if self.worker.is_none() {
            self.worker = Some(Worker::start(&self.config)?)
        }
        self.sequence += 1;
        let actors:Vec<_>=director.current_actors.iter().map(|a|json!({
            "id":a.id.0,"player":a.is_player,"hp":a.hp,"maxHp":a.max_hp,"job":a.class_job,
            "pos":a.position.0.to_array(),"rotation":a.rotation,"target":a.target.0,
            "enmity":a.enmity.iter().map(|id|id.0).collect::<Vec<_>>(),
            "actionCount":match director.player_vars.get(&a.id).and_then(|v|v.get("__action_count")){Some(EncounterVar::Int(n))=>*n,_=>0}
        })).collect();
        let statuses:Vec<_>=director.runtime.effects.iter().flat_map(|(actor,effects)|effects.iter().filter(|s|s.effect_id!=0).map(move |s|json!({
            "actor":actor.0,"id":s.effect_id,"param":s.param,"duration":s.duration,"source":s.source_actor_id.0
        }))).collect();
        let bindings: HashMap<_, _> = if fresh {
            HashMap::new()
        } else {
            director
                .helpers
                .iter()
                .map(|(key, id)| (key, id.0))
                .collect()
        };
        let frame = json!({"version":1,"seq":self.sequence,"time":if fresh{0.0}else{director.elapsed_secs},
            "battle":!fresh&&director.battle_started_at.is_some(),"actors":actors,"bindings":bindings,"statuses":statuses,"events":self.events});
        let bytes = serde_json::to_vec(&frame).map_err(|e| e.to_string())?;
        if bytes.len() > MAX_FRAME {
            return Err("C# 快照超出长度上限".into());
        }
        self.worker
            .as_ref()
            .unwrap()
            .send
            .try_send(bytes)
            .map_err(|e| e.to_string())?;
        self.events.clear();
        self.pending = Some((self.sequence, now));
        Ok(())
    }
    fn remember(&mut self, reply: &Reply) {
        if !self.ready {
            self.initial_scene = reply
                .commands
                .iter()
                .filter(|c| {
                    matches!(
                        c.method.as_str(),
                        "setup_map_effects" | "map_effect" | "set_weather" | "set_bgm"
                    )
                })
                .cloned()
                .collect();
        }
        self.state = reply.state.clone();
        self.ready = true;
    }
    fn restore_scene(&self, director: &mut DirectorData) {
        let mut ops = vec![Operation {
            method: "director_event".into(),
            args: vec![json!(0x8000001Bu32), json!([1, 0, 0, 0])],
        }];
        ops.extend(self.initial_scene.clone());
        match prepare(director, &ops, false) {
            Ok(draft) => director.apply_lua_director(draft),
            Err(error) => tracing::warn!("C# 初始场景恢复失败: {error}"),
        }
    }
    fn poll(&mut self, director: &mut DirectorData, now: Instant) -> Result<(), String> {
        if self.stopped {
            return Ok(());
        }
        if let Some(error) = self.error.take() {
            return Err(error);
        }
        if let Some(reply) = self.receive(now)? {
            if self.discard_pending {
                self.discard_pending = false;
            } else {
                let draft = prepare(director, &reply.commands, false).map_err(|e| e.to_string())?;
                director.apply_lua_director(draft);
                self.remember(&reply);
            }
        }
        if self.pending.is_some() {
            return Ok(());
        }
        if director.tasks.iter().any(|t| {
            matches!(
                t,
                LuaDirectorTask::ResetEncounter
                    | LuaDirectorTask::StopEncounter { .. }
                    | LuaDirectorTask::CompleteDuty { .. }
            )
        }) {
            return Ok(());
        }
        self.send(director, now, false)
    }
    fn poll_candidate(
        &mut self,
        director: &DirectorData,
        now: Instant,
    ) -> Result<Option<LuaDirector>, String> {
        if let Some(reply) = self.receive(now)? {
            let draft = prepare(director, &reply.commands, true).map_err(|e| e.to_string())?;
            self.remember(&reply);
            return Ok(Some(draft));
        }
        if self.pending.is_none() {
            self.send(director, now, true)?;
        }
        Ok(None)
    }
    pub fn debug_shortcut(&self, index: u32) -> u32 {
        self.state["debugShortcuts"]
            .get(index as usize)
            .and_then(|v| v.as_u64())
            .unwrap_or(0) as u32
    }
}

impl DirectorData {
    pub fn controller_command(&mut self, action: &str) -> String {
        let Some(mut controller) = self.external.take() else {
            return "当前副本没有 C# 控制器".into();
        };
        let result = match action {
            "reload" => {
                self.vars.remove("controller.reload_error");
                controller.candidate = Some(Box::new(Controller::new(controller.config.clone())));
                "正在编译并验证候选 C# 定义；成功后重建实例，失败保留当前战斗。".into()
            }
            "reset" => {
                controller.reset();
                self.reset_encounter_mode(false);
                "C# 时间轴已重置，将恢复初始场景。".into()
            }
            "stop" => {
                controller.stop();
                self.reset_encounter_mode(false);
                controller.restore_scene(self);
                "C# 时间轴已停止，本轮实体、读条、状态和任务已清理。".into()
            }
            _ => {
                if let Some(EncounterVar::Str(error)) = self.vars.get("controller.error") {
                    format!("C# 控制器错误：{error}")
                } else if let Some(EncounterVar::Str(error)) =
                    self.vars.get("controller.reload_error")
                {
                    format!("C# 重载失败，继续使用原定义：{error}")
                } else if controller.stopped {
                    "C# 控制器已停止。".into()
                } else if !controller.ready {
                    "C# 控制器正在编译和初始化。".into()
                } else {
                    format!(
                        "C#：{} | {} / {} | {}",
                        controller.state["name"].as_str().unwrap_or(""),
                        controller.state["phase"].as_str().unwrap_or(""),
                        controller.state["node"].as_str().unwrap_or(""),
                        controller.state["status"].as_str().unwrap_or("")
                    )
                }
            }
        };
        self.external = Some(controller);
        result
    }
    pub fn advance_external(&mut self, now: Instant) {
        let Some(mut controller) = self.external.take() else {
            return;
        };
        if let Some(mut candidate) = controller.candidate.take() {
            match candidate.poll_candidate(self, now) {
                Ok(Some(draft)) => {
                    controller.stop();
                    self.reset_encounter_mode(false);
                    self.apply_lua_director(draft);
                    controller = *candidate;
                    tracing::info!("C# 候选定义验证成功，已替换并重置实例");
                }
                Ok(None) => controller.candidate = Some(candidate),
                Err(error) => {
                    tracing::warn!("C# 重载失败，当前实例保持原定义: {error}");
                    self.vars
                        .insert("controller.reload_error".into(), EncounterVar::Str(error));
                }
            }
        }
        if let Err(error) = controller.poll(self, now) {
            tracing::error!("C# 副本控制器停止: {error}");
            controller.stop();
            self.reset_encounter_mode(false);
            controller.restore_scene(self);
            self.vars
                .insert("controller.error".into(), EncounterVar::Str(error));
        }
        self.external = Some(controller);
    }
}

#[cfg(test)]
mod tests;
