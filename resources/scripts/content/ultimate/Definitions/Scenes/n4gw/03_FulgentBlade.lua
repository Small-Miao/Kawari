-- 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.138, 55, function(d,s)
        s.scene:SpawnEObj(d, "blade_01", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -2.35628,
            state = 0,
            args1 = 4,
            args2 = 4521987,
            pos = {x=89.3934, y=0.0, z=89.3934},
        })
    end),
    At(0.138, 56, function(d,s)
        s.scene:SpawnEObj(d, "blade_02", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -5e-05,
            state = 0,
            args1 = 4,
            args2 = 4456451,
            pos = {x=100.0, y=0.0, z=90.0},
        })
    end),
    At(0.138, 57, function(d,s)
        s.scene:SpawnEObj(d, "blade_03", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -1.57087,
            state = 0,
            args1 = 4,
            args2 = 4390915,
            pos = {x=103.0, y=0.0, z=100.0},
        })
    end),
    At(0.138, 58, function(d,s)
        s.scene:SpawnEObj(d, "blade_04", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = 2.35618,
            state = 0,
            args1 = 4,
            args2 = 4325379,
            pos = {x=103.5858, y=0.0, z=96.4142},
        })
    end),
    At(0.138, 59, function(d,s)
        s.scene:SpawnEObj(d, "blade_05", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -5e-05,
            state = 0,
            args1 = 4,
            args2 = 4259843,
            pos = {x=100.0, y=0.0, z=110.0},
        })
    end),
    At(0.138, 60, function(d,s)
        s.scene:SpawnEObj(d, "blade_06", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -2.35628,
            state = 0,
            args1 = 4,
            args2 = 4194307,
            pos = {x=103.5858, y=0.0, z=103.5858},
        })
    end),
    At(8.049, 62, function(d,s)
        s.scene:AnimateEObj(d, "blade_06", 1, 2)
    end),
    At(8.049, 63, function(d,s)
        s.scene:AnimateEObj(d, "blade_05", 1, 2)
    end),
    At(8.049, 64, function(d,s)
        s.scene:AnimateEObj(d, "blade_04", 1, 2)
    end),
    At(8.049, 65, function(d,s)
        s.scene:AnimateEObj(d, "blade_03", 1, 2)
    end),
    At(8.049, 66, function(d,s)
        s.scene:AnimateEObj(d, "blade_02", 1, 2)
    end),
    At(8.049, 67, function(d,s)
        s.scene:AnimateEObj(d, "blade_01", 1, 2)
    end),
    At(10.013, 78, function(d,s)
        s.scene:AnimateEObj(d, "blade_06", 32, 16)
    end),
    At(10.013, 83, function(d,s)
        s.scene:AnimateEObj(d, "blade_05", 32, 16)
    end),
    At(14.015, 108, function(d,s)
        s.scene:AnimateEObj(d, "blade_04", 32, 16)
    end),
    At(14.015, 115, function(d,s)
        s.scene:AnimateEObj(d, "blade_03", 32, 16)
    end),
    At(17.078, 131, function(d,s)
        s.scene:AnimateEObj(d, "blade_06", 4, 8)
    end),
    At(17.078, 132, function(d,s)
        s.scene:AnimateEObj(d, "blade_05", 4, 8)
    end),
    At(18.03, 137, function(d,s)
        s.scene:AnimateEObj(d, "blade_02", 32, 16)
    end),
    At(18.03, 144, function(d,s)
        s.scene:AnimateEObj(d, "blade_01", 32, 16)
    end),
    At(19.352, 167, function(d,s)
        s.scene:RemoveEObj(d, "blade_05")
    end),
    At(19.352, 168, function(d,s)
        s.scene:RemoveEObj(d, "blade_06")
    end),
    At(21.108, 174, function(d,s)
        s.scene:AnimateEObj(d, "blade_03", 4, 8)
    end),
    At(21.108, 175, function(d,s)
        s.scene:AnimateEObj(d, "blade_04", 4, 8)
    end),
    At(23.337, 213, function(d,s)
        s.scene:RemoveEObj(d, "blade_03")
    end),
    At(23.337, 214, function(d,s)
        s.scene:RemoveEObj(d, "blade_04")
    end),
}
