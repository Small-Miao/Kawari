-- 潘多拉魔盒 [40326]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 936, function(d,s)
        C.Cast(d,s,A.Boss,40326,11.7,{spell=40326, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.75562, target=A.Boss})
    end),
    At(0.0, 937, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.75562)
    end),
    At(11.942, 940, function(d,s)
        C.Action(d,s,A.Boss,40326,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.75562, target=A.Boss})
    end),
    At(18.071, 942, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.34575)
    end),
}
