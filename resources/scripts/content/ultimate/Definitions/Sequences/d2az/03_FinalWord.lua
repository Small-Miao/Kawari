-- 终审判决 [18557]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 63, function(d,s)
        C.Cast(d,s,A.Boss,18557,3.7,{spell=18557, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(3.987, 64, function(d,s)
        C.Action(d,s,A.Boss,18557,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(4.964, 65, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743})
    end),
}
