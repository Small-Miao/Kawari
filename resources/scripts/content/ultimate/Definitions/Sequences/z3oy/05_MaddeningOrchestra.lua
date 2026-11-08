-- 癫狂交响曲 [47952]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 141, function(d,s)
        C.Cast(d,s,A.Boss,47952,4.7,{spell=47952, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.25427, target=A.Boss})
    end),
    At(4.971, 142, function(d,s)
        C.Action(d,s,A.Boss,47952,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.25427, target=A.Boss})
    end),
    At(5.806, 143, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},2.25427)
    end),
    At(5.806, 144, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},2.25427)
    end),
    At(5.806, 145, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.25427)
    end),
    At(5.806, 146, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},2.25427)
    end),
    At(5.806, 147, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.25427)
    end),
    At(5.878, 148, function(d,s)
        C.Action(d,s,A.Helper12,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(5.878, 149, function(d,s)
        C.Action(d,s,A.Helper13,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(5.878, 150, function(d,s)
        C.Action(d,s,A.Helper14,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(5.878, 151, function(d,s)
        C.Action(d,s,A.Helper16,47954,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(5.878, 152, function(d,s)
        C.Action(d,s,A.Helper15,47954,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(8.122, 153, function(d,s)
        C.Action(d,s,A.Boss,47953,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.25427, target=A.Boss})
    end),
    At(9.019, 154, function(d,s)
        C.Action(d,s,A.Helper13,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(9.019, 155, function(d,s)
        C.Action(d,s,A.Helper14,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(9.019, 156, function(d,s)
        C.Action(d,s,A.Helper16,47955,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(9.019, 157, function(d,s)
        C.Action(d,s,A.Helper15,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(11.222, 158, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.81974)
    end),
    At(11.522, 159, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.13977)
    end),
    At(12.546, 160, function(d,s)
        C.Action(d,s,A.Helper16,47958,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(12.546, 161, function(d,s)
        C.Action(d,s,A.Helper15,47957,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.25427})
    end),
    At(16.339, 162, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13977, target=A.Boss})
    end),
    At(17.128, 163, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(17.128, 164, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(17.128, 165, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(17.19, 166, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
    At(17.19, 167, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
    At(17.19, 168, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
    At(19.477, 169, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13977, target=A.Boss})
    end),
    At(20.268, 170, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(20.268, 171, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(20.268, 172, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.13977)
    end),
    At(20.268, 173, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
    At(20.268, 174, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
    At(20.268, 175, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13977})
    end),
}
