-- 未来观测α [18555]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 163, function(d,s)
        C.Cast(d,s,A.Boss,18555,4.7,{spell=18555, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(0.132, 164, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-5e-05)
    end),
    At(5.065, 165, function(d,s)
        C.Action(d,s,A.Boss,18555,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(6.18, 166, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=78.2888, y=0.0, z=91.0069},1.17807)
    end),
    At(6.18, 167, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=91.0069, y=0.0, z=78.2888},0.39266)
    end),
    At(6.18, 168, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=108.9931, y=0.0, z=78.2888},-0.39275)
    end),
    At(6.18, 169, function(d,s)
        C.Move(d,s,A.PerfectAlexander02,{x=121.7112, y=0.0, z=91.0069},-1.17816)
    end),
    At(6.198, 174, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
    At(6.248, 175, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7747)
    end),
    At(6.248, 176, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7747)
    end),
    At(6.248, 177, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7747)
    end),
    At(6.248, 178, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7747)
    end),
    At(6.447, 179, function(d,s)
        C.Spawn(d,s,A.FateProjection02)
    end),
    At(6.447, 180, function(d,s)
        C.Spawn(d,s,A.FateProjection01)
    end),
    At(6.447, 181, function(d,s)
        C.Spawn(d,s,A.FateProjection04)
    end),
    At(6.447, 182, function(d,s)
        C.Spawn(d,s,A.FateProjection03)
    end),
    At(6.447, 183, function(d,s)
        C.Spawn(d,s,A.FateProjection07)
    end),
    At(6.447, 184, function(d,s)
        C.Spawn(d,s,A.FateProjection05)
    end),
    At(6.447, 185, function(d,s)
        C.Spawn(d,s,A.FateProjection06)
    end),
    At(6.447, 186, function(d,s)
        C.Spawn(d,s,A.FateProjection08)
    end),
}
