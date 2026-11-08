-- 光与暗的孤翼 [40313]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1237, function(d,s)
        C.Cast(d,s,A.Boss,40313,6.6,{spell=40313, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.08691, target=A.Boss})
    end),
    At(6.831, 1245, function(d,s)
        C.Action(d,s,A.Boss,40313,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.08691, target=A.Boss})
    end),
    At(7.11, 1246, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.03157)
    end),
    At(7.178, 1247, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(7.178, 1248, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(7.178, 1249, function(d,s)
        C.Move(d,s,A.Helper14,{x=106.0622, y=0.0, z=96.5},-1.0472)
    end),
    At(7.255, 1251, function(d,s)
        C.Action(d,s,A.Boss,40314,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.04538, target=A.Boss})
    end),
    At(7.255, 1252, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=106.0622, y=0.0, z=96.5}, rotation=-1.0472, target=A.Helper14})
    end),
    At(8.014, 1253, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(8.014, 1254, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(8.014, 1255, function(d,s)
        C.Action(d,s,A.Helper13,39879,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.08691})
    end),
    At(8.607, 1256, function(d,s)
        C.Untether(d,s,A.Boss,0,0)
    end),
    At(10.707, 1259, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(10.707, 1260, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(10.707, 1261, function(d,s)
        C.Move(d,s,A.Helper14,{x=93.9378, y=0.0, z=96.5},1.0472)
    end),
    At(10.787, 1263, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=93.9378, y=0.0, z=96.5}, rotation=1.0472, target=A.Helper14})
    end),
    At(10.997, 1264, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.92683)
    end),
    At(11.052, 1265, function(d,s)
        C.Action(d,s,A.Boss,40315,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.92683, target=A.Boss})
    end),
    At(11.832, 1266, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(11.832, 1267, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.832, 1268, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.906, 1269, function(d,s)
        C.Action(d,s,A.Helper13,39880,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.08691})
    end),
    At(12.301, 1270, function(d,s)
        C.Untether(d,s,A.Boss,0,0)
    end),
    At(14.146, 1271, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.146, 1272, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.146, 1273, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=107.0},-3.14159)
    end),
    At(14.236, 1275, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=100.0, y=0.0, z=107.0}, rotation=-3.14159, target=A.Helper14})
    end),
    At(14.689, 1276, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.11149)
    end),
}
