-- 十亿核爆剑 [28057]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 702, function(d,s)
        C.Cast(d,s,A.Boss,28057,7.7,{spell=28057, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01625, target=A.Boss})
    end),
    At(0.062, 703, function(d,s)
        C.Cast(d,s,A.Helper08,28115,16.7,{spell=28115, omen_delay=54, cast_pos={x=112.2301, y=-0.0153, z=106.7979}, pos={x=112.2368, y=0.0, z=106.8015}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.062, 704, function(d,s)
        C.Cast(d,s,A.Helper09,28114,12.7,{spell=28114, omen_delay=36, cast_pos={x=87.9683, y=-0.0153, z=107.1946}, pos={x=87.9913, y=0.0, z=107.1966}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.062, 705, function(d,s)
        C.Cast(d,s,A.Helper10,28058,8.7,{spell=28058, omen_delay=18, cast_pos={x=99.7482, y=-0.0153, z=85.9846}, pos={x=99.7719, y=0.0, z=86.0019}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.936, 706, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.231, 707, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.285, 708, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(8.048, 709, function(d,s)
        C.Action(d,s,A.Boss,28057,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01625, target=A.Boss})
    end),
    At(8.048, 710, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(8.305, 711, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(8.985, 712, function(d,s)
        C.Action(d,s,A.Helper10,28058,{pos={x=99.7719, y=0.0, z=86.0019}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.128, 713, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.128, 714, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.128, 715, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},0.01625)
    end),
    At(9.211, 716, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.01625, target=A.Helper07})
    end),
    At(12.16, 717, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.13464)
    end),
    At(12.461, 718, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.02273)
    end),
    At(12.95, 719, function(d,s)
        C.Action(d,s,A.Helper09,28114,{pos={x=87.9913, y=0.0, z=107.1966}, rotation=-5e-05, target=A.Helper09})
    end),
    At(13.887, 720, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.22109)
    end),
    At(14.197, 721, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.48609)
    end),
    At(14.508, 722, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.75943)
    end),
    At(14.825, 723, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.0136)
    end),
    At(15.346, 724, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.05042)
    end),
    At(15.672, 725, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.89443)
    end),
    At(16.997, 726, function(d,s)
        C.Action(d,s,A.Helper08,28115,{pos={x=112.2368, y=0.0, z=106.8015}, rotation=-5e-05, target=A.Helper08})
    end),
    At(17.13, 727, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.74352)
    end),
    At(17.621, 728, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.38753)
    end),
    At(18.155, 729, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.57344)
    end),
    At(18.474, 730, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.795)
    end),
    At(18.807, 731, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.9416)
    end),
    At(19.321, 732, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.06652)
    end),
    At(19.679, 733, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.09691)
    end),
    At(19.986, 734, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.11829)
    end),
    At(20.564, 735, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.14006)
    end),
    At(26.223, 736, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13076, target=A.Boss})
    end),
    At(27.212, 737, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(27.212, 738, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(27.212, 739, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(27.212, 740, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(27.212, 741, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(27.212, 742, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(27.244, 743, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=112.2368, y=0.0, z=106.8015}, rotation=-5e-05})
    end),
    At(27.244, 744, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=87.9913, y=0.0, z=107.1966}, rotation=-5e-05})
    end),
    At(27.244, 745, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=99.7719, y=0.0, z=86.0019}, rotation=-5e-05})
    end),
    At(30.257, 746, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13076, target=A.Boss})
    end),
    At(31.255, 747, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(31.255, 748, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(31.255, 749, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(31.255, 750, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(31.255, 751, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(31.255, 752, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(31.255, 753, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=112.2368, y=0.0, z=106.8015}, rotation=-5e-05})
    end),
    At(31.255, 754, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=87.9913, y=0.0, z=107.1966}, rotation=-5e-05})
    end),
    At(31.255, 755, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=99.7719, y=0.0, z=86.0019}, rotation=-5e-05})
    end),
    At(33.146, 756, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(33.146, 757, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(33.146, 758, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.914, y=0.0, z=107.9995},-0.01079)
    end),
    At(33.146, 759, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(33.146, 760, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(33.146, 761, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.9708, y=0.0, z=96.0747},-0.01079)
    end),
    At(33.146, 762, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(33.146, 763, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(33.146, 764, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.1152, y=0.0, z=95.9257},0.77462)
    end),
}
