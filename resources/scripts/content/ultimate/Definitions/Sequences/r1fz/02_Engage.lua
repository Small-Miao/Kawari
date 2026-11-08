-- 最终本体出现：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 95, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(0.147, 97, function(d,s)
        C.Timeline(d,s,A.Boss,7747)
    end),
    At(1.268, 98, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.10578)
    end),
    At(1.568, 99, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12922)
    end),
    At(2.317, 100, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.12405)
    end),
    At(4.199, 102, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(4.199, 103, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(4.199, 104, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.1167, y=0.0, z=107.9991},-0.77089)
    end),
    At(4.199, 105, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(4.199, 106, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.8691, y=0.0, z=95.8994},-1.5563)
    end),
    At(4.199, 107, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(4.199, 108, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.0142, y=0.0, z=96.1015},1.58535)
    end),
}
