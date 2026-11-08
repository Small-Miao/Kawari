-- 三星 [47938]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(5.249, 179, function(d,s)
        s.scene:SpawnEObj(d, "tower_01", {
            base = 2015294,
            flags = 5,
            hidden = false,
            layout = 12327438,
            bind_layout = 0,
            radius = 1.0,
            rotation = 0.34903,
            state = 0,
            args1 = 2,
            args2 = 4390915,
            pos = {x=96.5798, y=0.0, z=90.6031},
        })
    end),
    At(5.249, 180, function(d,s)
        s.scene:SpawnEObj(d, "tower_02", {
            base = 2015294,
            flags = 5,
            hidden = false,
            layout = 12327437,
            bind_layout = 0,
            radius = 1.0,
            rotation = 1.0472,
            state = 0,
            args1 = 2,
            args2 = 4325379,
            pos = {x=91.3397, y=0.0, z=95.0},
        })
    end),
    At(5.249, 181, function(d,s)
        s.scene:SpawnEObj(d, "tower_03", {
            base = 2015294,
            flags = 5,
            hidden = false,
            layout = 12327436,
            bind_layout = 0,
            radius = 1.0,
            rotation = 1.74527,
            state = 0,
            args1 = 2,
            args2 = 4259843,
            pos = {x=90.1519, y=0.0, z=101.7365},
        })
    end),
    At(5.249, 182, function(d,s)
        s.scene:SpawnEObj(d, "tower_04", {
            base = 2015295,
            flags = 5,
            hidden = false,
            layout = 12327435,
            bind_layout = 0,
            radius = 1.0,
            rotation = 2.44343,
            state = 0,
            args1 = 2,
            args2 = 4587523,
            pos = {x=93.5721, y=0.0, z=107.6604},
        })
    end),
    At(5.249, 183, function(d,s)
        s.scene:SpawnEObj(d, "tower_05", {
            base = 2015295,
            flags = 5,
            hidden = false,
            layout = 12327434,
            bind_layout = 0,
            radius = 1.0,
            rotation = 3.1415,
            state = 0,
            args1 = 2,
            args2 = 4521987,
            pos = {x=100.0, y=0.0, z=110.0},
        })
    end),
    At(5.249, 184, function(d,s)
        s.scene:SpawnEObj(d, "tower_06", {
            base = 2015295,
            flags = 5,
            hidden = false,
            layout = 12327433,
            bind_layout = 0,
            radius = 1.0,
            rotation = -2.44352,
            state = 0,
            args1 = 2,
            args2 = 4456451,
            pos = {x=106.4279, y=0.0, z=107.6604},
        })
    end),
    At(5.249, 185, function(d,s)
        s.scene:SpawnEObj(d, "tower_07", {
            base = 2015296,
            flags = 5,
            hidden = false,
            layout = 12327432,
            bind_layout = 0,
            radius = 1.0,
            rotation = -1.74536,
            state = 0,
            args1 = 2,
            args2 = 4784131,
            pos = {x=109.8481, y=0.0, z=101.7365},
        })
    end),
    At(5.249, 186, function(d,s)
        s.scene:SpawnEObj(d, "tower_08", {
            base = 2015296,
            flags = 5,
            hidden = false,
            layout = 12327431,
            bind_layout = 0,
            radius = 1.0,
            rotation = -1.0472,
            state = 0,
            args1 = 2,
            args2 = 4718595,
            pos = {x=108.6603, y=0.0, z=95.0},
        })
    end),
    At(5.249, 187, function(d,s)
        s.scene:SpawnEObj(d, "tower_09", {
            base = 2015296,
            flags = 5,
            hidden = false,
            layout = 12327430,
            bind_layout = 0,
            radius = 1.0,
            rotation = -0.34913,
            state = 0,
            args1 = 2,
            args2 = 4653059,
            pos = {x=103.4202, y=0.0, z=90.6031},
        })
    end),
    At(8.043, 189, function(d,s)
        s.scene:AnimateEObj(d, "tower_02", 16, 32)
    end),
    At(8.043, 191, function(d,s)
        s.scene:AnimateEObj(d, "tower_04", 16, 32)
    end),
    At(8.043, 193, function(d,s)
        s.scene:AnimateEObj(d, "tower_06", 16, 32)
    end),
    At(8.043, 195, function(d,s)
        s.scene:AnimateEObj(d, "tower_09", 16, 32)
    end),
}
