-- 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
return {
    At(0.054, 1, function(d,s)
        s.scene:MapEffect(d, 0, 4, 8)
    end),
    At(13.485, 17, function(d,s)
        d:director_event(0x8000001A, {1, 1, 0, 0})
    end),
    At(14.17, 19, function(d,s)
        d:director_event(0x80000001, {1, 0, 0, 0})
    end),
    At(26.17, 20, function(d,s)
        d:director_event(0x80000023, {35823, 50, 0, 0})
    end),
    At(48.664, 21, function(d,s)
        d:director_event(0x80000023, {35825, 60, 0, 0})
    end),
    At(57.477, 22, function(d,s)
        d:director_event(0x80000001, {951, 0, 0, 0})
    end),
    At(58.194, 23, function(d,s)
        d:director_event(0x80000023, {35827, 60, 0, 0})
    end),
    At(59.037, 24, function(d,s)
        d:set_weather(175, 1.0)
    end),
    At(67.265, 25, function(d,s)
        d:director_event(0x8000001B, {1, 0, 0, 0})
    end),
}
