-- 百京核爆剑 [28059]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 765, function(d,s)
        C.Cast(d,s,A.Boss,28059,5.7,{spell=28059, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13076, target=A.Boss})
    end),
    At(0.0, 766, function(d,s)
        C.Cast(d,s,A.Helper08,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=93.0953, y=-0.0153, z=95.903}, pos={x=93.1152, y=0.0, z=95.9257}, rotation=0.77462, target=A.Helper08})
    end),
    At(0.0, 767, function(d,s)
        C.Cast(d,s,A.Helper09,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=106.9505, y=-0.0153, z=96.0555}, pos={x=106.9708, y=0.0, z=96.0747}, rotation=-0.01079, target=A.Helper09})
    end),
    At(0.0, 768, function(d,s)
        C.Cast(d,s,A.Helper10,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=99.9008, y=-0.0153, z=107.9881}, pos={x=99.914, y=0.0, z=107.9995}, rotation=-0.01079, target=A.Helper10})
    end),
    At(0.927, 769, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(1.59, 770, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(1.955, 771, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(4.934, 772, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.704, 773, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.988, 774, function(d,s)
        C.Action(d,s,A.Boss,28059,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13076, target=A.Boss})
    end),
    At(6.851, 775, function(d,s)
        C.Action(d,s,A.Helper08,28060,{pos={x=93.1152, y=0.0, z=95.9257}, rotation=0.77462, target=A.Helper08})
    end),
    At(6.851, 776, function(d,s)
        C.Action(d,s,A.Helper09,28060,{pos={x=106.9708, y=0.0, z=96.0747}, rotation=-0.01079, target=A.Helper09})
    end),
    At(6.851, 777, function(d,s)
        C.Action(d,s,A.Helper10,28060,{pos={x=99.914, y=0.0, z=107.9995}, rotation=-0.01079, target=A.Helper10})
    end),
    At(7.059, 778, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(7.059, 779, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(7.059, 780, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},3.13076)
    end),
    At(7.106, 781, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13076, target=A.Helper07})
    end),
    At(8.709, 782, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.709, 783, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.709, 784, function(d,s)
        C.Move(d,s,A.Helper08,{x=98.1179, y=0.0, z=91.0295},2.34535)
    end),
    At(8.709, 785, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(8.709, 786, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(8.709, 787, function(d,s)
        C.Move(d,s,A.Helper06,{x=88.1125, y=0.0, z=100.822},-0.7962)
    end),
    At(8.709, 788, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(8.709, 789, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(8.709, 790, function(d,s)
        C.Move(d,s,A.Helper05,{x=98.0114, y=0.0, z=100.9284},0.77462)
    end),
    At(8.709, 791, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.709, 792, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.709, 793, function(d,s)
        C.Move(d,s,A.Helper09,{x=113.9704, y=0.0, z=96.15},1.56003)
    end),
    At(8.709, 794, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(8.709, 795, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(8.709, 796, function(d,s)
        C.Move(d,s,A.Helper04,{x=99.9712, y=0.0, z=95.9995},-1.58161)
    end),
    At(8.709, 797, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(8.709, 798, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(8.709, 799, function(d,s)
        C.Move(d,s,A.Helper03,{x=106.8955, y=0.0, z=103.0743},-0.01079)
    end),
    At(8.709, 800, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.709, 801, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.709, 802, function(d,s)
        C.Move(d,s,A.Helper10,{x=106.9136, y=0.0, z=108.0748},1.56003)
    end),
    At(8.709, 803, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(8.709, 804, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(8.709, 805, function(d,s)
        C.Move(d,s,A.Helper02,{x=92.9144, y=0.0, z=107.9243},-1.58161)
    end),
    At(8.709, 806, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(8.709, 807, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(8.709, 808, function(d,s)
        C.Move(d,s,A.Helper01,{x=99.8387, y=0.0, z=114.9991},-0.01079)
    end),
    At(8.749, 809, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=98.1179, y=0.0, z=91.0295}, rotation=2.34535, dest={x=98.1003, y=-0.0153, z=91.0201}})
    end),
    At(8.749, 810, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=113.9704, y=0.0, z=96.15}, rotation=1.56003, dest={x=113.9696, y=-0.0153, z=96.1471}})
    end),
    At(8.749, 811, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=99.9712, y=0.0, z=95.9995}, rotation=-1.58161, dest={x=99.9619, y=-0.0153, z=95.9945}})
    end),
    At(8.749, 812, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=106.9136, y=0.0, z=108.0748}, rotation=1.56003, dest={x=106.8894, y=-0.0153, z=108.0491}})
    end),
    At(8.792, 813, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=92.9144, y=0.0, z=107.9243}, rotation=-1.58161, dest={x=92.9122, y=-0.0153, z=107.8965}})
    end),
    At(8.792, 814, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=106.8955, y=0.0, z=103.0743}, rotation=-0.01079, dest={x=106.8894, y=-0.0153, z=103.0442}})
    end),
    At(8.792, 815, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=98.0114, y=0.0, z=100.9284}, rotation=0.77462, dest={x=98.0087, y=-0.0153, z=100.9079}})
    end),
    At(8.792, 816, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=88.1125, y=0.0, z=100.822}, rotation=-0.7962, dest={x=88.0903, y=-0.0153, z=100.8164}})
    end),
    At(8.792, 817, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=99.8387, y=0.0, z=114.9991}, rotation=-0.01079, dest={x=99.8093, y=-0.0153, z=114.9767}})
    end),
    At(10.092, 818, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.03395)
    end),
    At(10.404, 819, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.27128)
    end),
    At(10.606, 820, function(d,s)
        C.Move(d,s,A.Helper08,{x=103.1206, y=0.0, z=86.1333},2.34535)
    end),
    At(10.606, 821, function(d,s)
        C.Move(d,s,A.Helper09,{x=120.97, y=0.0, z=96.2253},1.56003)
    end),
    At(10.606, 822, function(d,s)
        C.Move(d,s,A.Helper04,{x=92.9716, y=0.0, z=95.9242},-1.58161)
    end),
    At(10.606, 823, function(d,s)
        C.Move(d,s,A.Helper10,{x=113.9132, y=0.0, z=108.1501},1.56003)
    end),
    At(10.677, 824, function(d,s)
        C.Move(d,s,A.Helper02,{x=85.9148, y=0.0, z=107.849},-1.58161)
    end),
    At(10.677, 825, function(d,s)
        C.Move(d,s,A.Helper03,{x=106.8203, y=0.0, z=110.0739},-0.01079)
    end),
    At(10.677, 826, function(d,s)
        C.Move(d,s,A.Helper05,{x=102.9077, y=0.0, z=105.9311},0.77462)
    end),
    At(10.677, 827, function(d,s)
        C.Move(d,s,A.Helper06,{x=83.1098, y=0.0, z=105.7182},-0.7962)
    end),
    At(10.677, 828, function(d,s)
        C.Move(d,s,A.Helper01,{x=99.7634, y=0.0, z=121.9987},-0.01079)
    end),
    At(10.677, 829, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=103.1206, y=0.0, z=86.1333}, rotation=2.34535, dest={x=103.1052, y=-0.0153, z=86.1067}})
    end),
    At(10.677, 830, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=120.97, y=0.0, z=96.2253}, rotation=1.56003, dest={x=120.9583, y=-0.0153, z=96.2081}})
    end),
    At(10.677, 831, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=92.9716, y=0.0, z=95.9242}, rotation=-1.58161, dest={x=92.9427, y=-0.0153, z=95.903}})
    end),
    At(10.677, 832, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=113.9132, y=0.0, z=108.1501}, rotation=1.56003, dest={x=113.9086, y=-0.0153, z=108.1407}})
    end),
    At(10.677, 833, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=85.9148, y=0.0, z=107.849}, rotation=-1.58161, dest={x=85.893, y=-0.0153, z=107.8355}})
    end),
    At(10.677, 834, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=106.8203, y=0.0, z=110.0739}, rotation=-0.01079, dest={x=106.7979, y=-0.0153, z=110.0633}})
    end),
    At(10.677, 835, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=102.9077, y=0.0, z=105.9311}, rotation=0.77462, dest={x=102.8916, y=-0.0153, z=105.9129}})
    end),
    At(10.677, 836, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=83.1098, y=0.0, z=105.7182}, rotation=-0.7962, dest={x=83.0854, y=-0.0153, z=105.6992}})
    end),
    At(10.677, 837, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=99.7634, y=0.0, z=121.9987}, rotation=-0.01079, dest={x=99.7482, y=-0.0153, z=121.9959}})
    end),
    At(10.946, 838, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.29736)
    end),
    At(11.256, 839, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.39985)
    end),
    At(11.61, 840, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.36533)
    end),
    At(11.883, 841, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.25824)
    end),
    At(12.223, 842, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.21673)
    end),
    At(12.468, 843, function(d,s)
        C.Move(d,s,A.Helper08,{x=108.1233, y=0.0, z=81.237},2.34535)
    end),
    At(12.468, 844, function(d,s)
        C.Move(d,s,A.Helper09,{x=127.9696, y=0.0, z=96.3006},1.56003)
    end),
    At(12.468, 845, function(d,s)
        C.Move(d,s,A.Helper04,{x=85.972, y=0.0, z=95.8489},-1.58161)
    end),
    At(12.468, 846, function(d,s)
        C.Move(d,s,A.Helper10,{x=120.9128, y=0.0, z=108.2253},1.56003)
    end),
    At(12.506, 847, function(d,s)
        C.Move(d,s,A.Helper02,{x=78.9152, y=0.0, z=107.7737},-1.58161)
    end),
    At(12.506, 848, function(d,s)
        C.Move(d,s,A.Helper03,{x=106.745, y=0.0, z=117.0735},-0.01079)
    end),
    At(12.506, 849, function(d,s)
        C.Move(d,s,A.Helper05,{x=107.8039, y=0.0, z=110.9338},0.77462)
    end),
    At(12.506, 850, function(d,s)
        C.Move(d,s,A.Helper06,{x=78.1071, y=0.0, z=110.6144},-0.7962)
    end),
    At(12.506, 851, function(d,s)
        C.Move(d,s,A.Helper01,{x=99.6881, y=0.0, z=128.9983},-0.01079)
    end),
    At(12.506, 852, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=108.1233, y=0.0, z=81.237}, rotation=2.34535, dest={x=108.1102, y=-0.0153, z=81.2238}})
    end),
    At(12.506, 853, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=127.9696, y=0.0, z=96.3006}, rotation=1.56003, dest={x=127.9469, y=-0.0153, z=96.2997}})
    end),
    At(12.506, 854, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=85.972, y=0.0, z=95.8489}, rotation=-1.58161, dest={x=85.9541, y=-0.0153, z=95.8419}})
    end),
    At(12.506, 855, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=120.9128, y=0.0, z=108.2253}, rotation=1.56003, dest={x=120.8972, y=-0.0153, z=108.2017}})
    end),
    At(12.506, 856, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.19889)
    end),
    At(12.547, 857, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=78.9152, y=0.0, z=107.7737}, rotation=-1.58161, dest={x=78.9044, y=-0.0153, z=107.744}})
    end),
    At(12.547, 858, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=106.745, y=0.0, z=117.0735}, rotation=-0.01079, dest={x=106.7369, y=-0.0153, z=117.052}})
    end),
    At(12.547, 859, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=107.8039, y=0.0, z=110.9338}, rotation=0.77462, dest={x=107.7745, y=-0.0153, z=110.9178}})
    end),
    At(12.547, 860, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=78.1071, y=0.0, z=110.6144}, rotation=-0.7962, dest={x=78.0804, y=-0.0153, z=110.6126}})
    end),
    At(12.547, 861, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=99.6881, y=0.0, z=128.9983}, rotation=-0.01079, dest={x=99.6872, y=-0.0153, z=128.9845}})
    end),
    At(12.81, 862, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.22545)
    end),
    At(13.138, 863, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.06294)
    end),
    At(13.448, 864, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.03801)
    end),
    At(13.779, 865, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.01913)
    end),
    At(14.155, 866, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01615, target=A.Boss})
    end),
    At(14.365, 867, function(d,s)
        C.Move(d,s,A.Helper08,{x=113.126, y=0.0, z=76.3408},2.34535)
    end),
    At(14.365, 868, function(d,s)
        C.Move(d,s,A.Helper04,{x=78.9724, y=0.0, z=95.7736},-1.58161)
    end),
    At(14.365, 869, function(d,s)
        C.Move(d,s,A.Helper10,{x=127.9124, y=0.0, z=108.3006},1.56003)
    end),
    At(14.437, 870, function(d,s)
        C.Move(d,s,A.Helper02,{x=71.9156, y=0.0, z=107.6984},-1.58161)
    end),
    At(14.437, 871, function(d,s)
        C.Move(d,s,A.Helper03,{x=106.6697, y=0.0, z=124.0731},-0.01079)
    end),
    At(14.437, 872, function(d,s)
        C.Move(d,s,A.Helper05,{x=112.7001, y=0.0, z=115.9365},0.77462)
    end),
    At(14.437, 873, function(d,s)
        C.Move(d,s,A.Helper06,{x=73.1045, y=0.0, z=115.5107},-0.7962)
    end),
    At(14.437, 874, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=113.126, y=0.0, z=76.3408}, rotation=2.34535, dest={x=113.1151, y=-0.0153, z=76.3104}})
    end),
    At(14.437, 875, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=78.9724, y=0.0, z=95.7736}, rotation=-1.58161, dest={x=78.9654, y=-0.0153, z=95.7504}})
    end),
    At(14.437, 876, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=127.9124, y=0.0, z=108.3006}, rotation=1.56003, dest={x=127.8859, y=-0.0153, z=108.2933}})
    end),
    At(14.437, 877, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=71.9156, y=0.0, z=107.6984}, rotation=-1.58161, dest={x=71.8853, y=-0.0153, z=107.6829}})
    end),
    At(14.437, 878, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=106.6697, y=0.0, z=124.0731}, rotation=-0.01079, dest={x=106.6453, y=-0.0153, z=124.0711}})
    end),
    At(14.437, 879, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=112.7001, y=0.0, z=115.9365}, rotation=0.77462, dest={x=112.6879, y=-0.0153, z=115.9228}})
    end),
    At(14.437, 880, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=73.1045, y=0.0, z=115.5107}, rotation=-0.7962, dest={x=73.0755, y=-0.0153, z=115.4955}})
    end),
    At(15.183, 881, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(15.183, 882, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(15.183, 883, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(15.183, 884, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(15.183, 885, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(15.183, 886, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(15.252, 887, function(d,s)
        C.Action(d,s,A.Helper01,28065,{pos={x=99.6881, y=0.0, z=128.9983}, rotation=-0.01079})
    end),
    At(15.252, 888, function(d,s)
        C.Action(d,s,A.Helper09,28063,{pos={x=127.9696, y=0.0, z=96.3006}, rotation=1.56003})
    end),
    At(15.252, 889, function(d,s)
        C.Action(d,s,A.Helper07,28064,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13076})
    end),
    At(16.256, 890, function(d,s)
        C.Move(d,s,A.Helper04,{x=71.9728, y=0.0, z=95.6983},-1.58161)
    end),
    At(16.256, 891, function(d,s)
        C.Move(d,s,A.Helper03,{x=106.5944, y=0.0, z=131.0727},-0.01079)
    end),
    At(16.256, 892, function(d,s)
        C.Move(d,s,A.Helper05,{x=117.5964, y=0.0, z=120.9392},0.77462)
    end),
    At(16.256, 893, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=71.9728, y=0.0, z=95.6983}, rotation=-1.58161, dest={x=71.9463, y=-0.0153, z=95.6893}})
    end),
    At(16.341, 894, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=106.5944, y=0.0, z=131.0727}, rotation=-0.01079, dest={x=106.5843, y=-0.0153, z=131.0597}})
    end),
    At(16.341, 895, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=117.5964, y=0.0, z=120.9392}, rotation=0.77462, dest={x=117.5708, y=-0.0153, z=120.9277}})
    end),
    At(18.16, 896, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01568, target=A.Boss})
    end),
    At(19.194, 897, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(19.194, 898, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(19.194, 899, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(19.194, 900, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(19.194, 901, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(19.194, 902, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(19.26, 903, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=113.126, y=0.0, z=76.3408}, rotation=2.34535})
    end),
    At(19.26, 904, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=127.9696, y=0.0, z=96.3006}, rotation=1.56003})
    end),
    At(19.26, 905, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=127.9124, y=0.0, z=108.3006}, rotation=1.56003})
    end),
    At(20.093, 906, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.01031)
    end),
    At(21.122, 907, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(21.122, 908, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(21.122, 909, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(21.122, 910, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(21.122, 911, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(21.122, 912, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(21.122, 913, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(21.122, 914, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(21.122, 915, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(21.122, 916, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
