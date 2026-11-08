-- 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 843, function(d,s)
        C.Cast(d,s,A.Boss,18577,4.7,{spell=18577, omen_delay=0, cast_pos={x=99.9008, y=-0.0153, z=92.4849}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12884})
    end),
    At(0.036, 844, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(1.123, 845, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(5.001, 846, function(d,s)
        C.Action(d,s,A.Boss,18577,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12884})
    end),
    At(8.067, 847, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12884})
    end),
    At(8.29, 848, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.09461)
    end),
    At(9.733, 849, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.14111)
    end),
    At(10.016, 850, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.11216)
    end),
    At(11.083, 851, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11216})
    end),
}
