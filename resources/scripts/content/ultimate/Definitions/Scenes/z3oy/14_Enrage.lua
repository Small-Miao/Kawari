-- 遗弃末点 [47930]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(0.736, 615, function(d,s)
        s.scene:MapEffect(d, 33, 8, 16)
    end),
    At(0.736, 616, function(d,s)
        s.scene:MapEffect(d, 29, 4, 8)
    end),
    At(0.736, 617, function(d,s)
        s.scene:MapEffect(d, 30, 4, 8)
    end),
    At(0.736, 618, function(d,s)
        s.scene:MapEffect(d, 31, 4, 8)
    end),
    At(0.736, 619, function(d,s)
        s.scene:MapEffect(d, 32, 4, 8)
    end),
    At(4.291, 620, function(d,s)
        d:director_event(0x80000027, {44, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(21.819, 621, function(d,s)
        d:director_event(0x80000027, {45, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
}
