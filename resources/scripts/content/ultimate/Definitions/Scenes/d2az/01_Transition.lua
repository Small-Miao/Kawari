-- 木桩后转场：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
return {
    At(15.69, 12, function(d,s)
        s.scene:MapEffect(d, 2, 4, 8)
    end),
    At(15.69, 13, function(d,s)
        s.scene:MapEffect(d, 5, 1, 2)
    end),
    At(15.69, 14, function(d,s)
        s.scene:AnimateEObj(d, "prison_08", 1, 2)
    end),
    At(15.69, 15, function(d,s)
        s.scene:AnimateEObj(d, "prison_07", 1, 2)
    end),
    At(15.69, 16, function(d,s)
        s.scene:AnimateEObj(d, "prison_06", 1, 2)
    end),
    At(15.69, 17, function(d,s)
        s.scene:AnimateEObj(d, "prison_05", 1, 2)
    end),
    At(15.69, 18, function(d,s)
        s.scene:AnimateEObj(d, "prison_04", 1, 2)
    end),
    At(15.69, 19, function(d,s)
        s.scene:AnimateEObj(d, "prison_03", 1, 2)
    end),
    At(15.69, 20, function(d,s)
        s.scene:AnimateEObj(d, "prison_02", 1, 2)
    end),
    At(15.69, 21, function(d,s)
        s.scene:AnimateEObj(d, "prison_01", 1, 2)
    end),
    At(15.69, 22, function(d,s)
        d:set_weather(108, 1.0)
    end),
    At(18.583, 23, function(d,s)
        d:director_event(0x80000001, {713, 0, 0, 0})
    end),
    At(21.615, 24, function(d,s)
        d:director_event(0x80000001, {726, 0, 0, 0})
    end),
    At(23.616, 25, function(d,s)
        s.scene:MapEffect(d, 3, 1, 2)
    end),
    At(32.2, 28, function(d,s)
        d:director_event(0x80000008, {0, 0, 0, 0})
    end),
    At(68.381, 35, function(d,s)
        s.scene:MapEffect(d, 4, 1, 2)
    end),
    At(72.33, 50, function(d,s)
        d:director_event(0x80000009, {0, 0, 0, 0})
    end),
}
