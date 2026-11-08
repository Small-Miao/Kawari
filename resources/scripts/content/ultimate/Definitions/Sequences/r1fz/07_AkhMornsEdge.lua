-- 死亡轮回剑 [28051]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 582, function(d,s)
        C.Cast(d,s,A.Helper08,29453,6.4,{spell=29453, omen_delay=20, cast_pos={x=106.8589, y=-0.0153, z=104.0513}, pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.0, 583, function(d,s)
        C.Cast(d,s,A.Helper09,29452,6.4,{spell=29452, omen_delay=10, cast_pos={x=93.0037, y=-0.0153, z=103.8987}, pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.0, 584, function(d,s)
        C.Cast(d,s,A.Helper10,29454,6.4,{spell=29454, omen_delay=30, cast_pos={x=100.0534, y=-0.0153, z=91.9966}, pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.0, 585, function(d,s)
        C.Cast(d,s,A.Boss,28051,5.7,{spell=28051, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(0.973, 586, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(1.748, 587, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(3.846, 588, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(4.756, 589, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.987, 590, function(d,s)
        C.Action(d,s,A.Boss,28051,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(6.693, 591, function(d,s)
        C.Action(d,s,A.Helper08,29453,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper08})
    end),
    At(6.693, 592, function(d,s)
        C.Action(d,s,A.Helper09,29452,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper09})
    end),
    At(6.693, 593, function(d,s)
        C.Action(d,s,A.Helper10,29454,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(6.762, 594, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(6.762, 595, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(6.762, 596, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},-0.01031)
    end),
    At(6.805, 597, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01031, target=A.Helper07})
    end),
    At(8.112, 598, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(8.874, 599, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.874, 600, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.874, 601, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(8.874, 602, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.874, 603, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.874, 604, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(8.874, 605, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.874, 606, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.874, 607, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(8.946, 608, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper08})
    end),
    At(8.946, 609, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper09})
    end),
    At(8.946, 610, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.157, 611, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(9.965, 612, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.965, 613, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.965, 614, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(9.965, 615, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(9.965, 616, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(9.965, 617, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(9.965, 618, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(9.965, 619, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(9.965, 620, function(d,s)
        C.Move(d,s,A.Helper05,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(10.044, 621, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper05})
    end),
    At(10.044, 622, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper06})
    end),
    At(10.044, 623, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper07})
    end),
    At(10.267, 624, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(11.037, 625, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(11.037, 626, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(11.037, 627, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(11.037, 628, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(11.037, 629, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(11.037, 630, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(11.037, 631, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(11.037, 632, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(11.037, 633, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(11.116, 634, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper08})
    end),
    At(11.116, 635, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper09})
    end),
    At(11.116, 636, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(11.384, 637, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(12.096, 638, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(12.096, 639, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(12.096, 640, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(12.096, 641, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(12.096, 642, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(12.096, 643, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(12.096, 644, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(12.096, 645, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(12.096, 646, function(d,s)
        C.Move(d,s,A.Helper05,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(12.17, 647, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper05})
    end),
    At(12.17, 648, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper06})
    end),
    At(12.17, 649, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper07})
    end),
    At(12.388, 650, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(12.388, 651, function(d,s)
        C.Action(d,s,A.Boss,28053,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01031, target=A.Boss})
    end),
    At(13.166, 652, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(13.166, 653, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(13.166, 654, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.082, y=0.0, z=92.0004},-5e-05)
    end),
    At(13.166, 655, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(13.166, 656, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(13.166, 657, function(d,s)
        C.Move(d,s,A.Helper09,{x=93.0312, y=0.0, z=103.9288},-5e-05)
    end),
    At(13.166, 658, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(13.166, 659, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(13.166, 660, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.8868, y=0.0, z=104.0708},-5e-05)
    end),
    At(13.251, 661, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05, target=A.Helper08})
    end),
    At(13.251, 662, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05, target=A.Helper09})
    end),
    At(13.251, 663, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.565, 664, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.79198)
    end),
    At(14.875, 665, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.65229)
    end),
    At(15.255, 666, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.49103)
    end),
    At(15.518, 667, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.27473)
    end),
    At(15.877, 668, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.07924)
    end),
    At(16.813, 669, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.05326)
    end),
    At(17.175, 670, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.02708)
    end),
    At(17.684, 671, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.0036)
    end),
    At(18.043, 672, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.01625)
    end),
    At(18.548, 673, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01625, target=A.Boss})
    end),
    At(19.595, 674, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(19.595, 675, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(19.595, 676, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(19.595, 677, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(19.595, 678, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(19.595, 679, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(19.595, 680, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05})
    end),
    At(19.595, 681, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05})
    end),
    At(19.595, 682, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05})
    end),
    At(22.55, 683, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.01625, target=A.Boss})
    end),
    At(23.573, 684, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(23.573, 685, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(23.573, 686, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(23.573, 687, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(23.573, 688, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(23.573, 689, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(23.645, 690, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=106.8868, y=0.0, z=104.0708}, rotation=-5e-05})
    end),
    At(23.645, 691, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=93.0312, y=0.0, z=103.9288}, rotation=-5e-05})
    end),
    At(23.645, 692, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.082, y=0.0, z=92.0004}, rotation=-5e-05})
    end),
    At(25.5, 693, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(25.5, 694, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(25.5, 695, function(d,s)
        C.Move(d,s,A.Helper10,{x=99.7719, y=0.0, z=86.0019},-5e-05)
    end),
    At(25.5, 696, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(25.5, 697, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(25.5, 698, function(d,s)
        C.Move(d,s,A.Helper09,{x=87.9913, y=0.0, z=107.1966},-5e-05)
    end),
    At(25.5, 699, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(25.5, 700, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(25.5, 701, function(d,s)
        C.Move(d,s,A.Helper08,{x=112.2368, y=0.0, z=106.8015},-5e-05)
    end),
}
