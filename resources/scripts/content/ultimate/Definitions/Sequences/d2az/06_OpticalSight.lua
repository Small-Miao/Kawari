-- 制导 [18571]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 120, function(d,s)
        C.Cast(d,s,A.Boss,18571,2.7,{spell=18571, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092, target=A.Boss})
    end),
    At(3.003, 121, function(d,s)
        C.Action(d,s,A.Boss,18571,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092, target=A.Boss})
    end),
    At(4.887, 122, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.14092})
    end),
    At(4.976, 123, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(4.976, 124, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(4.976, 125, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(4.976, 126, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(5.07, 127, function(d,s)
        C.Action(d,s,A.Helper11,18573,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(5.07, 128, function(d,s)
        C.Action(d,s,A.Helper12,18573,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05})
    end),
}
