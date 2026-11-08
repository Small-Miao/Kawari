//! 原生 Lua 时间轴控制与候选 VM 预验证；错误重载不破坏当前战斗。
use super::*;

impl DirectorData {
    pub fn timeline_command(&mut self, action: &str) -> String {
        if self.external.is_some() { return self.controller_command(action); }
        match action {
            "reset" => {
                self.reset_encounter();
                "Lua 时间轴已重置，场景与木桩重新初始化。".into()
            }
            "stop" => {
                self.reset_encounter_mode(false);
                self.vars
                    .insert("timeline.state".into(), EncounterVar::Str("已停止".into()));
                "Lua 时间轴已停止，读条、延时任务、状态与本轮实体已清理。".into()
            }
            "reload" => match self.reload_timeline() {
                Ok(()) => "Lua 定义已验证并重新加载，场景与木桩已重置。".into(),
                Err(error) => {
                    tracing::warn!("Lua 时间轴重载失败，保留当前控制器: {error}");
                    format!("重载失败，当前战斗保持原定义：{error}")
                }
            },
            _ => {
                let get = |key: &str| match self.vars.get(key) {
                    Some(EncounterVar::Str(s)) => s.clone(),
                    _ => String::new(),
                };
                format!(
                    "Lua：{} | {} / {} | {}",
                    get("timeline.name"),
                    get("timeline.phase"),
                    get("timeline.node"),
                    get("timeline.state")
                )
            }
        }
    }

    fn reload_timeline(&mut self) -> Result<(), String> {
        if !self.vars.contains_key("timeline.name") {
            return Err("当前脚本未注册原生时间轴".into());
        }
        let path = self
            .script_path
            .as_ref()
            .ok_or("当前实例没有可重载脚本路径")?;
        let bytes = std::fs::read(path).map_err(|e| e.to_string())?;
        let candidate = KawariLua(Lua::new());
        let directory = std::path::Path::new(path)
            .parent()
            .ok_or("脚本目录无效")?
            .to_string_lossy()
            .replace('\\', "/");
        candidate
            .0
            .globals()
            .set("CONTENT_DIR", directory)
            .map_err(|e| e.to_string())?;
        candidate
            .0
            .load(bytes)
            .set_name(format!("@{path}"))
            .exec()
            .map_err(|e| e.to_string())?;
        let mut draft = LuaDirector {
            actors: self.current_actors.clone(),
            ..Default::default()
        };
        candidate
            .0
            .scope(|scope| {
                let ud = scope.create_userdata_ref_mut(&mut draft)?;
                candidate
                    .0
                    .globals()
                    .get::<Function>("onSetup")?
                    .call::<()>(ud)
            })
            .map_err(|e| e.to_string())?;
        // 所有依赖和初始化均成功后才清理旧轮次，候选任务此前只在内存排队。
        self.reset_encounter_mode(false);
        self.lua = candidate;
        self.apply_lua_director(draft);
        Ok(())
    }
}
