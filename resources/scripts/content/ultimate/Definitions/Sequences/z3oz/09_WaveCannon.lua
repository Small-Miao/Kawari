-- 波动炮 [31657]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1029, function(d,s)
        C.Cast(d,s,A.Boss,31657,10.6,{spell=31657, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.1298, target=A.Boss})
    end),
    At(1.883, 1030, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(1.883, 1031, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(1.883, 1032, function(d,s)
        C.Move(d,s,A.Helper29,{x=102.5, y=0.0, z=80.0},-5e-05)
    end),
    At(1.883, 1033, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(1.883, 1034, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(1.883, 1035, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=102.5},-1.57087)
    end),
    At(1.883, 1036, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(1.883, 1037, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(1.883, 1038, function(d,s)
        C.Move(d,s,A.Helper24,{x=97.5, y=0.0, z=120.0},-3.14159)
    end),
    At(1.883, 1039, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(1.883, 1040, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(1.883, 1041, function(d,s)
        C.Move(d,s,A.Helper22,{x=80.0, y=0.0, z=97.5},1.57077)
    end),
    At(2.011, 1042, function(d,s)
        C.Action(d,s,A.Helper22,31652,{pos={x=80.0, y=0.0, z=97.5}, rotation=1.57077, target=A.Helper22})
    end),
    At(2.011, 1043, function(d,s)
        C.Action(d,s,A.Helper24,31652,{pos={x=97.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper24})
    end),
    At(2.011, 1044, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=120.0, y=0.0, z=102.5}, rotation=-1.57087, target=A.Helper27})
    end),
    At(2.011, 1045, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=102.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(2.967, 1046, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(2.967, 1047, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(2.967, 1048, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(2.967, 1049, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(2.967, 1050, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(2.967, 1051, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.23494)
    end),
    At(2.967, 1052, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(2.967, 1053, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(2.967, 1054, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.78507)
    end),
    At(2.967, 1055, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(2.967, 1056, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(2.967, 1057, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.072, 1058, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.072, 1059, function(d,s)
        C.Action(d,s,A.Helper28,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.31985, target=A.Helper28})
    end),
    At(3.072, 1060, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.20934)
    end),
    At(3.072, 1061, function(d,s)
        C.Action(d,s,A.Helper31,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.20934, target=A.Helper31})
    end),
    At(3.072, 1062, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.78546)
    end),
    At(3.072, 1063, function(d,s)
        C.Action(d,s,A.Helper30,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.78546, target=A.Helper30})
    end),
    At(3.072, 1064, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.072, 1065, function(d,s)
        C.Action(d,s,A.Helper32,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78047, target=A.Helper32})
    end),
    At(3.072, 1066, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.072, 1067, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.19151)
    end),
    At(3.072, 1068, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.072, 1069, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.152, 1070, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.152, 1071, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.152, 1072, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.152, 1073, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.223, 1074, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.223, 1075, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.223, 1076, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.223, 1077, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.223, 1078, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.223, 1079, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.223, 1080, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.223, 1081, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.302, 1082, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.302, 1083, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.302, 1084, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.302, 1085, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.327, 1086, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.327, 1087, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.327, 1088, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.327, 1089, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78047)
    end),
    At(3.36, 1090, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.36, 1091, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.36, 1092, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.36, 1093, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78162)
    end),
    At(3.4, 1094, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.4, 1095, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.4, 1096, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.4, 1097, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78507)
    end),
    At(3.462, 1098, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.462, 1099, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.462, 1100, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.462, 1101, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.79025)
    end),
    At(3.538, 1102, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.538, 1103, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.538, 1104, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.538, 1105, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.79533)
    end),
    At(3.599, 1106, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.599, 1107, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.599, 1108, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.599, 1109, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.599, 1110, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.599, 1111, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.599, 1112, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.599, 1113, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.599, 1114, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.599, 1115, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.599, 1116, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.599, 1117, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.697, 1118, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.697, 1119, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.697, 1120, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.697, 1121, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.733, 1122, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.733, 1123, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.733, 1124, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79639)
    end),
    At(3.733, 1125, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.77, 1126, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.77, 1127, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.77, 1128, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79629)
    end),
    At(3.77, 1129, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.811, 1130, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.811, 1131, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.811, 1132, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79629)
    end),
    At(3.811, 1133, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.889, 1134, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.889, 1135, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.889, 1136, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.7962)
    end),
    At(3.889, 1137, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.945, 1138, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.31985)
    end),
    At(3.945, 1139, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.945, 1140, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79399)
    end),
    At(3.945, 1141, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(3.945, 1142, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(3.945, 1143, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(3.945, 1144, function(d,s)
        C.Move(d,s,A.Helper26,{x=107.5, y=0.0, z=80.0},-5e-05)
    end),
    At(3.945, 1145, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(3.945, 1146, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(3.945, 1147, function(d,s)
        C.Move(d,s,A.Helper25,{x=120.0, y=0.0, z=107.5},-1.57087)
    end),
    At(3.945, 1148, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(3.945, 1149, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(3.945, 1150, function(d,s)
        C.Move(d,s,A.Helper23,{x=92.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(3.945, 1151, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(3.945, 1152, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(3.945, 1153, function(d,s)
        C.Move(d,s,A.Helper21,{x=80.0, y=0.0, z=92.5},1.57077)
    end),
    At(3.945, 1154, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.32205)
    end),
    At(3.945, 1155, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(3.945, 1156, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79399)
    end),
    At(3.945, 1157, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(4.011, 1158, function(d,s)
        C.Action(d,s,A.Helper21,31652,{pos={x=80.0, y=0.0, z=92.5}, rotation=1.57077, target=A.Helper21})
    end),
    At(4.011, 1159, function(d,s)
        C.Action(d,s,A.Helper23,31652,{pos={x=92.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper23})
    end),
    At(4.011, 1160, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=107.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper26})
    end),
    At(4.011, 1161, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.32205)
    end),
    At(4.011, 1162, function(d,s)
        C.Action(d,s,A.Helper25,31652,{pos={x=120.0, y=0.0, z=107.5}, rotation=-1.57087, target=A.Helper25})
    end),
    At(4.011, 1163, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(4.011, 1164, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79399)
    end),
    At(4.011, 1165, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(4.083, 1166, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.32205)
    end),
    At(4.083, 1167, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(4.083, 1168, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79399)
    end),
    At(4.083, 1169, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(4.083, 1170, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},2.35542)
    end),
    At(4.083, 1171, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.18969)
    end),
    At(4.083, 1172, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.79399)
    end),
    At(4.083, 1173, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.81173)
    end),
    At(4.983, 1174, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(4.983, 1175, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(4.983, 1176, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55409)
    end),
    At(4.983, 1177, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(4.983, 1178, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(4.983, 1179, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12414)
    end),
    At(4.983, 1180, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(4.983, 1181, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(4.983, 1182, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.61631)
    end),
    At(4.983, 1183, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(4.983, 1184, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(4.983, 1185, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35139)
    end),
    At(5.079, 1186, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12453)
    end),
    At(5.079, 1187, function(d,s)
        C.Action(d,s,A.Helper31,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.12453, target=A.Helper31})
    end),
    At(5.079, 1188, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.079, 1189, function(d,s)
        C.Action(d,s,A.Helper30,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.59004, target=A.Helper30})
    end),
    At(5.079, 1190, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55332)
    end),
    At(5.079, 1191, function(d,s)
        C.Action(d,s,A.Helper32,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.55332, target=A.Helper32})
    end),
    At(5.079, 1192, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35139)
    end),
    At(5.079, 1193, function(d,s)
        C.Action(d,s,A.Helper29,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.35139, target=A.Helper29})
    end),
    At(5.101, 1194, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12453)
    end),
    At(5.101, 1195, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.101, 1196, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55323)
    end),
    At(5.101, 1197, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35139)
    end),
    At(5.158, 1198, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12453)
    end),
    At(5.158, 1199, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.158, 1200, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55304)
    end),
    At(5.158, 1201, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35139)
    end),
    At(5.236, 1202, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.236, 1203, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.236, 1204, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55294)
    end),
    At(5.236, 1205, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35139)
    end),
    At(5.236, 1206, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.236, 1207, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.236, 1208, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.236, 1209, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.283, 1210, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.283, 1211, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.283, 1212, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.283, 1213, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.347, 1214, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.347, 1215, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.347, 1216, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.347, 1217, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.413, 1218, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.413, 1219, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.413, 1220, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.413, 1221, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.413, 1222, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.413, 1223, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.413, 1224, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.413, 1225, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.484, 1226, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.484, 1227, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.484, 1228, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.484, 1229, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.548, 1230, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.548, 1231, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.548, 1232, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.548, 1233, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.548, 1234, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.548, 1235, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.548, 1236, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.548, 1237, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.61, 1238, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.61, 1239, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.61, 1240, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.61, 1241, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.678, 1242, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.678, 1243, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.678, 1244, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.678, 1245, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.678, 1246, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.678, 1247, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.678, 1248, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.678, 1249, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.725, 1250, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.725, 1251, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.725, 1252, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.725, 1253, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.772, 1254, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.772, 1255, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.772, 1256, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.772, 1257, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.826, 1258, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.826, 1259, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.826, 1260, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.826, 1261, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.885, 1262, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.885, 1263, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.885, 1264, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.885, 1265, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.961, 1266, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.961, 1267, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.961, 1268, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.961, 1269, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.961, 1270, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(5.961, 1271, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(5.961, 1272, function(d,s)
        C.Move(d,s,A.Helper28,{x=112.5, y=0.0, z=80.0},-5e-05)
    end),
    At(5.961, 1273, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(5.961, 1274, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(5.961, 1275, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=112.5},-1.57087)
    end),
    At(5.961, 1276, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(5.961, 1277, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(5.961, 1278, function(d,s)
        C.Move(d,s,A.Helper24,{x=87.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(5.961, 1279, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(5.961, 1280, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(5.961, 1281, function(d,s)
        C.Move(d,s,A.Helper22,{x=80.0, y=0.0, z=87.5},1.57077)
    end),
    At(5.961, 1282, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.961, 1283, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.981, 1284, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.981, 1285, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(5.981, 1286, function(d,s)
        C.Action(d,s,A.Helper22,31652,{pos={x=80.0, y=0.0, z=87.5}, rotation=1.57077, target=A.Helper22})
    end),
    At(5.981, 1287, function(d,s)
        C.Action(d,s,A.Helper24,31652,{pos={x=87.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper24})
    end),
    At(5.981, 1288, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=112.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper28})
    end),
    At(5.981, 1289, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=120.0, y=0.0, z=112.5}, rotation=-1.57087, target=A.Helper27})
    end),
    At(5.981, 1290, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(5.981, 1291, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(5.981, 1292, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(5.981, 1293, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(6.032, 1294, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(6.032, 1295, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(6.032, 1296, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(6.032, 1297, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(6.079, 1298, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},3.12568)
    end),
    At(6.079, 1299, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},1.59004)
    end),
    At(6.079, 1300, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-1.55284)
    end),
    At(6.079, 1301, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},-2.35033)
    end),
    At(7.944, 1302, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(7.944, 1303, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(7.944, 1304, function(d,s)
        C.Move(d,s,A.Helper32,{x=117.5, y=0.0, z=80.0},-5e-05)
    end),
    At(7.944, 1305, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(7.944, 1306, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(7.944, 1307, function(d,s)
        C.Move(d,s,A.Helper31,{x=120.0, y=0.0, z=117.5},-1.57087)
    end),
    At(7.944, 1308, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(7.944, 1309, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(7.944, 1310, function(d,s)
        C.Move(d,s,A.Helper30,{x=82.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(7.944, 1311, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(7.944, 1312, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(7.944, 1313, function(d,s)
        C.Move(d,s,A.Helper29,{x=80.0, y=0.0, z=82.5},1.57077)
    end),
    At(8.036, 1314, function(d,s)
        C.Action(d,s,A.Helper31,31652,{pos={x=120.0, y=0.0, z=117.5}, rotation=-1.57087, target=A.Helper31})
    end),
    At(8.036, 1315, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=82.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper30})
    end),
    At(8.036, 1316, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=117.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(8.036, 1317, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=80.0, y=0.0, z=82.5}, rotation=1.57077, target=A.Helper29})
    end),
    At(10.964, 1318, function(d,s)
        C.Action(d,s,A.Boss,31657,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.1298, target=A.Boss})
    end),
    At(11.251, 1319, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.89303)
    end),
    At(11.415, 1320, function(d,s)
        C.Action(d,s,A.Boss,31658,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.04942, target=A.Boss})
    end),
    At(11.581, 1321, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.04942)
    end),
    At(15.518, 1322, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.04942, target=A.Boss})
    end),
    At(16.278, 1323, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(16.278, 1324, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(16.278, 1325, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(16.278, 1326, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(16.344, 1327, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=120.0, y=0.0, z=117.5}, rotation=-1.57087})
    end),
    At(16.344, 1328, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=117.5, y=0.0, z=80.0}, rotation=-5e-05})
    end),
    At(16.611, 1329, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.60234)
    end),
    At(16.947, 1330, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.1228)
    end),
    At(18.601, 1331, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11072, target=A.Boss})
    end),
    At(19.398, 1332, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(19.398, 1333, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(19.398, 1334, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(19.398, 1335, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(19.464, 1336, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=120.0, y=0.0, z=117.5}, rotation=-1.57087})
    end),
    At(19.464, 1337, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=117.5, y=0.0, z=80.0}, rotation=-5e-05})
    end),
    At(19.653, 1338, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(19.653, 1339, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(19.653, 1340, function(d,s)
        C.Move(d,s,A.Helper30,{x=116.9706, y=-0.0, z=116.9706},-2.35628)
    end),
}
