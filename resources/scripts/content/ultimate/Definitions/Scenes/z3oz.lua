-- 场景初始化入口；各机制的地图、EObj 和演出调用见 z3oz 子目录。
local Initial=dofile(CONTENT_DIR.."/ultimate/Definitions/Scenes/z3oz/Initial.lua")
return {initial=Initial.Reset,spawn_objects=Initial.SpawnObjects}
