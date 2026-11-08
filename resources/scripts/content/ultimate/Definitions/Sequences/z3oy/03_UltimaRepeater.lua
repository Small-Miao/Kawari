-- 连续究极 [47936]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 44, function(d,s)
        C.Cast(d,s,A.Boss,47936,3.7,{spell=47936, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.06949, target=A.Boss})
    end),
    At(3.995, 45, function(d,s)
        C.Action(d,s,A.Boss,47936,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.06949, target=A.Boss})
    end),
    At(3.995, 46, function(d,s)
        C.Owner(d,s,A.Helper16,A.Boss)
    end),
    At(3.995, 47, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.06949)
    end),
    At(3.995, 48, function(d,s)
        C.Owner(d,s,A.Helper15,A.Boss)
    end),
    At(3.995, 49, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.06949)
    end),
    At(3.995, 50, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(3.995, 51, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.06949)
    end),
    At(3.995, 52, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(3.995, 53, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-3.06949)
    end),
    At(5.151, 54, function(d,s)
        C.Action(d,s,A.Helper16,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.06949, target=A.Helper16})
    end),
    At(5.865, 55, function(d,s)
        C.Action(d,s,A.Helper15,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.06949, target=A.Helper15})
    end),
    At(6.529, 56, function(d,s)
        C.Action(d,s,A.Helper14,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.06949, target=A.Helper14})
    end),
    At(7.221, 57, function(d,s)
        C.Action(d,s,A.Helper13,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.06949, target=A.Helper13})
    end),
    At(8.143, 58, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.11446)
    end),
    At(9.203, 59, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11446, target=A.Boss})
    end),
    At(9.932, 60, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(9.932, 61, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(9.932, 62, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(9.996, 63, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(9.996, 64, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(9.996, 65, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(12.353, 66, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11446, target=A.Boss})
    end),
    At(13.122, 67, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(13.122, 68, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(13.122, 69, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(13.176, 70, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(13.176, 71, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(13.176, 72, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(15.49, 73, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11446, target=A.Boss})
    end),
    At(16.251, 74, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(16.251, 75, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(16.251, 76, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(16.314, 77, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(16.314, 78, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(16.314, 79, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
}
