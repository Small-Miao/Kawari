-- 遗弃末世 [47925]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(12.027, 534, function(d,s)
        s.scene:MapEffect(d, (s.forsaken_puddle_index or 29), 16, 32)
    end),
    At(15.632, 546, function(d,s)
        s.scene:MapEffect(d, 20, 16, 32)
    end),
    At(15.632, 547, function(d,s)
        s.scene:MapEffect(d, 25, 16, 32)
    end),
    At(18.073, 548, function(d,s)
        d:director_event(0x80000027, {41, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(20.189, 556, function(d,s)
        s.scene:MapEffect(d, (s.forsaken_puddle_index or 30), 16, 32)
    end),
    At(23.827, 564, function(d,s)
        s.scene:MapEffect(d, 27, 16, 32)
    end),
    At(23.87, 565, function(d,s)
        s.scene:MapEffect(d, 28, 16, 32)
    end),
    At(26.176, 568, function(d,s)
        d:director_event(0x80000027, {42, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(28.31, 576, function(d,s)
        s.scene:MapEffect(d, (s.forsaken_puddle_index or 31), 16, 32)
    end),
    At(31.959, 586, function(d,s)
        s.scene:MapEffect(d, 26, 16, 32)
    end),
    At(31.959, 587, function(d,s)
        s.scene:MapEffect(d, 22, 16, 32)
    end),
    At(34.34, 588, function(d,s)
        d:director_event(0x80000027, {43, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(36.423, 596, function(d,s)
        s.scene:MapEffect(d, (s.forsaken_puddle_index or 32), 16, 32)
    end),
    At(40.063, 605, function(d,s)
        s.scene:MapEffect(d, 21, 16, 32)
    end),
    At(40.063, 606, function(d,s)
        s.scene:MapEffect(d, 24, 16, 32)
    end),
}
