-- 光尘之剑 [40306]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1820, function(d,s)
        C.Cast(d,s,A.Boss,40306,5.7,{spell=40306, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.04658, target=A.Boss})
    end),
    At(0.161, 1821, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.04658)
    end),
    At(6.015, 1828, function(d,s)
        C.Action(d,s,A.Boss,40306,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.04658, target=A.Boss})
    end),
    At(9.195, 1835, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.04658, target=A.Boss})
    end),
    At(9.353, 1836, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.75023)
    end),
    At(9.749, 1837, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(9.749, 1838, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(9.749, 1839, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.75023)
    end),
    At(9.749, 1840, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(9.749, 1841, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(9.749, 1842, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},2.75023)
    end),
    At(9.845, 1843, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.75023})
    end),
    At(9.845, 1844, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.75023})
    end),
    At(10.052, 1846, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(10.052, 1847, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(10.052, 1848, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=97.0},-5e-05)
    end),
    At(10.052, 1849, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(10.052, 1850, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(10.052, 1851, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=97.0},3.14159)
    end),
    At(10.052, 1853, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(10.052, 1854, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(10.052, 1855, function(d,s)
        C.Move(d,s,A.Helper10,{x=103.5858, y=0.0, z=96.4142},2.35618)
    end),
    At(10.052, 1856, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(10.052, 1857, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(10.052, 1858, function(d,s)
        C.Move(d,s,A.Helper09,{x=103.5858, y=0.0, z=96.4142},-0.78546)
    end),
    At(10.131, 1859, function(d,s)
        C.Cast(d,s,A.Helper09,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=96.3912}, pos={x=103.5858, y=0.0, z=96.4142}, rotation=-0.78546, target=A.Helper09})
    end),
    At(10.131, 1860, function(d,s)
        C.Cast(d,s,A.Helper10,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=96.3912}, pos={x=103.5858, y=0.0, z=96.4142}, rotation=2.35618, target=A.Helper10})
    end),
    At(10.131, 1861, function(d,s)
        C.Cast(d,s,A.Helper11,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=96.9711}, pos={x=100.0, y=0.0, z=97.0}, rotation=3.14159, target=A.Helper11})
    end),
    At(10.131, 1862, function(d,s)
        C.Cast(d,s,A.Helper12,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=96.9711}, pos={x=100.0, y=0.0, z=97.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(11.026, 1863, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.73098)
    end),
    At(11.361, 1864, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.60004)
    end),
    At(11.644, 1865, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.14175)
    end),
    At(12.19, 1866, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.07416)
    end),
    At(12.269, 1867, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.07416, target=A.Boss})
    end),
    At(12.499, 1868, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.0012)
    end),
    At(12.893, 1869, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(12.893, 1870, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(12.893, 1871, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.00254)
    end),
    At(12.893, 1872, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(12.893, 1873, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(12.893, 1874, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.00254)
    end),
    At(12.986, 1875, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.00254})
    end),
    At(12.986, 1876, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.00254})
    end),
    At(14.03, 1878, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.03, 1879, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.03, 1880, function(d,s)
        C.Move(d,s,A.Helper14,{x=110.0, y=0.0, z=100.0},1.57077)
    end),
    At(14.03, 1881, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(14.03, 1882, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(14.03, 1883, function(d,s)
        C.Move(d,s,A.Helper13,{x=110.0, y=0.0, z=100.0},-1.57087)
    end),
    At(14.03, 1885, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(14.03, 1886, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(14.03, 1887, function(d,s)
        C.Move(d,s,A.Helper08,{x=110.6569, y=0.0, z=110.6569},-2.35628)
    end),
    At(14.03, 1888, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(14.03, 1889, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(14.03, 1890, function(d,s)
        C.Move(d,s,A.Helper07,{x=110.6569, y=0.0, z=110.6569},0.78536)
    end),
    At(14.161, 1891, function(d,s)
        C.Cast(d,s,A.Helper07,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=110.6432, y=-0.0153, z=110.6432}, pos={x=110.6569, y=0.0, z=110.6569}, rotation=0.78536, target=A.Helper07})
    end),
    At(14.161, 1892, function(d,s)
        C.Cast(d,s,A.Helper08,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=110.6432, y=-0.0153, z=110.6432}, pos={x=110.6569, y=0.0, z=110.6569}, rotation=-2.35628, target=A.Helper08})
    end),
    At(14.161, 1893, function(d,s)
        C.Cast(d,s,A.Helper13,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=109.9718, y=-0.0153, z=99.9924}, pos={x=110.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(14.161, 1894, function(d,s)
        C.Cast(d,s,A.Helper14,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=109.9718, y=-0.0153, z=99.9924}, pos={x=110.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(15.435, 1895, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.00657, target=A.Boss})
    end),
    At(16.058, 1896, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(16.058, 1897, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(16.058, 1898, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=100.0},0.00657)
    end),
    At(16.058, 1899, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(16.058, 1900, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(16.058, 1901, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=100.0},0.00657)
    end),
    At(16.12, 1902, function(d,s)
        C.Action(d,s,A.Helper05,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00657})
    end),
    At(16.12, 1903, function(d,s)
        C.Action(d,s,A.Helper06,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00657})
    end),
    At(17.121, 1906, function(d,s)
        C.Action(d,s,A.Helper09,40118,{pos={x=103.5858, y=0.0, z=96.4142}, rotation=-0.78546, target=A.Helper09})
    end),
    At(17.121, 1907, function(d,s)
        C.Action(d,s,A.Helper10,40307,{pos={x=103.5858, y=0.0, z=96.4142}, rotation=2.35618, target=A.Helper10})
    end),
    At(17.121, 1908, function(d,s)
        C.Action(d,s,A.Helper11,40118,{pos={x=100.0, y=0.0, z=97.0}, rotation=3.14159, target=A.Helper11})
    end),
    At(17.121, 1909, function(d,s)
        C.Action(d,s,A.Helper12,40307,{pos={x=100.0, y=0.0, z=97.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(18.042, 1911, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(18.042, 1912, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(18.042, 1913, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=117.0},-3.14159)
    end),
    At(18.042, 1914, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(18.042, 1915, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(18.042, 1916, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=117.0},-5e-05)
    end),
    At(18.042, 1918, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(18.042, 1919, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(18.042, 1920, function(d,s)
        C.Move(d,s,A.Helper04,{x=89.3934, y=0.0, z=110.6569},-0.78546)
    end),
    At(18.042, 1921, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(18.042, 1922, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(18.042, 1923, function(d,s)
        C.Move(d,s,A.Helper03,{x=89.3934, y=0.0, z=110.6569},2.35618)
    end),
    At(18.157, 1924, function(d,s)
        C.Cast(d,s,A.Helper03,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=89.3721, y=-0.0153, z=110.6432}, pos={x=89.3934, y=0.0, z=110.6569}, rotation=2.35618, target=A.Helper03})
    end),
    At(18.157, 1925, function(d,s)
        C.Cast(d,s,A.Helper04,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=89.3721, y=-0.0153, z=110.6432}, pos={x=89.3934, y=0.0, z=110.6569}, rotation=-0.78546, target=A.Helper04})
    end),
    At(18.157, 1926, function(d,s)
        C.Cast(d,s,A.Helper05,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=116.9909}, pos={x=100.0, y=0.0, z=117.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(18.157, 1927, function(d,s)
        C.Cast(d,s,A.Helper06,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=116.9909}, pos={x=100.0, y=0.0, z=117.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(18.567, 1928, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.00657, target=A.Boss})
    end),
    At(19.207, 1929, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0503, y=0.0, z=99.9498},-0.78546)
    end),
    At(19.207, 1930, function(d,s)
        C.Move(d,s,A.Helper10,{x=107.1213, y=0.0, z=92.8787},2.35618)
    end),
    At(19.207, 1931, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=92.0},3.14159)
    end),
    At(19.207, 1932, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=102.0},-5e-05)
    end),
    At(19.207, 1933, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(19.207, 1934, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(19.207, 1935, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},0.00657)
    end),
    At(19.207, 1936, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(19.207, 1937, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(19.207, 1938, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},0.00657)
    end),
    At(19.207, 1939, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0503, y=0.0, z=99.9498}, rotation=-0.78546, target=A.Helper09})
    end),
    At(19.207, 1940, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=107.1213, y=0.0, z=92.8787}, rotation=2.35618, target=A.Helper10})
    end),
    At(19.207, 1941, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=92.0}, rotation=3.14159, target=A.Helper11})
    end),
    At(19.207, 1942, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=102.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(19.286, 1943, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00657})
    end),
    At(19.286, 1944, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00657})
    end),
    At(21.125, 1949, function(d,s)
        C.Action(d,s,A.Helper07,40118,{pos={x=110.6569, y=0.0, z=110.6569}, rotation=0.78536, target=A.Helper07})
    end),
    At(21.125, 1950, function(d,s)
        C.Action(d,s,A.Helper08,40307,{pos={x=110.6569, y=0.0, z=110.6569}, rotation=-2.35628, target=A.Helper08})
    end),
    At(21.125, 1951, function(d,s)
        C.Action(d,s,A.Helper13,40118,{pos={x=110.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(21.125, 1952, function(d,s)
        C.Action(d,s,A.Helper14,40307,{pos={x=110.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(21.275, 1953, function(d,s)
        C.Move(d,s,A.Helper09,{x=96.5147, y=0.0, z=103.4853},-0.78546)
    end),
    At(21.275, 1954, function(d,s)
        C.Move(d,s,A.Helper10,{x=110.6569, y=0.0, z=89.3432},2.35618)
    end),
    At(21.275, 1955, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=87.0},3.14159)
    end),
    At(21.275, 1956, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=107.0},-5e-05)
    end),
    At(21.275, 1957, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=96.5147, y=0.0, z=103.4853}, rotation=-0.78546, target=A.Helper09})
    end),
    At(21.275, 1958, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=110.6569, y=0.0, z=89.3432}, rotation=2.35618, target=A.Helper10})
    end),
    At(21.275, 1959, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=87.0}, rotation=3.14159, target=A.Helper11})
    end),
    At(21.275, 1960, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=107.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(21.667, 1961, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.00513, target=A.Boss})
    end),
    At(22.252, 1962, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.16112)
    end),
    At(22.308, 1963, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(22.308, 1964, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(22.308, 1965, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},-0.16112)
    end),
    At(22.308, 1966, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(22.308, 1967, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(22.308, 1968, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},-0.16112)
    end),
    At(22.382, 1969, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.16112})
    end),
    At(22.382, 1970, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.16112})
    end),
    At(22.74, 1971, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.20187)
    end),
    At(23.172, 1972, function(d,s)
        C.Move(d,s,A.Helper07,{x=114.1924, y=0.0, z=114.1924},0.78536)
    end),
    At(23.172, 1973, function(d,s)
        C.Move(d,s,A.Helper08,{x=107.1214, y=0.0, z=107.1214},-2.35628)
    end),
    At(23.172, 1974, function(d,s)
        C.Move(d,s,A.Helper13,{x=105.0, y=0.0, z=100.0},-1.57087)
    end),
    At(23.172, 1975, function(d,s)
        C.Move(d,s,A.Helper14,{x=115.0, y=0.0, z=100.0},1.57077)
    end),
    At(23.241, 1976, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=114.1924, y=0.0, z=114.1924}, rotation=0.78536, target=A.Helper07})
    end),
    At(23.241, 1977, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=107.1214, y=0.0, z=107.1214}, rotation=-2.35628, target=A.Helper08})
    end),
    At(23.241, 1978, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=105.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(23.241, 1979, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=115.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(23.306, 1980, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.9792, y=0.0, z=107.0208},-0.78546)
    end),
    At(23.306, 1981, function(d,s)
        C.Move(d,s,A.Helper10,{x=114.1924, y=0.0, z=85.8076},2.35618)
    end),
    At(23.306, 1982, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=82.0},3.14159)
    end),
    At(23.306, 1983, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=112.0},-5e-05)
    end),
    At(23.369, 1984, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=92.9792, y=0.0, z=107.0208}, rotation=-0.78546, target=A.Helper09})
    end),
    At(23.369, 1985, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=114.1924, y=0.0, z=85.8076}, rotation=2.35618, target=A.Helper10})
    end),
    At(23.369, 1986, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=100.0, y=0.0, z=82.0}, rotation=3.14159, target=A.Helper11})
    end),
    At(23.369, 1987, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=112.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(24.17, 1990, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.0222)
    end),
    At(24.504, 1991, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.20407)
    end),
}
