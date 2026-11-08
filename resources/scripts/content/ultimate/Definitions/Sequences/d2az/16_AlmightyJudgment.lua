-- 神圣大审判 [18574]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 852, function(d,s)
        C.Cast(d,s,A.Boss,18574,2.7,{spell=18574, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11216, target=A.Boss})
    end),
    At(2.983, 853, function(d,s)
        C.Action(d,s,A.Boss,18574,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11216, target=A.Boss})
    end),
    At(5.016, 854, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11216})
    end),
    At(5.999, 855, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(5.999, 856, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(5.999, 857, function(d,s)
        C.Move(d,s,A.Helper12,{x=92.0, y=0.0, z=84.0},-5e-05)
    end),
    At(5.999, 858, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(5.999, 859, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(5.999, 860, function(d,s)
        C.Move(d,s,A.Helper11,{x=108.0, y=0.0, z=84.0},-5e-05)
    end),
    At(5.999, 861, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(5.999, 862, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(5.999, 863, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(5.999, 864, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(5.999, 865, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(5.999, 866, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=92.0},-5e-05)
    end),
    At(5.999, 867, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(5.999, 868, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(5.999, 869, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=100.0},-5e-05)
    end),
    At(5.999, 870, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(5.999, 871, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(5.999, 872, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=108.0},-5e-05)
    end),
    At(5.999, 873, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(5.999, 874, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(5.999, 875, function(d,s)
        C.Move(d,s,A.Helper06,{x=116.0, y=0.0, z=108.0},-5e-05)
    end),
    At(5.999, 876, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(5.999, 877, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(5.999, 878, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(6.099, 879, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=99.9924}, pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(6.099, 880, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=91.9966}, pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(6.099, 881, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=91.9966}, pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(6.099, 882, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=83.9704}, pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(6.099, 883, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=83.9704}, pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(6.099, 884, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=115.9838}, pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(6.099, 885, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=107.9881}, pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(6.099, 886, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=107.9881}, pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(6.183, 887, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.44077)
    end),
    At(6.467, 888, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.09103)
    end),
    At(6.784, 889, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.05048)
    end),
    At(7.567, 890, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(7.567, 891, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(7.567, 892, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(7.567, 893, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(7.567, 894, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(7.567, 895, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(7.567, 896, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(7.567, 897, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(8.0, 898, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(8.0, 899, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(8.0, 900, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(8.0, 901, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(8.0, 902, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(8.0, 903, function(d,s)
        C.Move(d,s,A.Helper11,{x=84.0, y=0.0, z=92.0},-5e-05)
    end),
    At(8.0, 904, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.0, 905, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.0, 906, function(d,s)
        C.Move(d,s,A.Helper10,{x=92.0, y=0.0, z=92.0},-5e-05)
    end),
    At(8.0, 907, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.0, 908, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.0, 909, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=100.0},-5e-05)
    end),
    At(8.0, 910, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.0, 911, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.0, 912, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=108.0},-5e-05)
    end),
    At(8.0, 913, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(8.0, 914, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(8.0, 915, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(8.0, 916, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(8.0, 917, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(8.0, 918, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=116.0},-5e-05)
    end),
    At(8.0, 919, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(8.0, 920, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(8.0, 921, function(d,s)
        C.Move(d,s,A.Helper05,{x=108.0, y=0.0, z=116.0},-5e-05)
    end),
    At(8.0, 922, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.04655})
    end),
    At(8.117, 923, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=107.9881}, pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(8.117, 924, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=99.9924}, pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(8.117, 925, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=91.9966}, pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(8.117, 926, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=91.9966}, pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(8.117, 927, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=83.9704}, pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(8.117, 928, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=115.9838}, pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(8.117, 929, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=115.9838}, pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(8.117, 930, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=107.9881}, pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(9.566, 931, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(9.566, 932, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(9.566, 933, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.566, 934, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(9.566, 935, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(9.566, 936, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(9.566, 937, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(9.566, 938, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(9.983, 939, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(9.983, 940, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(9.983, 941, function(d,s)
        C.Move(d,s,A.Helper12,{x=84.0, y=0.0, z=84.0},-5e-05)
    end),
    At(9.983, 942, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(9.983, 943, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(9.983, 944, function(d,s)
        C.Move(d,s,A.Helper11,{x=116.0, y=0.0, z=84.0},-5e-05)
    end),
    At(9.983, 945, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(9.983, 946, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(9.983, 947, function(d,s)
        C.Move(d,s,A.Helper10,{x=108.0, y=0.0, z=92.0},-5e-05)
    end),
    At(9.983, 948, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(9.983, 949, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(9.983, 950, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.983, 951, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(9.983, 952, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(9.983, 953, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.983, 954, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.983, 955, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.983, 956, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.983, 957, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(9.983, 958, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(9.983, 959, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=108.0},-5e-05)
    end),
    At(9.983, 960, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(9.983, 961, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(9.983, 962, function(d,s)
        C.Move(d,s,A.Helper05,{x=84.0, y=0.0, z=116.0},-5e-05)
    end),
    At(9.983, 963, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(9.983, 964, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(9.983, 965, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.0, y=0.0, z=116.0},-5e-05)
    end),
    At(10.083, 966, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(10.116, 967, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=99.9924}, pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(10.116, 968, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=91.9966}, pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(10.116, 969, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=83.9704}, pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(10.116, 970, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=83.9704}, pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(10.116, 971, function(d,s)
        C.Cast(d,s,A.Helper04,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=115.9838}, pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(10.116, 972, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=115.9838}, pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(10.116, 973, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=107.9881}, pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(10.116, 974, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=99.9924}, pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(10.435, 975, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.21203)
    end),
    At(10.767, 976, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.42132)
    end),
    At(11.069, 977, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.67242})
    end),
    At(11.084, 978, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.67242)
    end),
    At(11.379, 979, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.92055)
    end),
    At(11.55, 980, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(11.55, 981, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(11.55, 982, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(11.55, 983, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(11.55, 984, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(11.55, 985, function(d,s)
        C.Action(d,s,A.Helper04,18575,{pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(11.55, 986, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(11.55, 987, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(11.55, 988, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(11.684, 989, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.12706)
    end),
    At(12.017, 990, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.34959)
    end),
    At(12.342, 991, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.53185)
    end),
    At(13.066, 992, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.6189)
    end),
    At(14.016, 993, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(14.016, 994, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(14.016, 995, function(d,s)
        C.Move(d,s,A.Helper12,{x=92.0, y=0.0, z=84.0},-5e-05)
    end),
    At(14.016, 996, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(14.016, 997, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(14.016, 998, function(d,s)
        C.Move(d,s,A.Helper11,{x=108.0, y=0.0, z=84.0},-5e-05)
    end),
    At(14.016, 999, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(14.016, 1000, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(14.016, 1001, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(14.016, 1002, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(14.016, 1003, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(14.016, 1004, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=92.0},-5e-05)
    end),
    At(14.016, 1005, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(14.016, 1006, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(14.016, 1007, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=100.0},-5e-05)
    end),
    At(14.016, 1008, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(14.016, 1009, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(14.016, 1010, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=108.0},-5e-05)
    end),
    At(14.016, 1011, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(14.016, 1012, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(14.016, 1013, function(d,s)
        C.Move(d,s,A.Helper06,{x=116.0, y=0.0, z=108.0},-5e-05)
    end),
    At(14.016, 1014, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(14.016, 1015, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(14.016, 1016, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(14.083, 1017, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.6189})
    end),
    At(14.101, 1018, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(14.101, 1019, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(14.101, 1020, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.101, 1021, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(14.101, 1022, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(14.101, 1023, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.101, 1024, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(14.101, 1025, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
}
