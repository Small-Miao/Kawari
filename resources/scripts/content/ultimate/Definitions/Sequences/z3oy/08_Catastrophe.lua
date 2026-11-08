-- 二选一的灾祟 [49743]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 235, function(d,s)
        C.Cast(d,s,A.Boss,49743,4.0,{spell=49743, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.273, 236, function(d,s)
        C.Action(d,s,A.Boss,49743,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.9, 241, function(d,s)
        C.Action(d,s,A.Helper13,47941,{pos={x=103.4202, y=0.0, z=90.6031}, rotation=-5e-05, target=A.Helper13})
    end),
    At(4.9, 242, function(d,s)
        C.Action(d,s,A.Helper14,47941,{pos={x=108.6603, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper14})
    end),
    At(4.9, 243, function(d,s)
        C.Action(d,s,A.Helper16,47939,{pos={x=91.3397, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(4.9, 244, function(d,s)
        C.Action(d,s,A.Helper15,47940,{pos={x=93.5721, y=0.0, z=107.6604}, rotation=-5e-05, target=A.Helper15})
    end),
    At(5.022, 245, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(5.085, 246, function(d,s)
        C.Action(d,s,A.Helper12,47947,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper12})
    end),
}
