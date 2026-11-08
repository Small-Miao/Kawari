-- 光尘之剑 [40306]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.217, 1822, function(d,s)
        s.scene:SpawnEObj(d, "blade_13", {
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
            pos = {x=89.3934, y=0.0, z=110.6569},
        })
    end),
    At(0.217, 1823, function(d,s)
        s.scene:SpawnEObj(d, "blade_14", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -3.14159,
            state = 0,
            args1 = 4,
            args2 = 4456451,
            pos = {x=100.0, y=0.0, z=117.0},
        })
    end),
    At(0.217, 1824, function(d,s)
        s.scene:SpawnEObj(d, "blade_15", {
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
            pos = {x=110.0, y=0.0, z=100.0},
        })
    end),
    At(0.217, 1825, function(d,s)
        s.scene:SpawnEObj(d, "blade_16", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = 2.35618,
            state = 0,
            args1 = 4,
            args2 = 4259843,
            pos = {x=103.5858, y=0.0, z=96.4142},
        })
    end),
    At(0.217, 1826, function(d,s)
        s.scene:SpawnEObj(d, "blade_17", {
            base = 2014199,
            flags = 5,
            hidden = false,
            layout = 0,
            bind_layout = 0,
            radius = 1.0,
            rotation = -5e-05,
            state = 0,
            args1 = 4,
            args2 = 4194307,
            pos = {x=100.0, y=0.0, z=97.0},
        })
    end),
    At(0.217, 1827, function(d,s)
        s.scene:SpawnEObj(d, "blade_18", {
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
            pos = {x=110.6569, y=0.0, z=110.6569},
        })
    end),
    At(8.065, 1829, function(d,s)
        s.scene:AnimateEObj(d, "blade_17", 1, 2)
    end),
    At(8.065, 1830, function(d,s)
        s.scene:AnimateEObj(d, "blade_16", 1, 2)
    end),
    At(8.065, 1831, function(d,s)
        s.scene:AnimateEObj(d, "blade_15", 1, 2)
    end),
    At(8.065, 1832, function(d,s)
        s.scene:AnimateEObj(d, "blade_18", 1, 2)
    end),
    At(8.065, 1833, function(d,s)
        s.scene:AnimateEObj(d, "blade_14", 1, 2)
    end),
    At(8.065, 1834, function(d,s)
        s.scene:AnimateEObj(d, "blade_13", 1, 2)
    end),
    At(10.052, 1845, function(d,s)
        s.scene:AnimateEObj(d, "blade_17", 32, 16)
    end),
    At(10.052, 1852, function(d,s)
        s.scene:AnimateEObj(d, "blade_16", 32, 16)
    end),
    At(14.03, 1877, function(d,s)
        s.scene:AnimateEObj(d, "blade_15", 32, 16)
    end),
    At(14.03, 1884, function(d,s)
        s.scene:AnimateEObj(d, "blade_18", 32, 16)
    end),
    At(17.055, 1904, function(d,s)
        s.scene:AnimateEObj(d, "blade_17", 4, 8)
    end),
    At(17.055, 1905, function(d,s)
        s.scene:AnimateEObj(d, "blade_16", 4, 8)
    end),
    At(18.042, 1910, function(d,s)
        s.scene:AnimateEObj(d, "blade_14", 32, 16)
    end),
    At(18.042, 1917, function(d,s)
        s.scene:AnimateEObj(d, "blade_13", 32, 16)
    end),
    At(19.509, 1945, function(d,s)
        s.scene:RemoveEObj(d, "blade_16")
    end),
    At(19.509, 1946, function(d,s)
        s.scene:RemoveEObj(d, "blade_17")
    end),
    At(21.067, 1947, function(d,s)
        s.scene:AnimateEObj(d, "blade_18", 4, 8)
    end),
    At(21.067, 1948, function(d,s)
        s.scene:AnimateEObj(d, "blade_15", 4, 8)
    end),
    At(23.538, 1988, function(d,s)
        s.scene:RemoveEObj(d, "blade_15")
    end),
    At(23.538, 1989, function(d,s)
        s.scene:RemoveEObj(d, "blade_18")
    end),
    At(24.715, 1992, function(d,s)
        d:director_event(0x80000027, {45, 2, 9326, 0})
    end),
}
