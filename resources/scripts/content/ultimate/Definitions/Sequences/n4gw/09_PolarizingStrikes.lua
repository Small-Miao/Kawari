-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 614, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(0.0, 615, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.0, 616, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.061, 617, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.061, 618, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.061, 619, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.061, 620, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.115, 621, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.115, 622, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.177, 623, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.177, 624, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.252, 625, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.252, 626, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.252, 627, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.252, 628, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.314, 629, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.314, 630, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.393, 631, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.393, 632, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.393, 633, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.393, 634, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.454, 635, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.454, 636, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.534, 637, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(0.534, 638, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(0.534, 639, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
    At(0.534, 640, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(0.534, 641, function(d,s)
        C.Action(d,s,A.Helper11,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.81441, target=A.Helper11})
    end),
    At(0.534, 642, function(d,s)
        C.Action(d,s,A.Helper12,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.38015, target=A.Helper12})
    end),
    At(2.52, 643, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(2.52, 644, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(2.52, 645, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(2.52, 646, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.52, 647, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(2.52, 648, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(2.52, 649, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.601, 650, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.601, 651, function(d,s)
        C.Cast(d,s,A.Helper13,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.72975, target=A.Helper13})
    end),
    At(2.601, 652, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.601, 653, function(d,s)
        C.Cast(d,s,A.Helper14,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=2.3651, target=A.Helper14})
    end),
    At(2.601, 654, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.601, 655, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.663, 656, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.663, 657, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.703, 658, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.703, 659, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.748, 660, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.748, 661, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.786, 662, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.786, 663, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.865, 664, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.865, 665, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.92, 666, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.92, 667, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.92, 668, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.92, 669, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.993, 670, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.993, 671, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(2.993, 672, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(2.993, 673, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.065, 674, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.065, 675, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.065, 676, function(d,s)
        C.Action(d,s,A.Helper13,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.72975, target=A.Helper13})
    end),
    At(3.065, 677, function(d,s)
        C.Action(d,s,A.Helper14,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.3651, target=A.Helper14})
    end),
    At(3.106, 678, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.106, 679, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.169, 680, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.169, 681, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.169, 682, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.169, 683, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.256, 684, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.256, 685, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.319, 686, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.319, 687, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.319, 688, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.319, 689, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.393, 690, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.393, 691, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.434, 692, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.434, 693, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.472, 694, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.472, 695, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(3.508, 696, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.508, 697, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.545, 698, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.545, 699, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.586, 700, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.586, 701, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.625, 702, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(3.625, 703, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.665, 704, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.665, 705, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.707, 706, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.707, 707, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.764, 708, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.764, 709, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.802, 710, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.802, 711, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.36251)
    end),
    At(3.865, 712, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.865, 713, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(3.886, 714, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.886, 715, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(3.933, 716, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72534)
    end),
    At(3.933, 717, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(3.979, 718, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(3.979, 719, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(4.019, 720, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.019, 721, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(4.098, 722, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.098, 723, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(4.116, 724, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.116, 725, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(4.158, 726, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.158, 727, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.15734)
    end),
    At(4.199, 728, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.199, 729, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.234, 730, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.234, 731, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.296, 732, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.296, 733, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.333, 734, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.52209)
    end),
    At(4.333, 735, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.372, 736, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.24012)
    end),
    At(4.372, 737, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.414, 738, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.24012)
    end),
    At(4.414, 739, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.471, 740, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.24012)
    end),
    At(4.471, 741, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.511, 742, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.21184)
    end),
    At(4.511, 743, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.90749)
    end),
    At(4.548, 744, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(4.548, 745, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
}
