-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1379, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(0.0, 1380, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.32746)
    end),
    At(0.0, 1381, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(0.0, 1382, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(0.0, 1383, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.32746)
    end),
    At(0.062, 1384, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(0.062, 1385, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.32746)
    end),
    At(0.139, 1386, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(0.139, 1387, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.32746)
    end),
    At(0.139, 1388, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.24683)
    end),
    At(0.139, 1389, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.31078)
    end),
    At(0.199, 1390, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.08691)
    end),
    At(0.199, 1391, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.22, 1392, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.08691)
    end),
    At(0.22, 1393, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.308, 1394, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.308, 1395, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.308, 1396, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.308, 1397, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.387, 1398, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.387, 1399, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.446, 1400, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.446, 1401, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.446, 1402, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.446, 1403, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.22257)
    end),
    At(0.522, 1404, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.0197)
    end),
    At(0.522, 1405, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.80856)
    end),
    At(0.522, 1406, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.21807)
    end),
    At(0.522, 1407, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.75478)
    end),
    At(0.561, 1408, function(d,s)
        C.Action(d,s,A.Helper13,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.80856, target=A.Helper13})
    end),
    At(0.561, 1409, function(d,s)
        C.Action(d,s,A.Helper14,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.75478, target=A.Helper14})
    end),
    At(2.485, 1410, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(2.485, 1411, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(2.485, 1412, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(2.485, 1413, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.6008)
    end),
    At(2.485, 1414, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(2.485, 1415, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(2.485, 1416, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.558, 1417, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.558, 1418, function(d,s)
        C.Cast(d,s,A.Helper11,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-0.69246, target=A.Helper11})
    end),
    At(2.558, 1419, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7589)
    end),
    At(2.558, 1420, function(d,s)
        C.Cast(d,s,A.Helper12,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.7589, target=A.Helper12})
    end),
    At(2.621, 1421, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.621, 1422, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7589)
    end),
    At(2.697, 1423, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.697, 1424, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7589)
    end),
    At(2.697, 1425, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.697, 1426, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7589)
    end),
    At(2.768, 1427, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.768, 1428, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.76139)
    end),
    At(2.84, 1429, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.84, 1430, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.76139)
    end),
    At(2.84, 1431, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.84, 1432, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.76139)
    end),
    At(2.91, 1433, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.91, 1434, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(2.91, 1435, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.91, 1436, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(2.971, 1437, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(2.971, 1438, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.042, 1439, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.042, 1440, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.042, 1441, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.042, 1442, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.042, 1443, function(d,s)
        C.Action(d,s,A.Helper11,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.69246, target=A.Helper11})
    end),
    At(3.042, 1444, function(d,s)
        C.Action(d,s,A.Helper12,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.7589, target=A.Helper12})
    end),
    At(3.064, 1445, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.064, 1446, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.148, 1447, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.148, 1448, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.211, 1449, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.211, 1450, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.211, 1451, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.211, 1452, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.274, 1453, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.274, 1454, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.351, 1455, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.351, 1456, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.351, 1457, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.351, 1458, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.388, 1459, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.388, 1460, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.429, 1461, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.429, 1462, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.486, 1463, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.486, 1464, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(3.528, 1465, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.528, 1466, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.566, 1467, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.566, 1468, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.606, 1469, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.606, 1470, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.691, 1471, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.691, 1472, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.736, 1473, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.736, 1474, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.758, 1475, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.758, 1476, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.804, 1477, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.804, 1478, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.855, 1479, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.855, 1480, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.7867)
    end),
    At(3.894, 1481, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.894, 1482, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.60512)
    end),
    At(3.931, 1483, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.931, 1484, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.60512)
    end),
    At(3.975, 1485, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(3.975, 1486, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.60512)
    end),
    At(4.019, 1487, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(4.019, 1488, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.60512)
    end),
    At(4.061, 1489, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.061, 1490, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.60512)
    end),
    At(4.109, 1491, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.109, 1492, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.58863)
    end),
    At(4.152, 1493, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.152, 1494, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.45584)
    end),
    At(4.195, 1495, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.195, 1496, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.45584)
    end),
    At(4.233, 1497, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.233, 1498, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.272, 1499, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.272, 1500, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.348, 1501, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69217)
    end),
    At(4.348, 1502, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.422, 1503, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(4.422, 1504, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.422, 1505, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(4.422, 1506, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.478, 1507, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(4.478, 1508, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(4.553, 1509, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(4.553, 1510, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
}
