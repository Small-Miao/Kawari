-- 复乐园 [40319]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 303, function(d,s)
        C.Cast(d,s,A.Boss,40319,3.7,{spell=40319, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.51718, target=A.Boss})
    end),
    At(0.141, 304, function(d,s)
        C.Move(d,s,A.Helper03,{x=110.6066, y=0.0, z=110.6066},0.78536)
    end),
    At(0.141, 305, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=120.0},-5e-05)
    end),
    At(0.216, 306, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=110.6066, y=0.0, z=110.6066}, rotation=0.78536, target=A.Helper03})
    end),
    At(0.216, 307, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(2.17, 308, function(d,s)
        C.Move(d,s,A.Helper03,{x=114.1421, y=0.0, z=114.1422},0.78536)
    end),
    At(2.241, 309, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=114.1421, y=0.0, z=114.1422}, rotation=0.78536, target=A.Helper03})
    end),
    At(4.013, 310, function(d,s)
        C.Action(d,s,A.Boss,40319,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.51718, target=A.Boss})
    end),
    At(7.064, 315, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
