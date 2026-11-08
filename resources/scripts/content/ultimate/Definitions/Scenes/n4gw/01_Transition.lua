-- 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(3.34, 7, function(d,s)
        d:director_event(0x8000001E, {791, 0, 0, 0})
    end),
    At(5.674, 11, function(d,s)
        d:director_event(0x80000027, {54, 2, 12809, d:actor_id(A.UsurperOfFrostP4) or 0})
    end),
    At(10.833, 17, function(d,s)
        d:director_event(0x8000001A, {1, 1, 0, 0})
    end),
    At(12.783, 19, function(d,s)
        s.scene:MapEffect(d, 46, 4, 8)
    end),
    At(25.788, 22, function(d,s)
        d:director_event(0x80000001, {1, 0, 0, 0})
    end),
    At(32.826, 23, function(d,s)
        s.scene:MapEffect(d, 40, 4, 8)
    end),
    At(32.826, 24, function(d,s)
        s.scene:MapEffect(d, 41, 4, 4)
    end),
    At(32.826, 25, function(d,s)
        s.scene:MapEffect(d, 47, 1, 2)
    end),
    At(32.826, 26, function(d,s)
        d:set_weather(108, 0.0)
    end),
    At(65.331, 27, function(d,s)
        d:director_event(0x80000001, {20099, 0, 0, 0})
    end),
    At(76.88, 28, function(d,s)
        d:director_event(0x8000001B, {1, 0, 0, 0})
    end),
}
