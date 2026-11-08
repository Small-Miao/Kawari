-- 株连 [18580]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1289, function(d,s)
        C.Cast(d,s,A.Boss,18580,4.7,{spell=18580, omen_delay=0, cast_pos={x=107.9271, y=-0.0153, z=100.3586}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.5237})
    end),
    At(0.134, 1290, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.5237)
    end),
    At(1.848, 1291, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(1.848, 1292, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(1.848, 1293, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(1.848, 1294, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(1.848, 1295, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(1.848, 1296, function(d,s)
        C.Move(d,s,A.Helper11,{x=84.0, y=0.0, z=92.0},-5e-05)
    end),
    At(1.848, 1297, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(1.848, 1298, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(1.848, 1299, function(d,s)
        C.Move(d,s,A.Helper10,{x=92.0, y=0.0, z=92.0},-5e-05)
    end),
    At(1.848, 1300, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(1.848, 1301, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(1.848, 1302, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=100.0},-5e-05)
    end),
    At(1.848, 1303, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(1.848, 1304, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(1.848, 1305, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=108.0},-5e-05)
    end),
    At(1.848, 1306, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(1.848, 1307, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(1.848, 1308, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(1.848, 1309, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(1.848, 1310, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(1.848, 1311, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=116.0},-5e-05)
    end),
    At(1.848, 1312, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(1.848, 1313, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(1.848, 1314, function(d,s)
        C.Move(d,s,A.Helper05,{x=108.0, y=0.0, z=116.0},-5e-05)
    end),
    At(1.947, 1315, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(1.947, 1316, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(1.947, 1317, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(1.947, 1318, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(1.947, 1319, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(1.947, 1320, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(1.947, 1321, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(1.947, 1322, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(3.825, 1323, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(3.825, 1324, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(3.825, 1325, function(d,s)
        C.Move(d,s,A.Helper12,{x=84.0, y=0.0, z=84.0},-5e-05)
    end),
    At(3.825, 1326, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(3.825, 1327, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(3.825, 1328, function(d,s)
        C.Move(d,s,A.Helper11,{x=116.0, y=0.0, z=84.0},-5e-05)
    end),
    At(3.825, 1329, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(3.825, 1330, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(3.825, 1331, function(d,s)
        C.Move(d,s,A.Helper10,{x=108.0, y=0.0, z=92.0},-5e-05)
    end),
    At(3.825, 1332, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(3.825, 1333, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(3.825, 1334, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.825, 1335, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(3.825, 1336, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(3.825, 1337, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.825, 1338, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(3.825, 1339, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(3.825, 1340, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.825, 1341, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(3.825, 1342, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(3.825, 1343, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=108.0},-5e-05)
    end),
    At(3.825, 1344, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(3.825, 1345, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(3.825, 1346, function(d,s)
        C.Move(d,s,A.Helper05,{x=84.0, y=0.0, z=116.0},-5e-05)
    end),
    At(3.825, 1347, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(3.825, 1348, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(3.825, 1349, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.0, y=0.0, z=116.0},-5e-05)
    end),
    At(3.881, 1350, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(3.881, 1351, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(3.881, 1352, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(3.881, 1353, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(3.881, 1354, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(3.881, 1355, function(d,s)
        C.Action(d,s,A.Helper04,18576,{pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(3.881, 1356, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(3.881, 1357, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(3.881, 1358, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(4.948, 1359, function(d,s)
        C.Action(d,s,A.Boss,18580,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.5237})
    end),
    At(8.252, 1360, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.56178)
    end),
    At(8.462, 1361, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.50291)
    end),
    At(8.773, 1362, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.53062)
    end),
    At(9.122, 1363, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.69975)
    end),
    At(9.415, 1364, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.38353)
    end),
    At(9.967, 1365, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.70632)
    end),
    At(10.131, 1366, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.03738)
    end),
    At(10.434, 1367, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.13201)
    end),
    At(10.756, 1368, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.05348)
    end),
    At(11.064, 1369, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12807)
    end),
    At(12.198, 1370, function(d,s)
        C.Action(d,s,A.Boss,18581,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.12807, dest={x=99.9924, y=-0.0153, z=99.9924}})
    end),
    At(12.85, 1371, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12807)
    end),
    At(14.698, 1372, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.44412)
    end),
}
