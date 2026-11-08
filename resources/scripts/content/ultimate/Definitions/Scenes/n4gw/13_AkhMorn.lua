-- 死亡轮回 [40310]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.07, 1128, function(d,s)
        s.scene:AnimateEObj(d, "blade_07", 4, 8)
    end),
    At(0.07, 1129, function(d,s)
        s.scene:AnimateEObj(d, "blade_08", 4, 8)
    end),
    At(2.423, 1156, function(d,s)
        d:director_event(0x80000027, {37, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
    At(2.559, 1161, function(d,s)
        s.scene:RemoveEObj(d, "blade_07")
    end),
    At(2.559, 1162, function(d,s)
        s.scene:RemoveEObj(d, "blade_08")
    end),
}
