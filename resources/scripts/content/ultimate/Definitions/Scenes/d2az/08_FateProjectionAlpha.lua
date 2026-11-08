-- 未来观测α [18555]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
return {
    At(6.18, 170, function(d,s)
        s.scene:MapEffect(d, 1, 64, 128)
    end),
    At(6.18, 171, function(d,s)
        s.scene:MapEffect(d, 5, 64, 128)
    end),
    At(6.18, 172, function(d,s)
        s.scene:MapEffect(d, 4, 64, 128)
    end),
    At(6.18, 173, function(d,s)
        d:set_weather(132, 1.0)
    end),
}
