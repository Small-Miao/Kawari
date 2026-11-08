-- 未来观测β [19219]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 466, function(d,s)
        C.Cast(d,s,A.Boss,19219,4.7,{spell=19219, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(0.0, 467, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-5e-05)
    end),
    At(4.701, 468, function(d,s)
        C.Action(d,s,A.Boss,19219,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(5.816, 469, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=121.7112, y=0.0, z=91.0069},-1.17816)
    end),
    At(5.816, 470, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=108.9931, y=0.0, z=78.2888},-0.39275)
    end),
    At(5.816, 471, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=78.2888, y=0.0, z=91.0069},1.17807)
    end),
    At(5.816, 472, function(d,s)
        C.Move(d,s,A.PerfectAlexander02,{x=91.0069, y=0.0, z=78.2888},0.39266)
    end),
    At(5.849, 477, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
    At(5.9, 478, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7747)
    end),
    At(5.9, 479, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7747)
    end),
    At(5.9, 480, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7747)
    end),
    At(5.9, 481, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7747)
    end),
    At(6.234, 482, function(d,s)
        C.Spawn(d,s,A.FateProjection09)
    end),
    At(6.234, 483, function(d,s)
        C.Spawn(d,s,A.FateProjection10)
    end),
    At(6.234, 484, function(d,s)
        C.Spawn(d,s,A.FateProjection11)
    end),
    At(6.234, 485, function(d,s)
        C.Spawn(d,s,A.FateProjection12)
    end),
    At(6.234, 486, function(d,s)
        C.Spawn(d,s,A.FateProjection13)
    end),
    At(6.234, 487, function(d,s)
        C.Spawn(d,s,A.FateProjection14)
    end),
    At(6.234, 488, function(d,s)
        C.Spawn(d,s,A.FateProjection15)
    end),
    At(6.234, 489, function(d,s)
        C.Spawn(d,s,A.FateProjection16)
    end),
}
