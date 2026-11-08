-- 时空干涉 [18582]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1373, function(d,s)
        C.Cast(d,s,A.Boss,18582,4.7,{spell=18582, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(0.117, 1374, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-5e-05)
    end),
    At(5.0, 1375, function(d,s)
        C.Action(d,s,A.Boss,18582,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(6.202, 1376, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
