-- 加重诛罚 [18578]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 451, function(d,s)
        C.Cast(d,s,A.Boss,18578,2.7,{spell=18578, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12999, target=A.Boss})
    end),
    At(2.982, 452, function(d,s)
        C.Action(d,s,A.Boss,18578,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12999, target=A.Boss})
    end),
    At(6.07, 453, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(6.07, 454, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(6.135, 455, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
}
