-- 最终本体出现：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 43, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(0.197, 44, function(d,s)
        C.Despawn(d,s,A.OracleOfDarknessP4)
    end),
    At(0.197, 45, function(d,s)
        C.Despawn(d,s,A.UsurperOfFrostP4)
    end),
    At(3.16, 47, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347, target=A.Boss})
    end),
    At(3.803, 48, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(3.803, 49, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-0.01347)
    end),
    At(3.803, 50, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(3.803, 51, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-0.01347)
    end),
    At(3.858, 52, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347})
    end),
    At(3.858, 53, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347})
    end),
}
