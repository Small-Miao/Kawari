-- 洪水 [49471]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 80, function(d,s)
        C.Cast(d,s,A.Boss,49471,4.7,{spell=49471, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11446, target=A.Boss})
    end),
    At(0.0, 81, function(d,s)
        C.Move(d,s,A.Helper13,{x=96.4645, y=0.0, z=96.4645},-0.78546)
    end),
    At(0.0, 82, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(0.0, 83, function(d,s)
        C.Move(d,s,A.Helper12,{x=110.6066, y=0.0, z=110.6066},-0.78546)
    end),
    At(0.063, 84, function(d,s)
        C.Cast(d,s,A.Helper12,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=124.7425, y=-0.0153, z=96.4523}, pos={x=110.6066, y=0.0, z=110.6066}, rotation=-0.78546, target=A.Helper12})
    end),
    At(0.063, 85, function(d,s)
        C.Cast(d,s,A.Helper13,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=110.5821, y=-0.0153, z=82.2919}, pos={x=96.4645, y=0.0, z=96.4645}, rotation=-0.78546, target=A.Helper13})
    end),
    At(0.997, 86, function(d,s)
        C.Move(d,s,A.Helper16,{x=96.4645, y=0.0, z=103.5355},0.78536)
    end),
    At(0.997, 87, function(d,s)
        C.Move(d,s,A.Helper15,{x=110.6066, y=0.0, z=89.3934},0.78536)
    end),
    At(1.085, 88, function(d,s)
        C.Cast(d,s,A.Helper16,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=82.2919, y=-0.0153, z=89.3721}, pos={x=96.4645, y=0.0, z=103.5355}, rotation=0.78536, target=A.Helper16})
    end),
    At(1.085, 89, function(d,s)
        C.Cast(d,s,A.Helper15,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=96.4523, y=-0.0153, z=75.2422}, pos={x=110.6066, y=0.0, z=89.3934}, rotation=0.78536, target=A.Helper15})
    end),
    At(1.551, 90, function(d,s)
        C.Action(d,s,A.Helper12,49539,{pos={x=110.6066, y=0.0, z=110.6066}, rotation=-0.78546, target=A.Helper12})
    end),
    At(1.551, 91, function(d,s)
        C.Action(d,s,A.Helper13,49539,{pos={x=96.4645, y=0.0, z=96.4645}, rotation=-0.78546, target=A.Helper13})
    end),
    At(1.983, 92, function(d,s)
        C.Move(d,s,A.Helper14,{x=89.3934, y=0.0, z=89.3934},-0.78546)
    end),
    At(1.983, 93, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(1.983, 94, function(d,s)
        C.Move(d,s,A.Helper11,{x=103.5355, y=0.0, z=103.5355},-0.78546)
    end),
    At(2.118, 95, function(d,s)
        C.Cast(d,s,A.Helper11,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=117.6623, y=-0.0153, z=89.3721}, pos={x=103.5355, y=0.0, z=103.5355}, rotation=-0.78546, target=A.Helper11})
    end),
    At(2.118, 96, function(d,s)
        C.Cast(d,s,A.Helper14,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=103.5325, y=-0.0153, z=75.2422}, pos={x=89.3934, y=0.0, z=89.3934}, rotation=-0.78546, target=A.Helper14})
    end),
    At(2.586, 97, function(d,s)
        C.Action(d,s,A.Helper16,49539,{pos={x=96.4645, y=0.0, z=103.5355}, rotation=0.78536, target=A.Helper16})
    end),
    At(2.586, 98, function(d,s)
        C.Action(d,s,A.Helper15,49539,{pos={x=110.6066, y=0.0, z=89.3934}, rotation=0.78536, target=A.Helper15})
    end),
    At(3.024, 99, function(d,s)
        C.Move(d,s,A.Helper13,{x=89.3934, y=0.0, z=110.6066},0.78536)
    end),
    At(3.024, 100, function(d,s)
        C.Move(d,s,A.Helper12,{x=103.5355, y=0.0, z=96.4645},0.78536)
    end),
    At(3.145, 101, function(d,s)
        C.Cast(d,s,A.Helper12,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=89.3721, y=-0.0153, z=82.2919}, pos={x=103.5355, y=0.0, z=96.4645}, rotation=0.78536, target=A.Helper12})
    end),
    At(3.145, 102, function(d,s)
        C.Cast(d,s,A.Helper13,49539,1.2,{spell=49539, omen_delay=0, cast_pos={x=75.2422, y=-0.0153, z=96.4523}, pos={x=89.3934, y=0.0, z=110.6066}, rotation=0.78536, target=A.Helper13})
    end),
    At(3.538, 103, function(d,s)
        C.Action(d,s,A.Helper11,49539,{pos={x=103.5355, y=0.0, z=103.5355}, rotation=-0.78546, target=A.Helper11})
    end),
    At(3.538, 104, function(d,s)
        C.Action(d,s,A.Helper14,49539,{pos={x=89.3934, y=0.0, z=89.3934}, rotation=-0.78546, target=A.Helper14})
    end),
    At(4.557, 105, function(d,s)
        C.Action(d,s,A.Helper12,49539,{pos={x=103.5355, y=0.0, z=96.4645}, rotation=0.78536, target=A.Helper12})
    end),
    At(4.557, 106, function(d,s)
        C.Action(d,s,A.Helper13,49539,{pos={x=89.3934, y=0.0, z=110.6066}, rotation=0.78536, target=A.Helper13})
    end),
    At(4.967, 107, function(d,s)
        C.Action(d,s,A.Boss,49471,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.11446, target=A.Boss})
    end),
    At(5.831, 108, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(5.962, 109, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(6.023, 110, function(d,s)
        C.Action(d,s,A.Helper16,47951,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(6.023, 111, function(d,s)
        C.Move(d,s,A.Helper14,{x=96.4645, y=0.0, z=96.4645},-0.78546)
    end),
    At(6.023, 112, function(d,s)
        C.Move(d,s,A.Helper13,{x=110.6066, y=0.0, z=110.6066},-0.78546)
    end),
    At(6.082, 113, function(d,s)
        C.Action(d,s,A.Helper13,49769,{pos={x=110.6066, y=0.0, z=110.6066}, rotation=-0.78546, target=A.Helper13})
    end),
    At(6.082, 114, function(d,s)
        C.Action(d,s,A.Helper14,49769,{pos={x=96.4645, y=0.0, z=96.4645}, rotation=-0.78546, target=A.Helper14})
    end),
    At(6.928, 115, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(7.009, 116, function(d,s)
        C.Action(d,s,A.Helper15,47951,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(7.009, 117, function(d,s)
        C.Move(d,s,A.Helper16,{x=96.4645, y=0.0, z=103.5355},0.78536)
    end),
    At(7.009, 118, function(d,s)
        C.Move(d,s,A.Helper11,{x=110.6066, y=0.0, z=89.3934},0.78536)
    end),
    At(7.111, 119, function(d,s)
        C.Action(d,s,A.Helper11,49769,{pos={x=110.6066, y=0.0, z=89.3934}, rotation=0.78536, target=A.Helper11})
    end),
    At(7.111, 120, function(d,s)
        C.Action(d,s,A.Helper16,49769,{pos={x=96.4645, y=0.0, z=103.5355}, rotation=0.78536, target=A.Helper16})
    end),
    At(7.965, 121, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-3.11446)
    end),
    At(8.045, 122, function(d,s)
        C.Action(d,s,A.Helper12,47951,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(8.045, 123, function(d,s)
        C.Move(d,s,A.Helper15,{x=89.3934, y=0.0, z=89.3934},-0.78546)
    end),
    At(8.045, 124, function(d,s)
        C.Move(d,s,A.Helper13,{x=103.5355, y=0.0, z=103.5355},-0.78546)
    end),
    At(8.124, 125, function(d,s)
        C.Action(d,s,A.Helper13,49769,{pos={x=103.5355, y=0.0, z=103.5355}, rotation=-0.78546, target=A.Helper13})
    end),
    At(8.124, 126, function(d,s)
        C.Action(d,s,A.Helper15,49769,{pos={x=89.3934, y=0.0, z=89.3934}, rotation=-0.78546, target=A.Helper15})
    end),
    At(8.124, 127, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.91034)
    end),
    At(8.442, 128, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.26577)
    end),
    At(8.747, 129, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.65802)
    end),
    At(9.068, 130, function(d,s)
        C.Action(d,s,A.Helper14,47951,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.11446})
    end),
    At(9.068, 131, function(d,s)
        C.Move(d,s,A.Helper16,{x=89.3934, y=0.0, z=110.6066},0.78536)
    end),
    At(9.068, 132, function(d,s)
        C.Move(d,s,A.Helper12,{x=103.5355, y=0.0, z=96.4645},0.78536)
    end),
    At(9.199, 133, function(d,s)
        C.Action(d,s,A.Helper12,49769,{pos={x=103.5355, y=0.0, z=96.4645}, rotation=0.78536, target=A.Helper12})
    end),
    At(9.199, 134, function(d,s)
        C.Action(d,s,A.Helper16,49769,{pos={x=89.3934, y=0.0, z=110.6066}, rotation=0.78536, target=A.Helper16})
    end),
    At(10.905, 135, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.8003)
    end),
    At(11.394, 136, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.41323)
    end),
    At(11.724, 137, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.93268)
    end),
    At(12.253, 138, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.37229)
    end),
    At(12.564, 139, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.40824)
    end),
    At(13.093, 140, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.25427)
    end),
}
