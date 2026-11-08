-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 746, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(0.0, 747, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.0, 748, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.037, 749, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.037, 750, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.073, 751, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.073, 752, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.114, 753, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.114, 754, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.154, 755, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.154, 756, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.217, 757, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.217, 758, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.276, 759, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.276, 760, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.276, 761, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12478)
    end),
    At(0.276, 762, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.356, 763, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12056)
    end),
    At(0.356, 764, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.411, 765, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12056)
    end),
    At(0.411, 766, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.411, 767, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.12056)
    end),
    At(0.411, 768, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.493, 769, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.11328)
    end),
    At(0.493, 770, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.72975)
    end),
    At(0.493, 771, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.66444)
    end),
    At(0.493, 772, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.3651)
    end),
    At(0.554, 773, function(d,s)
        C.Action(d,s,A.Helper13,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.72975, target=A.Helper13})
    end),
    At(0.554, 774, function(d,s)
        C.Action(d,s,A.Helper14,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.3651, target=A.Helper14})
    end),
    At(2.455, 776, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(2.455, 777, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(2.455, 778, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(2.455, 779, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.455, 780, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(2.455, 781, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(2.455, 782, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72506)
    end),
    At(2.535, 783, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72506)
    end),
    At(2.535, 784, function(d,s)
        C.Cast(d,s,A.Helper11,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.72506, target=A.Helper11})
    end),
    At(2.535, 785, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.535, 786, function(d,s)
        C.Cast(d,s,A.Helper12,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=2.27814, target=A.Helper12})
    end),
    At(2.615, 787, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72506)
    end),
    At(2.615, 788, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.672, 789, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72506)
    end),
    At(2.672, 790, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.672, 791, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72525)
    end),
    At(2.672, 792, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.75, 793, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72525)
    end),
    At(2.75, 794, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.813, 795, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.72582)
    end),
    At(2.813, 796, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.813, 797, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(2.813, 798, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.895, 799, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(2.895, 800, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.955, 801, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(2.955, 802, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(2.955, 803, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(2.955, 804, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.029, 805, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.029, 806, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.029, 807, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.029, 808, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.029, 809, function(d,s)
        C.Action(d,s,A.Helper11,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.72506, target=A.Helper11})
    end),
    At(3.029, 810, function(d,s)
        C.Action(d,s,A.Helper12,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.27814, target=A.Helper12})
    end),
    At(3.076, 811, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.076, 812, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.14, 813, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.14, 814, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.208, 815, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.208, 816, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.208, 817, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.208, 818, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.289, 819, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.289, 820, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.347, 821, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.347, 822, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.347, 823, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(3.347, 824, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.421, 825, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75372)
    end),
    At(3.421, 826, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.461, 827, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75372)
    end),
    At(3.461, 828, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(3.479, 829, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75372)
    end),
    At(3.479, 830, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.517, 831, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75372)
    end),
    At(3.517, 832, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.592, 833, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75372)
    end),
    At(3.592, 834, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.633, 835, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.633, 836, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.671, 837, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.671, 838, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.716, 839, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.716, 840, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.756, 841, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.756, 842, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.797, 843, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.797, 844, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.2698)
    end),
    At(3.878, 845, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.878, 846, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(3.878, 847, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75564)
    end),
    At(3.878, 848, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(3.917, 849, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(3.917, 850, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(3.965, 851, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(3.965, 852, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(4.01, 853, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.01, 854, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(4.05, 855, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.05, 856, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(4.144, 857, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.144, 858, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(4.169, 859, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.169, 860, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.95734)
    end),
    At(4.217, 861, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.217, 862, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.26, 863, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.93454)
    end),
    At(4.26, 864, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.279, 865, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.1586)
    end),
    At(4.279, 866, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.319, 867, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.16532)
    end),
    At(4.319, 868, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.364, 869, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.19782)
    end),
    At(4.364, 870, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.402, 871, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.19782)
    end),
    At(4.402, 872, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.445, 873, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.19782)
    end),
    At(4.445, 874, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.521, 875, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.19782)
    end),
    At(4.521, 876, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.64623)
    end),
    At(4.563, 877, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.19782)
    end),
    At(4.563, 878, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.643, 879, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(4.643, 880, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.643, 881, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.643, 882, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.643, 883, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.706, 884, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.706, 885, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.783, 886, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.783, 887, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.783, 888, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.783, 889, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.841, 890, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.841, 891, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.876, 892, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.876, 893, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.59254)
    end),
    At(4.917, 894, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.917, 895, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.63894)
    end),
    At(4.917, 896, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.09787)
    end),
    At(4.956, 897, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.956, 898, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.63894)
    end),
    At(4.991, 899, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(4.991, 900, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.63894)
    end),
    At(5.032, 901, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(5.032, 902, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.63894)
    end),
    At(5.071, 903, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.35649)
    end),
    At(5.071, 904, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.75008)
    end),
    At(5.071, 905, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.63894)
    end),
    At(5.071, 906, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.27814)
    end),
    At(5.112, 907, function(d,s)
        C.Action(d,s,A.Helper11,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.75008, target=A.Helper11})
    end),
    At(5.112, 908, function(d,s)
        C.Action(d,s,A.Helper12,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.27814, target=A.Helper12})
    end),
    At(5.266, 909, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.89711)
    end),
    At(5.266, 910, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(5.266, 911, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(5.266, 912, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-2.89711)
    end),
    At(5.266, 913, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(5.266, 914, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(5.266, 915, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-2.89711)
    end),
    At(5.327, 916, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.89711})
    end),
    At(5.327, 917, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.89711})
    end),
    At(5.551, 918, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.50901)
    end),
    At(5.839, 919, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.16587)
    end),
    At(6.192, 920, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.76511)
    end),
    At(6.482, 922, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.71123)
    end),
    At(6.804, 923, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.79033)
    end),
    At(7.529, 924, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.9257)
    end),
    At(7.779, 925, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.88591, target=A.Boss})
    end),
    At(7.853, 926, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.88591)
    end),
    At(8.143, 927, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.86137)
    end),
    At(8.406, 928, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(8.406, 929, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(8.406, 930, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-1.86137)
    end),
    At(8.406, 931, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(8.406, 932, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(8.406, 933, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.86137)
    end),
    At(8.476, 934, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.86137})
    end),
    At(8.476, 935, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.86137})
    end),
}
