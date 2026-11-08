-- 代码：＊能＊ [31648]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1897, function(d,s)
        C.Cast(d,s,A.Boss,31648,15.7,{spell=31648, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(15.947, 1898, function(d,s)
        C.Action(d,s,A.Boss,31648,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
}
