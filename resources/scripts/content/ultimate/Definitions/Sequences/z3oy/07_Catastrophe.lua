-- 二选一的灾祟 [49743]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 196, function(d,s)
        C.Cast(d,s,A.Boss,49743,4.0,{spell=49743, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.302, 197, function(d,s)
        C.Action(d,s,A.Boss,49743,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.87, 202, function(d,s)
        C.Move(d,s,A.Helper12,{x=90.1519, y=0.0, z=101.7365},-5e-05)
    end),
    At(4.87, 204, function(d,s)
        C.Move(d,s,A.Helper11,{x=96.5798, y=0.0, z=90.6031},-5e-05)
    end),
    At(4.87, 206, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(4.87, 207, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=110.0},-5e-05)
    end),
    At(4.87, 209, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(4.87, 210, function(d,s)
        C.Move(d,s,A.Helper09,{x=109.8481, y=0.0, z=101.7365},-5e-05)
    end),
    At(4.947, 212, function(d,s)
        C.Action(d,s,A.Helper13,47941,{pos={x=103.4202, y=0.0, z=90.6031}, rotation=-5e-05, target=A.Helper13})
    end),
    At(4.947, 213, function(d,s)
        C.Action(d,s,A.Helper14,47940,{pos={x=106.4279, y=0.0, z=107.6604}, rotation=-5e-05, target=A.Helper14})
    end),
    At(4.947, 214, function(d,s)
        C.Action(d,s,A.Helper16,47939,{pos={x=91.3397, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(4.947, 215, function(d,s)
        C.Action(d,s,A.Helper15,47940,{pos={x=93.5721, y=0.0, z=107.6604}, rotation=-5e-05, target=A.Helper15})
    end),
    At(5.065, 216, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(5.065, 217, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(5.129, 218, function(d,s)
        C.Action(d,s,A.Helper08,47947,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper08})
    end),
    At(10.861, 223, function(d,s)
        C.Move(d,s,A.Helper16,{x=91.3397, y=0.0, z=95.0},-5e-05)
    end),
    At(10.861, 225, function(d,s)
        C.Move(d,s,A.Helper15,{x=93.5721, y=0.0, z=107.6604},-5e-05)
    end),
    At(10.861, 227, function(d,s)
        C.Move(d,s,A.Helper14,{x=108.6603, y=0.0, z=95.0},-5e-05)
    end),
    At(10.861, 229, function(d,s)
        C.Move(d,s,A.Helper13,{x=103.4202, y=0.0, z=90.6031},-5e-05)
    end),
    At(10.989, 231, function(d,s)
        C.Action(d,s,A.Helper09,47941,{pos={x=109.8481, y=0.0, z=101.7365}, rotation=-5e-05, target=A.Helper09})
    end),
    At(10.989, 232, function(d,s)
        C.Action(d,s,A.Helper10,47940,{pos={x=100.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(10.989, 233, function(d,s)
        C.Action(d,s,A.Helper12,47939,{pos={x=90.1519, y=0.0, z=101.7365}, rotation=-5e-05, target=A.Helper12})
    end),
    At(10.989, 234, function(d,s)
        C.Action(d,s,A.Helper11,47939,{pos={x=96.5798, y=0.0, z=90.6031}, rotation=-5e-05, target=A.Helper11})
    end),
}
