-- 死亡轮回 [40310]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1127, function(d,s)
        C.Cast(d,s,A.Boss,40310,7.7,{spell=40310, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.97621, target=A.Boss})
    end),
    At(0.14, 1130, function(d,s)
        C.Action(d,s,A.Helper03,40118,{pos={x=110.6569, y=0.0, z=89.3431}, rotation=2.35618, target=A.Helper03})
    end),
    At(0.14, 1131, function(d,s)
        C.Action(d,s,A.Helper04,40307,{pos={x=110.6569, y=0.0, z=89.3431}, rotation=-0.78546, target=A.Helper04})
    end),
    At(0.14, 1132, function(d,s)
        C.Action(d,s,A.Helper05,40118,{pos={x=100.0, y=0.0, z=83.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(0.14, 1133, function(d,s)
        C.Action(d,s,A.Helper06,40307,{pos={x=100.0, y=0.0, z=83.0}, rotation=3.14159, target=A.Helper06})
    end),
    At(0.279, 1134, function(d,s)
        C.Move(d,s,A.Helper07,{x=96.4142, y=0.0, z=96.4142},0.78536)
    end),
    At(0.279, 1135, function(d,s)
        C.Move(d,s,A.Helper13,{x=80.0, y=0.0, z=100.0},-1.57087)
    end),
    At(0.279, 1136, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.57077)
    end),
    At(0.342, 1137, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=96.4142, y=0.0, z=96.4142}, rotation=0.78536, target=A.Helper07})
    end),
    At(0.342, 1138, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=80.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(0.342, 1139, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(0.408, 1140, function(d,s)
        C.Move(d,s,A.Helper09,{x=110.5564, y=0.0, z=89.4436},2.35618)
    end),
    At(0.408, 1141, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=83.0},-3.14159)
    end),
    At(0.486, 1142, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=110.5564, y=0.0, z=89.4436}, rotation=2.35618, target=A.Helper09})
    end),
    At(0.486, 1143, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=83.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(2.214, 1144, function(d,s)
        C.Move(d,s,A.Helper03,{x=114.1924, y=0.0, z=85.8076},2.35618)
    end),
    At(2.214, 1145, function(d,s)
        C.Move(d,s,A.Helper04,{x=107.1214, y=0.0, z=92.8787},-0.78546)
    end),
    At(2.214, 1146, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=88.0},-5e-05)
    end),
    At(2.214, 1147, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=78.0},3.14159)
    end),
    At(2.214, 1148, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=114.1924, y=0.0, z=85.8076}, rotation=2.35618, target=A.Helper03})
    end),
    At(2.214, 1149, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=107.1214, y=0.0, z=92.8787}, rotation=-0.78546, target=A.Helper04})
    end),
    At(2.214, 1150, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(2.214, 1151, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=78.0}, rotation=3.14159, target=A.Helper06})
    end),
    At(2.356, 1152, function(d,s)
        C.Move(d,s,A.Helper07,{x=99.9497, y=0.0, z=99.9498},0.78536)
    end),
    At(2.356, 1153, function(d,s)
        C.Move(d,s,A.Helper14,{x=105.0, y=0.0, z=100.0},1.57077)
    end),
    At(2.423, 1154, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=99.9497, y=0.0, z=99.9498}, rotation=0.78536, target=A.Helper07})
    end),
    At(2.423, 1155, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=105.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(2.489, 1157, function(d,s)
        C.Move(d,s,A.Helper09,{x=114.0919, y=0.0, z=85.9081},2.35618)
    end),
    At(2.489, 1158, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=78.0},-3.14159)
    end),
    At(2.559, 1159, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=114.0919, y=0.0, z=85.9081}, rotation=2.35618, target=A.Helper09})
    end),
    At(2.559, 1160, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=78.0}, rotation=-3.14159, target=A.Helper12})
    end),
    At(4.287, 1163, function(d,s)
        C.Move(d,s,A.Helper04,{x=103.5858, y=0.0, z=96.4142},-0.78546)
    end),
    At(4.287, 1164, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=93.0},-5e-05)
    end),
    At(4.287, 1165, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=103.5858, y=0.0, z=96.4142}, rotation=-0.78546, target=A.Helper04})
    end),
    At(4.287, 1166, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=93.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(4.446, 1167, function(d,s)
        C.Move(d,s,A.Helper07,{x=103.4853, y=0.0, z=103.4853},0.78536)
    end),
    At(4.446, 1168, function(d,s)
        C.Move(d,s,A.Helper14,{x=110.0, y=0.0, z=100.0},1.57077)
    end),
    At(4.467, 1169, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=103.4853, y=0.0, z=103.4853}, rotation=0.78536, target=A.Helper07})
    end),
    At(4.467, 1170, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=110.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(6.276, 1171, function(d,s)
        C.Move(d,s,A.Helper04,{x=100.0503, y=0.0, z=99.9498},-0.78546)
    end),
    At(6.276, 1172, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=98.0},-5e-05)
    end),
    At(6.32, 1173, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=100.0503, y=0.0, z=99.9498}, rotation=-0.78546, target=A.Helper04})
    end),
    At(6.32, 1174, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=98.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(6.533, 1175, function(d,s)
        C.Move(d,s,A.Helper07,{x=107.0208, y=0.0, z=107.0208},0.78536)
    end),
    At(6.533, 1176, function(d,s)
        C.Move(d,s,A.Helper14,{x=115.0, y=0.0, z=100.0},1.57077)
    end),
    At(6.597, 1177, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=107.0208, y=0.0, z=107.0208}, rotation=0.78536, target=A.Helper07})
    end),
    At(6.597, 1178, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=115.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(7.934, 1179, function(d,s)
        C.Action(d,s,A.Boss,40310,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.97621, target=A.Boss})
    end),
    At(7.934, 1180, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(7.934, 1181, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(7.934, 1182, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(7.934, 1183, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(8.059, 1184, function(d,s)
        C.Action(d,s,A.Helper12,40311,{pos={x=100.0, y=0.0, z=78.0}, rotation=-3.14159})
    end),
    At(8.059, 1185, function(d,s)
        C.Action(d,s,A.Helper13,40312,{pos={x=80.0, y=0.0, z=100.0}, rotation=-1.57087})
    end),
    At(8.378, 1186, function(d,s)
        C.Move(d,s,A.Helper04,{x=96.5148, y=0.0, z=103.4853},-0.78546)
    end),
    At(8.378, 1187, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=103.0},-5e-05)
    end),
    At(8.43, 1188, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=96.5148, y=0.0, z=103.4853}, rotation=-0.78546, target=A.Helper04})
    end),
    At(8.43, 1189, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=103.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(8.641, 1190, function(d,s)
        C.Move(d,s,A.Helper07,{x=110.5563, y=0.0, z=110.5564},0.78536)
    end),
    At(8.641, 1191, function(d,s)
        C.Move(d,s,A.Helper14,{x=120.0, y=0.0, z=100.0},1.57077)
    end),
    At(8.641, 1192, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=110.5563, y=0.0, z=110.5564}, rotation=0.78536, target=A.Helper07})
    end),
    At(8.641, 1193, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=120.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(10.412, 1194, function(d,s)
        C.Move(d,s,A.Helper04,{x=92.9792, y=0.0, z=107.0208},-0.78546)
    end),
    At(10.412, 1195, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(10.455, 1196, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=92.9792, y=0.0, z=107.0208}, rotation=-0.78546, target=A.Helper04})
    end),
    At(10.455, 1197, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(10.672, 1198, function(d,s)
        C.Move(d,s,A.Helper07,{x=114.0919, y=0.0, z=114.0919},0.78536)
    end),
    At(10.694, 1199, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=114.0919, y=0.0, z=114.0919}, rotation=0.78536, target=A.Helper07})
    end),
    At(11.105, 1200, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.97621, target=A.Boss})
    end),
    At(11.331, 1201, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.84517)
    end),
    At(11.603, 1202, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.18863)
    end),
    At(11.741, 1203, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(11.741, 1204, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(11.741, 1205, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.18863)
    end),
    At(11.741, 1206, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.741, 1207, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.741, 1208, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.18863)
    end),
    At(11.822, 1209, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.18863})
    end),
    At(11.822, 1210, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.18863})
    end),
    At(12.542, 1211, function(d,s)
        C.Move(d,s,A.Helper04,{x=89.4437, y=0.0, z=110.5564},-0.78546)
    end),
    At(12.542, 1212, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=113.0},-5e-05)
    end),
    At(12.542, 1213, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=89.4437, y=0.0, z=110.5564}, rotation=-0.78546, target=A.Helper04})
    end),
    At(12.542, 1214, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=113.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(12.812, 1215, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.08605)
    end),
    At(13.166, 1216, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.02776)
    end),
    At(13.665, 1217, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.08691)
    end),
    At(14.27, 1218, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.08691, target=A.Boss})
    end),
    At(14.644, 1219, function(d,s)
        C.Move(d,s,A.Helper04,{x=85.9081, y=0.0, z=114.0919},-0.78546)
    end),
    At(14.644, 1220, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=118.0},-5e-05)
    end),
    At(14.644, 1221, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=85.9081, y=0.0, z=114.0919}, rotation=-0.78546, target=A.Helper04})
    end),
    At(14.644, 1222, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=118.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.917, 1223, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.917, 1224, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.917, 1225, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.08691)
    end),
    At(14.917, 1226, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(14.917, 1227, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(14.917, 1228, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.08691)
    end),
    At(14.989, 1229, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.08691})
    end),
    At(14.989, 1230, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.08691})
    end),
}
