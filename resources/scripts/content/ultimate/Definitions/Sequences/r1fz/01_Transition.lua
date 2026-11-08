-- 木桩后转场：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.076, 1, function(d,s)
        C.Targetable(d,s,A.NidhoggP6,false)
    end),
    At(0.114, 2, function(d,s)
        C.Timeline(d,s,A.NidhoggP6,4574)
    end),
    At(0.536, 3, function(d,s)
        C.Spawn(d,s,A.RightEye)
    end),
    At(0.536, 4, function(d,s)
        C.Spawn(d,s,A.LeftEye01)
    end),
    At(0.536, 5, function(d,s)
        C.Spawn(d,s,A.Estinien)
    end),
    At(4.042, 6, function(d,s)
        C.Tether(d,s,A.LeftEye01,A.Estinien,178,0)
    end),
    At(4.042, 7, function(d,s)
        C.Tether(d,s,A.RightEye,A.Estinien,179,0)
    end),
    At(4.124, 8, function(d,s)
        C.Timeline(d,s,A.RightEye,7750)
    end),
    At(4.124, 9, function(d,s)
        C.Timeline(d,s,A.LeftEye01,7750)
    end),
    At(4.124, 10, function(d,s)
        C.Timeline(d,s,A.Estinien,7750)
    end),
    At(10.529, 12, function(d,s)
        C.Spawn(d,s,A.Alphinaud)
    end),
    At(12.21, 13, function(d,s)
        C.Targetable(d,s,A.HraesvelgrP6,false)
    end),
    At(15.423, 14, function(d,s)
        C.Timeline(d,s,A.Alphinaud,7756)
    end),
    At(20.418, 16, function(d,s)
        C.Action(d,s,A.RightEye,29050,{pos={x=97.9781, y=-0.0153, z=99.9923}, rotation=-1.56991, dest={x=89.9825, y=-0.0153, z=99.9924}})
    end),
    At(20.418, 17, function(d,s)
        C.Action(d,s,A.LeftEye01,29050,{pos={x=102.0, y=-0.0, z=100.0}, rotation=1.57077, dest={x=109.9718, y=-0.0153, z=99.9924}})
    end),
    At(20.418, 18, function(d,s)
        C.Action(d,s,A.Estinien,26810,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Estinien})
    end),
    At(21.175, 19, function(d,s)
        C.Model(d,s,A.RightEye,0)
    end),
    At(21.175, 20, function(d,s)
        C.Model(d,s,A.LeftEye01,0)
    end),
    At(22.058, 21, function(d,s)
        C.Model(d,s,A.Estinien,27)
    end),
    At(23.492, 22, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=100.2365, y=-0.0153, z=109.9107},2.57602)
    end),
    At(23.56, 23, function(d,s)
        C.Move(d,s,A.RightEye,{x=89.9825, y=0.1984, z=99.9924},-1.56991)
    end),
    At(23.56, 24, function(d,s)
        C.Move(d,s,A.LeftEye01,{x=109.9718, y=0.1984, z=99.9924},1.57077)
    end),
    At(23.763, 25, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=102.0371, y=0.0458, z=109.3919},1.849)
    end),
    At(23.844, 26, function(d,s)
        C.Move(d,s,A.RightEye,{x=89.9825, y=0.1984, z=99.9924},1.40222)
    end),
    At(23.844, 27, function(d,s)
        C.Move(d,s,A.LeftEye01,{x=109.9718, y=0.1984, z=99.9924},-1.38966)
    end),
    At(24.071, 28, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=103.8682, y=0.1068, z=108.8731},1.849)
    end),
    At(24.449, 29, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=105.6687, y=0.1373, z=108.3543},1.849)
    end),
    At(24.736, 30, function(d,s)
        C.Targetable(d,s,A.LeftEye01,false)
    end),
    At(24.736, 31, function(d,s)
        C.Target(d,s,A.Alphinaud,A.LeftEye01)
    end),
    At(24.736, 32, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=106.981, y=0.1984, z=107.9881},2.41467)
    end),
    At(25.06, 33, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=106.981, y=0.1984, z=107.9881},2.78273)
    end),
    At(26.553, 34, function(d,s)
        C.Cast(d,s,A.Alphinaud,25584,1.7,{spell=25584, omen_delay=0, cast_pos={x=109.9718, y=0.1984, z=99.9924}, pos={x=106.981, y=0.1984, z=107.9881}, rotation=2.78273, target=A.LeftEye01})
    end),
    At(26.633, 35, function(d,s)
        C.Spawn(d,s,A.BossP5)
    end),
    At(26.633, 36, function(d,s)
        C.Spawn(d,s,A.Boss)
    end),
    At(28.526, 37, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.Boss,4573}, {A.BossP5,4574}})
    end),
    At(28.526, 38, function(d,s)
        C.Targetable(d,s,A.BossP5,false)
    end),
    At(28.526, 39, function(d,s)
        C.Action(d,s,A.Alphinaud,25584,{pos={x=106.981, y=0.1984, z=107.9881}, rotation=2.78273, target=A.LeftEye01})
    end),
    At(30.788, 40, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=106.981, y=0.1984, z=107.9881},-3.12338)
    end),
    At(31.031, 41, function(d,s)
        C.Move(d,s,A.Alphinaud,{x=106.981, y=0.1984, z=107.9881},-2.42282)
    end),
    At(33.758, 42, function(d,s)
        C.Timeline(d,s,A.Alphinaud,10602)
    end),
    At(37.141, 43, function(d,s)
        C.Presentation(d,s,A.HraesvelgrP6,1,0,100)
    end),
    At(37.375, 44, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(37.375, 45, function(d,s)
        C.Owner(d,s,A.Helper10,A.BossP5)
    end),
    At(37.375, 46, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=88.0},-5e-05)
    end),
    At(37.451, 48, function(d,s)
        C.Model(d,s,A.Alphinaud,12)
    end),
    At(37.451, 49, function(d,s)
        C.Model(d,s,A.Estinien,6)
    end),
    At(37.529, 50, function(d,s)
        C.Action(d,s,A.Helper10,29156,{pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(37.529, 51, function(d,s)
        C.Timeline(d,s,A.Estinien,10508)
    end),
    At(37.529, 52, function(d,s)
        C.Timeline(d,s,A.Alphinaud,8956)
    end),
    At(37.937, 53, function(d,s)
        C.Spawn(d,s,A.LeftEye02)
    end),
    At(37.937, 54, function(d,s)
        C.Spawn(d,s,A.LeftEye03)
    end),
    At(38.32, 55, function(d,s)
        C.Despawn(d,s,A.HraesvelgrP6)
    end),
    At(39.155, 56, function(d,s)
        C.Move(d,s,A.LeftEye01,{x=109.9718, y=0.1984, z=99.9924},-1.95514)
    end),
    At(39.22, 57, function(d,s)
        C.Untether(d,s,A.LeftEye01,0,0)
    end),
    At(39.22, 58, function(d,s)
        C.Action(d,s,A.LeftEye01,25587,{pos={x=109.9718, y=0.1984, z=99.9924}, rotation=-2.44688, target=A.BossP5})
    end),
    At(39.384, 59, function(d,s)
        C.Move(d,s,A.RightEye,{x=89.9825, y=0.1984, z=99.9924},1.9677)
    end),
    At(39.449, 60, function(d,s)
        C.Untether(d,s,A.RightEye,0,0)
    end),
    At(39.449, 61, function(d,s)
        C.Action(d,s,A.RightEye,25587,{pos={x=89.9825, y=0.1984, z=99.9924}, rotation=2.44678, target=A.BossP5})
    end),
    At(39.449, 62, function(d,s)
        C.Action(d,s,A.LeftEye03,29365,{pos={x=105.0, y=0.0, z=120.5}, rotation=-3.14159, target=A.BossP5})
    end),
    At(39.449, 63, function(d,s)
        C.Move(d,s,A.LeftEye01,{x=109.9718, y=0.1984, z=99.9924},-2.44688)
    end),
    At(39.658, 64, function(d,s)
        C.Action(d,s,A.LeftEye02,25588,{pos={x=104.0, y=0.0, z=122.0}, rotation=-3.14159, target=A.BossP5})
    end),
    At(39.658, 65, function(d,s)
        C.Move(d,s,A.LeftEye02,{x=103.9902, y=-0.0153, z=121.9959},-3.02453)
    end),
    At(39.658, 66, function(d,s)
        C.Move(d,s,A.LeftEye03,{x=104.9973, y=-0.0153, z=120.47},-2.98896)
    end),
    At(39.658, 67, function(d,s)
        C.Move(d,s,A.RightEye,{x=89.9825, y=0.1984, z=99.9924},2.44678)
    end),
    At(41.114, 68, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.Alphinaud,7746}, {A.Estinien,7737}})
    end),
    At(42.286, 69, function(d,s)
        C.Presentation(d,s,A.LeftEye01,1,0,100)
    end),
    At(42.5, 70, function(d,s)
        C.Presentation(d,s,A.RightEye,1,0,100)
    end),
    At(42.97, 71, function(d,s)
        C.Presentation(d,s,A.LeftEye03,1,0,100)
    end),
    At(43.21, 72, function(d,s)
        C.Presentation(d,s,A.LeftEye02,1,0,100)
    end),
    At(43.575, 73, function(d,s)
        C.Despawn(d,s,A.RightEye)
    end),
    At(43.575, 74, function(d,s)
        C.Despawn(d,s,A.LeftEye01)
    end),
    At(44.42, 75, function(d,s)
        C.Despawn(d,s,A.LeftEye02)
    end),
    At(44.42, 76, function(d,s)
        C.Despawn(d,s,A.LeftEye03)
    end),
    At(53.13, 78, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(53.13, 79, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(53.13, 80, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=88.0},-5e-05)
    end),
    At(53.197, 81, function(d,s)
        C.Action(d,s,A.Helper10,29752,{pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(55.186, 84, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(55.186, 85, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(55.186, 86, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(55.186, 87, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(55.186, 88, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(55.186, 89, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(55.253, 90, function(d,s)
        C.Despawn(d,s,A.NidhoggP6)
    end),
    At(55.253, 91, function(d,s)
        C.Despawn(d,s,A.Estinien)
    end),
    At(55.253, 92, function(d,s)
        C.Despawn(d,s,A.Alphinaud)
    end),
    At(58.083, 93, function(d,s)
        C.Move(d,s,A.Boss,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(59.254, 94, function(d,s)
        C.Despawn(d,s,A.BossP5)
    end),
}
