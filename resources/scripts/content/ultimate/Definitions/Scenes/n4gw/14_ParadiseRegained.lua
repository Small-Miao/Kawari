-- 复乐园 [40319]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(4.799, 1233, function(d,s)
        s.scene:MapEffect(d, 52, 1, 2)
    end),
    At(4.799, 1234, function(d,s)
        s.scene:MapEffect(d, 49, 4, 1)
    end),
    At(6.134, 1235, function(d,s)
        s.scene:MapEffect(d, 52, 16, 32)
    end),
}
