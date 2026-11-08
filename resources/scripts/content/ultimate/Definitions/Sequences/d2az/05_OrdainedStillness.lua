-- 静止命令 [18559]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 86, function(d,s)
        C.Cast(d,s,A.Boss,18559,3.7,{spell=18559, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(4.02, 87, function(d,s)
        C.Action(d,s,A.Boss,18559,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743, target=A.Boss})
    end),
    At(4.02, 88, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(4.02, 89, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(4.02, 90, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(4.02, 91, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(4.02, 92, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(4.02, 93, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(4.02, 94, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(4.02, 95, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(4.02, 96, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(4.02, 97, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(4.02, 98, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(4.02, 99, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(4.02, 100, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(4.02, 101, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(4.02, 102, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(4.02, 103, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(4.082, 104, function(d,s)
        C.Action(d,s,A.Helper08,19040,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.082, 105, function(d,s)
        C.Action(d,s,A.Helper09,19040,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(4.082, 106, function(d,s)
        C.Action(d,s,A.Helper10,19040,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(4.082, 107, function(d,s)
        C.Action(d,s,A.Helper11,19040,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(4.082, 108, function(d,s)
        C.Action(d,s,A.Helper12,19040,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05})
    end),
    At(4.082, 109, function(d,s)
        C.Action(d,s,A.Helper05,19040,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.082, 110, function(d,s)
        C.Action(d,s,A.Helper06,19040,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(4.082, 111, function(d,s)
        C.Action(d,s,A.Helper07,19040,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(6.966, 112, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743})
    end),
    At(7.118, 113, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.08177)
    end),
    At(7.634, 114, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.02213)
    end),
    At(8.398, 115, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.08963)
    end),
    At(8.715, 116, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12414)
    end),
    At(9.922, 117, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.11388)
    end),
    At(10.069, 118, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11388})
    end),
    At(10.883, 119, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.14092)
    end),
}
