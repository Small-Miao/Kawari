-- 死亡轮回剑 [28051]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 917, function(d,s)
        C.Cast(d,s,A.Boss,28051,5.7,{spell=28051, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(0.0, 918, function(d,s)
        C.Cast(d,s,A.Helper08,29453,6.4,{spell=29453, omen_delay=20, cast_pos={x=106.9505, y=-0.0153, z=103.8987}, pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.0, 919, function(d,s)
        C.Cast(d,s,A.Helper09,29452,6.4,{spell=29452, omen_delay=10, cast_pos={x=93.0953, y=-0.0153, z=104.0513}, pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.0, 920, function(d,s)
        C.Cast(d,s,A.Helper10,29454,6.4,{spell=29454, omen_delay=30, cast_pos={x=99.9008, y=-0.0153, z=91.9966}, pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.916, 921, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(1.78, 922, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(4.267, 923, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(4.832, 924, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(5.122, 925, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=298, duration=0}})
    end),
    At(6.005, 926, function(d,s)
        C.Action(d,s,A.Boss,28051,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(6.655, 927, function(d,s)
        C.Action(d,s,A.Helper08,29453,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper08})
    end),
    At(6.655, 928, function(d,s)
        C.Action(d,s,A.Helper09,29452,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper09})
    end),
    At(6.655, 929, function(d,s)
        C.Action(d,s,A.Helper10,29454,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(6.804, 930, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(6.804, 931, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(6.804, 932, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},0.01031)
    end),
    At(6.804, 933, function(d,s)
        C.Action(d,s,A.Helper07,28049,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.01031, target=A.Helper07})
    end),
    At(8.123, 934, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(8.847, 935, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.847, 936, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.847, 937, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(8.847, 938, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.847, 939, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.847, 940, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(8.847, 941, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.847, 942, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.847, 943, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(8.92, 944, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper08})
    end),
    At(8.92, 945, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper09})
    end),
    At(8.92, 946, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.207, 947, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(9.917, 948, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.917, 949, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.917, 950, function(d,s)
        C.Move(d,s,A.Helper07,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(9.917, 951, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(9.917, 952, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(9.917, 953, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(9.917, 954, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(9.917, 955, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(9.917, 956, function(d,s)
        C.Move(d,s,A.Helper05,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(9.999, 957, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper05})
    end),
    At(9.999, 958, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper06})
    end),
    At(9.999, 959, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper07})
    end),
    At(10.237, 960, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(11.049, 961, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(11.049, 962, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(11.049, 963, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(11.049, 964, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(11.049, 965, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(11.049, 966, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(11.049, 967, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(11.049, 968, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(11.049, 969, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(11.049, 970, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper08})
    end),
    At(11.049, 971, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper09})
    end),
    At(11.049, 972, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(11.317, 973, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(12.124, 974, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(12.124, 975, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(12.124, 976, function(d,s)
        C.Move(d,s,A.Helper07,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(12.124, 977, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(12.124, 978, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(12.124, 979, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(12.124, 980, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(12.124, 981, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(12.124, 982, function(d,s)
        C.Move(d,s,A.Helper05,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(12.124, 983, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper05})
    end),
    At(12.124, 984, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper06})
    end),
    At(12.124, 985, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper07})
    end),
    At(12.374, 986, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(13.186, 987, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(13.186, 988, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(13.186, 989, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(13.186, 990, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(13.186, 991, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(13.186, 992, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(13.186, 993, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(13.186, 994, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(13.186, 995, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(13.186, 996, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper08})
    end),
    At(13.186, 997, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper09})
    end),
    At(13.186, 998, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(13.391, 999, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(13.462, 1000, function(d,s)
        C.Action(d,s,A.Boss,28053,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01031, target=A.Boss})
    end),
    At(14.22, 1001, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(14.22, 1002, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(14.22, 1003, function(d,s)
        C.Move(d,s,A.Helper07,{x=99.917, y=0.0, z=92.0004},-5e-05)
    end),
    At(14.22, 1004, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(14.22, 1005, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(14.22, 1006, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.1136, y=0.0, z=104.0716},-5e-05)
    end),
    At(14.22, 1007, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(14.22, 1008, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(14.22, 1009, function(d,s)
        C.Move(d,s,A.Helper05,{x=106.9693, y=0.0, z=103.9279},-5e-05)
    end),
    At(14.308, 1010, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.308, 1011, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05, target=A.Helper06})
    end),
    At(14.308, 1012, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper07})
    end),
    At(15.564, 1013, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.04509)
    end),
    At(15.898, 1014, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.83857)
    end),
    At(16.18, 1015, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.56734)
    end),
    At(16.469, 1016, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.29256)
    end),
    At(17.016, 1017, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.08193)
    end),
    At(17.365, 1018, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.01539)
    end),
    At(19.599, 1019, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.00983, target=A.Boss})
    end),
    At(20.615, 1020, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(20.615, 1021, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(20.615, 1022, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(20.615, 1023, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(20.615, 1024, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(20.615, 1025, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(20.707, 1026, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05})
    end),
    At(20.707, 1027, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05})
    end),
    At(20.707, 1028, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05})
    end),
    At(23.592, 1029, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.00983, target=A.Boss})
    end),
    At(24.654, 1030, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(24.654, 1031, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(24.654, 1032, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(24.654, 1033, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(24.654, 1034, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(24.654, 1035, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(24.654, 1036, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=106.9693, y=0.0, z=103.9279}, rotation=-5e-05})
    end),
    At(24.654, 1037, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=93.1136, y=0.0, z=104.0716}, rotation=-5e-05})
    end),
    At(24.654, 1038, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=99.917, y=0.0, z=92.0004}, rotation=-5e-05})
    end),
    At(26.378, 1039, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.56284)
    end),
    At(26.538, 1040, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(26.538, 1041, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(26.538, 1042, function(d,s)
        C.Move(d,s,A.Helper10,{x=107.9985, y=0.0, z=100.1537},-5e-05)
    end),
    At(26.538, 1043, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(26.538, 1044, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(26.538, 1045, function(d,s)
        C.Move(d,s,A.Helper09,{x=96.1338, y=0.0, z=92.9962},-5e-05)
    end),
    At(26.538, 1046, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(26.538, 1047, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(26.538, 1048, function(d,s)
        C.Move(d,s,A.Helper08,{x=95.8676, y=0.0, z=106.8501},-5e-05)
    end),
}
