-- 波动炮 [31657]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 642, function(d,s)
        C.Cast(d,s,A.Boss,31657,10.6,{spell=31657, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.88872, target=A.Boss})
    end),
    At(2.956, 643, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(2.956, 644, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(2.956, 645, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.93138)
    end),
    At(2.956, 646, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(2.956, 647, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(2.956, 648, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.84687)
    end),
    At(2.956, 649, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(2.956, 650, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(2.956, 651, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(2.956, 652, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(2.956, 653, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(2.956, 654, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.051, 655, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.84687)
    end),
    At(3.051, 656, function(d,s)
        C.Action(d,s,A.Helper31,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.84687, target=A.Helper31})
    end),
    At(3.051, 657, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.051, 658, function(d,s)
        C.Action(d,s,A.Helper30,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.55313, target=A.Helper30})
    end),
    At(3.051, 659, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.81556)
    end),
    At(3.051, 660, function(d,s)
        C.Action(d,s,A.Helper32,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.81556, target=A.Helper32})
    end),
    At(3.051, 661, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.051, 662, function(d,s)
        C.Action(d,s,A.Helper29,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.56895, target=A.Helper29})
    end),
    At(3.103, 663, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.84687)
    end),
    At(3.103, 664, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.103, 665, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.81556)
    end),
    At(3.103, 666, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.103, 667, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.103, 668, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.103, 669, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.81556)
    end),
    At(3.103, 670, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.187, 671, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.187, 672, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.187, 673, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.81556)
    end),
    At(3.187, 674, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.214, 675, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.214, 676, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.214, 677, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.81556)
    end),
    At(3.214, 678, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.301, 679, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.301, 680, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.301, 681, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.301, 682, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.301, 683, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.301, 684, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.301, 685, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.301, 686, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.353, 687, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.353, 688, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.353, 689, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.353, 690, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.437, 691, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.63144)
    end),
    At(3.437, 692, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.437, 693, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.437, 694, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.437, 695, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.437, 696, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.437, 697, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.437, 698, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.485, 699, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.485, 700, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.485, 701, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.485, 702, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.558, 703, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.558, 704, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.558, 705, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.558, 706, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.558, 707, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.558, 708, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.558, 709, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.558, 710, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.629, 711, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.629, 712, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.629, 713, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.629, 714, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.629, 715, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.629, 716, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.629, 717, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.629, 718, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.68, 719, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.51054)
    end),
    At(3.68, 720, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.68, 721, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.68, 722, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.762, 723, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.50489)
    end),
    At(3.762, 724, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.762, 725, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.762, 726, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.833, 727, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(3.833, 728, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.833, 729, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.833, 730, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.833, 731, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(3.833, 732, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.833, 733, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.833, 734, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.889, 735, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(3.889, 736, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.889, 737, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.889, 738, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.963, 739, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(3.963, 740, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.963, 741, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.963, 742, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(3.963, 743, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(3.963, 744, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(3.963, 745, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(3.963, 746, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(4.018, 747, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(4.018, 748, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(4.018, 749, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(4.018, 750, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(4.095, 751, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},2.3582)
    end),
    At(4.095, 752, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-1.55313)
    end),
    At(4.095, 753, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},0.77683)
    end),
    At(4.095, 754, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},1.56895)
    end),
    At(4.974, 755, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(4.974, 756, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(4.974, 757, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(4.974, 758, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(4.974, 759, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(4.974, 760, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(4.974, 761, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(4.974, 762, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(4.974, 763, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(4.974, 764, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(4.974, 765, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(4.974, 766, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.11101)
    end),
    At(5.041, 767, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(5.041, 768, function(d,s)
        C.Action(d,s,A.Helper31,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00599, target=A.Helper31})
    end),
    At(5.041, 769, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.041, 770, function(d,s)
        C.Action(d,s,A.Helper30,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.35359, target=A.Helper30})
    end),
    At(5.041, 771, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.041, 772, function(d,s)
        C.Action(d,s,A.Helper32,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78747, target=A.Helper32})
    end),
    At(5.041, 773, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.11101)
    end),
    At(5.041, 774, function(d,s)
        C.Action(d,s,A.Helper29,31659,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.11101, target=A.Helper29})
    end),
    At(5.103, 775, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(5.103, 776, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.103, 777, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.103, 778, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.11187)
    end),
    At(5.172, 779, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(5.172, 780, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.172, 781, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.172, 782, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.11187)
    end),
    At(5.172, 783, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(5.172, 784, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.172, 785, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.172, 786, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.1136)
    end),
    At(5.242, 787, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00599)
    end),
    At(5.242, 788, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.242, 789, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.242, 790, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.242, 791, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0059)
    end),
    At(5.242, 792, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.242, 793, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.242, 794, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.291, 795, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0059)
    end),
    At(5.291, 796, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.291, 797, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.291, 798, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.356, 799, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0059)
    end),
    At(5.356, 800, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.356, 801, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.356, 802, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.422, 803, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0059)
    end),
    At(5.422, 804, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.422, 805, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.422, 806, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.422, 807, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0058)
    end),
    At(5.422, 808, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.422, 809, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.422, 810, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.511, 811, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0057)
    end),
    At(5.511, 812, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.511, 813, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.511, 814, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.511, 815, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00542)
    end),
    At(5.511, 816, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.511, 817, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.511, 818, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.576, 819, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00494)
    end),
    At(5.576, 820, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.576, 821, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.576, 822, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.628, 823, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00455)
    end),
    At(5.628, 824, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.628, 825, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.628, 826, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.718, 827, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00455)
    end),
    At(5.718, 828, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.718, 829, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.718, 830, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.718, 831, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00455)
    end),
    At(5.718, 832, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.718, 833, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.718, 834, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.767, 835, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00455)
    end),
    At(5.767, 836, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.767, 837, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.767, 838, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.767, 839, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00436)
    end),
    At(5.767, 840, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.767, 841, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.767, 842, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.836, 843, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00427)
    end),
    At(5.836, 844, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.836, 845, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.836, 846, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.906, 847, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.0034)
    end),
    At(5.906, 848, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.906, 849, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.906, 850, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.906, 851, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00331)
    end),
    At(5.906, 852, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.906, 853, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.906, 854, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(5.97, 855, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00244)
    end),
    At(5.97, 856, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(5.97, 857, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(5.97, 858, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(6.055, 859, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00062)
    end),
    At(6.055, 860, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(6.055, 861, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(6.055, 862, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(6.055, 863, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},0.00024)
    end),
    At(6.055, 864, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-2.35359)
    end),
    At(6.055, 865, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-0.78747)
    end),
    At(6.055, 866, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=100.0},3.12999)
    end),
    At(10.852, 867, function(d,s)
        C.Action(d,s,A.Boss,31657,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.88872, target=A.Boss})
    end),
    At(11.127, 868, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.32324)
    end),
    At(11.174, 869, function(d,s)
        C.Action(d,s,A.Boss,31658,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.00264, target=A.Boss})
    end),
    At(11.371, 870, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.00264)
    end),
    At(15.282, 871, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.00264, target=A.Boss})
    end),
    At(16.036, 872, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(16.036, 873, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(16.036, 874, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(16.036, 875, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(16.114, 876, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00024})
    end),
    At(16.114, 877, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78747})
    end),
    At(16.367, 878, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.12102)
    end),
    At(16.689, 879, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.1298)
    end),
    At(18.426, 880, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.1298, target=A.Boss})
    end),
    At(19.139, 881, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(19.139, 882, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(19.139, 883, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(19.139, 884, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(19.202, 885, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.00024})
    end),
    At(19.202, 886, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78747})
    end),
    At(19.403, 887, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(19.403, 888, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(19.403, 889, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=80.0},-5e-05)
    end),
    At(19.403, 890, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(19.403, 891, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(19.403, 892, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=80.0},-5e-05)
    end),
    At(19.403, 893, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(19.403, 894, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(19.403, 895, function(d,s)
        C.Move(d,s,A.Helper28,{x=80.0, y=0.0, z=100.0},1.57077)
    end),
    At(19.403, 896, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(19.403, 897, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(19.403, 898, function(d,s)
        C.Move(d,s,A.Helper27,{x=80.0, y=0.0, z=100.0},1.57077)
    end),
}
