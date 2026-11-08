-- 光尘之剑 [40306]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 943, function(d,s)
        C.Cast(d,s,A.Boss,40306,5.7,{spell=40306, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.34575, target=A.Boss})
    end),
    At(5.942, 951, function(d,s)
        C.Action(d,s,A.Boss,40306,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.34575, target=A.Boss})
    end),
    At(9.076, 958, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.34575, target=A.Boss})
    end),
    At(9.363, 959, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.46234)
    end),
    At(9.706, 960, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(9.706, 961, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(9.706, 962, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-1.46234)
    end),
    At(9.706, 963, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(9.706, 964, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(9.706, 965, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.46234)
    end),
    At(9.781, 966, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.46234})
    end),
    At(9.781, 967, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.46234})
    end),
    At(9.908, 969, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(9.908, 970, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(9.908, 971, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=103.0},-3.14159)
    end),
    At(9.908, 972, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(9.908, 973, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(9.908, 974, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=103.0},-5e-05)
    end),
    At(9.908, 976, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(9.908, 977, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(9.908, 978, function(d,s)
        C.Move(d,s,A.Helper10,{x=96.4142, y=0.0, z=103.5858},-0.78546)
    end),
    At(9.908, 979, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(9.908, 980, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(9.908, 981, function(d,s)
        C.Move(d,s,A.Helper09,{x=96.4142, y=0.0, z=103.5858},2.35618)
    end),
    At(9.997, 982, function(d,s)
        C.Cast(d,s,A.Helper09,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=96.3912, y=-0.0153, z=103.563}, pos={x=96.4142, y=0.0, z=103.5858}, rotation=2.35618, target=A.Helper09})
    end),
    At(9.997, 983, function(d,s)
        C.Cast(d,s,A.Helper10,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=96.3912, y=-0.0153, z=103.563}, pos={x=96.4142, y=0.0, z=103.5858}, rotation=-0.78546, target=A.Helper10})
    end),
    At(9.997, 984, function(d,s)
        C.Cast(d,s,A.Helper11,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=102.9831}, pos={x=100.0, y=0.0, z=103.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(9.997, 985, function(d,s)
        C.Cast(d,s,A.Helper12,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=102.9831}, pos={x=100.0, y=0.0, z=103.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(11.22, 986, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.42694)
    end),
    At(11.578, 987, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.8905)
    end),
    At(11.83, 988, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.98417)
    end),
    At(12.161, 989, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.9647)
    end),
    At(12.257, 990, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.9647, target=A.Boss})
    end),
    At(12.45, 991, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.9299)
    end),
    At(12.871, 992, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(12.871, 993, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(12.871, 994, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.9299)
    end),
    At(12.871, 995, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(12.871, 996, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(12.871, 997, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},2.9299)
    end),
    At(12.954, 998, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.9299})
    end),
    At(12.954, 999, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.9299})
    end),
    At(13.208, 1000, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.13833)
    end),
    At(13.96, 1002, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(13.96, 1003, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(13.96, 1004, function(d,s)
        C.Move(d,s,A.Helper14,{x=90.0, y=0.0, z=100.0},1.57077)
    end),
    At(13.96, 1005, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(13.96, 1006, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(13.96, 1007, function(d,s)
        C.Move(d,s,A.Helper13,{x=90.0, y=0.0, z=100.0},-1.57087)
    end),
    At(13.96, 1009, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(13.96, 1010, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(13.96, 1011, function(d,s)
        C.Move(d,s,A.Helper08,{x=89.3431, y=0.0, z=89.3431},-2.35628)
    end),
    At(13.96, 1012, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(13.96, 1013, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(13.96, 1014, function(d,s)
        C.Move(d,s,A.Helper07,{x=89.3431, y=0.0, z=89.3431},0.78536)
    end),
    At(14.02, 1015, function(d,s)
        C.Cast(d,s,A.Helper07,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=89.3416, y=-0.0153, z=89.3416}, pos={x=89.3431, y=0.0, z=89.3431}, rotation=0.78536, target=A.Helper07})
    end),
    At(14.02, 1016, function(d,s)
        C.Cast(d,s,A.Helper08,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=89.3416, y=-0.0153, z=89.3416}, pos={x=89.3431, y=0.0, z=89.3431}, rotation=-2.35628, target=A.Helper08})
    end),
    At(14.02, 1017, function(d,s)
        C.Cast(d,s,A.Helper13,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=89.9825, y=-0.0153, z=99.9924}, pos={x=90.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(14.02, 1018, function(d,s)
        C.Cast(d,s,A.Helper14,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=89.9825, y=-0.0153, z=99.9924}, pos={x=90.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(14.884, 1019, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.89903)
    end),
    At(15.461, 1021, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.89903, target=A.Boss})
    end),
    At(16.034, 1022, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(16.034, 1023, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(16.034, 1024, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=100.0},2.90334)
    end),
    At(16.034, 1025, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(16.034, 1026, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(16.034, 1027, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=100.0},2.90334)
    end),
    At(16.115, 1028, function(d,s)
        C.Action(d,s,A.Helper05,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.90334})
    end),
    At(16.115, 1029, function(d,s)
        C.Action(d,s,A.Helper06,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.90334})
    end),
    At(16.341, 1030, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.99193)
    end),
    At(16.626, 1031, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.03364)
    end),
    At(17.047, 1034, function(d,s)
        C.Action(d,s,A.Helper09,40118,{pos={x=96.4142, y=0.0, z=103.5858}, rotation=2.35618, target=A.Helper09})
    end),
    At(17.047, 1035, function(d,s)
        C.Action(d,s,A.Helper10,40307,{pos={x=96.4142, y=0.0, z=103.5858}, rotation=-0.78546, target=A.Helper10})
    end),
    At(17.047, 1036, function(d,s)
        C.Action(d,s,A.Helper11,40118,{pos={x=100.0, y=0.0, z=103.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(17.047, 1037, function(d,s)
        C.Action(d,s,A.Helper12,40307,{pos={x=100.0, y=0.0, z=103.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(17.925, 1039, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(17.925, 1040, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(17.925, 1041, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=83.0},3.14159)
    end),
    At(17.925, 1042, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(17.925, 1043, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(17.925, 1044, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=83.0},-5e-05)
    end),
    At(17.925, 1046, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(17.925, 1047, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(17.925, 1048, function(d,s)
        C.Move(d,s,A.Helper04,{x=110.6569, y=0.0, z=89.3431},-0.78546)
    end),
    At(17.925, 1049, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(17.925, 1050, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(17.925, 1051, function(d,s)
        C.Move(d,s,A.Helper03,{x=110.6569, y=0.0, z=89.3431},2.35618)
    end),
    At(18.07, 1052, function(d,s)
        C.Cast(d,s,A.Helper03,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=110.6432, y=-0.0153, z=89.3416}, pos={x=110.6569, y=0.0, z=89.3431}, rotation=2.35618, target=A.Helper03})
    end),
    At(18.07, 1053, function(d,s)
        C.Cast(d,s,A.Helper04,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=110.6432, y=-0.0153, z=89.3416}, pos={x=110.6569, y=0.0, z=89.3431}, rotation=-0.78546, target=A.Helper04})
    end),
    At(18.07, 1054, function(d,s)
        C.Cast(d,s,A.Helper05,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=82.9938}, pos={x=100.0, y=0.0, z=83.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(18.07, 1055, function(d,s)
        C.Cast(d,s,A.Helper06,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=82.9938}, pos={x=100.0, y=0.0, z=83.0}, rotation=3.14159, target=A.Helper06})
    end),
    At(18.601, 1056, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.03364, target=A.Boss})
    end),
    At(19.04, 1057, function(d,s)
        C.Move(d,s,A.Helper09,{x=99.9498, y=0.0, z=100.0503},2.35618)
    end),
    At(19.04, 1058, function(d,s)
        C.Move(d,s,A.Helper10,{x=92.8787, y=0.0, z=107.1213},-0.78546)
    end),
    At(19.04, 1059, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(19.04, 1060, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=98.0},-3.14159)
    end),
    At(19.1, 1061, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=99.9498, y=0.0, z=100.0503}, rotation=2.35618, target=A.Helper09})
    end),
    At(19.1, 1062, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=92.8787, y=0.0, z=107.1213}, rotation=-0.78546, target=A.Helper10})
    end),
    At(19.1, 1063, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(19.1, 1064, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=98.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(19.16, 1067, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(19.16, 1068, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(19.16, 1069, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},3.03364)
    end),
    At(19.16, 1070, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(19.16, 1071, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(19.16, 1072, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},3.03364)
    end),
    At(19.266, 1073, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.03364})
    end),
    At(19.314, 1074, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.03364})
    end),
    At(20.276, 1075, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12625)
    end),
    At(20.561, 1077, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.9881)
    end),
    At(20.919, 1078, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.92779)
    end),
    At(20.996, 1081, function(d,s)
        C.Action(d,s,A.Helper07,40118,{pos={x=89.3431, y=0.0, z=89.3431}, rotation=0.78536, target=A.Helper07})
    end),
    At(20.996, 1082, function(d,s)
        C.Action(d,s,A.Helper08,40307,{pos={x=89.3431, y=0.0, z=89.3431}, rotation=-2.35628, target=A.Helper08})
    end),
    At(20.996, 1083, function(d,s)
        C.Action(d,s,A.Helper13,40118,{pos={x=90.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(20.996, 1084, function(d,s)
        C.Action(d,s,A.Helper14,40307,{pos={x=90.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(21.132, 1085, function(d,s)
        C.Move(d,s,A.Helper09,{x=103.4853, y=0.0, z=96.5147},2.35618)
    end),
    At(21.132, 1086, function(d,s)
        C.Move(d,s,A.Helper10,{x=89.3431, y=0.0, z=110.6569},-0.78546)
    end),
    At(21.132, 1087, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=113.0},-5e-05)
    end),
    At(21.132, 1088, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=93.0},-3.14159)
    end),
    At(21.181, 1089, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=103.4853, y=0.0, z=96.5147}, rotation=2.35618, target=A.Helper09})
    end),
    At(21.181, 1090, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=89.3431, y=0.0, z=110.6569}, rotation=-0.78546, target=A.Helper10})
    end),
    At(21.181, 1091, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=113.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(21.181, 1092, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=93.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(21.707, 1093, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.92779, target=A.Boss})
    end),
    At(22.287, 1094, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.02424)
    end),
    At(22.356, 1095, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(22.356, 1096, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(22.356, 1097, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},3.02424)
    end),
    At(22.356, 1098, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(22.356, 1099, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(22.356, 1100, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},3.02424)
    end),
    At(22.441, 1101, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.02424})
    end),
    At(22.441, 1102, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.02424})
    end),
    At(22.642, 1103, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.84927)
    end),
    At(22.931, 1104, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.82856)
    end),
    At(23.08, 1105, function(d,s)
        C.Move(d,s,A.Helper07,{x=92.8787, y=0.0, z=92.8787},0.78536)
    end),
    At(23.08, 1106, function(d,s)
        C.Move(d,s,A.Helper08,{x=85.8076, y=0.0, z=85.8076},-2.35628)
    end),
    At(23.08, 1107, function(d,s)
        C.Move(d,s,A.Helper13,{x=85.0, y=0.0, z=100.0},-1.57087)
    end),
    At(23.08, 1108, function(d,s)
        C.Move(d,s,A.Helper14,{x=95.0, y=0.0, z=100.0},1.57077)
    end),
    At(23.142, 1109, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=92.8787, y=0.0, z=92.8787}, rotation=0.78536, target=A.Helper07})
    end),
    At(23.142, 1110, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=85.8076, y=0.0, z=85.8076}, rotation=-2.35628, target=A.Helper08})
    end),
    At(23.142, 1111, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=85.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(23.142, 1112, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=95.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(23.216, 1113, function(d,s)
        C.Move(d,s,A.Helper09,{x=107.0208, y=0.0, z=92.9792},2.35618)
    end),
    At(23.216, 1114, function(d,s)
        C.Move(d,s,A.Helper10,{x=85.8076, y=0.0, z=114.1924},-0.78546)
    end),
    At(23.216, 1115, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=118.0},-5e-05)
    end),
    At(23.216, 1116, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=88.0},-3.14159)
    end),
    At(23.216, 1117, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.95607)
    end),
    At(23.261, 1118, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=107.0208, y=0.0, z=92.9792}, rotation=2.35618, target=A.Helper09})
    end),
    At(23.261, 1119, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=85.8076, y=0.0, z=114.1924}, rotation=-0.78546, target=A.Helper10})
    end),
    At(23.261, 1120, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=118.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(23.261, 1121, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=88.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(24.04, 1124, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.9763)
    end),
    At(24.323, 1125, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.04639)
    end),
    At(24.604, 1126, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.97621)
    end),
}
