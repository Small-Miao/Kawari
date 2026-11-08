-- 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.212, 1994, function(d,s)
        s.scene:AnimateEObj(d, "blade_13", 4, 8)
    end),
    At(0.212, 1995, function(d,s)
        s.scene:AnimateEObj(d, "blade_14", 4, 8)
    end),
    At(2.732, 2026, function(d,s)
        s.scene:RemoveEObj(d, "blade_13")
    end),
    At(2.732, 2027, function(d,s)
        s.scene:RemoveEObj(d, "blade_14")
    end),
    At(4.871, 2036, function(d,s)
        d:director_event(0x80000027, {46, 2, 9347, 0})
    end),
    At(9.908, 2060, function(d,s)
        d:director_event(0x80000027, {47, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
    At(16.343, 2096, function(d,s)
        d:director_event(0x80000027, {48, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
}
