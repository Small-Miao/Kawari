-- 行动命令 [18558]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 66, function(d,s)
        C.Cast(d,s,A.Boss,18558,3.7,{spell=18558, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(3.946, 67, function(d,s)
        C.Action(d,s,A.Boss,18558,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(3.946, 68, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(3.946, 69, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(3.946, 70, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(3.946, 71, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(3.946, 72, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(3.946, 73, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(3.946, 74, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(3.946, 75, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(3.946, 76, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(4.031, 77, function(d,s)
        C.Action(d,s,A.Helper08,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.031, 78, function(d,s)
        C.Action(d,s,A.Helper09,19039,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(4.031, 79, function(d,s)
        C.Action(d,s,A.Helper10,19039,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(4.031, 80, function(d,s)
        C.Action(d,s,A.Helper11,19039,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(4.031, 81, function(d,s)
        C.Action(d,s,A.Helper12,19039,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05})
    end),
    At(4.031, 82, function(d,s)
        C.Action(d,s,A.Helper05,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.031, 83, function(d,s)
        C.Action(d,s,A.Helper06,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.031, 84, function(d,s)
        C.Action(d,s,A.Helper07,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(11.031, 85, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743})
    end),
}
