-- 宇宙龙炎 [31654]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1628, function(d,s)
        C.Action(d,s,A.Helper01,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper01})
    end),
    At(0.0, 1629, function(d,s)
        C.Action(d,s,A.Helper02,31662,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper02})
    end),
    At(0.0, 1630, function(d,s)
        C.Cast(d,s,A.Boss,31654,5.3,{spell=31654, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.95707, target=A.Boss})
    end),
    At(0.888, 1631, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(0.888, 1632, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(0.888, 1633, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=76.0},-5e-05)
    end),
    At(0.888, 1634, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(0.888, 1635, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(0.888, 1636, function(d,s)
        C.Move(d,s,A.Helper30,{x=111.3137, y=0.0, z=88.6863},-0.78546)
    end),
    At(0.888, 1637, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(0.888, 1638, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(0.888, 1639, function(d,s)
        C.Move(d,s,A.Helper29,{x=108.0, y=0.0, z=100.0},-1.57087)
    end),
    At(0.888, 1640, function(d,s)
        C.Action(d,s,A.Helper12,31663,{pos={x=116.9509, y=0.0, z=102.3475}, rotation=-5e-05, target=A.Helper12})
    end),
    At(0.888, 1641, function(d,s)
        C.Action(d,s,A.Helper21,31663,{pos={x=114.9007, y=0.0, z=101.935}, rotation=-5e-05, target=A.Helper21})
    end),
    At(0.888, 1642, function(d,s)
        C.Action(d,s,A.Helper22,31663,{pos={x=117.4726, y=0.0, z=100.9941}, rotation=-5e-05, target=A.Helper22})
    end),
    At(0.888, 1643, function(d,s)
        C.Action(d,s,A.Helper23,31663,{pos={x=116.5942, y=0.0, z=102.4226}, rotation=-5e-05, target=A.Helper23})
    end),
    At(0.888, 1644, function(d,s)
        C.Action(d,s,A.Helper24,31663,{pos={x=116.1352, y=0.0, z=101.9265}, rotation=-5e-05, target=A.Helper24})
    end),
    At(0.888, 1645, function(d,s)
        C.Action(d,s,A.Helper25,31663,{pos={x=116.5562, y=0.0, z=101.7977}, rotation=-5e-05, target=A.Helper25})
    end),
    At(0.888, 1646, function(d,s)
        C.Action(d,s,A.Helper26,31663,{pos={x=115.7734, y=0.0, z=102.2222}, rotation=-5e-05, target=A.Helper26})
    end),
    At(0.888, 1647, function(d,s)
        C.Action(d,s,A.Helper31,31663,{pos={x=116.0262, y=0.0, z=101.7596}, rotation=-5e-05, target=A.Helper31})
    end),
    At(0.947, 1648, function(d,s)
        C.Action(d,s,A.Helper30,31662,{pos={x=111.3137, y=0.0, z=88.6863}, rotation=-0.78546, target=A.Helper30})
    end),
    At(0.947, 1649, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=100.0, y=0.0, z=76.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(1.0, 1650, function(d,s)
        C.Action(d,s,A.Helper29,31662,{pos={x=108.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper29})
    end),
    At(1.806, 1651, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(1.806, 1652, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(1.806, 1653, function(d,s)
        C.Move(d,s,A.Helper28,{x=106.347, y=0.0, z=115.339},-5e-05)
    end),
    At(1.806, 1654, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(1.806, 1655, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(1.806, 1656, function(d,s)
        C.Move(d,s,A.Helper27,{x=108.3668, y=0.0, z=113.1092},-5e-05)
    end),
    At(1.806, 1657, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(1.806, 1658, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(1.806, 1659, function(d,s)
        C.Move(d,s,A.Helper11,{x=106.1413, y=0.0, z=115.0872},-5e-05)
    end),
    At(1.806, 1660, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(1.806, 1661, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(1.806, 1662, function(d,s)
        C.Move(d,s,A.Helper10,{x=106.3612, y=0.0, z=114.467},-5e-05)
    end),
    At(1.806, 1663, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(1.806, 1664, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(1.806, 1665, function(d,s)
        C.Move(d,s,A.Helper09,{x=104.4169, y=0.0, z=113.6697},-5e-05)
    end),
    At(1.806, 1666, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(1.806, 1667, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(1.806, 1668, function(d,s)
        C.Move(d,s,A.Helper08,{x=107.099, y=0.0, z=114.8517},-5e-05)
    end),
    At(1.806, 1669, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(1.806, 1670, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(1.806, 1671, function(d,s)
        C.Move(d,s,A.Helper07,{x=106.3714, y=0.0, z=114.2829},-5e-05)
    end),
    At(1.806, 1672, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(1.806, 1673, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(1.806, 1674, function(d,s)
        C.Move(d,s,A.Helper06,{x=106.2858, y=0.0, z=114.9857},-5e-05)
    end),
    At(1.881, 1675, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(1.881, 1676, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(1.881, 1677, function(d,s)
        C.Move(d,s,A.Helper05,{x=116.9706, y=-0.0, z=83.0294},-0.78546)
    end),
    At(1.948, 1678, function(d,s)
        C.Cast(d,s,A.Helper06,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.2791, y=-0.0153, z=114.9767}, pos={x=106.2858, y=0.0, z=114.9857}, rotation=-5e-05, target=A.Helper06})
    end),
    At(1.948, 1679, function(d,s)
        C.Cast(d,s,A.Helper07,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.3706, y=-0.0153, z=114.2748}, pos={x=106.3714, y=0.0, z=114.2829}, rotation=-5e-05, target=A.Helper07})
    end),
    At(1.948, 1680, function(d,s)
        C.Cast(d,s,A.Helper08,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=107.0726, y=-0.0153, z=114.8241}, pos={x=107.099, y=0.0, z=114.8517}, rotation=-5e-05, target=A.Helper08})
    end),
    At(1.948, 1681, function(d,s)
        C.Cast(d,s,A.Helper09,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=104.387, y=-0.0153, z=113.6645}, pos={x=104.4169, y=0.0, z=113.6697}, rotation=-5e-05, target=A.Helper09})
    end),
    At(1.948, 1682, function(d,s)
        C.Cast(d,s,A.Helper10,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.3401, y=-0.0153, z=114.4579}, pos={x=106.3612, y=0.0, z=114.467}, rotation=-5e-05, target=A.Helper10})
    end),
    At(1.948, 1683, function(d,s)
        C.Cast(d,s,A.Helper11,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.1265, y=-0.0153, z=115.0683}, pos={x=106.1413, y=0.0, z=115.0872}, rotation=-5e-05, target=A.Helper11})
    end),
    At(1.948, 1684, function(d,s)
        C.Cast(d,s,A.Helper27,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=108.3543, y=-0.0153, z=113.0846}, pos={x=108.3668, y=0.0, z=113.1092}, rotation=-5e-05, target=A.Helper27})
    end),
    At(1.948, 1685, function(d,s)
        C.Cast(d,s,A.Helper28,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.3401, y=-0.0153, z=115.3124}, pos={x=106.347, y=0.0, z=115.339}, rotation=-5e-05, target=A.Helper28})
    end),
    At(1.948, 1686, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(1.948, 1687, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(1.948, 1688, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.0, y=0.0, z=100.0},-1.57087)
    end),
    At(1.948, 1689, function(d,s)
        C.Action(d,s,A.Helper05,31662,{pos={x=116.9706, y=-0.0, z=83.0294}, rotation=-0.78546, target=A.Helper05})
    end),
    At(1.999, 1690, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=116.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper04})
    end),
    At(2.863, 1691, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(2.863, 1692, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(2.863, 1693, function(d,s)
        C.Move(d,s,A.Helper32,{x=124.0, y=-0.0, z=100.0},-1.57087)
    end),
    At(2.863, 1694, function(d,s)
        C.Action(d,s,A.Helper13,31663,{pos={x=113.1797, y=0.0, z=109.8844}, rotation=-5e-05, target=A.Helper13})
    end),
    At(2.863, 1695, function(d,s)
        C.Action(d,s,A.Helper14,31663,{pos={x=113.2757, y=0.0, z=108.9076}, rotation=-5e-05, target=A.Helper14})
    end),
    At(2.863, 1696, function(d,s)
        C.Action(d,s,A.Helper15,31663,{pos={x=112.2392, y=0.0, z=109.1781}, rotation=-5e-05, target=A.Helper15})
    end),
    At(2.863, 1697, function(d,s)
        C.Action(d,s,A.Helper16,31663,{pos={x=113.8531, y=0.0, z=108.9005}, rotation=-5e-05, target=A.Helper16})
    end),
    At(2.863, 1698, function(d,s)
        C.Action(d,s,A.Helper17,31663,{pos={x=113.6945, y=0.0, z=105.225}, rotation=-5e-05, target=A.Helper17})
    end),
    At(2.863, 1699, function(d,s)
        C.Action(d,s,A.Helper18,31663,{pos={x=113.5523, y=0.0, z=109.6075}, rotation=-5e-05, target=A.Helper18})
    end),
    At(2.863, 1700, function(d,s)
        C.Action(d,s,A.Helper20,31663,{pos={x=113.2568, y=0.0, z=108.4712}, rotation=-5e-05, target=A.Helper20})
    end),
    At(2.863, 1701, function(d,s)
        C.Action(d,s,A.Helper19,31663,{pos={x=113.3397, y=0.0, z=109.3958}, rotation=-5e-05, target=A.Helper19})
    end),
    At(2.94, 1702, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=124.0, y=-0.0, z=100.0}, rotation=-1.57087, target=A.Helper32})
    end),
    At(4.879, 1703, function(d,s)
        C.Action(d,s,A.Helper06,31663,{pos={x=106.2858, y=0.0, z=114.9857}, rotation=-5e-05, target=A.Helper06})
    end),
    At(4.879, 1704, function(d,s)
        C.Action(d,s,A.Helper07,31663,{pos={x=106.3714, y=0.0, z=114.2829}, rotation=-5e-05, target=A.Helper07})
    end),
    At(4.879, 1705, function(d,s)
        C.Action(d,s,A.Helper08,31663,{pos={x=107.099, y=0.0, z=114.8517}, rotation=-5e-05, target=A.Helper08})
    end),
    At(4.879, 1706, function(d,s)
        C.Action(d,s,A.Helper09,31663,{pos={x=104.4169, y=0.0, z=113.6697}, rotation=-5e-05, target=A.Helper09})
    end),
    At(4.879, 1707, function(d,s)
        C.Action(d,s,A.Helper10,31663,{pos={x=106.3612, y=0.0, z=114.467}, rotation=-5e-05, target=A.Helper10})
    end),
    At(4.879, 1708, function(d,s)
        C.Action(d,s,A.Helper11,31663,{pos={x=106.1413, y=0.0, z=115.0872}, rotation=-5e-05, target=A.Helper11})
    end),
    At(4.879, 1709, function(d,s)
        C.Action(d,s,A.Helper28,31663,{pos={x=106.347, y=0.0, z=115.339}, rotation=-5e-05, target=A.Helper28})
    end),
    At(4.879, 1710, function(d,s)
        C.Action(d,s,A.Helper27,31663,{pos={x=108.3668, y=0.0, z=113.1092}, rotation=-5e-05, target=A.Helper27})
    end),
    At(5.623, 1711, function(d,s)
        C.Action(d,s,A.Boss,31654,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.95707, target=A.Boss})
    end),
    At(7.972, 1712, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(7.972, 1713, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(7.972, 1714, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.95707)
    end),
    At(7.972, 1715, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(7.972, 1716, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(7.972, 1717, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.95707)
    end),
    At(7.972, 1718, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(7.972, 1719, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(7.972, 1720, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},0.95707)
    end),
    At(8.056, 1721, function(d,s)
        C.Action(d,s,A.Helper30,31656,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(8.056, 1722, function(d,s)
        C.Action(d,s,A.Helper31,31655,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(8.056, 1723, function(d,s)
        C.Action(d,s,A.Helper32,31655,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(14.688, 1724, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.50999)
    end),
    At(14.758, 1725, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.50999, target=A.Boss})
    end),
    At(15.51, 1726, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(15.51, 1727, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(15.51, 1728, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(15.51, 1729, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(15.594, 1730, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(15.594, 1731, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(15.878, 1732, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.61591)
    end),
    At(16.216, 1733, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.98445)
    end),
    At(17.918, 1734, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.98445, target=A.Boss})
    end),
    At(18.681, 1735, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(18.681, 1736, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(18.681, 1737, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(18.681, 1738, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(18.742, 1739, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(18.742, 1740, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.95707})
    end),
    At(20.542, 1741, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.05473)
    end),
    At(21.062, 1742, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.08637)
    end),
    At(21.366, 1743, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.07306)
    end),
    At(21.723, 1744, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.65957)
    end),
    At(22.2, 1745, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.14159)
    end),
}
