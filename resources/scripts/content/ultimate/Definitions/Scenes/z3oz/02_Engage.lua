-- 最终本体出现：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
return {
    At(0.0, 32, function(d,s)
        d:director_event(0x8000001E, {686, 0, 0, 0})
    end),
    At(0.0, 33, function(d,s)
        s.scene:MapEffect(d, 0, 1, 2)
    end),
}
