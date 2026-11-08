-- 复乐园 [40319]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1231, function(d,s)
        C.Cast(d,s,A.Boss,40319,3.7,{spell=40319, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.08691, target=A.Boss})
    end),
    At(3.961, 1232, function(d,s)
        C.Action(d,s,A.Boss,40319,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.08691, target=A.Boss})
    end),
    At(7.076, 1236, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
