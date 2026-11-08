-- 宇宙记忆 [31649]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 41, function(d,s)
        C.Cast(d,s,A.Boss,31649,5.7,{spell=31649, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13028, target=A.Boss})
    end),
    At(5.951, 42, function(d,s)
        C.Action(d,s,A.Boss,31649,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13028, target=A.Boss})
    end),
    At(10.098, 43, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13028, target=A.Boss})
    end),
    At(10.891, 44, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(10.891, 45, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(10.891, 46, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=119.1128, y=0.0, z=100.9695}, rotation=-1.02524})
    end),
    At(10.891, 47, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0732, z=100.0}, rotation=-5e-05})
    end),
    At(11.296, 48, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.07649)
    end),
    At(13.197, 49, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(13.989, 50, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(13.989, 51, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(13.989, 52, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(13.989, 53, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(13.989, 54, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=119.1128, y=0.0, z=100.9695}, rotation=-1.02524})
    end),
    At(13.989, 55, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0732, z=100.0}, rotation=-5e-05})
    end),
    At(14.217, 56, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(14.217, 57, function(d,s)
        C.Move(d,s,A.Helper30,{x=85.0, y=0.0, z=80.0},-5e-05)
    end),
    At(14.217, 58, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(14.217, 59, function(d,s)
        C.Move(d,s,A.Helper29,{x=85.0, y=0.0, z=80.0},-5e-05)
    end),
    At(14.238, 60, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(14.238, 61, function(d,s)
        C.Move(d,s,A.Helper28,{x=120.0, y=0.0, z=85.0},-1.57087)
    end),
    At(14.238, 62, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(14.238, 63, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=85.0},-1.57087)
    end),
    At(14.238, 64, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(14.238, 65, function(d,s)
        C.Move(d,s,A.Helper26,{x=115.0, y=0.0, z=120.0},-3.14159)
    end),
    At(14.238, 66, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(14.238, 67, function(d,s)
        C.Move(d,s,A.Helper25,{x=115.0, y=0.0, z=120.0},-3.14159)
    end),
    At(14.238, 68, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(14.238, 69, function(d,s)
        C.Move(d,s,A.Helper24,{x=80.0, y=0.0, z=115.0},1.57077)
    end),
    At(14.238, 70, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(14.238, 71, function(d,s)
        C.Move(d,s,A.Helper23,{x=80.0, y=0.0, z=115.0},1.57077)
    end),
}
