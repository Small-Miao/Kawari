-- 失乐园 [40327]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(5.416, 2102, function(d,s)
        d:director_event(0x80000027, {49, 2, 9326, 0})
    end),
    At(10.425, 2103, function(d,s)
        d:director_event(0x80000027, {50, 2, 9347, 0})
    end),
    At(17.488, 2105, function(d,s)
        d:director_event(0x80000027, {51, 2, 13699, 0})
    end),
}
