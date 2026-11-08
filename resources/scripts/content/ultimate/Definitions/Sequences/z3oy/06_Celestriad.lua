-- 三星 [47938]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 177, function(d,s)
        C.Cast(d,s,A.Boss,47938,4.7,{spell=47938, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.997, 178, function(d,s)
        C.Action(d,s,A.Boss,47938,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(8.043, 188, function(d,s)
        C.Move(d,s,A.Helper16,{x=91.3397, y=0.0, z=95.0},-5e-05)
    end),
    At(8.043, 190, function(d,s)
        C.Move(d,s,A.Helper15,{x=93.5721, y=0.0, z=107.6604},-5e-05)
    end),
    At(8.043, 192, function(d,s)
        C.Move(d,s,A.Helper14,{x=106.4279, y=0.0, z=107.6604},-5e-05)
    end),
    At(8.043, 194, function(d,s)
        C.Move(d,s,A.Helper13,{x=103.4202, y=0.0, z=90.6031},-5e-05)
    end),
}
