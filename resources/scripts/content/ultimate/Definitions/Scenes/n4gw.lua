-- 场景初始化入口；各机制的地图、EObj 和演出调用见 n4gw 子目录。
local Initial=dofile(CONTENT_DIR.."/ultimate/Definitions/Scenes/n4gw/Initial.lua")
return {initial=Initial.Reset,spawn_objects=Initial.SpawnObjects}
