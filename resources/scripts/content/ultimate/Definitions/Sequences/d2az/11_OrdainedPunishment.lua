-- 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 456, function(d,s)
        C.Cast(d,s,A.Boss,18577,4.7,{spell=18577, omen_delay=0, cast_pos={x=100.1144, y=-0.0153, z=89.5552}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12999})
    end),
    At(0.037, 457, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(1.127, 458, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(5.009, 459, function(d,s)
        C.Action(d,s,A.Boss,18577,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12999})
    end),
    At(8.126, 460, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12999})
    end),
    At(8.126, 461, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.08292)
    end),
    At(11.092, 462, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.06547})
    end),
    At(12.398, 463, function(d,s)
        C.Action(d,s,A.Boss,18581,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.06547, dest={x=99.9924, y=-0.0153, z=99.9924}})
    end),
    At(12.998, 464, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.06547)
    end),
    At(14.892, 465, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.38161)
    end),
}
