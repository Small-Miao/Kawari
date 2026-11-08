-- 潘多拉魔盒 [40326]：地图 / EObj / 音乐 / 天气 / 过场。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
return {
    At(0.849, 938, function(d,s)
        d:director_event(0x80000027, {34, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
    At(7.884, 939, function(d,s)
        d:director_event(0x80000027, {38, 2, 13561, d:actor_id(A.Boss) or 0})
    end),
    At(13.91, 941, function(d,s)
        s.scene:MapEffect(d, 47, 8, 16)
    end),
}
