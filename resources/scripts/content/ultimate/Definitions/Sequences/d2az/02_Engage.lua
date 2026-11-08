-- 最终本体出现：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 51, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(0.15, 52, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.68391)
    end),
    At(0.217, 53, function(d,s)
        C.Spawn(d,s,A.PerfectAlexander02)
    end),
    At(0.217, 54, function(d,s)
        C.Spawn(d,s,A.PerfectAlexander03)
    end),
    At(0.217, 55, function(d,s)
        C.Spawn(d,s,A.PerfectAlexander05)
    end),
    At(0.217, 56, function(d,s)
        C.Spawn(d,s,A.PerfectAlexander04)
    end),
    At(0.433, 57, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.14545)
    end),
    At(0.799, 58, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.09132)
    end),
    At(1.067, 59, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.07659)
    end),
    At(1.367, 60, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12424)
    end),
    At(5.067, 61, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743})
    end),
    At(8.102, 62, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.11743})
    end),
}
