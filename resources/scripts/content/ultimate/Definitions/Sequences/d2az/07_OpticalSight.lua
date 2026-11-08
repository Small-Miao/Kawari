-- 制导 [18570]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 129, function(d,s)
        C.Cast(d,s,A.Boss,18570,2.7,{spell=18570, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092, target=A.Boss})
    end),
    At(3.011, 130, function(d,s)
        C.Action(d,s,A.Boss,18570,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092, target=A.Boss})
    end),
    At(4.828, 131, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092})
    end),
    At(5.012, 132, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(5.012, 133, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(5.012, 134, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(5.012, 135, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(5.012, 136, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(5.012, 137, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(5.012, 138, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(5.012, 139, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(5.012, 140, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(5.012, 141, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(5.012, 142, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(5.012, 143, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(5.012, 144, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(5.012, 145, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(5.012, 146, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(5.012, 147, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(5.078, 148, function(d,s)
        C.Action(d,s,A.Helper08,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(5.078, 149, function(d,s)
        C.Action(d,s,A.Helper09,18572,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(5.078, 150, function(d,s)
        C.Action(d,s,A.Helper10,18572,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(5.078, 151, function(d,s)
        C.Action(d,s,A.Helper11,18572,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(5.078, 152, function(d,s)
        C.Action(d,s,A.Helper12,18572,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05})
    end),
    At(5.078, 153, function(d,s)
        C.Action(d,s,A.Helper05,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(5.078, 154, function(d,s)
        C.Action(d,s,A.Helper06,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(5.078, 155, function(d,s)
        C.Action(d,s,A.Helper07,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(6.145, 156, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.06739)
    end),
    At(7.61, 157, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.10085)
    end),
    At(7.86, 158, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11849})
    end),
    At(7.928, 159, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.11849)
    end),
    At(10.195, 160, function(d,s)
        C.Action(d,s,A.Boss,18581,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11849, dest={x=99.9924, y=-0.0153, z=99.9924}})
    end),
    At(10.928, 161, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.11849)
    end),
    At(12.813, 162, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.43453)
    end),
}
