-- 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.077, 216, function(d,s)
        s.scene:AnimateEObj(d, "blade_01", 4, 8)
    end),
    At(0.077, 217, function(d,s)
        s.scene:AnimateEObj(d, "blade_02", 4, 8)
    end),
    At(2.393, 252, function(d,s)
        s.scene:RemoveEObj(d, "blade_01")
    end),
    At(2.393, 253, function(d,s)
        s.scene:RemoveEObj(d, "blade_02")
    end),
    At(12.212, 302, function(d,s)
        d:director_event(0x80000027, {35, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
}
