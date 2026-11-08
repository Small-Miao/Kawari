-- 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
return {
    At(2.995, 43, function(d,s)
        d:director_event(0x80000027, {38, 2, 7131, d:actor_id(A.Boss) or 0})
    end),
}
