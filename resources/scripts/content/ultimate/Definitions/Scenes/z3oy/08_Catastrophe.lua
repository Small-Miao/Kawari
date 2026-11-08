-- 二选一的灾祟 [49743]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(4.77, 237, function(d,s)
        s.scene:AnimateEObj(d, "tower_09", 1, 64)
    end),
    At(4.77, 238, function(d,s)
        s.scene:AnimateEObj(d, "tower_08", 1, 64)
    end),
    At(4.77, 239, function(d,s)
        s.scene:AnimateEObj(d, "tower_04", 1, 64)
    end),
    At(4.77, 240, function(d,s)
        s.scene:AnimateEObj(d, "tower_02", 1, 64)
    end),
}
