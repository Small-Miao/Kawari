-- 宇宙流星 [31664]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
return {
    At(7.993, 1785, function(d,s)
        s.scene:MapEffect(d, 12, 4, 2)
    end),
    At(7.993, 1786, function(d,s)
        s.scene:MapEffect(d, 13, 4, 2)
    end),
    At(7.993, 1787, function(d,s)
        s.scene:MapEffect(d, 14, 4, 2)
    end),
    At(7.993, 1788, function(d,s)
        s.scene:MapEffect(d, 15, 4, 2)
    end),
    At(7.993, 1789, function(d,s)
        s.scene:MapEffect(d, 16, 4, 2)
    end),
    At(7.993, 1790, function(d,s)
        s.scene:MapEffect(d, 17, 4, 2)
    end),
    At(7.993, 1791, function(d,s)
        s.scene:MapEffect(d, 18, 4, 2)
    end),
    At(7.993, 1792, function(d,s)
        s.scene:MapEffect(d, 19, 4, 2)
    end),
    At(8.416, 1801, function(d,s)
        s.scene:MapEffect(d, 21, 1, 2)
    end),
}
