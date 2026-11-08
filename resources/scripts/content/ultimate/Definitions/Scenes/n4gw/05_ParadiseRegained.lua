-- 复乐园 [40319]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(4.843, 311, function(d,s)
        s.scene:MapEffect(d, 51, 1, 2)
    end),
    At(4.843, 312, function(d,s)
        s.scene:MapEffect(d, 48, 4, 1)
    end),
    At(4.879, 313, function(d,s)
        s.scene:MapEffect(d, 51, 64, 128)
    end),
    At(5.929, 314, function(d,s)
        d:director_event(0x80000027, {39, 2, 9347, 0})
    end),
}
