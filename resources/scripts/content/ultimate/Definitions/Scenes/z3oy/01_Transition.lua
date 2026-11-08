-- 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(6.22, 6, function(d,s)
        d:director_event(0x80000001, {1, 0, 0, 0})
    end),
    At(8.137, 8, function(d,s)
        s.scene:MapEffect(d, 0, 2048, 4096)
    end),
    At(8.137, 9, function(d,s)
        s.scene:MapEffect(d, 20, 1, 1)
    end),
    At(8.137, 10, function(d,s)
        s.scene:MapEffect(d, 21, 1, 1)
    end),
    At(8.137, 11, function(d,s)
        s.scene:MapEffect(d, 22, 1, 1)
    end),
    At(8.137, 12, function(d,s)
        s.scene:MapEffect(d, 23, 1, 1)
    end),
    At(8.137, 13, function(d,s)
        s.scene:MapEffect(d, 24, 1, 1)
    end),
    At(8.137, 14, function(d,s)
        s.scene:MapEffect(d, 25, 1, 1)
    end),
    At(8.137, 15, function(d,s)
        s.scene:MapEffect(d, 26, 1, 1)
    end),
    At(8.137, 16, function(d,s)
        s.scene:MapEffect(d, 27, 1, 1)
    end),
    At(8.137, 17, function(d,s)
        s.scene:MapEffect(d, 28, 1, 1)
    end),
    At(8.137, 18, function(d,s)
        s.scene:MapEffect(d, 29, 1, 1)
    end),
    At(8.137, 19, function(d,s)
        s.scene:MapEffect(d, 30, 1, 1)
    end),
    At(8.137, 20, function(d,s)
        s.scene:MapEffect(d, 31, 1, 1)
    end),
    At(8.137, 21, function(d,s)
        s.scene:MapEffect(d, 32, 1, 1)
    end),
    At(8.137, 22, function(d,s)
        s.scene:MapEffect(d, 33, 1, 1)
    end),
    At(8.137, 23, function(d,s)
        d:director_event(0x80000028, {0, 4, 6, 0})
    end),
    At(8.137, 24, function(d,s)
        d:set_weather(175, 0.0)
    end),
    At(10.279, 28, function(d,s)
        d:director_event(0x80000027, {34, 2, 7131, d:actor_id(A.KefkaP4) or 0})
    end),
    At(16.854, 29, function(d,s)
        d:director_event(0x80000001, {20294, 0, 0, 0})
    end),
    At(23.015, 30, function(d,s)
        d:director_event(0x80000027, {35, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(30.113, 31, function(d,s)
        d:director_event(0x80000027, {36, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
    At(37.166, 39, function(d,s)
        d:director_event(0x8000000D, {2, 0, 0, 0})
    end),
}
