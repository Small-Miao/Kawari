-- 百京核爆剑 [28059]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
return {
    At(10.058, 158, function(d,s)
        d:director_event(0x8000001E, {581, 0, 0, 0})
    end),
}
