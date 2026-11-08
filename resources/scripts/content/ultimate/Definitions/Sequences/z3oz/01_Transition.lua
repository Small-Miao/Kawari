-- 木桩后转场：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.193, 2, function(d,s)
        C.Action(d,s,A.BossP5,31555,{pos={x=98.9853, y=0.0153, z=98.0087}, rotation=0.46226, dest={x=99.9924, y=-0.0153, z=99.9924}})
    end),
    At(0.258, 3, function(d,s)
        C.Move(d,s,A.BossP5,{x=98.9853, y=0.0153, z=98.0087},0.46226)
    end),
    At(0.516, 4, function(d,s)
        C.Spawn(d,s,A.Boss)
    end),
    At(0.516, 5, function(d,s)
        C.Spawn(d,s,A.IntermissionAlpha)
    end),
    At(0.516, 6, function(d,s)
        C.Spawn(d,s,A.IntermissionOmegaF)
    end),
    At(0.97, 7, function(d,s)
        C.Move(d,s,A.BossP5,{x=99.9924, y=0.0458, z=99.9924},0.46226)
    end),
    At(1.4, 8, function(d,s)
        C.Cast(d,s,A.BossP5,31623,9.7,{spell=31623, omen_delay=0, cast_pos={x=99.9924, y=0.0458, z=99.9924}, pos={x=99.9924, y=0.0458, z=99.9924}, rotation=-5e-05, target=A.BossP5})
    end),
    At(1.465, 9, function(d,s)
        C.Move(d,s,A.BossP5,{x=99.9924, y=0.0458, z=99.9924},-5e-05)
    end),
    At(11.367, 10, function(d,s)
        C.Action(d,s,A.BossP5,31623,{pos={x=99.9924, y=0.0458, z=99.9924}, rotation=-5e-05, target=A.BossP5})
    end),
    At(11.367, 11, function(d,s)
        C.Targetable(d,s,A.BossP5,false)
    end),
    At(11.367, 12, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(11.367, 13, function(d,s)
        C.Owner(d,s,A.Helper32,A.BossP5)
    end),
    At(11.367, 14, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0732, z=100.0},-5e-05)
    end),
    At(11.452, 15, function(d,s)
        C.Cast(d,s,A.Helper32,32626,0.9,{spell=32626, omen_delay=0, cast_pos={x=99.9924, y=0.0458, z=99.9924}, pos={x=100.0, y=0.0732, z=100.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(12.676, 16, function(d,s)
        C.Action(d,s,A.Helper32,32626,{pos={x=100.0, y=0.0732, z=100.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(14.17, 18, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.IntermissionOmegaF,4574}, {A.IntermissionAlpha,4573}, {A.Boss,4561}})
    end),
}
