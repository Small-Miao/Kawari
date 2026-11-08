-- 失乐园 [40327]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 2100, function(d,s)
        C.Cast(d,s,A.Boss,40327,11.7,{spell=40327, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.94754, target=A.Boss})
    end),
    At(0.0, 2101, function(d,s)
        C.Cast(d,s,A.Helper14,40328,21.2,{spell=40328, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-2.94754, target=A.Helper14})
    end),
    At(11.996, 2104, function(d,s)
        C.Action(d,s,A.Boss,40327,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.94754, target=A.Boss})
    end),
}
