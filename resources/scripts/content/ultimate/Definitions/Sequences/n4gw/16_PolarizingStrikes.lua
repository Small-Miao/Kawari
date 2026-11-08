-- 星灵之剑 [40316]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1277, function(d,s)
        C.Cast(d,s,A.Boss,40316,6.2,{spell=40316, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(6.47, 1278, function(d,s)
        C.Action(d,s,A.Boss,40316,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(6.47, 1279, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(6.47, 1280, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(6.47, 1281, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76245)
    end),
    At(6.47, 1282, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(6.47, 1283, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(6.47, 1284, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.611, 1285, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.611, 1286, function(d,s)
        C.Cast(d,s,A.Helper13,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-0.80856, target=A.Helper13})
    end),
    At(6.611, 1287, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.7612)
    end),
    At(6.611, 1288, function(d,s)
        C.Cast(d,s,A.Helper14,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.7612, target=A.Helper14})
    end),
    At(6.611, 1289, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.611, 1290, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.691, 1291, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.691, 1292, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.77, 1293, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.77, 1294, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.77, 1295, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.77, 1296, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.833, 1297, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.833, 1298, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.833, 1299, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.833, 1300, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.913, 1301, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.913, 1302, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.965, 1303, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.965, 1304, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(6.965, 1305, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(6.965, 1306, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.045, 1307, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.045, 1308, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.099, 1309, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.099, 1310, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.099, 1311, function(d,s)
        C.Action(d,s,A.Helper13,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.80856, target=A.Helper13})
    end),
    At(7.099, 1312, function(d,s)
        C.Action(d,s,A.Helper14,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.7612, target=A.Helper14})
    end),
    At(7.118, 1313, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.118, 1314, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.141, 1315, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.141, 1316, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.208, 1317, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.208, 1318, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.27, 1319, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.27, 1320, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.27, 1321, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.27, 1322, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.355, 1323, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.355, 1324, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.431, 1325, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.431, 1326, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.431, 1327, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.431, 1328, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.488, 1329, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.488, 1330, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.529, 1331, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.529, 1332, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.57, 1333, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.57, 1334, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.607, 1335, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.607, 1336, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.649, 1337, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.649, 1338, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.695, 1339, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(7.695, 1340, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.74, 1341, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80367)
    end),
    At(7.74, 1342, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.759, 1343, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80367)
    end),
    At(7.759, 1344, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.848, 1345, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80367)
    end),
    At(7.848, 1346, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(7.888, 1347, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74155)
    end),
    At(7.888, 1348, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(7.927, 1349, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74155)
    end),
    At(7.927, 1350, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(7.947, 1351, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74155)
    end),
    At(7.947, 1352, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(7.99, 1353, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74155)
    end),
    At(7.99, 1354, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(8.046, 1355, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74155)
    end),
    At(8.046, 1356, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(8.11, 1357, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.11, 1358, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(8.131, 1359, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.131, 1360, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(8.173, 1361, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.173, 1362, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75113)
    end),
    At(8.215, 1363, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.215, 1364, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.251, 1365, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.251, 1366, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.313, 1367, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.313, 1368, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.35, 1369, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.35, 1370, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.387, 1371, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.53043)
    end),
    At(8.387, 1372, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.434, 1373, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(8.434, 1374, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.493, 1375, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(8.493, 1376, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
    At(8.549, 1377, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(8.549, 1378, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.55325)
    end),
}
