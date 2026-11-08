-- 未来确定α [18556]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
return {
    At(23.084, 360, function(d,s)
        s.scene:MapEffect(d, 1, 1, 2)
    end),
    At(23.084, 361, function(d,s)
        s.scene:MapEffect(d, 5, 1, 32)
    end),
    At(23.084, 362, function(d,s)
        s.scene:MapEffect(d, 4, 1, 32)
    end),
    At(23.084, 363, function(d,s)
        d:set_weather(108, 1.0)
    end),
}
