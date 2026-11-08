-- 入场和重置：先恢复上一阶段场景，再等待木桩触发。
local M={}
function M.Reset(d,scene)
    d:setup_map_effects({1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 1)
    scene:MapEffect(d, 9, 4, 8)
    scene:MapEffect(d, 8, 4, 8)
    scene:MapEffect(d, 10, 4, 8)
    scene:MapEffect(d, 11, 4, 2)
    scene:MapEffect(d, 1, 4, 1024)
    scene:MapEffect(d, 20, 4, 8)
    scene:MapEffect(d, 5, 4, 8)
    d:set_weather(174, 0)
    d:set_bgm(964)
end
function M.SpawnObjects(d,scene)
end
return M
