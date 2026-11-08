-- 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
return {
    At(10.178, 11, function(d,s)
        d:director_event(0x80000016, {1, 70, 0, 0})
    end),
    At(17.311, 15, function(d,s)
        d:director_event(0x8000001E, {580, 0, 0, 0})
    end),
    At(37.375, 47, function(d,s)
        d:set_weather(170, 3.0)
    end),
    At(52.098, 77, function(d,s)
        d:director_event(0x80000001, {1, 0, 0, 0})
    end),
    At(54.145, 82, function(d,s)
        d:director_event(0x8000001F, {765, 0, 0, 0})
    end),
    At(54.145, 83, function(d,s)
        d:set_weather(47, 0.0)
    end),
}
