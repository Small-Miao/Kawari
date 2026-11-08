-- 连续究极 [47936]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 247, function(d,s)
        C.Cast(d,s,A.Boss,47936,3.7,{spell=47936, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(3.995, 257, function(d,s)
        C.Action(d,s,A.Boss,47936,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(3.995, 258, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(3.995, 259, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(3.995, 260, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(3.995, 261, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},3.14159)
    end),
    At(5.113, 262, function(d,s)
        C.Action(d,s,A.Helper16,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper16})
    end),
    At(5.843, 263, function(d,s)
        C.Action(d,s,A.Helper15,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper15})
    end),
    At(6.522, 264, function(d,s)
        C.Action(d,s,A.Helper14,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper14})
    end),
    At(7.212, 265, function(d,s)
        C.Action(d,s,A.Helper13,47937,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.14159, target=A.Helper13})
    end),
    At(8.274, 266, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.10305)
    end),
    At(9.228, 267, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.10305, target=A.Boss})
    end),
    At(9.981, 268, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(9.981, 269, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(9.981, 270, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(10.033, 271, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(10.033, 272, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(10.033, 273, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(12.385, 274, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.10305, target=A.Boss})
    end),
    At(13.119, 275, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(13.119, 276, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(13.119, 277, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.10305)
    end),
    At(13.158, 278, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(13.158, 279, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(13.171, 280, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.10305})
    end),
    At(14.547, 282, function(d,s)
        C.Move(d,s,A.Helper16,{x=70.0, y=0.0, z=95.0},0.78536)
    end),
    At(14.547, 283, function(d,s)
        C.Move(d,s,A.Helper15,{x=85.0, y=0.0, z=80.0},0.78536)
    end),
    At(14.574, 284, function(d,s)
        C.Cast(d,s,A.Helper16,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=69.9931, y=-0.0153, z=94.9874}, pos={x=70.0, y=0.0, z=95.0}, rotation=0.78536, target=A.Helper16})
    end),
    At(14.574, 285, function(d,s)
        C.Cast(d,s,A.Helper15,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=84.9775, y=-0.0153, z=79.9725}, pos={x=85.0, y=0.0, z=80.0}, rotation=0.78536, target=A.Helper15})
    end),
}
