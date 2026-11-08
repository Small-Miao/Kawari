-- 木桩后转场：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.057, 1, function(d,s)
        C.Targetable(d,s,A.UsurperOfFrostP4,false)
    end),
    At(0.057, 2, function(d,s)
        C.Targetable(d,s,A.OracleOfDarknessP4,false)
    end),
    At(0.127, 3, function(d,s)
        C.Timeline(d,s,A.OracleOfDarknessP4,4576)
    end),
    At(0.127, 4, function(d,s)
        C.Timeline(d,s,A.UsurperOfFrostP4,4581)
    end),
    At(3.34, 5, function(d,s)
        C.Move(d,s,A.UsurperOfFrostP4,{x=94.5, y=0.0, z=100.0},-5e-05)
    end),
    At(3.34, 6, function(d,s)
        C.Move(d,s,A.OracleOfDarknessP4,{x=105.5, y=0.0, z=100.0},-5e-05)
    end),
    At(3.58, 8, function(d,s)
        C.Timeline(d,s,A.OracleOfDarknessP4,4564)
    end),
    At(3.58, 9, function(d,s)
        C.Timeline(d,s,A.UsurperOfFrostP4,7747)
    end),
    At(3.65, 10, function(d,s)
        C.Spawn(d,s,A.Boss)
    end),
    At(8.783, 12, function(d,s)
        C.Action(d,s,A.UsurperOfFrostP4,40231,{pos={x=94.5, y=0.0, z=100.0}, rotation=-5e-05, target=A.UsurperOfFrostP4})
    end),
    At(9.641, 13, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(9.641, 14, function(d,s)
        C.Owner(d,s,A.Helper14,A.UsurperOfFrostP4)
    end),
    At(9.641, 15, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=115.0},-3.14159)
    end),
    At(9.71, 16, function(d,s)
        C.Action(d,s,A.Helper14,40232,{pos={x=100.0, y=0.0, z=115.0}, rotation=-3.14159, target=A.Helper14})
    end),
    At(10.833, 18, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.UsurperOfFrostP4,4578}, {A.OracleOfDarknessP4,4573}, {A.Boss,4561}})
    end),
    At(12.849, 20, function(d,s)
        C.Despawn(d,s,A.VisionOfGaia)
    end),
    At(12.849, 21, function(d,s)
        C.Despawn(d,s,A.VisionOfRyne)
    end),
    At(76.966, 29, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(76.966, 30, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(76.966, 31, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(76.966, 32, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(76.966, 33, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(76.966, 34, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(76.966, 35, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(76.966, 36, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(76.966, 37, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(76.966, 38, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(76.966, 39, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(76.966, 40, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(76.966, 41, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(76.966, 42, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
}
