-- 魔数 [31670]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1891, function(d,s)
        C.Cast(d,s,A.Boss,31670,4.7,{spell=31670, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(1.025, 1892, function(d,s)
        C.Despawn(d,s,A.CosmoMeteor02)
    end),
    At(1.43, 1893, function(d,s)
        C.Despawn(d,s,A.CosmoMeteor01)
    end),
    At(5.007, 1894, function(d,s)
        C.Action(d,s,A.Boss,31670,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
}
