-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1645, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(0.0, 1646, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.13236)
    end),
    At(0.0, 1647, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.06227)
    end),
    At(0.042, 1648, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.13945)
    end),
    At(0.042, 1649, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.05633)
    end),
    At(0.08, 1650, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.16141)
    end),
    At(0.08, 1651, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.139, 1652, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.139, 1653, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.195, 1654, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.195, 1655, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.273, 1656, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.273, 1657, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.273, 1658, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.273, 1659, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.348, 1660, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.348, 1661, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.41, 1662, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.41, 1663, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.41, 1664, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.41, 1665, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.475, 1666, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.475, 1667, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.554, 1668, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.17243)
    end),
    At(0.554, 1669, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.74385)
    end),
    At(0.554, 1670, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01932)
    end),
    At(0.554, 1671, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.79591)
    end),
    At(0.554, 1672, function(d,s)
        C.Action(d,s,A.Helper13,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.74385, target=A.Helper13})
    end),
    At(0.554, 1673, function(d,s)
        C.Action(d,s,A.Helper14,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.79591, target=A.Helper14})
    end),
    At(2.476, 1674, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(2.476, 1675, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(2.476, 1676, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(2.476, 1677, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.476, 1678, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(2.476, 1679, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(2.476, 1680, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.553, 1681, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.553, 1682, function(d,s)
        C.Cast(d,s,A.Helper11,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-0.64471, target=A.Helper11})
    end),
    At(2.553, 1683, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.553, 1684, function(d,s)
        C.Cast(d,s,A.Helper12,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.82141, target=A.Helper12})
    end),
    At(2.626, 1685, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.626, 1686, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.68, 1687, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.68, 1688, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.697, 1689, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.697, 1690, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.717, 1691, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.717, 1692, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.784, 1693, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.784, 1694, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.863, 1695, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.863, 1696, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.863, 1697, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.863, 1698, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(2.938, 1699, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(2.938, 1700, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.01, 1701, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(3.01, 1702, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.01, 1703, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(3.01, 1704, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.076, 1705, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(3.076, 1706, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.076, 1707, function(d,s)
        C.Action(d,s,A.Helper11,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.64471, target=A.Helper11})
    end),
    At(3.076, 1708, function(d,s)
        C.Action(d,s,A.Helper12,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.82141, target=A.Helper12})
    end),
    At(3.141, 1709, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.141, 1710, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.141, 1711, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.141, 1712, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.215, 1713, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.215, 1714, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.287, 1715, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.287, 1716, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.287, 1717, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.287, 1718, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.343, 1719, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.343, 1720, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.417, 1721, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.417, 1722, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.417, 1723, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.417, 1724, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.472, 1725, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.472, 1726, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.552, 1727, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.552, 1728, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.552, 1729, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.552, 1730, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.588, 1731, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.588, 1732, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.607, 1733, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.607, 1734, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.652, 1735, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.652, 1736, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.711, 1737, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.711, 1738, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(3.755, 1739, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64481)
    end),
    At(3.755, 1740, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(3.833, 1741, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(3.833, 1742, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(3.852, 1743, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(3.852, 1744, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(3.902, 1745, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(3.902, 1746, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(3.943, 1747, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(3.943, 1748, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(3.989, 1749, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(3.989, 1750, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(4.026, 1751, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(4.026, 1752, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82467)
    end),
    At(4.063, 1753, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(4.063, 1754, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.105, 1755, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.65373)
    end),
    At(4.105, 1756, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.149, 1757, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.149, 1758, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.203, 1759, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.203, 1760, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.282, 1761, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.282, 1762, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.282, 1763, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.282, 1764, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.321, 1765, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.321, 1766, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.379, 1767, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.96033)
    end),
    At(4.379, 1768, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.02332)
    end),
    At(4.418, 1769, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.418, 1770, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.456, 1771, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.456, 1772, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.495, 1773, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.495, 1774, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.574, 1775, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.574, 1776, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.619, 1777, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11149, target=A.Boss})
    end),
    At(4.619, 1778, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.619, 1779, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.659, 1780, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.659, 1781, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.702, 1782, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.702, 1783, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.738, 1784, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.738, 1785, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.27749)
    end),
    At(4.775, 1786, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.26157)
    end),
    At(4.775, 1787, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(4.816, 1788, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.58257)
    end),
    At(4.816, 1789, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(4.816, 1790, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.98054)
    end),
    At(4.872, 1791, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.58257)
    end),
    At(4.872, 1792, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(4.912, 1793, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.58257)
    end),
    At(4.912, 1794, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(4.987, 1795, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.58257)
    end),
    At(4.987, 1796, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(5.06, 1797, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.61842)
    end),
    At(5.06, 1798, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(5.06, 1799, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.61842)
    end),
    At(5.06, 1800, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(5.118, 1801, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-1.73021)
    end),
    At(5.118, 1802, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},-0.64471)
    end),
    At(5.118, 1803, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.53156)
    end),
    At(5.118, 1804, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},0.82141)
    end),
    At(5.2, 1805, function(d,s)
        C.Action(d,s,A.Helper11,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.64471, target=A.Helper11})
    end),
    At(5.2, 1806, function(d,s)
        C.Action(d,s,A.Helper12,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.82141, target=A.Helper12})
    end),
    At(5.2, 1807, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.79502)
    end),
    At(5.239, 1808, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(5.239, 1809, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(5.239, 1810, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.79502)
    end),
    At(5.239, 1811, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(5.239, 1812, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(5.239, 1813, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.79502)
    end),
    At(5.32, 1814, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.79502})
    end),
    At(5.32, 1815, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.79502})
    end),
    At(5.663, 1816, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.07047)
    end),
    At(5.983, 1817, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.35561)
    end),
    At(6.329, 1818, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.65848)
    end),
    At(6.628, 1819, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.93594)
    end),
}
