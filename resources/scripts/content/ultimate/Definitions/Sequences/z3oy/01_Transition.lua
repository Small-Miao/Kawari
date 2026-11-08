-- 木桩后转场：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.045, 1, function(d,s)
        C.Spawn(d,s,A.Boss)
    end),
    At(1.018, 2, function(d,s)
        C.Move(d,s,A.KefkaP4,{x=99.9924, y=-0.0153, z=99.9924},3.10746)
    end),
    At(1.259, 3, function(d,s)
        C.Cast(d,s,A.KefkaP4,49738,4.7,{spell=49738, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.KefkaP4})
    end),
    At(1.384, 4, function(d,s)
        C.Move(d,s,A.KefkaP4,{x=99.9924, y=-0.0153, z=99.9924},3.14159)
    end),
    At(6.22, 5, function(d,s)
        C.Action(d,s,A.KefkaP4,49738,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.KefkaP4})
    end),
    At(6.22, 7, function(d,s)
        C.Targetable(d,s,A.KefkaP4,false)
    end),
    At(9.473, 25, function(d,s)
        C.Move(d,s,A.KefkaP4,{x=99.9924, y=-0.0153, z=99.9924},-0.91738)
    end),
    At(9.559, 26, function(d,s)
        C.SynchronizedTimelines(d,s,{{A.Boss,4561}, {A.KefkaP4,4579}})
    end),
    At(9.777, 27, function(d,s)
        C.Move(d,s,A.KefkaP4,{x=99.9924, y=-0.0153, z=99.9924},-5e-05)
    end),
    At(37.049, 32, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(37.049, 33, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(37.049, 34, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(37.049, 35, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(37.049, 36, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(37.049, 37, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(37.11, 38, function(d,s)
        C.Despawn(d,s,A.KefkaP4)
    end),
}
