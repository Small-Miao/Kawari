-- 光与暗的孤翼 [40313]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(1.027, 1238, function(d,s)
        s.scene:MapEffect(d, 52, 64, 128)
    end),
    At(1.129, 1239, function(d,s)
        s.scene:MapEffect(d, 51, 1, 2)
    end),
    At(1.129, 1240, function(d,s)
        s.scene:MapEffect(d, 48, 4, 1)
    end),
    At(2.857, 1241, function(d,s)
        s.scene:MapEffect(d, 51, 16, 32)
    end),
    At(3.393, 1242, function(d,s)
        s.scene:MapEffect(d, 51, 64, 128)
    end),
    At(4.675, 1243, function(d,s)
        s.scene:MapEffect(d, 53, 1, 2)
    end),
    At(4.675, 1244, function(d,s)
        s.scene:MapEffect(d, 50, 4, 1)
    end),
    At(7.178, 1250, function(d,s)
        s.scene:MapEffect(d, 52, 4, 8)
    end),
    At(9.389, 1257, function(d,s)
        s.scene:MapEffect(d, 53, 16, 32)
    end),
    At(9.638, 1258, function(d,s)
        s.scene:MapEffect(d, 53, 64, 128)
    end),
    At(10.707, 1262, function(d,s)
        s.scene:MapEffect(d, 51, 4, 8)
    end),
    At(14.146, 1274, function(d,s)
        s.scene:MapEffect(d, 53, 4, 8)
    end),
}
