-- 波动炮：限制解除 [31660]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1341, function(d,s)
        C.Cast(d,s,A.Helper30,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=116.9604, y=-0.0153, z=116.9604}, pos={x=116.9706, y=-0.0, z=116.9706}, rotation=-2.35628, target=A.Helper30})
    end),
    At(0.0, 1342, function(d,s)
        C.Cast(d,s,A.Boss,31660,4.7,{spell=31660, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11072, target=A.Boss})
    end),
    At(0.869, 1343, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(0.869, 1344, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(0.869, 1345, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=-0.0, z=124.0},3.14159)
    end),
    At(0.982, 1346, function(d,s)
        C.Cast(d,s,A.Helper32,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=99.9924, y=-0.0153, z=123.9796}, pos={x=100.0, y=-0.0, z=124.0}, rotation=3.14159, target=A.Helper32})
    end),
    At(1.865, 1347, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(1.865, 1348, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(1.865, 1349, function(d,s)
        C.Move(d,s,A.Helper31,{x=83.0294, y=0.0, z=116.9706},2.35618)
    end),
    At(1.955, 1350, function(d,s)
        C.Cast(d,s,A.Helper31,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=83.0243, y=-0.0153, z=116.9604}, pos={x=83.0294, y=0.0, z=116.9706}, rotation=2.35618, target=A.Helper31})
    end),
    At(2.945, 1351, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(2.945, 1352, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(2.945, 1353, function(d,s)
        C.Move(d,s,A.Helper29,{x=76.0, y=-0.0, z=100.0},1.57077)
    end),
    At(3.012, 1354, function(d,s)
        C.Cast(d,s,A.Helper29,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=75.9747, y=-0.0153, z=99.9924}, pos={x=76.0, y=-0.0, z=100.0}, rotation=1.57077, target=A.Helper29})
    end),
    At(5.001, 1355, function(d,s)
        C.Action(d,s,A.Boss,31660,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11072, target=A.Boss})
    end),
    At(9.839, 1356, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(9.839, 1357, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(9.839, 1358, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.1265, y=0.0, z=100.378},-5e-05)
    end),
    At(9.839, 1359, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(9.839, 1360, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(9.839, 1361, function(d,s)
        C.Move(d,s,A.Helper27,{x=100.1867, y=0.0, z=100.5791},-5e-05)
    end),
    At(9.839, 1362, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(9.839, 1363, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(9.839, 1364, function(d,s)
        C.Move(d,s,A.Helper26,{x=99.7197, y=0.0, z=100.3139},-5e-05)
    end),
    At(9.839, 1365, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(9.839, 1366, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(9.839, 1367, function(d,s)
        C.Move(d,s,A.Helper25,{x=100.0442, y=0.0, z=100.0332},-5e-05)
    end),
    At(9.839, 1368, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(9.839, 1369, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(9.863, 1370, function(d,s)
        C.Move(d,s,A.Helper24,{x=99.9616, y=0.0, z=100.0001},-5e-05)
    end),
    At(9.863, 1371, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(9.863, 1372, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(9.863, 1373, function(d,s)
        C.Move(d,s,A.Helper23,{x=99.9989, y=0.0, z=100.1374},-5e-05)
    end),
    At(9.863, 1374, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(9.863, 1375, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(9.863, 1376, function(d,s)
        C.Move(d,s,A.Helper22,{x=100.0794, y=0.0, z=100.1088},-5e-05)
    end),
    At(9.863, 1377, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(9.863, 1378, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(9.863, 1379, function(d,s)
        C.Move(d,s,A.Helper21,{x=100.0072, y=0.0, z=100.2916},-5e-05)
    end),
    At(9.965, 1380, function(d,s)
        C.Cast(d,s,A.Helper21,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=100.267}, pos={x=100.0072, y=0.0, z=100.2916}, rotation=-5e-05, target=A.Helper21})
    end),
    At(9.965, 1381, function(d,s)
        C.Cast(d,s,A.Helper22,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.0534, y=-0.0153, z=100.0839}, pos={x=100.0794, y=0.0, z=100.1088}, rotation=-5e-05, target=A.Helper22})
    end),
    At(9.965, 1382, function(d,s)
        C.Cast(d,s,A.Helper23,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=100.1144}, pos={x=99.9989, y=0.0, z=100.1374}, rotation=-5e-05, target=A.Helper23})
    end),
    At(9.965, 1383, function(d,s)
        C.Cast(d,s,A.Helper24,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9313, y=-0.0153, z=99.9924}, pos={x=99.9616, y=0.0, z=100.0001}, rotation=-5e-05, target=A.Helper24})
    end),
    At(9.965, 1384, function(d,s)
        C.Cast(d,s,A.Helper25,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.0229, y=-0.0153, z=100.0229}, pos={x=100.0442, y=0.0, z=100.0332}, rotation=-5e-05, target=A.Helper25})
    end),
    At(9.965, 1385, function(d,s)
        C.Cast(d,s,A.Helper26,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.7177, y=-0.0153, z=100.2976}, pos={x=99.7197, y=0.0, z=100.3139}, rotation=-5e-05, target=A.Helper26})
    end),
    At(9.965, 1386, function(d,s)
        C.Cast(d,s,A.Helper27,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.1755, y=-0.0153, z=100.5722}, pos={x=100.1867, y=0.0, z=100.5791}, rotation=-5e-05, target=A.Helper27})
    end),
    At(9.965, 1387, function(d,s)
        C.Cast(d,s,A.Helper28,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.1144, y=-0.0153, z=100.3586}, pos={x=100.1265, y=0.0, z=100.378}, rotation=-5e-05, target=A.Helper28})
    end),
    At(10.177, 1388, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.43942)
    end),
    At(10.439, 1389, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.0081)
    end),
    At(10.736, 1390, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.26064)
    end),
    At(11.084, 1391, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.89828)
    end),
    At(11.401, 1392, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.9675)
    end),
    At(11.694, 1393, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.98898)
    end),
    At(11.861, 1394, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(11.861, 1395, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(11.861, 1396, function(d,s)
        C.Move(d,s,A.Helper20,{x=103.4432, y=0.0, z=98.9312},-5e-05)
    end),
    At(11.861, 1397, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(11.861, 1398, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(11.861, 1399, function(d,s)
        C.Move(d,s,A.Helper19,{x=106.6566, y=0.0, z=97.1881},-5e-05)
    end),
    At(11.861, 1400, function(d,s)
        C.Owner(d,s,A.Helper18,nil)
    end),
    At(11.861, 1401, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(11.861, 1402, function(d,s)
        C.Move(d,s,A.Helper18,{x=103.484, y=0.0, z=98.8146},-5e-05)
    end),
    At(11.861, 1403, function(d,s)
        C.Owner(d,s,A.Helper17,nil)
    end),
    At(11.861, 1404, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(11.861, 1405, function(d,s)
        C.Move(d,s,A.Helper17,{x=106.271, y=0.0, z=97.3555},-5e-05)
    end),
    At(11.861, 1406, function(d,s)
        C.Owner(d,s,A.Helper16,nil)
    end),
    At(11.861, 1407, function(d,s)
        C.Owner(d,s,A.Helper16,A.Boss)
    end),
    At(11.861, 1408, function(d,s)
        C.Move(d,s,A.Helper16,{x=105.8404, y=0.0, z=97.7353},-5e-05)
    end),
    At(11.861, 1409, function(d,s)
        C.Owner(d,s,A.Helper15,nil)
    end),
    At(11.861, 1410, function(d,s)
        C.Owner(d,s,A.Helper15,A.Boss)
    end),
    At(11.861, 1411, function(d,s)
        C.Move(d,s,A.Helper15,{x=107.0444, y=0.0, z=96.8692},-5e-05)
    end),
    At(11.861, 1412, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(11.861, 1413, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(11.861, 1414, function(d,s)
        C.Move(d,s,A.Helper14,{x=104.8428, y=0.0, z=97.9719},-5e-05)
    end),
    At(11.861, 1415, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.861, 1416, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.861, 1417, function(d,s)
        C.Move(d,s,A.Helper13,{x=104.7961, y=0.0, z=98.0069},-5e-05)
    end),
    At(11.911, 1418, function(d,s)
        C.Action(d,s,A.Helper30,31661,{pos={x=116.9706, y=-0.0, z=116.9706}, rotation=-2.35628, target=A.Helper30})
    end),
    At(11.966, 1419, function(d,s)
        C.Cast(d,s,A.Helper13,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=104.7837, y=-0.0153, z=97.9782}, pos={x=104.7961, y=0.0, z=98.0069}, rotation=-5e-05, target=A.Helper13})
    end),
    At(11.966, 1420, function(d,s)
        C.Cast(d,s,A.Helper14,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=104.8142, y=-0.0153, z=97.9477}, pos={x=104.8428, y=0.0, z=97.9719}, rotation=-5e-05, target=A.Helper14})
    end),
    At(11.966, 1421, function(d,s)
        C.Cast(d,s,A.Helper15,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=107.042, y=-0.0153, z=96.849}, pos={x=107.0444, y=0.0, z=96.8692}, rotation=-5e-05, target=A.Helper15})
    end),
    At(11.966, 1422, function(d,s)
        C.Cast(d,s,A.Helper16,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.8213, y=-0.0153, z=97.734}, pos={x=105.8404, y=0.0, z=97.7353}, rotation=-5e-05, target=A.Helper16})
    end),
    At(11.966, 1423, function(d,s)
        C.Cast(d,s,A.Helper17,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.2486, y=-0.0153, z=97.3373}, pos={x=106.271, y=0.0, z=97.3555}, rotation=-5e-05, target=A.Helper17})
    end),
    At(11.966, 1424, function(d,s)
        C.Cast(d,s,A.Helper18,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=103.4714, y=-0.0153, z=98.8022}, pos={x=103.484, y=0.0, z=98.8146}, rotation=-5e-05, target=A.Helper18})
    end),
    At(11.966, 1425, function(d,s)
        C.Cast(d,s,A.Helper20,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=103.4409, y=-0.0153, z=98.9242}, pos={x=103.4432, y=0.0, z=98.9312}, rotation=-5e-05, target=A.Helper20})
    end),
    At(11.966, 1426, function(d,s)
        C.Cast(d,s,A.Helper19,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.6453, y=-0.0153, z=97.1847}, pos={x=106.6566, y=0.0, z=97.1881}, rotation=-5e-05, target=A.Helper19})
    end),
    At(12.951, 1427, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(12.951, 1428, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(12.951, 1429, function(d,s)
        C.Move(d,s,A.Helper12,{x=111.3137, y=0.0, z=111.3137},-2.35628)
    end),
    At(12.951, 1430, function(d,s)
        C.Action(d,s,A.Helper21,31663,{pos={x=100.0072, y=0.0, z=100.2916}, rotation=-5e-05, target=A.Helper21})
    end),
    At(12.951, 1431, function(d,s)
        C.Action(d,s,A.Helper22,31663,{pos={x=100.0794, y=0.0, z=100.1088}, rotation=-5e-05, target=A.Helper22})
    end),
    At(12.951, 1432, function(d,s)
        C.Action(d,s,A.Helper23,31663,{pos={x=99.9989, y=0.0, z=100.1374}, rotation=-5e-05, target=A.Helper23})
    end),
    At(12.951, 1433, function(d,s)
        C.Action(d,s,A.Helper24,31663,{pos={x=99.9616, y=0.0, z=100.0001}, rotation=-5e-05, target=A.Helper24})
    end),
    At(12.951, 1434, function(d,s)
        C.Action(d,s,A.Helper25,31663,{pos={x=100.0442, y=0.0, z=100.0332}, rotation=-5e-05, target=A.Helper25})
    end),
    At(12.951, 1435, function(d,s)
        C.Action(d,s,A.Helper26,31663,{pos={x=99.7197, y=0.0, z=100.3139}, rotation=-5e-05, target=A.Helper26})
    end),
    At(12.951, 1436, function(d,s)
        C.Action(d,s,A.Helper27,31663,{pos={x=100.1867, y=0.0, z=100.5791}, rotation=-5e-05, target=A.Helper27})
    end),
    At(12.951, 1437, function(d,s)
        C.Action(d,s,A.Helper28,31663,{pos={x=100.1265, y=0.0, z=100.378}, rotation=-5e-05, target=A.Helper28})
    end),
    At(12.951, 1438, function(d,s)
        C.Action(d,s,A.Helper32,31661,{pos={x=100.0, y=-0.0, z=124.0}, rotation=3.14159, target=A.Helper32})
    end),
    At(13.026, 1439, function(d,s)
        C.Action(d,s,A.Helper12,31662,{pos={x=111.3137, y=0.0, z=111.3137}, rotation=-2.35628, target=A.Helper12})
    end),
    At(13.33, 1440, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.9582)
    end),
    At(13.851, 1441, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(13.851, 1442, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(13.851, 1443, function(d,s)
        C.Move(d,s,A.Helper30,{x=114.5962, y=0.0, z=94.2532},-5e-05)
    end),
    At(13.851, 1444, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(13.851, 1445, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(13.851, 1446, function(d,s)
        C.Move(d,s,A.Helper11,{x=113.7809, y=0.0, z=94.0139},-5e-05)
    end),
    At(13.851, 1447, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(13.851, 1448, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(13.851, 1449, function(d,s)
        C.Move(d,s,A.Helper10,{x=113.0367, y=0.0, z=94.0515},-5e-05)
    end),
    At(13.851, 1450, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(13.851, 1451, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(13.851, 1452, function(d,s)
        C.Move(d,s,A.Helper09,{x=115.2127, y=0.0, z=93.992},-5e-05)
    end),
    At(13.851, 1453, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(13.851, 1454, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(13.851, 1455, function(d,s)
        C.Move(d,s,A.Helper08,{x=114.5287, y=0.0, z=93.751},-5e-05)
    end),
    At(13.851, 1456, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(13.851, 1457, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(13.851, 1458, function(d,s)
        C.Move(d,s,A.Helper07,{x=111.6663, y=0.0, z=95.6508},-5e-05)
    end),
    At(13.851, 1459, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(13.851, 1460, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(13.851, 1461, function(d,s)
        C.Move(d,s,A.Helper06,{x=113.4197, y=0.0, z=94.5103},-5e-05)
    end),
    At(13.851, 1462, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(13.851, 1463, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(13.851, 1464, function(d,s)
        C.Move(d,s,A.Helper05,{x=114.696, y=0.0, z=94.9819},-5e-05)
    end),
    At(13.942, 1465, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(13.942, 1466, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(13.942, 1467, function(d,s)
        C.Move(d,s,A.Helper04,{x=105.6569, y=0.0, z=105.6569},-2.35628)
    end),
    At(13.942, 1468, function(d,s)
        C.Action(d,s,A.Helper31,31661,{pos={x=83.0294, y=0.0, z=116.9706}, rotation=2.35618, target=A.Helper31})
    end),
    At(14.001, 1469, function(d,s)
        C.Cast(d,s,A.Helper05,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=114.6715, y=-0.0153, z=94.9569}, pos={x=114.696, y=0.0, z=94.9819}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.001, 1470, function(d,s)
        C.Cast(d,s,A.Helper06,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.3898, y=-0.0153, z=94.4991}, pos={x=113.4197, y=0.0, z=94.5103}, rotation=-5e-05, target=A.Helper06})
    end),
    At(14.001, 1471, function(d,s)
        C.Cast(d,s,A.Helper07,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=111.6503, y=-0.0153, z=95.6283}, pos={x=111.6663, y=0.0, z=95.6508}, rotation=-5e-05, target=A.Helper07})
    end),
    At(14.001, 1472, function(d,s)
        C.Cast(d,s,A.Helper08,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=114.519, y=-0.0153, z=93.7362}, pos={x=114.5287, y=0.0, z=93.751}, rotation=-5e-05, target=A.Helper08})
    end),
    At(14.001, 1473, function(d,s)
        C.Cast(d,s,A.Helper09,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=115.1904, y=-0.0153, z=93.9803}, pos={x=115.2127, y=0.0, z=93.992}, rotation=-5e-05, target=A.Helper09})
    end),
    At(14.001, 1474, function(d,s)
        C.Cast(d,s,A.Helper10,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.0236, y=-0.0153, z=94.0414}, pos={x=113.0367, y=0.0, z=94.0515}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.001, 1475, function(d,s)
        C.Cast(d,s,A.Helper11,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.756, y=-0.0153, z=94.0108}, pos={x=113.7809, y=0.0, z=94.0139}, rotation=-5e-05, target=A.Helper11})
    end),
    At(14.001, 1476, function(d,s)
        C.Cast(d,s,A.Helper30,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=114.58, y=-0.0153, z=94.2245}, pos={x=114.5962, y=0.0, z=94.2532}, rotation=-5e-05, target=A.Helper30})
    end),
    At(14.001, 1477, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(14.001, 1478, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(14.001, 1479, function(d,s)
        C.Move(d,s,A.Helper03,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(14.001, 1480, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=105.6569, y=0.0, z=105.6569}, rotation=-2.35628, target=A.Helper04})
    end),
    At(14.062, 1481, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper03})
    end),
    At(14.926, 1482, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(14.926, 1483, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(14.926, 1484, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-2.35628)
    end),
    At(14.926, 1485, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(14.926, 1486, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(14.926, 1487, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(14.926, 1488, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(14.926, 1489, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(14.926, 1490, function(d,s)
        C.Move(d,s,A.Helper27,{x=88.6863, y=0.0, z=111.3137},-0.78546)
    end),
    At(14.926, 1491, function(d,s)
        C.Action(d,s,A.Helper13,31663,{pos={x=104.7961, y=0.0, z=98.0069}, rotation=-5e-05, target=A.Helper13})
    end),
    At(14.926, 1492, function(d,s)
        C.Action(d,s,A.Helper14,31663,{pos={x=104.8428, y=0.0, z=97.9719}, rotation=-5e-05, target=A.Helper14})
    end),
    At(14.926, 1493, function(d,s)
        C.Action(d,s,A.Helper15,31663,{pos={x=107.0444, y=0.0, z=96.8692}, rotation=-5e-05, target=A.Helper15})
    end),
    At(14.926, 1494, function(d,s)
        C.Action(d,s,A.Helper16,31663,{pos={x=105.8404, y=0.0, z=97.7353}, rotation=-5e-05, target=A.Helper16})
    end),
    At(14.926, 1495, function(d,s)
        C.Action(d,s,A.Helper17,31663,{pos={x=106.271, y=0.0, z=97.3555}, rotation=-5e-05, target=A.Helper17})
    end),
    At(14.926, 1496, function(d,s)
        C.Action(d,s,A.Helper18,31663,{pos={x=103.484, y=0.0, z=98.8146}, rotation=-5e-05, target=A.Helper18})
    end),
    At(14.926, 1497, function(d,s)
        C.Action(d,s,A.Helper20,31663,{pos={x=103.4432, y=0.0, z=98.9312}, rotation=-5e-05, target=A.Helper20})
    end),
    At(14.926, 1498, function(d,s)
        C.Action(d,s,A.Helper19,31663,{pos={x=106.6566, y=0.0, z=97.1881}, rotation=-5e-05, target=A.Helper19})
    end),
    At(14.926, 1499, function(d,s)
        C.Action(d,s,A.Helper29,31661,{pos={x=76.0, y=-0.0, z=100.0}, rotation=1.57077, target=A.Helper29})
    end),
    At(14.986, 1500, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.82254)
    end),
    At(15.045, 1501, function(d,s)
        C.Action(d,s,A.Helper27,31662,{pos={x=88.6863, y=0.0, z=111.3137}, rotation=-0.78546, target=A.Helper27})
    end),
    At(15.045, 1502, function(d,s)
        C.Action(d,s,A.Helper28,31662,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper28})
    end),
    At(15.045, 1503, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.35628, target=A.Helper32})
    end),
    At(15.302, 1504, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.64393)
    end),
    At(15.621, 1505, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.4562)
    end),
    At(15.905, 1506, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(15.905, 1507, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(15.905, 1508, function(d,s)
        C.Move(d,s,A.Helper31,{x=116.0262, y=0.0, z=101.7596},-5e-05)
    end),
    At(15.905, 1509, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(15.905, 1510, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(15.905, 1511, function(d,s)
        C.Move(d,s,A.Helper26,{x=115.7734, y=0.0, z=102.2222},-5e-05)
    end),
    At(15.905, 1512, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(15.905, 1513, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(15.905, 1514, function(d,s)
        C.Move(d,s,A.Helper25,{x=116.5562, y=0.0, z=101.7977},-5e-05)
    end),
    At(15.905, 1515, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(15.905, 1516, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(15.905, 1517, function(d,s)
        C.Move(d,s,A.Helper24,{x=116.1352, y=0.0, z=101.9265},-5e-05)
    end),
    At(15.905, 1518, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(15.905, 1519, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(15.905, 1520, function(d,s)
        C.Move(d,s,A.Helper23,{x=116.5942, y=0.0, z=102.4226},-5e-05)
    end),
    At(15.905, 1521, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(15.905, 1522, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(15.905, 1523, function(d,s)
        C.Move(d,s,A.Helper22,{x=117.4726, y=0.0, z=100.9941},-5e-05)
    end),
    At(15.905, 1524, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(15.905, 1525, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(15.905, 1526, function(d,s)
        C.Move(d,s,A.Helper21,{x=114.9007, y=0.0, z=101.935},-5e-05)
    end),
    At(15.905, 1527, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(15.905, 1528, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(15.905, 1529, function(d,s)
        C.Move(d,s,A.Helper12,{x=116.9509, y=0.0, z=102.3475},-5e-05)
    end),
    At(15.985, 1530, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.42581)
    end),
    At(15.985, 1531, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(15.985, 1532, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(15.985, 1533, function(d,s)
        C.Move(d,s,A.Helper04,{x=94.3431, y=0.0, z=94.3431},-2.35628)
    end),
    At(15.985, 1534, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(15.985, 1535, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(15.985, 1536, function(d,s)
        C.Move(d,s,A.Helper03,{x=94.3431, y=0.0, z=105.6569},-0.78546)
    end),
    At(15.985, 1537, function(d,s)
        C.Cast(d,s,A.Helper12,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=116.9299, y=-0.0153, z=102.3423}, pos={x=116.9509, y=0.0, z=102.3475}, rotation=-5e-05, target=A.Helper12})
    end),
    At(15.985, 1538, function(d,s)
        C.Cast(d,s,A.Helper21,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=114.8852, y=-0.0153, z=101.915}, pos={x=114.9007, y=0.0, z=101.935}, rotation=-5e-05, target=A.Helper21})
    end),
    At(15.985, 1539, function(d,s)
        C.Cast(d,s,A.Helper22,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=117.4487, y=-0.0153, z=100.9689}, pos={x=117.4726, y=0.0, z=100.9941}, rotation=-5e-05, target=A.Helper22})
    end),
    At(15.985, 1540, function(d,s)
        C.Cast(d,s,A.Helper23,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=116.5942, y=-0.0153, z=102.4033}, pos={x=116.5942, y=0.0, z=102.4226}, rotation=-5e-05, target=A.Helper23})
    end),
    At(15.985, 1541, function(d,s)
        C.Cast(d,s,A.Helper24,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=116.1059, y=-0.0153, z=101.915}, pos={x=116.1352, y=0.0, z=101.9265}, rotation=-5e-05, target=A.Helper24})
    end),
    At(15.985, 1542, function(d,s)
        C.Cast(d,s,A.Helper25,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=116.5332, y=-0.0153, z=101.7929}, pos={x=116.5562, y=0.0, z=101.7977}, rotation=-5e-05, target=A.Helper25})
    end),
    At(15.985, 1543, function(d,s)
        C.Cast(d,s,A.Helper26,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=115.7702, y=-0.0153, z=102.2202}, pos={x=115.7734, y=0.0, z=102.2222}, rotation=-5e-05, target=A.Helper26})
    end),
    At(15.985, 1544, function(d,s)
        C.Cast(d,s,A.Helper31,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=116.0143, y=-0.0153, z=101.7319}, pos={x=116.0262, y=0.0, z=101.7596}, rotation=-5e-05, target=A.Helper31})
    end),
    At(15.985, 1545, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(15.985, 1546, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(15.985, 1547, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(15.985, 1548, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(15.985, 1549, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(15.985, 1550, function(d,s)
        C.Move(d,s,A.Helper01,{x=84.0, y=0.0, z=100.0},-1.57087)
    end),
    At(16.041, 1551, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=94.3431, y=0.0, z=105.6569}, rotation=-0.78546, target=A.Helper03})
    end),
    At(16.041, 1552, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=94.3431, y=0.0, z=94.3431}, rotation=-2.35628, target=A.Helper04})
    end),
    At(16.095, 1553, function(d,s)
        C.Action(d,s,A.Helper01,31662,{pos={x=84.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper01})
    end),
    At(16.095, 1554, function(d,s)
        C.Action(d,s,A.Helper02,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper02})
    end),
    At(16.905, 1555, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.30673)
    end),
    At(16.949, 1556, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(16.949, 1557, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(16.949, 1558, function(d,s)
        C.Move(d,s,A.Helper32,{x=88.6863, y=0.0, z=88.6863},-2.35628)
    end),
    At(16.949, 1559, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(16.949, 1560, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(16.949, 1561, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(16.949, 1562, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(16.949, 1563, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(16.949, 1564, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},-0.78546)
    end),
    At(16.949, 1565, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(16.949, 1566, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(16.949, 1567, function(d,s)
        C.Move(d,s,A.Helper27,{x=92.0, y=0.0, z=100.0},-1.57087)
    end),
    At(16.949, 1568, function(d,s)
        C.Action(d,s,A.Helper05,31663,{pos={x=114.696, y=0.0, z=94.9819}, rotation=-5e-05, target=A.Helper05})
    end),
    At(16.949, 1569, function(d,s)
        C.Action(d,s,A.Helper06,31663,{pos={x=113.4197, y=0.0, z=94.5103}, rotation=-5e-05, target=A.Helper06})
    end),
    At(16.949, 1570, function(d,s)
        C.Action(d,s,A.Helper07,31663,{pos={x=111.6663, y=0.0, z=95.6508}, rotation=-5e-05, target=A.Helper07})
    end),
    At(16.949, 1571, function(d,s)
        C.Action(d,s,A.Helper08,31663,{pos={x=114.5287, y=0.0, z=93.751}, rotation=-5e-05, target=A.Helper08})
    end),
    At(16.949, 1572, function(d,s)
        C.Action(d,s,A.Helper09,31663,{pos={x=115.2127, y=0.0, z=93.992}, rotation=-5e-05, target=A.Helper09})
    end),
    At(16.949, 1573, function(d,s)
        C.Action(d,s,A.Helper10,31663,{pos={x=113.0367, y=0.0, z=94.0515}, rotation=-5e-05, target=A.Helper10})
    end),
    At(16.949, 1574, function(d,s)
        C.Action(d,s,A.Helper11,31663,{pos={x=113.7809, y=0.0, z=94.0139}, rotation=-5e-05, target=A.Helper11})
    end),
    At(16.949, 1575, function(d,s)
        C.Action(d,s,A.Helper30,31663,{pos={x=114.5962, y=0.0, z=94.2532}, rotation=-5e-05, target=A.Helper30})
    end),
    At(17.026, 1576, function(d,s)
        C.Action(d,s,A.Helper27,31662,{pos={x=92.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper27})
    end),
    At(17.026, 1577, function(d,s)
        C.Action(d,s,A.Helper28,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78546, target=A.Helper28})
    end),
    At(17.026, 1578, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=88.6863, y=0.0, z=88.6863}, rotation=-2.35628, target=A.Helper32})
    end),
    At(17.026, 1579, function(d,s)
        C.Action(d,s,A.Helper29,31662,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(17.208, 1580, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.14183)
    end),
    At(17.521, 1581, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.95707)
    end),
    At(17.881, 1582, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(17.881, 1583, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(17.881, 1584, function(d,s)
        C.Move(d,s,A.Helper20,{x=113.2568, y=0.0, z=108.4712},-5e-05)
    end),
    At(17.881, 1585, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(17.881, 1586, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(17.881, 1587, function(d,s)
        C.Move(d,s,A.Helper19,{x=113.3397, y=0.0, z=109.3958},-5e-05)
    end),
    At(17.881, 1588, function(d,s)
        C.Owner(d,s,A.Helper18,nil)
    end),
    At(17.881, 1589, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(17.881, 1590, function(d,s)
        C.Move(d,s,A.Helper18,{x=113.5523, y=0.0, z=109.6075},-5e-05)
    end),
    At(17.881, 1591, function(d,s)
        C.Owner(d,s,A.Helper17,nil)
    end),
    At(17.881, 1592, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(17.881, 1593, function(d,s)
        C.Move(d,s,A.Helper17,{x=113.6945, y=0.0, z=105.225},-5e-05)
    end),
    At(17.881, 1594, function(d,s)
        C.Owner(d,s,A.Helper16,nil)
    end),
    At(17.881, 1595, function(d,s)
        C.Owner(d,s,A.Helper16,A.Boss)
    end),
    At(17.881, 1596, function(d,s)
        C.Move(d,s,A.Helper16,{x=113.8531, y=0.0, z=108.9005},-5e-05)
    end),
    At(17.881, 1597, function(d,s)
        C.Owner(d,s,A.Helper15,nil)
    end),
    At(17.881, 1598, function(d,s)
        C.Owner(d,s,A.Helper15,A.Boss)
    end),
    At(17.881, 1599, function(d,s)
        C.Move(d,s,A.Helper15,{x=112.2392, y=0.0, z=109.1781},-5e-05)
    end),
    At(17.881, 1600, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(17.881, 1601, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(17.881, 1602, function(d,s)
        C.Move(d,s,A.Helper14,{x=113.2757, y=0.0, z=108.9076},-5e-05)
    end),
    At(17.881, 1603, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(17.881, 1604, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(17.881, 1605, function(d,s)
        C.Move(d,s,A.Helper13,{x=113.1797, y=0.0, z=109.8844},-5e-05)
    end),
    At(17.952, 1606, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(17.952, 1607, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(17.952, 1608, function(d,s)
        C.Move(d,s,A.Helper04,{x=83.0294, y=0.0, z=83.0294},-2.35628)
    end),
    At(17.952, 1609, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(17.952, 1610, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(17.952, 1611, function(d,s)
        C.Move(d,s,A.Helper03,{x=105.6569, y=0.0, z=94.3431},-0.78546)
    end),
    At(18.019, 1612, function(d,s)
        C.Cast(d,s,A.Helper13,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.1762, y=-0.0153, z=109.8802}, pos={x=113.1797, y=0.0, z=109.8844}, rotation=-5e-05, target=A.Helper13})
    end),
    At(18.019, 1613, function(d,s)
        C.Cast(d,s,A.Helper14,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.2677, y=-0.0153, z=108.9036}, pos={x=113.2757, y=0.0, z=108.9076}, rotation=-5e-05, target=A.Helper14})
    end),
    At(18.019, 1614, function(d,s)
        C.Cast(d,s,A.Helper15,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=112.2301, y=-0.0153, z=109.1478}, pos={x=112.2392, y=0.0, z=109.1781}, rotation=-5e-05, target=A.Helper15})
    end),
    At(18.019, 1615, function(d,s)
        C.Cast(d,s,A.Helper16,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.8476, y=-0.0153, z=108.8731}, pos={x=113.8531, y=0.0, z=108.9005}, rotation=-5e-05, target=A.Helper16})
    end),
    At(18.019, 1616, function(d,s)
        C.Cast(d,s,A.Helper17,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.6645, y=-0.0153, z=105.211}, pos={x=113.6945, y=0.0, z=105.225}, rotation=-5e-05, target=A.Helper17})
    end),
    At(18.019, 1617, function(d,s)
        C.Cast(d,s,A.Helper18,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.5424, y=-0.0153, z=109.6056}, pos={x=113.5523, y=0.0, z=109.6075}, rotation=-5e-05, target=A.Helper18})
    end),
    At(18.019, 1618, function(d,s)
        C.Cast(d,s,A.Helper20,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.2372, y=-0.0153, z=108.4459}, pos={x=113.2568, y=0.0, z=108.4712}, rotation=-5e-05, target=A.Helper20})
    end),
    At(18.019, 1619, function(d,s)
        C.Cast(d,s,A.Helper19,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=113.3288, y=-0.0153, z=109.3919}, pos={x=113.3397, y=0.0, z=109.3958}, rotation=-5e-05, target=A.Helper19})
    end),
    At(18.019, 1620, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(18.019, 1621, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(18.019, 1622, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(18.019, 1623, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(18.019, 1624, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(18.019, 1625, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},-1.57087)
    end),
    At(18.019, 1626, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=105.6569, y=0.0, z=94.3431}, rotation=-0.78546, target=A.Helper03})
    end),
    At(18.019, 1627, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=83.0294, y=0.0, z=83.0294}, rotation=-2.35628, target=A.Helper04})
    end),
}
