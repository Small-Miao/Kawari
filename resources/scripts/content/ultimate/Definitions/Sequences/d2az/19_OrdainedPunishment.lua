-- 诛罚 [18577]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1115, function(d,s)
        C.Cast(d,s,A.Boss,18577,4.7,{spell=18577, omen_delay=0, cast_pos={x=100.0534, y=-0.0153, z=91.6609}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13153})
    end),
    At(0.037, 1116, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05})
    end),
    At(1.093, 1117, function(d,s)
        C.Action(d,s,A.Helper12,18579,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05})
    end),
    At(4.995, 1118, function(d,s)
        C.Action(d,s,A.Boss,18577,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13153})
    end),
}
