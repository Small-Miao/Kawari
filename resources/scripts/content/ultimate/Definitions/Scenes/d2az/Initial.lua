-- 入场和重置：先恢复上一阶段场景，再等待木桩触发。
local M={}
function M.Reset(d,scene)
    d:setup_map_effects({0, 1, 4, 1, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 5)
    scene:MapEffect(d, 7, 4, 2)
    scene:MapEffect(d, 2, 1, 32)
    scene:MapEffect(d, 1, 1, 2)
    scene:MapEffect(d, 3, 4, 8)
    d:set_weather(71, 0)
    d:set_bgm(725)
end
function M.SpawnObjects(d,scene)
    scene:SpawnEObj(d, "prison_01", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160974,
        bind_layout = 8150085,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_02", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160973,
        bind_layout = 8150084,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_03", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160972,
        bind_layout = 8150083,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_04", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160971,
        bind_layout = 8150082,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_05", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160970,
        bind_layout = 8150081,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_06", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160969,
        bind_layout = 8150080,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_07", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160968,
        bind_layout = 8150079,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
    scene:SpawnEObj(d, "prison_08", {
        base = 2007457,
        flags = 5,
        hidden = false,
        layout = 8160966,
        bind_layout = 8150078,
        radius = 1.0,
        rotation = -5e-05,
        state = 0,
        args1 = 4,
        args2 = 0,
        pos = {x=100.0, y=0.0, z=100.0},
    })
end
return M
