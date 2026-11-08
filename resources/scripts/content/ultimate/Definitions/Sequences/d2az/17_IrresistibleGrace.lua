-- 株连 [18580]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1026, function(d,s)
        C.Cast(d,s,A.Boss,18580,4.7,{spell=18580, omen_delay=0, cast_pos={x=107.5303, y=-0.0153, z=100.4501}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.50711})
    end),
    At(0.155, 1027, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.50711)
    end),
    At(1.902, 1028, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(1.902, 1029, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(1.902, 1030, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(1.902, 1031, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(1.902, 1032, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(1.902, 1033, function(d,s)
        C.Move(d,s,A.Helper11,{x=84.0, y=0.0, z=92.0},-5e-05)
    end),
    At(1.902, 1034, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(1.902, 1035, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(1.902, 1036, function(d,s)
        C.Move(d,s,A.Helper10,{x=92.0, y=0.0, z=92.0},-5e-05)
    end),
    At(1.902, 1037, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(1.902, 1038, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(1.902, 1039, function(d,s)
        C.Move(d,s,A.Helper09,{x=116.0, y=0.0, z=100.0},-5e-05)
    end),
    At(1.902, 1040, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(1.902, 1041, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(1.902, 1042, function(d,s)
        C.Move(d,s,A.Helper08,{x=84.0, y=0.0, z=108.0},-5e-05)
    end),
    At(1.902, 1043, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(1.902, 1044, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(1.902, 1045, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(1.902, 1046, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(1.902, 1047, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(1.902, 1048, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=116.0},-5e-05)
    end),
    At(1.902, 1049, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(1.902, 1050, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(1.902, 1051, function(d,s)
        C.Move(d,s,A.Helper05,{x=108.0, y=0.0, z=116.0},-5e-05)
    end),
    At(1.978, 1052, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=84.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(1.978, 1053, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=116.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(1.978, 1054, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=92.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(1.978, 1055, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=84.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(1.978, 1056, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(1.978, 1057, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=108.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(1.978, 1058, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=92.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(1.978, 1059, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(3.89, 1060, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(3.89, 1061, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(3.89, 1062, function(d,s)
        C.Move(d,s,A.Helper12,{x=84.0, y=0.0, z=84.0},-5e-05)
    end),
    At(3.89, 1063, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(3.89, 1064, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(3.89, 1065, function(d,s)
        C.Move(d,s,A.Helper11,{x=116.0, y=0.0, z=84.0},-5e-05)
    end),
    At(3.89, 1066, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(3.89, 1067, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(3.89, 1068, function(d,s)
        C.Move(d,s,A.Helper10,{x=108.0, y=0.0, z=92.0},-5e-05)
    end),
    At(3.89, 1069, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(3.89, 1070, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(3.89, 1071, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.89, 1072, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(3.89, 1073, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(3.89, 1074, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.89, 1075, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(3.89, 1076, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(3.89, 1077, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=100.0},-5e-05)
    end),
    At(3.89, 1078, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(3.89, 1079, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(3.89, 1080, function(d,s)
        C.Move(d,s,A.Helper06,{x=92.0, y=0.0, z=108.0},-5e-05)
    end),
    At(3.89, 1081, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(3.89, 1082, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(3.89, 1083, function(d,s)
        C.Move(d,s,A.Helper05,{x=84.0, y=0.0, z=116.0},-5e-05)
    end),
    At(3.89, 1084, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(3.89, 1085, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(3.89, 1086, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.0, y=0.0, z=116.0},-5e-05)
    end),
    At(3.965, 1087, function(d,s)
        C.Action(d,s,A.Helper08,18576,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(3.965, 1088, function(d,s)
        C.Action(d,s,A.Helper09,18576,{pos={x=92.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(3.965, 1089, function(d,s)
        C.Action(d,s,A.Helper10,18576,{pos={x=108.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(3.965, 1090, function(d,s)
        C.Action(d,s,A.Helper11,18576,{pos={x=116.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(3.965, 1091, function(d,s)
        C.Action(d,s,A.Helper12,18576,{pos={x=84.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(3.965, 1092, function(d,s)
        C.Action(d,s,A.Helper04,18576,{pos={x=116.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(3.965, 1093, function(d,s)
        C.Action(d,s,A.Helper05,18576,{pos={x=84.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(3.965, 1094, function(d,s)
        C.Action(d,s,A.Helper06,18576,{pos={x=92.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(3.965, 1095, function(d,s)
        C.Action(d,s,A.Helper07,18576,{pos={x=108.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(4.989, 1096, function(d,s)
        C.Action(d,s,A.Boss,18580,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.50711})
    end),
    At(8.007, 1097, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.50711})
    end),
    At(8.245, 1098, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.81125)
    end),
    At(9.005, 1099, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.96848)
    end),
    At(9.309, 1100, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.1238)
    end),
    At(9.646, 1101, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.29053)
    end),
    At(9.955, 1102, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.55112)
    end),
    At(10.234, 1103, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.89636)
    end),
    At(10.556, 1104, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.4093)
    end),
    At(10.87, 1105, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.96221)
    end),
    At(10.993, 1106, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.9904})
    end),
    At(11.164, 1107, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.05703)
    end),
    At(11.723, 1108, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.94294)
    end),
}
