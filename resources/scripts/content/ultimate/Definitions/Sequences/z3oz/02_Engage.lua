-- 最终本体出现：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 26, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(0.0, 27, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(0.0, 28, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(0.0, 29, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(0.0, 30, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(0.0, 31, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(0.0, 34, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(0.044, 35, function(d,s)
        C.Despawn(d,s,A.BossP5)
    end),
    At(0.044, 36, function(d,s)
        C.Despawn(d,s,A.IntermissionOmegaF)
    end),
    At(0.044, 37, function(d,s)
        C.Despawn(d,s,A.IntermissionAlpha)
    end),
    At(1.752, 38, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.06726)
    end),
    At(2.097, 39, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.01443)
    end),
    At(2.413, 40, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12807)
    end),
}
