-- 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(1.023, 46, function(d,s)
        d:director_event(0x80000027, {36, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
}
