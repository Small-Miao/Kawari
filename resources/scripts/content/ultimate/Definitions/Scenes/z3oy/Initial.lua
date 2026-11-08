-- 入场和重置：先恢复上一阶段场景，再等待木桩触发。
local M={}
function M.Reset(d,scene)
    d:setup_map_effects({1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 5)
    scene:MapEffect(d, 17, 1, 2)
    scene:MapEffect(d, 18, 1, 4)
    scene:MapEffect(d, 7, 4, 8)
    scene:MapEffect(d, 8, 4, 8)
    scene:MapEffect(d, 1, 4, 8)
    scene:MapEffect(d, 2, 4, 8)
    scene:MapEffect(d, 5, 4, 8)
    scene:MapEffect(d, 3, 4, 8)
    scene:MapEffect(d, 6, 4, 8)
    scene:MapEffect(d, 4, 4, 8)
    scene:MapEffect(d, 19, 4, 8)
    scene:MapEffect(d, 0, 512, 1024)
    scene:MapEffect(d, 34, 4, 8)
    d:set_weather(174, 0)
    d:set_bgm(20293)
end
function M.SpawnObjects(d,scene)
end
return M
