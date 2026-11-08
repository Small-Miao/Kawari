-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1511, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(0.0, 1512, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.39889)
    end),
    At(0.0, 1513, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(0.0, 1514, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(0.0, 1515, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.18854)
    end),
    At(0.074, 1516, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(0.074, 1517, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.074, 1518, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.53359)
    end),
    At(0.074, 1519, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.13, 1520, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.33187)
    end),
    At(0.13, 1521, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.209, 1522, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.32909)
    end),
    At(0.209, 1523, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.209, 1524, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.209, 1525, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.281, 1526, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.281, 1527, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.342, 1528, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.342, 1529, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.17128)
    end),
    At(0.342, 1530, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.342, 1531, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.13514)
    end),
    At(0.423, 1532, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.423, 1533, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.13514)
    end),
    At(0.479, 1534, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.479, 1535, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.13514)
    end),
    At(0.479, 1536, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.3195)
    end),
    At(0.479, 1537, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.69246)
    end),
    At(0.479, 1538, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.13514)
    end),
    At(0.479, 1539, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.78929)
    end),
    At(0.517, 1540, function(d,s)
        C.Action(d,s,A.Helper11,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.69246, target=A.Helper11})
    end),
    At(0.517, 1541, function(d,s)
        C.Action(d,s,A.Helper12,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.78929, target=A.Helper12})
    end),
    At(2.429, 1542, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(2.429, 1543, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(2.429, 1544, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(2.429, 1545, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.429, 1546, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(2.429, 1547, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(2.429, 1548, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.71269)
    end),
    At(2.524, 1549, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.71269)
    end),
    At(2.524, 1550, function(d,s)
        C.Cast(d,s,A.Helper13,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-0.71269, target=A.Helper13})
    end),
    At(2.524, 1551, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.524, 1552, function(d,s)
        C.Cast(d,s,A.Helper14,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.79591, target=A.Helper14})
    end),
    At(2.561, 1553, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.71269)
    end),
    At(2.561, 1554, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.599, 1555, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.71461)
    end),
    At(2.599, 1556, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.663, 1557, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.724)
    end),
    At(2.663, 1558, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.702, 1559, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.73234)
    end),
    At(2.702, 1560, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.747, 1561, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(2.747, 1562, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.821, 1563, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(2.821, 1564, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.893, 1565, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(2.893, 1566, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.893, 1567, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(2.893, 1568, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(2.964, 1569, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(2.964, 1570, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(3.022, 1571, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.022, 1572, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(3.022, 1573, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.022, 1574, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(3.022, 1575, function(d,s)
        C.Action(d,s,A.Helper13,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.71269, target=A.Helper13})
    end),
    At(3.022, 1576, function(d,s)
        C.Action(d,s,A.Helper14,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.79591, target=A.Helper14})
    end),
    At(3.062, 1577, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.062, 1578, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79543)
    end),
    At(3.13, 1579, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.13, 1580, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79543)
    end),
    At(3.19, 1581, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.19, 1582, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79543)
    end),
    At(3.19, 1583, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.19, 1584, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79447)
    end),
    At(3.257, 1585, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.257, 1586, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.7658)
    end),
    At(3.331, 1587, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.331, 1588, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.7658)
    end),
    At(3.331, 1589, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.331, 1590, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.7658)
    end),
    At(3.412, 1591, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.412, 1592, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.7658)
    end),
    At(3.449, 1593, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(3.449, 1594, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.493, 1595, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.73158)
    end),
    At(3.493, 1596, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.531, 1597, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.72352)
    end),
    At(3.531, 1598, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.571, 1599, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.68642)
    end),
    At(3.571, 1600, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.612, 1601, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.66964)
    end),
    At(3.612, 1602, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.65, 1603, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.61097)
    end),
    At(3.65, 1604, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.669, 1605, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.56725)
    end),
    At(3.669, 1606, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.712, 1607, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.50435)
    end),
    At(3.712, 1608, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.76523)
    end),
    At(3.779, 1609, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.48278)
    end),
    At(3.779, 1610, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(3.824, 1611, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.41375)
    end),
    At(3.824, 1612, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(3.87, 1613, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.39237)
    end),
    At(3.87, 1614, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(3.91, 1615, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.34338)
    end),
    At(3.91, 1616, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(3.95, 1617, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.28509)
    end),
    At(3.95, 1618, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(3.992, 1619, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.26706)
    end),
    At(3.992, 1620, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(4.046, 1621, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.19199)
    end),
    At(4.046, 1622, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(4.091, 1623, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.17512)
    end),
    At(4.091, 1624, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.52765)
    end),
    At(4.129, 1625, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.1196)
    end),
    At(4.129, 1626, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.168, 1627, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.10378)
    end),
    At(4.168, 1628, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.211, 1629, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.03475)
    end),
    At(4.211, 1630, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.271, 1631, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.01548)
    end),
    At(4.271, 1632, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.308, 1633, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.02651)
    end),
    At(4.308, 1634, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.389, 1635, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.0336)
    end),
    At(4.389, 1636, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.426, 1637, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.04741)
    end),
    At(4.426, 1638, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.26284)
    end),
    At(4.444, 1639, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.07176)
    end),
    At(4.444, 1640, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.06227)
    end),
    At(4.488, 1641, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.09381)
    end),
    At(4.488, 1642, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.06227)
    end),
    At(4.526, 1643, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.10273)
    end),
    At(4.526, 1644, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.06227)
    end),
}
