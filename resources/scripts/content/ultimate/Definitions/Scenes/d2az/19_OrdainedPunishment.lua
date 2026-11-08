-- 诛罚 [18577]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
return {
    At(8.058, 1119, function(d,s)
        s.scene:MapEffect(d, 6, 1, 2)
    end),
}
