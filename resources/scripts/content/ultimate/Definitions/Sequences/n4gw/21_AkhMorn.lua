-- 死亡轮回 [40310]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1993, function(d,s)
        C.Cast(d,s,A.Boss,40310,7.7,{spell=40310, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.20407, target=A.Boss})
    end),
    At(0.288, 1996, function(d,s)
        C.Action(d,s,A.Helper03,40118,{pos={x=89.3934, y=0.0, z=110.6569}, rotation=2.35618, target=A.Helper03})
    end),
    At(0.288, 1997, function(d,s)
        C.Action(d,s,A.Helper04,40307,{pos={x=89.3934, y=0.0, z=110.6569}, rotation=-0.78546, target=A.Helper04})
    end),
    At(0.288, 1998, function(d,s)
        C.Action(d,s,A.Helper05,40118,{pos={x=100.0, y=0.0, z=117.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(0.288, 1999, function(d,s)
        C.Action(d,s,A.Helper06,40307,{pos={x=100.0, y=0.0, z=117.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(0.363, 2000, function(d,s)
        C.Move(d,s,A.Helper08,{x=103.5858, y=0.0, z=103.5858},-2.35628)
    end),
    At(0.363, 2001, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.57087)
    end),
    At(0.363, 2002, function(d,s)
        C.Move(d,s,A.Helper14,{x=120.0, y=0.0, z=100.0},1.57077)
    end),
    At(0.418, 2003, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=103.5858, y=0.0, z=103.5858}, rotation=-2.35628, target=A.Helper08})
    end),
    At(0.418, 2004, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(0.418, 2005, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=120.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper14})
    end),
    At(0.492, 2006, function(d,s)
        C.Move(d,s,A.Helper09,{x=89.4436, y=0.0, z=110.5563},-0.78546)
    end),
    At(0.492, 2007, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=117.0},-5e-05)
    end),
    At(0.567, 2008, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=89.4436, y=0.0, z=110.5563}, rotation=-0.78546, target=A.Helper09})
    end),
    At(0.567, 2009, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=117.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(2.364, 2010, function(d,s)
        C.Move(d,s,A.Helper03,{x=92.9289, y=0.0, z=107.1214},2.35618)
    end),
    At(2.364, 2011, function(d,s)
        C.Move(d,s,A.Helper04,{x=85.8578, y=0.0, z=114.1924},-0.78546)
    end),
    At(2.364, 2012, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=122.0},-5e-05)
    end),
    At(2.364, 2013, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=112.0},-3.14159)
    end),
    At(2.364, 2014, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=92.9289, y=0.0, z=107.1214}, rotation=2.35618, target=A.Helper03})
    end),
    At(2.364, 2015, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=85.8578, y=0.0, z=114.1924}, rotation=-0.78546, target=A.Helper04})
    end),
    At(2.364, 2016, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=122.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(2.364, 2017, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=112.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(2.442, 2018, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0503, y=0.0, z=100.0503},-2.35628)
    end),
    At(2.442, 2019, function(d,s)
        C.Move(d,s,A.Helper13,{x=95.0, y=0.0, z=100.0},-1.57087)
    end),
    At(2.512, 2020, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=100.0503, y=0.0, z=100.0503}, rotation=-2.35628, target=A.Helper08})
    end),
    At(2.512, 2021, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=95.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(2.573, 2022, function(d,s)
        C.Move(d,s,A.Helper09,{x=85.9081, y=0.0, z=114.0919},-0.78546)
    end),
    At(2.573, 2023, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=122.0},-5e-05)
    end),
    At(2.613, 2024, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=85.9081, y=0.0, z=114.0919}, rotation=-0.78546, target=A.Helper09})
    end),
    At(2.613, 2025, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0, y=0.0, z=122.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(4.382, 2028, function(d,s)
        C.Move(d,s,A.Helper03,{x=96.4645, y=0.0, z=103.5858},2.35618)
    end),
    At(4.382, 2029, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=107.0},-3.14159)
    end),
    At(4.442, 2030, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=96.4645, y=0.0, z=103.5858}, rotation=2.35618, target=A.Helper03})
    end),
    At(4.442, 2031, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=107.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(4.513, 2032, function(d,s)
        C.Move(d,s,A.Helper08,{x=96.5148, y=0.0, z=96.5148},-2.35628)
    end),
    At(4.513, 2033, function(d,s)
        C.Move(d,s,A.Helper13,{x=90.0, y=0.0, z=100.0},-1.57087)
    end),
    At(4.513, 2034, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=96.5148, y=0.0, z=96.5148}, rotation=-2.35628, target=A.Helper08})
    end),
    At(4.513, 2035, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=90.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(6.455, 2037, function(d,s)
        C.Move(d,s,A.Helper03,{x=100.0, y=0.0, z=100.0503},2.35618)
    end),
    At(6.455, 2038, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=102.0},-3.14159)
    end),
    At(6.491, 2039, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=100.0, y=0.0, z=100.0503}, rotation=2.35618, target=A.Helper03})
    end),
    At(6.491, 2040, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=102.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(6.572, 2041, function(d,s)
        C.Move(d,s,A.Helper08,{x=92.9792, y=0.0, z=92.9792},-2.35628)
    end),
    At(6.572, 2042, function(d,s)
        C.Move(d,s,A.Helper13,{x=85.0, y=0.0, z=100.0},-1.57087)
    end),
    At(6.631, 2043, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=92.9792, y=0.0, z=92.9792}, rotation=-2.35628, target=A.Helper08})
    end),
    At(6.631, 2044, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=85.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(7.953, 2045, function(d,s)
        C.Action(d,s,A.Boss,40310,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.20407, target=A.Boss})
    end),
    At(7.953, 2046, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(7.953, 2047, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(7.953, 2048, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(7.953, 2049, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(8.03, 2050, function(d,s)
        C.Action(d,s,A.Helper12,40311,{pos={x=100.0, y=0.0, z=122.0}, rotation=-5e-05})
    end),
    At(8.03, 2051, function(d,s)
        C.Action(d,s,A.Helper14,40312,{pos={x=120.0, y=0.0, z=100.0}, rotation=1.57077})
    end),
    At(8.477, 2052, function(d,s)
        C.Move(d,s,A.Helper03,{x=103.5355, y=0.0, z=96.5148},2.35618)
    end),
    At(8.477, 2053, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=97.0},-3.14159)
    end),
    At(8.518, 2054, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=103.5355, y=0.0, z=96.5148}, rotation=2.35618, target=A.Helper03})
    end),
    At(8.518, 2055, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=97.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(8.579, 2056, function(d,s)
        C.Move(d,s,A.Helper08,{x=89.4437, y=0.0, z=89.4437},-2.35628)
    end),
    At(8.579, 2057, function(d,s)
        C.Move(d,s,A.Helper13,{x=80.0, y=0.0, z=100.0},-1.57087)
    end),
    At(8.641, 2058, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=89.4437, y=0.0, z=89.4437}, rotation=-2.35628, target=A.Helper08})
    end),
    At(8.641, 2059, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=80.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper13})
    end),
    At(10.554, 2061, function(d,s)
        C.Move(d,s,A.Helper03,{x=107.0711, y=0.0, z=92.9792},2.35618)
    end),
    At(10.554, 2062, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=92.0},-3.14159)
    end),
    At(10.596, 2063, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=107.0711, y=0.0, z=92.9792}, rotation=2.35618, target=A.Helper03})
    end),
    At(10.596, 2064, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=92.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(10.631, 2065, function(d,s)
        C.Move(d,s,A.Helper08,{x=85.9081, y=0.0, z=85.9081},-2.35628)
    end),
    At(10.669, 2066, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=85.9081, y=0.0, z=85.9081}, rotation=-2.35628, target=A.Helper08})
    end),
    At(11.072, 2067, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.20407, target=A.Boss})
    end),
    At(11.403, 2068, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.88802)
    end),
    At(11.655, 2069, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.96892)
    end),
    At(11.691, 2070, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(11.691, 2071, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(11.691, 2072, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-2.96892)
    end),
    At(11.691, 2073, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.691, 2074, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.691, 2075, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-2.96892)
    end),
    At(11.806, 2076, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.96892})
    end),
    At(11.806, 2077, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.96892})
    end),
    At(12.648, 2078, function(d,s)
        C.Move(d,s,A.Helper03,{x=110.6066, y=0.0, z=89.4437},2.35618)
    end),
    At(12.648, 2079, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=87.0},-3.14159)
    end),
    At(12.648, 2080, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=110.6066, y=0.0, z=89.4437}, rotation=2.35618, target=A.Helper03})
    end),
    At(12.648, 2081, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=87.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(12.878, 2082, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.94754)
    end),
    At(14.227, 2083, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.94754, target=A.Boss})
    end),
    At(14.685, 2084, function(d,s)
        C.Move(d,s,A.Helper03,{x=114.1422, y=0.0, z=85.9081},2.35618)
    end),
    At(14.685, 2085, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=82.0},-3.14159)
    end),
    At(14.76, 2086, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=114.1422, y=0.0, z=85.9081}, rotation=2.35618, target=A.Helper03})
    end),
    At(14.76, 2087, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=82.0}, rotation=-3.14159, target=A.Helper06})
    end),
    At(14.892, 2088, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.892, 2089, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.892, 2090, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-2.94754)
    end),
    At(14.892, 2091, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(14.892, 2092, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(14.892, 2093, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-2.94754)
    end),
    At(14.96, 2094, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.94754})
    end),
    At(14.96, 2095, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.94754})
    end),
    At(16.343, 2097, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(16.343, 2098, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(16.343, 2099, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-2.94754)
    end),
}
