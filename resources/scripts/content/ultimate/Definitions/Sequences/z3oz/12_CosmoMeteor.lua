-- 宇宙流星 [31664]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
local Meteor=dofile(CONTENT_DIR.."/ultimate/Definitions/Actions/TOP/CosmoMeteor.lua")
return {
    At(0.0, 1746, function(d,s)
        C.Cast(d,s,A.Boss,31664,4.7,{spell=31664, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.869, 1747, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(4.869, 1748, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(4.869, 1749, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.6324, y=0.0, z=100.3913},-5e-05)
    end),
    At(4.869, 1750, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(4.869, 1751, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(4.869, 1752, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0272, y=0.0, z=100.0683},-5e-05)
    end),
    At(4.869, 1753, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(4.869, 1754, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(4.869, 1755, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.1459, y=0.0, z=100.1881},-5e-05)
    end),
    At(4.869, 1756, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(4.869, 1757, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(4.869, 1758, function(d,s)
        C.Move(d,s,A.Helper29,{x=99.7214, y=0.0, z=100.2687},-5e-05)
    end),
    At(4.869, 1759, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(4.869, 1760, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(4.869, 1761, function(d,s)
        C.Move(d,s,A.Helper28,{x=99.9062, y=0.0, z=100.7675},-5e-05)
    end),
    At(4.869, 1762, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(4.869, 1763, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(4.869, 1764, function(d,s)
        C.Move(d,s,A.Helper27,{x=100.2384, y=0.0, z=99.5573},-5e-05)
    end),
    At(4.869, 1765, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(4.869, 1766, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(4.869, 1767, function(d,s)
        C.Move(d,s,A.Helper26,{x=99.919, y=-0.0, z=100.1989},-5e-05)
    end),
    At(4.869, 1768, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(4.869, 1769, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(4.869, 1770, function(d,s)
        C.Move(d,s,A.Helper25,{x=100.1966, y=0.0, z=100.1528},-5e-05)
    end),
    At(4.941, 1771, function(d,s)
        C.Action(d,s,A.Boss,31664,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.941, 1772, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(5.009, 1773, function(d,s)
        C.Cast(d,s,A.Helper25,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=100.1755, y=-0.0153, z=100.145}, pos={x=100.1966, y=0.0, z=100.1528}, rotation=-5e-05, target=A.Helper25})
    end),
    At(5.009, 1774, function(d,s)
        C.Cast(d,s,A.Helper26,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=99.9008, y=-0.0153, z=100.1755}, pos={x=99.919, y=-0.0, z=100.1989}, rotation=-5e-05, target=A.Helper26})
    end),
    At(5.009, 1775, function(d,s)
        C.Cast(d,s,A.Helper28,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=99.9008, y=-0.0153, z=100.7553}, pos={x=99.9062, y=0.0, z=100.7675}, rotation=-5e-05, target=A.Helper28})
    end),
    At(5.009, 1776, function(d,s)
        C.Cast(d,s,A.Helper27,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=100.2365, y=-0.0153, z=99.5346}, pos={x=100.2384, y=0.0, z=99.5573}, rotation=-5e-05, target=A.Helper27})
    end),
    At(5.009, 1777, function(d,s)
        C.Cast(d,s,A.Helper30,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=100.145, y=-0.0153, z=100.1755}, pos={x=100.1459, y=0.0, z=100.1881}, rotation=-5e-05, target=A.Helper30})
    end),
    At(5.009, 1778, function(d,s)
        C.Cast(d,s,A.Helper31,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=100.0229, y=-0.0153, z=100.0534}, pos={x=100.0272, y=0.0, z=100.0683}, rotation=-5e-05, target=A.Helper31})
    end),
    At(5.009, 1779, function(d,s)
        C.Cast(d,s,A.Helper32,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=100.6027, y=-0.0153, z=100.3891}, pos={x=100.6324, y=0.0, z=100.3913}, rotation=-5e-05, target=A.Helper32})
    end),
    At(5.009, 1780, function(d,s)
        C.Cast(d,s,A.Helper29,31666,3.7,{spell=31666, omen_delay=0, cast_pos={x=99.7177, y=-0.0153, z=100.267}, pos={x=99.7214, y=0.0, z=100.2687}, rotation=-5e-05, target=A.Helper29})
    end),
    At(5.297, 1781, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(6.078, 1782, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(7.29, 1783, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(7.486, 1784, function(d,s)
        C.Model(d,s,A.Boss,28)
    end),
    At(8.184, 1793, function(d,s)
        C.Spawn(d,s,A.CosmoMeteor01)
    end),
    At(8.184, 1794, function(d,s)
        C.Spawn(d,s,A.CosmoMeteor02)
    end),
    At(8.184, 1795, function(d,s)
        C.Spawn(d,s,A.CosmoComet01)
    end),
    At(8.184, 1796, function(d,s)
        C.Spawn(d,s,A.CosmoComet02)
    end),
    At(8.184, 1797, function(d,s)
        C.Spawn(d,s,A.CosmoComet03)
    end),
    At(8.184, 1798, function(d,s)
        C.Spawn(d,s,A.CosmoComet04)
    end),
    At(8.184, 1799, function(d,s)
        C.Spawn(d,s,A.CosmoComet05)
    end),
    At(8.184, 1800, function(d,s)
        C.Spawn(d,s,A.CosmoComet06)
    end),
    At(8.927, 1802, function(d,s)
        C.Action(d,s,A.Helper25,31666,{pos={x=100.1966, y=0.0, z=100.1528}, rotation=-5e-05, target=A.Helper25})
    end),
    At(8.927, 1803, function(d,s)
        C.Action(d,s,A.Helper26,31666,{pos={x=99.919, y=-0.0, z=100.1989}, rotation=-5e-05, target=A.Helper26})
    end),
    At(8.927, 1804, function(d,s)
        C.Action(d,s,A.Helper27,31666,{pos={x=100.2384, y=0.0, z=99.5573}, rotation=-5e-05, target=A.Helper27})
    end),
    At(8.927, 1805, function(d,s)
        C.Action(d,s,A.Helper28,31666,{pos={x=99.9062, y=0.0, z=100.7675}, rotation=-5e-05, target=A.Helper28})
    end),
    At(8.927, 1806, function(d,s)
        C.Action(d,s,A.Helper30,31666,{pos={x=100.1459, y=0.0, z=100.1881}, rotation=-5e-05, target=A.Helper30})
    end),
    At(8.927, 1807, function(d,s)
        C.Action(d,s,A.Helper31,31666,{pos={x=100.0272, y=0.0, z=100.0683}, rotation=-5e-05, target=A.Helper31})
    end),
    At(8.927, 1808, function(d,s)
        C.Action(d,s,A.Helper32,31666,{pos={x=100.6324, y=0.0, z=100.3913}, rotation=-5e-05, target=A.Helper32})
    end),
    At(8.927, 1809, function(d,s)
        C.Action(d,s,A.Helper29,31666,{pos={x=99.7214, y=0.0, z=100.2687}, rotation=-5e-05, target=A.Helper29})
    end),
    At(9.112, 1810, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(10.025, 1811, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(10.025, 1812, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(10.025, 1813, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(10.025, 1814, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(10.025, 1815, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(10.025, 1816, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(10.025, 1817, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(10.025, 1818, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(10.161, 1819, function(d,s)
        C.Action(d,s,A.Helper30,32699,{pos={x=100.1459, y=0.0, z=100.1881}, rotation=-5e-05})
    end),
    At(10.161, 1820, function(d,s)
        C.Action(d,s,A.Helper31,32699,{pos={x=100.0272, y=0.0, z=100.0683}, rotation=-5e-05})
    end),
    At(10.161, 1821, function(d,s)
        C.Action(d,s,A.Helper32,32699,{pos={x=100.6324, y=0.0, z=100.3913}, rotation=-5e-05})
    end),
    At(10.161, 1822, function(d,s)
        C.Action(d,s,A.Helper29,32699,{pos={x=99.7214, y=0.0, z=100.2687}, rotation=-5e-05})
    end),
    At(10.363, 1823, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(11.041, 1824, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(11.041, 1825, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(11.041, 1826, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(11.041, 1827, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(11.041, 1828, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(11.041, 1829, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(11.041, 1830, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(11.041, 1831, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(11.155, 1832, function(d,s)
        C.Action(d,s,A.Helper25,32699,{pos={x=100.1966, y=0.0, z=100.1528}, rotation=-5e-05})
    end),
    At(11.155, 1833, function(d,s)
        C.Action(d,s,A.Helper26,32699,{pos={x=99.919, y=-0.0, z=100.1989}, rotation=-5e-05})
    end),
    At(11.207, 1834, function(d,s)
        C.Action(d,s,A.Helper27,32699,{pos={x=100.2384, y=0.0, z=99.5573}, rotation=-5e-05})
    end),
    At(11.207, 1835, function(d,s)
        C.Action(d,s,A.Helper28,32699,{pos={x=99.9062, y=0.0, z=100.7675}, rotation=-5e-05})
    end),
    At(12.14, 1836, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(13.334, 1837, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(13.478, 1838, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(15.116, 1839, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(16.101, 1840, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(16.101, 1841, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(16.101, 1842, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(16.101, 1843, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(16.101, 1844, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(16.101, 1845, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(16.101, 1846, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(16.101, 1847, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(16.171, 1848, function(d,s)
        C.Action(d,s,A.Helper30,32699,{pos={x=100.1459, y=0.0, z=100.1881}, rotation=-5e-05})
    end),
    At(16.171, 1849, function(d,s)
        C.Action(d,s,A.Helper31,32699,{pos={x=100.0272, y=0.0, z=100.0683}, rotation=-5e-05})
    end),
    At(16.171, 1850, function(d,s)
        C.Action(d,s,A.Helper32,32699,{pos={x=100.6324, y=0.0, z=100.3913}, rotation=-5e-05})
    end),
    At(16.171, 1851, function(d,s)
        C.Action(d,s,A.Helper29,32699,{pos={x=99.7214, y=0.0, z=100.2687}, rotation=-5e-05})
    end),
    At(16.763, 1852, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(17.078, 1853, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(17.078, 1854, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(17.078, 1855, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(17.078, 1856, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(17.078, 1857, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(17.078, 1858, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(17.078, 1859, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(17.078, 1860, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(17.197, 1861, function(d,s)
        C.Action(d,s,A.Helper25,32699,{pos={x=100.1966, y=0.0, z=100.1528}, rotation=-5e-05})
    end),
    At(17.197, 1862, function(d,s)
        C.Action(d,s,A.Helper26,32699,{pos={x=99.919, y=-0.0, z=100.1989}, rotation=-5e-05})
    end),
    At(17.197, 1863, function(d,s)
        C.Action(d,s,A.Helper27,32699,{pos={x=100.2384, y=0.0, z=99.5573}, rotation=-5e-05})
    end),
    At(17.197, 1864, function(d,s)
        C.Action(d,s,A.Helper28,32699,{pos={x=99.9062, y=0.0, z=100.7675}, rotation=-5e-05})
    end),
    At(18.093, 1865, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(18.3, 1866, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(21.126, 1867, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(21.833, 1868, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(24.128, 1869, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(27.117, 1870, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=553, duration=0}})
    end),
    At(27.503, 1871, function(d,s)
        C.Despawn(d,s,A.CosmoComet01)
    end),
    At(27.503, 1872, function(d,s)
        C.Despawn(d,s,A.CosmoComet02)
    end),
    At(27.503, 1873, function(d,s)
        C.Despawn(d,s,A.CosmoComet06)
    end),
    At(27.923, 1874, function(d,s)
        C.Despawn(d,s,A.CosmoComet03)
    end),
    At(27.923, 1875, function(d,s)
        C.Despawn(d,s,A.CosmoComet04)
    end),
    At(27.923, 1876, function(d,s)
        C.Despawn(d,s,A.CosmoComet05)
    end),
    At(28.103, 1877, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(28.103, 1878, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(28.103, 1879, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(28.103, 1880, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(28.103, 1881, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(28.103, 1882, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(28.103, 1883, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(28.103, 1884, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(28.192, 1885, function(d,s)
        C.Action(d,s,A.Helper30,31668,{pos={x=100.1459, y=0.0, z=100.1881}, rotation=-5e-05})
    end),
    At(28.192, 1886, function(d,s)
        C.Action(d,s,A.Helper31,31668,{pos={x=100.0272, y=0.0, z=100.0683}, rotation=-5e-05})
    end),
    At(28.192, 1887, function(d,s)
        C.Action(d,s,A.Helper32,31668,{pos={x=100.6324, y=0.0, z=100.3913}, rotation=-5e-05})
    end),
    At(28.192, 1888, function(d,s)
        C.Action(d,s,A.Helper29,31667,{pos={x=99.7214, y=0.0, z=100.2687}, rotation=-5e-05})
    end),
    At(29.182, 1889, function(d,s)
        C.Action(d,s,A.Boss,31665,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(29.997, 1890, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(20.092, -1, function(d,s)
        Meteor.Mark(d,s)
    end),
}
