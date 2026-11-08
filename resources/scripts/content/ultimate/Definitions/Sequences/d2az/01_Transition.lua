-- 木桩后转场：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.09, 1, function(d,s)
        C.Action(d,s,A.AlexanderPrime,18553,{pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, target=A.AlexanderPrime})
    end),
    At(0.807, 2, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(0.807, 3, function(d,s)
        C.Owner(d,s,A.Helper12,A.Alexander)
    end),
    At(0.807, 4, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=28.7, z=44.9},-5e-05)
    end),
    At(0.857, 5, function(d,s)
        C.Cast(d,s,A.Helper12,19034,4.7,{spell=19034, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=28.7, z=44.9}, rotation=-3.14159})
    end),
    At(2.109, 6, function(d,s)
        C.Untether(d,s,A.BruteJustice,0,0)
    end),
    At(2.109, 7, function(d,s)
        C.Untether(d,s,A.CruiseChaser,0,0)
    end),
    At(2.109, 8, function(d,s)
        C.Targetable(d,s,A.AlexanderPrime,false)
    end),
    At(2.141, 9, function(d,s)
        C.Timeline(d,s,A.AlexanderPrime,7737)
    end),
    At(5.874, 10, function(d,s)
        C.Action(d,s,A.Helper12,19034,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05, dest={x=99.9924, y=-0.0153, z=99.9924}})
    end),
    At(15.556, 11, function(d,s)
        C.Action(d,s,A.Alexander,18554,{pos={x=109.8293, y=0.0, z=88.8354}, rotation=-5e-05, target=A.Alexander})
    end),
    At(27.666, 26, function(d,s)
        C.Move(d,s,A.AlexanderPrimeCutscene,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(27.717, 27, function(d,s)
        C.Timeline(d,s,A.AlexanderPrimeCutscene,7747)
    end),
    At(33.216, 29, function(d,s)
        C.Move(d,s,A.Boss,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(33.216, 30, function(d,s)
        C.Move(d,s,A.PerfectAlexanderCutscene,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(33.216, 31, function(d,s)
        C.Move(d,s,A.AlexanderPrimeCutscene,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(33.216, 32, function(d,s)
        C.Move(d,s,A.CruiseChaserCutscene,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(33.216, 33, function(d,s)
        C.Move(d,s,A.BruteJustice,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(33.216, 34, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.Boss,4561}, {A.PerfectAlexanderCutscene,4562}, {A.AlexanderPrimeCutscene,4561}, {A.CruiseChaserCutscene,4561}, {A.BruteJustice,4566}})
    end),
    At(71.382, 36, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(71.382, 37, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(71.382, 38, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(71.382, 39, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(71.382, 40, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(71.382, 41, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(71.382, 42, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(71.382, 43, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(71.6, 44, function(d,s)
        C.Despawn(d,s,A.PerfectAlexanderCutscene)
    end),
    At(71.6, 45, function(d,s)
        C.Despawn(d,s,A.CruiseChaserCutscene)
    end),
    At(71.6, 46, function(d,s)
        C.Despawn(d,s,A.BruteJustice)
    end),
    At(71.6, 47, function(d,s)
        C.Despawn(d,s,A.AlexanderPrimeCutscene)
    end),
    At(71.6, 48, function(d,s)
        C.Despawn(d,s,A.AlexanderPrime)
    end),
    At(71.6, 49, function(d,s)
        C.Despawn(d,s,A.CruiseChaser)
    end),
}
