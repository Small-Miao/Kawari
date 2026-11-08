-- 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
return {
    At(0.073, 96, function(d,s)
        d:director_event(0x80000016, {1, 80, 0, 0})
    end),
    At(3.146, 101, function(d,s)
        d:director_event(0x80000001, {907, 0, 0, 0})
    end),
}
