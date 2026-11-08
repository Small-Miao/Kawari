-- 宇宙天箭 [31650]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 899, function(d,s)
        C.Cast(d,s,A.Helper28,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=79.9725, y=-0.0153, z=99.9924}, pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper28})
    end),
    At(0.0, 900, function(d,s)
        C.Cast(d,s,A.Helper27,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=79.9725, y=-0.0153, z=99.9924}, pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper27})
    end),
    At(0.0, 901, function(d,s)
        C.Cast(d,s,A.Helper30,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=79.9725}, pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper30})
    end),
    At(0.0, 902, function(d,s)
        C.Cast(d,s,A.Helper29,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=99.9924, y=-0.0153, z=79.9725}, pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(0.0, 903, function(d,s)
        C.Cast(d,s,A.Boss,31650,5.7,{spell=31650, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.1298, target=A.Boss})
    end),
    At(1.901, 904, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(1.901, 905, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(1.901, 906, function(d,s)
        C.Move(d,s,A.Helper32,{x=85.0, y=0.0, z=80.0},-5e-05)
    end),
    At(1.901, 907, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(1.901, 908, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(1.901, 909, function(d,s)
        C.Move(d,s,A.Helper31,{x=85.0, y=0.0, z=80.0},-5e-05)
    end),
    At(1.901, 910, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(1.901, 911, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(1.901, 912, function(d,s)
        C.Move(d,s,A.Helper26,{x=120.0, y=0.0, z=85.0},-1.57087)
    end),
    At(1.901, 913, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(1.901, 914, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(1.901, 915, function(d,s)
        C.Move(d,s,A.Helper25,{x=120.0, y=0.0, z=85.0},-1.57087)
    end),
    At(1.901, 916, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(1.901, 917, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(1.901, 918, function(d,s)
        C.Move(d,s,A.Helper24,{x=115.0, y=0.0, z=120.0},-3.14159)
    end),
    At(1.901, 919, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(1.901, 920, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(1.901, 921, function(d,s)
        C.Move(d,s,A.Helper23,{x=115.0, y=0.0, z=120.0},-3.14159)
    end),
    At(1.901, 922, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(1.901, 923, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(1.901, 924, function(d,s)
        C.Move(d,s,A.Helper22,{x=80.0, y=0.0, z=115.0},1.57077)
    end),
    At(1.901, 925, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(1.901, 926, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(1.901, 927, function(d,s)
        C.Move(d,s,A.Helper21,{x=80.0, y=0.0, z=115.0},1.57077)
    end),
    At(1.974, 928, function(d,s)
        C.Cast(d,s,A.Helper21,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=79.9725, y=-0.0153, z=114.9767}, pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper21})
    end),
    At(1.974, 929, function(d,s)
        C.Cast(d,s,A.Helper22,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=79.9725, y=-0.0153, z=114.9767}, pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper22})
    end),
    At(1.974, 930, function(d,s)
        C.Cast(d,s,A.Helper24,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=114.9767, y=-0.0153, z=119.9817}, pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper24})
    end),
    At(1.974, 931, function(d,s)
        C.Cast(d,s,A.Helper23,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=114.9767, y=-0.0153, z=119.9817}, pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper23})
    end),
    At(1.974, 932, function(d,s)
        C.Cast(d,s,A.Helper26,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=119.9817, y=-0.0153, z=84.9775}, pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper26})
    end),
    At(1.974, 933, function(d,s)
        C.Cast(d,s,A.Helper25,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=119.9817, y=-0.0153, z=84.9775}, pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper25})
    end),
    At(1.974, 934, function(d,s)
        C.Cast(d,s,A.Helper31,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=84.9775, y=-0.0153, z=79.9725}, pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper31})
    end),
    At(1.974, 935, function(d,s)
        C.Cast(d,s,A.Helper32,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=84.9775, y=-0.0153, z=79.9725}, pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(5.519, 936, function(d,s)
        C.Action(d,s,A.Helper28,32337,{pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper28})
    end),
    At(5.519, 937, function(d,s)
        C.Action(d,s,A.Helper30,32337,{pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper30})
    end),
    At(5.996, 938, function(d,s)
        C.Action(d,s,A.Boss,31650,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.1298, target=A.Boss})
    end),
    At(7.476, 939, function(d,s)
        C.Action(d,s,A.Helper22,32337,{pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper22})
    end),
    At(7.476, 940, function(d,s)
        C.Action(d,s,A.Helper24,32337,{pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper24})
    end),
    At(7.476, 941, function(d,s)
        C.Action(d,s,A.Helper26,32337,{pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper26})
    end),
    At(7.476, 942, function(d,s)
        C.Action(d,s,A.Helper32,32337,{pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(7.994, 943, function(d,s)
        C.Action(d,s,A.Helper27,31651,{pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper27})
    end),
    At(7.994, 944, function(d,s)
        C.Action(d,s,A.Helper29,31651,{pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(9.97, 945, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(9.97, 946, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(9.97, 947, function(d,s)
        C.Move(d,s,A.Helper32,{x=92.5, y=0.0, z=80.0},-5e-05)
    end),
    At(9.97, 948, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(9.97, 949, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(9.97, 950, function(d,s)
        C.Move(d,s,A.Helper30,{x=107.5, y=0.0, z=80.0},-5e-05)
    end),
    At(9.97, 951, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(9.97, 952, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(9.97, 953, function(d,s)
        C.Move(d,s,A.Helper28,{x=79.9999, y=-0.0, z=92.5},1.57077)
    end),
    At(9.97, 954, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(9.97, 955, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(9.97, 956, function(d,s)
        C.Move(d,s,A.Helper26,{x=80.0, y=-0.0, z=107.5},1.57077)
    end),
    At(9.97, 957, function(d,s)
        C.Action(d,s,A.Helper21,31651,{pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper21})
    end),
    At(9.97, 958, function(d,s)
        C.Action(d,s,A.Helper23,31651,{pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper23})
    end),
    At(9.97, 959, function(d,s)
        C.Action(d,s,A.Helper25,31651,{pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper25})
    end),
    At(9.97, 960, function(d,s)
        C.Action(d,s,A.Helper31,31651,{pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper31})
    end),
    At(10.036, 961, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=80.0, y=-0.0, z=107.5}, rotation=1.57077, target=A.Helper26})
    end),
    At(10.036, 962, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=79.9999, y=-0.0, z=92.5}, rotation=1.57077, target=A.Helper28})
    end),
    At(10.036, 963, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=107.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper30})
    end),
    At(10.036, 964, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=92.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(11.948, 965, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(11.948, 966, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(11.948, 967, function(d,s)
        C.Move(d,s,A.Helper29,{x=87.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(11.948, 968, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(11.948, 969, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(11.948, 970, function(d,s)
        C.Move(d,s,A.Helper27,{x=112.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(11.948, 971, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(11.948, 972, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(11.948, 973, function(d,s)
        C.Move(d,s,A.Helper24,{x=80.0, y=-0.0, z=87.5},1.57077)
    end),
    At(11.948, 974, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(11.948, 975, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(11.948, 976, function(d,s)
        C.Move(d,s,A.Helper22,{x=80.0, y=-0.0, z=112.5},1.57077)
    end),
    At(11.948, 977, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(11.948, 978, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(11.948, 979, function(d,s)
        C.Move(d,s,A.Helper20,{x=92.5, y=0.0, z=80.0},-5e-05)
    end),
    At(11.948, 980, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(11.948, 981, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(11.948, 982, function(d,s)
        C.Move(d,s,A.Helper19,{x=120.0, y=0.0, z=92.5},-1.57087)
    end),
    At(11.948, 983, function(d,s)
        C.Owner(d,s,A.Helper18,nil)
    end),
    At(11.948, 984, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(11.948, 985, function(d,s)
        C.Move(d,s,A.Helper18,{x=107.5, y=0.0, z=120.0},-3.14159)
    end),
    At(11.948, 986, function(d,s)
        C.Owner(d,s,A.Helper17,nil)
    end),
    At(11.948, 987, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(11.948, 988, function(d,s)
        C.Move(d,s,A.Helper17,{x=80.0, y=0.0, z=107.5},1.57077)
    end),
    At(12.041, 989, function(d,s)
        C.Action(d,s,A.Helper17,31652,{pos={x=80.0, y=0.0, z=107.5}, rotation=1.57077, target=A.Helper17})
    end),
    At(12.041, 990, function(d,s)
        C.Action(d,s,A.Helper18,31652,{pos={x=107.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper18})
    end),
    At(12.041, 991, function(d,s)
        C.Action(d,s,A.Helper20,31652,{pos={x=92.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper20})
    end),
    At(12.041, 992, function(d,s)
        C.Action(d,s,A.Helper22,31652,{pos={x=80.0, y=-0.0, z=112.5}, rotation=1.57077, target=A.Helper22})
    end),
    At(12.041, 993, function(d,s)
        C.Action(d,s,A.Helper24,31652,{pos={x=80.0, y=-0.0, z=87.5}, rotation=1.57077, target=A.Helper24})
    end),
    At(12.041, 994, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=112.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper27})
    end),
    At(12.041, 995, function(d,s)
        C.Action(d,s,A.Helper19,31652,{pos={x=120.0, y=0.0, z=92.5}, rotation=-1.57087, target=A.Helper19})
    end),
    At(12.041, 996, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=87.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(13.952, 997, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(13.952, 998, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(13.952, 999, function(d,s)
        C.Move(d,s,A.Helper32,{x=82.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(13.952, 1000, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(13.952, 1001, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(13.952, 1002, function(d,s)
        C.Move(d,s,A.Helper31,{x=117.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(13.952, 1003, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(13.952, 1004, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(13.952, 1005, function(d,s)
        C.Move(d,s,A.Helper30,{x=80.0, y=-0.0, z=82.5},1.57077)
    end),
    At(13.952, 1006, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(13.952, 1007, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(13.952, 1008, function(d,s)
        C.Move(d,s,A.Helper28,{x=80.0, y=-0.0, z=117.5},1.57077)
    end),
    At(13.952, 1009, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(13.952, 1010, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(13.952, 1011, function(d,s)
        C.Move(d,s,A.Helper26,{x=97.5, y=0.0, z=80.0},-5e-05)
    end),
    At(13.952, 1012, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(13.952, 1013, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(13.952, 1014, function(d,s)
        C.Move(d,s,A.Helper25,{x=120.0, y=0.0, z=97.5},-1.57087)
    end),
    At(13.952, 1015, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(13.952, 1016, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(13.952, 1017, function(d,s)
        C.Move(d,s,A.Helper23,{x=102.5, y=0.0, z=120.0},-3.14159)
    end),
    At(13.952, 1018, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(13.952, 1019, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(13.952, 1020, function(d,s)
        C.Move(d,s,A.Helper21,{x=80.0, y=0.0, z=102.5},1.57077)
    end),
    At(14.042, 1021, function(d,s)
        C.Action(d,s,A.Helper21,31652,{pos={x=80.0, y=0.0, z=102.5}, rotation=1.57077, target=A.Helper21})
    end),
    At(14.042, 1022, function(d,s)
        C.Action(d,s,A.Helper23,31652,{pos={x=102.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper23})
    end),
    At(14.042, 1023, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=97.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper26})
    end),
    At(14.042, 1024, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=80.0, y=-0.0, z=117.5}, rotation=1.57077, target=A.Helper28})
    end),
    At(14.042, 1025, function(d,s)
        C.Action(d,s,A.Helper25,31652,{pos={x=120.0, y=0.0, z=97.5}, rotation=-1.57087, target=A.Helper25})
    end),
    At(14.042, 1026, function(d,s)
        C.Action(d,s,A.Helper31,31652,{pos={x=117.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper31})
    end),
    At(14.042, 1027, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=80.0, y=-0.0, z=82.5}, rotation=1.57077, target=A.Helper30})
    end),
    At(14.042, 1028, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=82.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
}
