-- 癫狂交响曲 [47952]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 484, function(d,s)
        C.Cast(d,s,A.Boss,47952,4.7,{spell=47952, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12443, target=A.Boss})
    end),
    At(4.97, 485, function(d,s)
        C.Action(d,s,A.Boss,47952,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12443, target=A.Boss})
    end),
    At(5.86, 486, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.12443)
    end),
    At(5.86, 487, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.12443)
    end),
    At(5.86, 488, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.12443)
    end),
    At(5.86, 489, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-3.12443)
    end),
    At(5.86, 490, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},-3.12443)
    end),
    At(5.92, 491, function(d,s)
        C.Action(d,s,A.Helper12,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(5.92, 492, function(d,s)
        C.Action(d,s,A.Helper13,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(5.92, 493, function(d,s)
        C.Action(d,s,A.Helper14,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(5.92, 494, function(d,s)
        C.Action(d,s,A.Helper16,47954,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(5.92, 495, function(d,s)
        C.Action(d,s,A.Helper15,47954,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(8.147, 496, function(d,s)
        C.Action(d,s,A.Boss,47953,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12443, target=A.Boss})
    end),
    At(9.044, 497, function(d,s)
        C.Action(d,s,A.Helper13,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(9.044, 498, function(d,s)
        C.Action(d,s,A.Helper14,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(9.044, 499, function(d,s)
        C.Action(d,s,A.Helper16,47955,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(9.044, 500, function(d,s)
        C.Action(d,s,A.Helper15,47956,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(11.365, 501, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.13622)
    end),
    At(12.531, 502, function(d,s)
        C.Action(d,s,A.Helper16,47957,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(12.531, 503, function(d,s)
        C.Action(d,s,A.Helper15,47958,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(16.388, 504, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13622, target=A.Boss})
    end),
    At(17.156, 505, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(17.156, 506, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(17.156, 507, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(17.224, 508, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(17.224, 509, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(17.224, 510, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(19.546, 511, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13622, target=A.Boss})
    end),
    At(20.285, 512, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(20.285, 513, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(20.285, 514, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(20.344, 515, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(20.344, 516, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(20.344, 517, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(22.654, 518, function(d,s)
        C.Action(d,s,A.Boss,50770,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13622, target=A.Boss})
    end),
    At(23.416, 519, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(23.416, 520, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(23.416, 521, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},3.13622)
    end),
    At(23.483, 522, function(d,s)
        C.Action(d,s,A.Helper14,50772,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(23.483, 523, function(d,s)
        C.Action(d,s,A.Helper16,50771,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
    At(23.483, 524, function(d,s)
        C.Action(d,s,A.Helper15,50773,{pos={x=100.0, y=0.0, z=100.0}, rotation=3.13622})
    end),
}
