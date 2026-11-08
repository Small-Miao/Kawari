-- 二选一的灾祟 [49743]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(4.87, 198, function(d,s)
        s.scene:AnimateEObj(d, "tower_09", 1, 64)
    end),
    At(4.87, 199, function(d,s)
        s.scene:AnimateEObj(d, "tower_06", 1, 64)
    end),
    At(4.87, 200, function(d,s)
        s.scene:AnimateEObj(d, "tower_04", 1, 64)
    end),
    At(4.87, 201, function(d,s)
        s.scene:AnimateEObj(d, "tower_02", 1, 64)
    end),
    At(4.87, 203, function(d,s)
        s.scene:AnimateEObj(d, "tower_03", 16, 32)
    end),
    At(4.87, 205, function(d,s)
        s.scene:AnimateEObj(d, "tower_01", 16, 32)
    end),
    At(4.87, 208, function(d,s)
        s.scene:AnimateEObj(d, "tower_05", 16, 32)
    end),
    At(4.87, 211, function(d,s)
        s.scene:AnimateEObj(d, "tower_07", 16, 32)
    end),
    At(10.861, 219, function(d,s)
        s.scene:AnimateEObj(d, "tower_07", 1, 64)
    end),
    At(10.861, 220, function(d,s)
        s.scene:AnimateEObj(d, "tower_05", 1, 64)
    end),
    At(10.861, 221, function(d,s)
        s.scene:AnimateEObj(d, "tower_01", 1, 64)
    end),
    At(10.861, 222, function(d,s)
        s.scene:AnimateEObj(d, "tower_03", 1, 64)
    end),
    At(10.861, 224, function(d,s)
        s.scene:AnimateEObj(d, "tower_02", 16, 32)
    end),
    At(10.861, 226, function(d,s)
        s.scene:AnimateEObj(d, "tower_04", 16, 32)
    end),
    At(10.861, 228, function(d,s)
        s.scene:AnimateEObj(d, "tower_08", 16, 32)
    end),
    At(10.861, 230, function(d,s)
        s.scene:AnimateEObj(d, "tower_09", 16, 32)
    end),
}
