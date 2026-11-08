-- 连续究极 [47936]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(0.041, 248, function(d,s)
        s.scene:RemoveEObj(d, "tower_01")
    end),
    At(0.041, 249, function(d,s)
        s.scene:RemoveEObj(d, "tower_02")
    end),
    At(0.041, 250, function(d,s)
        s.scene:RemoveEObj(d, "tower_03")
    end),
    At(0.041, 251, function(d,s)
        s.scene:RemoveEObj(d, "tower_04")
    end),
    At(0.041, 252, function(d,s)
        s.scene:RemoveEObj(d, "tower_05")
    end),
    At(0.041, 253, function(d,s)
        s.scene:RemoveEObj(d, "tower_06")
    end),
    At(0.041, 254, function(d,s)
        s.scene:RemoveEObj(d, "tower_08")
    end),
    At(0.041, 255, function(d,s)
        s.scene:RemoveEObj(d, "tower_09")
    end),
    At(0.041, 256, function(d,s)
        s.scene:RemoveEObj(d, "tower_07")
    end),
    At(14.547, 281, function(d,s)
        d:director_event(0x80000027, {37, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
}
