-- 神圣大审判 [18574]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1120, function(d,s)
        C.Cast(d,s,A.Boss,18574,2.7,{spell=18574, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13153, target=A.Boss})
    end),
    At(2.984, 1121, function(d,s)
        C.Action(d,s,A.Boss,18574,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13153, target=A.Boss})
    end),
    At(6.001, 1122, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(6.001, 1123, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(6.001, 1124, function(d,s)
        C.Move(d,s,A.Helper12,{x=92.0, y=0.0, z=84.0},-5e-05)
    end),
    At(6.001, 1125, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(6.001, 1126, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(6.001, 1127, function(d,s)
        C.Move(d,s,A.Helper11,{x=108.0, y=0.0, z=84.0},-5e-05)
    end),
    At(6.001, 1128, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(6.001, 1129, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(6.001, 1130, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(6.001, 1131, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(6.001, 1132, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(6.001, 1133, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=92.0},-5e-05)
    end),
    At(6.001, 1134, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(6.001, 1135, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(6.001, 1136, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=100.0},-5e-05)
    end),
    At(6.001, 1137, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(6.001, 1138, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(6.001, 1139, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=108.0},-5e-05)
    end),
    At(6.001, 1140, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(6.001, 1141, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(6.001, 1142, function(d,s)
        C.Move(d,s,A.Helper06,{x=116.0, y=0.0, z=108.0},-5e-05)
    end),
    At(6.001, 1143, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(6.001, 1144, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(6.001, 1145, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(6.084, 1146, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=99.9924}, pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(6.084, 1147, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=91.9966}, pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(6.084, 1148, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=91.9966}, pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(6.084, 1149, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=83.9704}, pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(6.084, 1150, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=83.9704}, pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(6.084, 1151, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=115.9838}, pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(6.084, 1152, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=107.9881}, pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(6.084, 1153, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=107.9881}, pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(6.689, 1154, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.03431)
    end),
    At(6.984, 1155, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.08586)
    end),
    At(7.318, 1156, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.04933)
    end),
    At(7.584, 1157, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(7.584, 1158, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(7.584, 1159, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(7.584, 1160, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(7.584, 1161, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(7.584, 1162, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(7.584, 1163, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(7.584, 1164, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(8.0, 1165, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(8.0, 1166, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(8.0, 1167, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(8.0, 1168, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(8.0, 1169, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(8.0, 1170, function(d,s)
        C.Move(d,s,A.Helper11,{x=84.0, y=0.0, z=92.0},-5e-05)
    end),
    At(8.0, 1171, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.0, 1172, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.0, 1173, function(d,s)
        C.Move(d,s,A.Helper10,{x=92.0, y=0.0, z=92.0},-5e-05)
    end),
    At(8.0, 1174, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.0, 1175, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.0, 1176, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=100.0},-5e-05)
    end),
    At(8.0, 1177, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.0, 1178, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.0, 1179, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=108.0},-5e-05)
    end),
    At(8.0, 1180, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(8.0, 1181, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(8.0, 1182, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(8.0, 1183, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(8.0, 1184, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(8.0, 1185, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=116.0},-5e-05)
    end),
    At(8.0, 1186, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(8.0, 1187, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(8.0, 1188, function(d,s)
        C.Move(d,s,A.Helper05,{x=108.0, y=0.0, z=116.0},-5e-05)
    end),
    At(8.05, 1189, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.00964)
    end),
    At(8.101, 1190, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=107.9881}, pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(8.101, 1191, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=99.9924}, pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(8.101, 1192, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=91.9966}, pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(8.101, 1193, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=91.9966}, pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(8.101, 1194, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=83.9704}, pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(8.101, 1195, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=115.9838}, pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(8.101, 1196, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=115.9838}, pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(8.101, 1197, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=107.9881}, pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(9.583, 1198, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(9.583, 1199, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(9.583, 1200, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.583, 1201, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(9.583, 1202, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(9.583, 1203, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(9.583, 1204, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(9.583, 1205, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(9.987, 1206, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(9.987, 1207, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(9.987, 1208, function(d,s)
        C.Move(d,s,A.Helper12,{x=84.0, y=0.0, z=84.0},-5e-05)
    end),
    At(9.987, 1209, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(9.987, 1210, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(9.987, 1211, function(d,s)
        C.Move(d,s,A.Helper11,{x=116.0, y=0.0, z=84.0},-5e-05)
    end),
    At(9.987, 1212, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(9.987, 1213, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(9.987, 1214, function(d,s)
        C.Move(d,s,A.Helper10,{x=108.0, y=0.0, z=92.0},-5e-05)
    end),
    At(9.987, 1215, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(9.987, 1216, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(9.987, 1217, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.987, 1218, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(9.987, 1219, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(9.987, 1220, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.987, 1221, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.987, 1222, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.987, 1223, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.987, 1224, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(9.987, 1225, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(9.987, 1226, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=108.0},-5e-05)
    end),
    At(9.987, 1227, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(9.987, 1228, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(9.987, 1229, function(d,s)
        C.Move(d,s,A.Helper05,{x=84.0, y=0.0, z=116.0},-5e-05)
    end),
    At(9.987, 1230, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(9.987, 1231, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(9.987, 1232, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.0, y=0.0, z=116.0},-5e-05)
    end),
    At(10.067, 1233, function(d,s)
        C.Cast(d,s,A.Helper08,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(10.067, 1234, function(d,s)
        C.Cast(d,s,A.Helper09,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=99.9924}, pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(10.067, 1235, function(d,s)
        C.Cast(d,s,A.Helper10,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=91.9966}, pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(10.067, 1236, function(d,s)
        C.Cast(d,s,A.Helper11,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=83.9704}, pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(10.067, 1237, function(d,s)
        C.Cast(d,s,A.Helper12,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=83.9704}, pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(10.067, 1238, function(d,s)
        C.Cast(d,s,A.Helper04,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=115.9838, y=-0.0153, z=115.9838}, pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(10.067, 1239, function(d,s)
        C.Cast(d,s,A.Helper05,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=83.9704, y=-0.0153, z=115.9838}, pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(10.067, 1240, function(d,s)
        C.Cast(d,s,A.Helper06,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=91.9966, y=-0.0153, z=107.9881}, pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(10.067, 1241, function(d,s)
        C.Cast(d,s,A.Helper07,18575,1.2,{spell=18575, omen_delay=0, cast_pos={x=107.9881, y=-0.0153, z=99.9924}, pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(11.083, 1242, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.19544)
    end),
    At(11.521, 1243, function(d,s)
        C.Action(d,s,A.Helper08,18575,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(11.521, 1244, function(d,s)
        C.Action(d,s,A.Helper09,18575,{pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(11.521, 1245, function(d,s)
        C.Action(d,s,A.Helper10,18575,{pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(11.521, 1246, function(d,s)
        C.Action(d,s,A.Helper11,18575,{pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(11.521, 1247, function(d,s)
        C.Action(d,s,A.Helper12,18575,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(11.521, 1248, function(d,s)
        C.Action(d,s,A.Helper04,18575,{pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(11.521, 1249, function(d,s)
        C.Action(d,s,A.Helper05,18575,{pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(11.521, 1250, function(d,s)
        C.Action(d,s,A.Helper06,18575,{pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(11.521, 1251, function(d,s)
        C.Action(d,s,A.Helper07,18575,{pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(11.589, 1252, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.40196)
    end),
    At(11.887, 1253, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.64049)
    end),
    At(12.29, 1254, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.90271)
    end),
    At(12.534, 1255, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.17759)
    end),
    At(12.818, 1256, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.48295)
    end),
    At(14.033, 1257, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(14.033, 1258, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(14.033, 1259, function(d,s)
        C.Move(d,s,A.Helper12,{x=92.0, y=0.0, z=84.0},-5e-05)
    end),
    At(14.033, 1260, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(14.033, 1261, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(14.033, 1262, function(d,s)
        C.Move(d,s,A.Helper11,{x=108.0, y=0.0, z=84.0},-5e-05)
    end),
    At(14.033, 1263, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(14.033, 1264, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(14.033, 1265, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(14.033, 1266, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(14.033, 1267, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(14.033, 1268, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=92.0},-5e-05)
    end),
    At(14.033, 1269, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(14.033, 1270, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(14.033, 1271, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=100.0},-5e-05)
    end),
    At(14.033, 1272, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(14.033, 1273, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(14.033, 1274, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=108.0},-5e-05)
    end),
    At(14.033, 1275, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(14.033, 1276, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(14.033, 1277, function(d,s)
        C.Move(d,s,A.Helper06,{x=116.0, y=0.0, z=108.0},-5e-05)
    end),
    At(14.033, 1278, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(14.033, 1279, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(14.033, 1280, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(14.118, 1281, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=84.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(14.118, 1282, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=116.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(14.118, 1283, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.118, 1284, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=108.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(14.118, 1285, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=92.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(14.118, 1286, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.118, 1287, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=116.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(14.118, 1288, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=108.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
}
