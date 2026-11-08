-- 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.281, 944, function(d,s)
        s.scene:SpawnEObj(d, "blade_07", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -0.78546,
            state = 0,
            args1 = 4,
            args2 = 4521987,
            pos = {x=110.6569, y=0.0, z=89.3431},
        })
    end),
    At(0.281, 945, function(d,s)
        s.scene:SpawnEObj(d, "blade_08", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = 3.14159,
            state = 0,
            args1 = 4,
            args2 = 4456451,
            pos = {x=100.0, y=0.0, z=83.0},
        })
    end),
    At(0.281, 946, function(d,s)
        s.scene:SpawnEObj(d, "blade_09", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -2.35628,
            state = 0,
            args1 = 4,
            args2 = 4390915,
            pos = {x=89.3431, y=0.0, z=89.3431},
        })
    end),
    At(0.281, 947, function(d,s)
        s.scene:SpawnEObj(d, "blade_10", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = 1.57077,
            state = 0,
            args1 = 4,
            args2 = 4325379,
            pos = {x=90.0, y=0.0, z=100.0},
        })
    end),
    At(0.281, 948, function(d,s)
        s.scene:SpawnEObj(d, "blade_11", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -0.78546,
            state = 0,
            args1 = 4,
            args2 = 4259843,
            pos = {x=96.4142, y=0.0, z=103.5858},
        })
    end),
    At(0.281, 949, function(d,s)
        s.scene:SpawnEObj(d, "blade_12", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -3.14159,
            state = 0,
            args1 = 4,
            args2 = 4194307,
            pos = {x=100.0, y=0.0, z=103.0},
        })
    end),
    At(0.863, 950, function(d,s)
        s.scene:MapEffect(d, 47, 1, 32)
    end),
    At(7.941, 952, function(d,s)
        s.scene:AnimateEObj(d, "blade_12", 1, 2)
    end),
    At(7.941, 953, function(d,s)
        s.scene:AnimateEObj(d, "blade_11", 1, 2)
    end),
    At(7.941, 954, function(d,s)
        s.scene:AnimateEObj(d, "blade_10", 1, 2)
    end),
    At(7.941, 955, function(d,s)
        s.scene:AnimateEObj(d, "blade_09", 1, 2)
    end),
    At(7.941, 956, function(d,s)
        s.scene:AnimateEObj(d, "blade_08", 1, 2)
    end),
    At(7.941, 957, function(d,s)
        s.scene:AnimateEObj(d, "blade_07", 1, 2)
    end),
    At(9.908, 968, function(d,s)
        s.scene:AnimateEObj(d, "blade_12", 32, 16)
    end),
    At(9.908, 975, function(d,s)
        s.scene:AnimateEObj(d, "blade_11", 32, 16)
    end),
    At(13.96, 1001, function(d,s)
        s.scene:AnimateEObj(d, "blade_10", 32, 16)
    end),
    At(13.96, 1008, function(d,s)
        s.scene:AnimateEObj(d, "blade_09", 32, 16)
    end),
    At(15.312, 1020, function(d,s)
        d:director_event(0x80000027, {43, 2, 9347, 0})
    end),
    At(16.98, 1032, function(d,s)
        s.scene:AnimateEObj(d, "blade_12", 4, 8)
    end),
    At(16.98, 1033, function(d,s)
        s.scene:AnimateEObj(d, "blade_11", 4, 8)
    end),
    At(17.925, 1038, function(d,s)
        s.scene:AnimateEObj(d, "blade_08", 32, 16)
    end),
    At(17.925, 1045, function(d,s)
        s.scene:AnimateEObj(d, "blade_07", 32, 16)
    end),
    At(19.1, 1065, function(d,s)
        s.scene:RemoveEObj(d, "blade_11")
    end),
    At(19.1, 1066, function(d,s)
        s.scene:RemoveEObj(d, "blade_12")
    end),
    At(20.347, 1076, function(d,s)
        d:director_event(0x80000027, {44, 2, 9326, 0})
    end),
    At(20.996, 1079, function(d,s)
        s.scene:AnimateEObj(d, "blade_09", 4, 8)
    end),
    At(20.996, 1080, function(d,s)
        s.scene:AnimateEObj(d, "blade_10", 4, 8)
    end),
    At(23.484, 1122, function(d,s)
        s.scene:RemoveEObj(d, "blade_09")
    end),
    At(23.484, 1123, function(d,s)
        s.scene:RemoveEObj(d, "blade_10")
    end),
}
