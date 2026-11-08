-- 入场和重置：先恢复上一阶段场景，再等待木桩触发。
local M={}
function M.Reset(d,scene)
    d:setup_map_effects({4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 1)
    scene:MapEffect(d, 8, 4, 8)
    scene:MapEffect(d, 0, 32, 64)
    d:set_weather(3, 0)
    d:set_bgm(926)
end
function M.SpawnObjects(d,scene)
end
return M
