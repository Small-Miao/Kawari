-- 百京核爆剑 [28059]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 439, function(d,s)
        C.Cast(d,s,A.Boss,28059,5.7,{spell=28059, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.04588, target=A.Boss})
    end),
    At(0.0, 440, function(d,s)
        C.Cast(d,s,A.Helper08,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=106.7369, y=-0.0153, z=104.2954}, pos={x=106.7378, y=0.0, z=104.3131}, rotation=-1.6167, target=A.Helper08})
    end),
    At(0.0, 441, function(d,s)
        C.Cast(d,s,A.Helper09,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=92.8817, y=-0.0153, z=103.6545}, pos={x=92.8959, y=0.0, z=103.6785}, rotation=2.31035, target=A.Helper09})
    end),
    At(0.0, 442, function(d,s)
        C.Cast(d,s,A.Helper10,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=100.3586, y=-0.0153, z=91.9966}, pos={x=100.3663, y=0.0, z=92.0084}, rotation=3.09576, target=A.Helper10})
    end),
    At(0.874, 443, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(1.003, 444, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(3.996, 445, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(5.95, 446, function(d,s)
        C.Action(d,s,A.Boss,28059,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.04588, target=A.Boss})
    end),
    At(6.834, 447, function(d,s)
        C.Action(d,s,A.Helper08,28060,{pos={x=106.7378, y=0.0, z=104.3131}, rotation=-1.6167, target=A.Helper08})
    end),
    At(6.834, 448, function(d,s)
        C.Action(d,s,A.Helper09,28060,{pos={x=92.8959, y=0.0, z=103.6785}, rotation=2.31035, target=A.Helper09})
    end),
    At(6.834, 449, function(d,s)
        C.Action(d,s,A.Helper10,28060,{pos={x=100.3663, y=0.0, z=92.0084}, rotation=3.09576, target=A.Helper10})
    end),
    At(6.987, 450, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(7.065, 451, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(7.065, 452, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(7.065, 453, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},-0.04588)
    end),
    At(7.103, 454, function(d,s)
        C.Action(d,s,A.Helper07,28049,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.04588, target=A.Helper07})
    end),
    At(8.688, 455, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.688, 456, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.688, 457, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.4172, y=0.0, z=111.3057},-0.04588)
    end),
    At(8.688, 458, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(8.688, 459, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(8.688, 460, function(d,s)
        C.Move(d,s,A.Helper06,{x=107.0583, y=0.0, z=97.3204},3.09576)
    end),
    At(8.688, 461, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(8.688, 462, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(8.688, 463, function(d,s)
        C.Move(d,s,A.Helper05,{x=99.7451, y=0.0, z=103.9925},-1.6167)
    end),
    At(8.688, 464, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.688, 465, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.688, 466, function(d,s)
        C.Move(d,s,A.Helper09,{x=88.178, y=0.0, z=98.5073},-2.40201)
    end),
    At(8.688, 467, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(8.688, 468, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(8.688, 469, function(d,s)
        C.Move(d,s,A.Helper04,{x=97.6138, y=0.0, z=108.8498},0.73953)
    end),
    At(8.688, 470, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(8.688, 471, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(8.688, 472, function(d,s)
        C.Move(d,s,A.Helper03,{x=98.0671, y=0.0, z=98.9606},2.31035)
    end),
    At(8.688, 473, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.688, 474, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.688, 475, function(d,s)
        C.Move(d,s,A.Helper10,{x=93.3737, y=0.0, z=91.6879},-1.6167)
    end),
    At(8.688, 476, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(8.688, 477, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(8.688, 478, function(d,s)
        C.Move(d,s,A.Helper02,{x=107.359, y=0.0, z=92.3289},1.52494)
    end),
    At(8.688, 479, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(8.688, 480, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(8.688, 481, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.6869, y=0.0, z=85.0157},3.09576)
    end),
    At(8.769, 482, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=106.4172, y=0.0, z=111.3057}, rotation=-0.04588, dest={x=106.4012, y=-0.0153, z=111.284}})
    end),
    At(8.769, 483, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=88.178, y=0.0, z=98.5073}, rotation=-2.40201, dest={x=88.1514, y=-0.0153, z=98.497}})
    end),
    At(8.769, 484, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=97.6138, y=0.0, z=108.8498}, rotation=0.73953, dest={x=97.612, y=-0.0153, z=108.8426}})
    end),
    At(8.769, 485, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=93.3737, y=0.0, z=91.6879}, rotation=-1.6167, dest={x=93.37, y=-0.0153, z=91.6609}})
    end),
    At(8.843, 486, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=107.359, y=0.0, z=92.3289}, rotation=1.52494, dest={x=107.3472, y=-0.0153, z=92.3018}})
    end),
    At(8.843, 487, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=98.0671, y=0.0, z=98.9606}, rotation=2.31035, dest={x=98.0392, y=-0.0153, z=98.9548}})
    end),
    At(8.843, 488, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=99.7451, y=0.0, z=103.9925}, rotation=-1.6167, dest={x=99.7177, y=-0.0153, z=103.9902}})
    end),
    At(8.843, 489, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=107.0583, y=0.0, z=97.3204}, rotation=3.09576, dest={x=107.042, y=-0.0153, z=97.3068}})
    end),
    At(8.843, 490, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=100.6869, y=0.0, z=85.0157}, rotation=3.09576, dest={x=100.6638, y=-0.0153, z=85.008}})
    end),
    At(10.04, 491, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.59879)
    end),
    At(10.328, 492, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.13824)
    end),
    At(10.558, 493, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.0967, y=0.0, z=118.2984},-0.04588)
    end),
    At(10.558, 494, function(d,s)
        C.Move(d,s,A.Helper09,{x=83.4601, y=0.0, z=93.3361},-2.40201)
    end),
    At(10.558, 495, function(d,s)
        C.Move(d,s,A.Helper04,{x=102.3317, y=0.0, z=114.021},0.73953)
    end),
    At(10.558, 496, function(d,s)
        C.Move(d,s,A.Helper10,{x=86.381, y=0.0, z=91.3673},-1.6167)
    end),
    At(10.596, 497, function(d,s)
        C.Move(d,s,A.Helper02,{x=114.3517, y=0.0, z=92.6495},1.52494)
    end),
    At(10.596, 498, function(d,s)
        C.Move(d,s,A.Helper03,{x=103.2383, y=0.0, z=94.2428},2.31035)
    end),
    At(10.596, 499, function(d,s)
        C.Move(d,s,A.Helper05,{x=92.7524, y=0.0, z=103.672},-1.6167)
    end),
    At(10.596, 500, function(d,s)
        C.Move(d,s,A.Helper06,{x=107.3789, y=0.0, z=90.3277},3.09576)
    end),
    At(10.596, 501, function(d,s)
        C.Move(d,s,A.Helper01,{x=101.0074, y=0.0, z=78.0231},3.09576)
    end),
    At(10.596, 502, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=106.0967, y=0.0, z=118.2984}, rotation=-0.04588, dest={x=106.096, y=-0.0153, z=118.2727}})
    end),
    At(10.596, 503, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=83.4601, y=0.0, z=93.3361}, rotation=-2.40201, dest={x=83.4516, y=-0.0153, z=93.3089}})
    end),
    At(10.596, 504, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=102.3317, y=0.0, z=114.021}, rotation=0.73953, dest={x=102.3117, y=-0.0153, z=114.0002}})
    end),
    At(10.596, 505, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=86.381, y=0.0, z=91.3673}, rotation=-1.6167, dest={x=86.3508, y=-0.0153, z=91.3558}})
    end),
    At(10.675, 506, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=114.3517, y=0.0, z=92.6495}, rotation=1.52494, dest={x=114.3359, y=-0.0153, z=92.6375}})
    end),
    At(10.675, 507, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=103.2383, y=0.0, z=94.2428}, rotation=2.31035, dest={x=103.2273, y=-0.0153, z=94.2245}})
    end),
    At(10.675, 508, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=92.7524, y=0.0, z=103.672}, rotation=-1.6167, dest={x=92.7291, y=-0.0153, z=103.6545}})
    end),
    At(10.675, 509, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=107.3789, y=0.0, z=90.3277}, rotation=3.09576, dest={x=107.3777, y=-0.0153, z=90.3182}})
    end),
    At(10.675, 510, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=101.0074, y=0.0, z=78.0231}, rotation=3.09576, dest={x=100.9995, y=-0.0153, z=78.0194}})
    end),
    At(11.828, 511, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.11053)
    end),
    At(12.445, 512, function(d,s)
        C.Move(d,s,A.Helper08,{x=105.7761, y=0.0, z=125.291},-0.04588)
    end),
    At(12.445, 513, function(d,s)
        C.Move(d,s,A.Helper09,{x=78.7422, y=0.0, z=88.1649},-2.40201)
    end),
    At(12.445, 514, function(d,s)
        C.Move(d,s,A.Helper04,{x=107.0496, y=0.0, z=119.1922},0.73953)
    end),
    At(12.445, 515, function(d,s)
        C.Move(d,s,A.Helper10,{x=79.3884, y=0.0, z=91.0468},-1.6167)
    end),
    At(12.52, 516, function(d,s)
        C.Move(d,s,A.Helper02,{x=121.3443, y=0.0, z=92.97},1.52494)
    end),
    At(12.52, 517, function(d,s)
        C.Move(d,s,A.Helper03,{x=108.4095, y=0.0, z=89.5249},2.31035)
    end),
    At(12.52, 518, function(d,s)
        C.Move(d,s,A.Helper05,{x=85.7598, y=0.0, z=103.3514},-1.6167)
    end),
    At(12.52, 519, function(d,s)
        C.Move(d,s,A.Helper06,{x=107.6994, y=0.0, z=83.3351},3.09576)
    end),
    At(12.52, 520, function(d,s)
        C.Move(d,s,A.Helper01,{x=101.328, y=0.0, z=71.0304},3.09576)
    end),
    At(12.52, 521, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=105.7761, y=0.0, z=125.291}, rotation=-0.04588, dest={x=105.7603, y=-0.0153, z=125.2613}})
    end),
    At(12.52, 522, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=78.7422, y=0.0, z=88.1649}, rotation=-2.40201, dest={x=78.7213, y=-0.0153, z=88.1514}})
    end),
    At(12.52, 523, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=107.0496, y=0.0, z=119.1922}, rotation=0.73953, dest={x=107.042, y=-0.0153, z=119.1882}})
    end),
    At(12.52, 524, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=79.3884, y=0.0, z=91.0468}, rotation=-1.6167, dest={x=79.3622, y=-0.0153, z=91.0201}})
    end),
    At(12.592, 525, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=121.3443, y=0.0, z=92.97}, rotation=1.52494, dest={x=121.3245, y=-0.0153, z=92.9427}})
    end),
    At(12.592, 526, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=108.4095, y=0.0, z=89.5249}, rotation=2.31035, dest={x=108.3848, y=-0.0153, z=89.5247}})
    end),
    At(12.592, 527, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=85.7598, y=0.0, z=103.3514}, rotation=-1.6167, dest={x=85.7404, y=-0.0153, z=103.3494}})
    end),
    At(12.592, 528, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=107.6994, y=0.0, z=83.3351}, rotation=3.09576, dest={x=107.6829, y=-0.0153, z=83.3295}})
    end),
    At(12.592, 529, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=101.328, y=0.0, z=71.0304}, rotation=3.09576, dest={x=101.3046, y=-0.0153, z=71.0002}})
    end),
    At(13.232, 530, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.84701)
    end),
    At(13.513, 531, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.02708)
    end),
    At(14.131, 532, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01107, target=A.Boss})
    end),
    At(14.35, 533, function(d,s)
        C.Move(d,s,A.Helper09,{x=74.0243, y=0.0, z=82.9937},-2.40201)
    end),
    At(14.35, 534, function(d,s)
        C.Move(d,s,A.Helper04,{x=111.7675, y=0.0, z=124.3634},0.73953)
    end),
    At(14.35, 535, function(d,s)
        C.Move(d,s,A.Helper10,{x=72.3957, y=0.0, z=90.7262},-1.6167)
    end),
    At(14.423, 536, function(d,s)
        C.Move(d,s,A.Helper02,{x=128.337, y=0.0, z=93.2906},1.52494)
    end),
    At(14.423, 537, function(d,s)
        C.Move(d,s,A.Helper03,{x=113.5807, y=0.0, z=84.807},2.31035)
    end),
    At(14.423, 538, function(d,s)
        C.Move(d,s,A.Helper05,{x=78.7671, y=0.0, z=103.0309},-1.6167)
    end),
    At(14.423, 539, function(d,s)
        C.Move(d,s,A.Helper06,{x=108.0199, y=0.0, z=76.3424},3.09576)
    end),
    At(14.423, 540, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=74.0243, y=0.0, z=82.9937}, rotation=-2.40201, dest={x=74.0215, y=-0.0153, z=82.9633}})
    end),
    At(14.423, 541, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=111.7675, y=0.0, z=124.3634}, rotation=0.73953, dest={x=111.7418, y=-0.0153, z=124.3458}})
    end),
    At(14.423, 542, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=72.3957, y=0.0, z=90.7262}, rotation=-1.6167, dest={x=72.3735, y=-0.0153, z=90.7149}})
    end),
    At(14.423, 543, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=128.337, y=0.0, z=93.2906}, rotation=1.52494, dest={x=128.3131, y=-0.0153, z=93.2784}})
    end),
    At(14.423, 544, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=113.5807, y=0.0, z=84.807}, rotation=2.31035, dest={x=113.5729, y=-0.0153, z=84.7944}})
    end),
    At(14.423, 545, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=78.7671, y=0.0, z=103.0309}, rotation=-1.6167, dest={x=78.7518, y=-0.0153, z=103.0137}})
    end),
    At(14.423, 546, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=108.0199, y=0.0, z=76.3424}, rotation=3.09576, dest={x=108.0186, y=-0.0153, z=76.3409}})
    end),
    At(15.164, 547, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(15.164, 548, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(15.164, 549, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(15.164, 550, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(15.164, 551, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(15.164, 552, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(15.233, 553, function(d,s)
        C.Action(d,s,A.Helper01,28065,{pos={x=101.328, y=0.0, z=71.0304}, rotation=3.09576})
    end),
    At(15.233, 554, function(d,s)
        C.Action(d,s,A.Helper08,28063,{pos={x=105.7761, y=0.0, z=125.291}, rotation=-0.04588})
    end),
    At(15.233, 555, function(d,s)
        C.Action(d,s,A.Helper07,28064,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.04588})
    end),
    At(16.235, 556, function(d,s)
        C.Move(d,s,A.Helper03,{x=118.752, y=0.0, z=80.0891},2.31035)
    end),
    At(16.235, 557, function(d,s)
        C.Move(d,s,A.Helper05,{x=71.7745, y=0.0, z=102.7103},-1.6167)
    end),
    At(16.235, 558, function(d,s)
        C.Move(d,s,A.Helper06,{x=108.3405, y=0.0, z=69.3498},3.09576)
    end),
    At(16.272, 559, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=118.752, y=0.0, z=80.0891}, rotation=2.31035, dest={x=118.7304, y=-0.0153, z=80.0641}})
    end),
    At(16.272, 560, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=71.7745, y=0.0, z=102.7103}, rotation=-1.6167, dest={x=71.7632, y=-0.0153, z=102.7085}})
    end),
    At(16.272, 561, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=108.3405, y=0.0, z=69.3498}, rotation=3.09576, dest={x=108.3238, y=-0.0153, z=69.3217}})
    end),
    At(18.143, 562, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(19.132, 563, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(19.132, 564, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(19.132, 565, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(19.132, 566, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(19.132, 567, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(19.132, 568, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(19.213, 569, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=105.7761, y=0.0, z=125.291}, rotation=-0.04588})
    end),
    At(19.213, 570, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=74.0243, y=0.0, z=82.9937}, rotation=-2.40201})
    end),
    At(19.213, 571, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=72.3957, y=0.0, z=90.7262}, rotation=-1.6167})
    end),
    At(21.055, 572, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(21.055, 573, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(21.055, 574, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(21.055, 575, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(21.055, 576, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(21.055, 577, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(21.055, 578, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(21.055, 579, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(21.055, 580, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(21.055, 581, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
