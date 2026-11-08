-- 光与暗的孤翼 [40313]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(1.159, 317, function(d,s)
        s.scene:MapEffect(d, 52, 1, 2)
    end),
    At(1.159, 318, function(d,s)
        s.scene:MapEffect(d, 49, 4, 1)
    end),
    At(3.859, 319, function(d,s)
        d:director_event(0x80000027, {40, 2, 9326, 0})
    end),
    At(4.671, 320, function(d,s)
        s.scene:MapEffect(d, 53, 1, 2)
    end),
    At(4.671, 321, function(d,s)
        s.scene:MapEffect(d, 50, 4, 1)
    end),
    At(5.255, 322, function(d,s)
        s.scene:MapEffect(d, 53, 16, 32)
    end),
    At(7.071, 324, function(d,s)
        s.scene:MapEffect(d, 53, 64, 128)
    end),
    At(7.204, 330, function(d,s)
        s.scene:MapEffect(d, 51, 4, 8)
    end),
    At(9.36, 336, function(d,s)
        s.scene:MapEffect(d, 52, 16, 32)
    end),
    At(10.262, 337, function(d,s)
        s.scene:MapEffect(d, 52, 64, 128)
    end),
    At(10.732, 341, function(d,s)
        s.scene:MapEffect(d, 52, 4, 8)
    end),
    At(14.205, 354, function(d,s)
        s.scene:MapEffect(d, 53, 4, 8)
    end),
}
