-- 混沌涡旋 [47934]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 436, function(d,s)
        C.Action(d,s,A.Helper13,47933,{pos={x=110.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper13})
    end),
    At(0.0, 437, function(d,s)
        C.Action(d,s,A.Helper14,47933,{pos={x=95.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper14})
    end),
    At(0.0, 438, function(d,s)
        C.Cast(d,s,A.Boss,47934,4.7,{spell=47934, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(0.326, 439, function(d,s)
        C.Action(d,s,A.Helper12,47932,{pos={x=115.0, y=0.0, z=80.0}, rotation=-0.78546, target=A.Helper12})
    end),
    At(0.326, 440, function(d,s)
        C.Action(d,s,A.Helper11,47932,{pos={x=130.0, y=0.0, z=95.0}, rotation=-0.78546, target=A.Helper11})
    end),
    At(0.457, 441, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=115.0},-5e-05)
    end),
    At(0.457, 442, function(d,s)
        C.Move(d,s,A.Helper10,{x=115.0, y=0.0, z=100.0},-5e-05)
    end),
    At(0.543, 443, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=100.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.543, 444, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=115.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.857, 445, function(d,s)
        C.Move(d,s,A.Helper07,{x=125.0, y=0.0, z=100.0},-5e-05)
    end),
    At(0.857, 446, function(d,s)
        C.Move(d,s,A.Helper08,{x=110.0, y=0.0, z=85.0},-5e-05)
    end),
    At(0.943, 447, function(d,s)
        C.Action(d,s,A.Helper08,47933,{pos={x=110.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.943, 448, function(d,s)
        C.Action(d,s,A.Helper07,47933,{pos={x=125.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(0.992, 449, function(d,s)
        C.Move(d,s,A.Helper05,{x=120.0, y=0.0, z=105.0},-5e-05)
    end),
    At(0.992, 450, function(d,s)
        C.Move(d,s,A.Helper06,{x=105.0, y=0.0, z=120.0},-5e-05)
    end),
    At(1.113, 451, function(d,s)
        C.Action(d,s,A.Helper05,47933,{pos={x=120.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(1.113, 452, function(d,s)
        C.Action(d,s,A.Helper06,47933,{pos={x=105.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(1.361, 453, function(d,s)
        C.Move(d,s,A.Helper15,{x=105.0, y=0.0, z=90.0},-5e-05)
    end),
    At(1.361, 454, function(d,s)
        C.Move(d,s,A.Helper16,{x=120.0, y=0.0, z=105.0},-5e-05)
    end),
    At(1.49, 455, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=120.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(1.49, 456, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=105.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(1.939, 457, function(d,s)
        C.Move(d,s,A.Helper13,{x=115.0, y=0.0, z=110.0},-5e-05)
    end),
    At(1.939, 458, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=95.0},-5e-05)
    end),
    At(2.002, 459, function(d,s)
        C.Action(d,s,A.Helper13,47933,{pos={x=115.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper13})
    end),
    At(2.002, 460, function(d,s)
        C.Action(d,s,A.Helper14,47933,{pos={x=100.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper14})
    end),
    At(2.432, 461, function(d,s)
        C.Move(d,s,A.Helper11,{x=95.0, y=0.0, z=100.0},-5e-05)
    end),
    At(2.432, 462, function(d,s)
        C.Move(d,s,A.Helper12,{x=110.0, y=0.0, z=115.0},-5e-05)
    end),
    At(2.52, 463, function(d,s)
        C.Action(d,s,A.Helper12,47933,{pos={x=110.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(2.52, 464, function(d,s)
        C.Action(d,s,A.Helper11,47933,{pos={x=95.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(2.964, 465, function(d,s)
        C.Move(d,s,A.Helper09,{x=105.0, y=0.0, z=120.0},-5e-05)
    end),
    At(2.964, 466, function(d,s)
        C.Move(d,s,A.Helper10,{x=90.0, y=0.0, z=105.0},-5e-05)
    end),
    At(3.053, 467, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=105.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(3.053, 468, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=90.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(3.447, 469, function(d,s)
        C.Move(d,s,A.Helper15,{x=85.0, y=0.0, z=110.0},-5e-05)
    end),
    At(3.447, 470, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=0.0, z=125.0},-5e-05)
    end),
    At(3.578, 471, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=100.0, y=0.0, z=125.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(3.578, 472, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=85.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(4.968, 473, function(d,s)
        C.Action(d,s,A.Boss,47934,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(5.869, 474, function(d,s)
        C.Action(d,s,A.Helper09,47935,{pos={x=105.0, y=0.0, z=120.0}, rotation=-5e-05})
    end),
    At(5.869, 475, function(d,s)
        C.Action(d,s,A.Helper10,47935,{pos={x=90.0, y=0.0, z=105.0}, rotation=-5e-05})
    end),
    At(5.869, 476, function(d,s)
        C.Action(d,s,A.Helper12,47935,{pos={x=110.0, y=0.0, z=115.0}, rotation=-5e-05})
    end),
    At(5.869, 477, function(d,s)
        C.Action(d,s,A.Helper13,47935,{pos={x=115.0, y=0.0, z=110.0}, rotation=-5e-05})
    end),
    At(5.869, 478, function(d,s)
        C.Action(d,s,A.Helper11,47935,{pos={x=95.0, y=0.0, z=100.0}, rotation=-5e-05})
    end),
    At(5.869, 479, function(d,s)
        C.Action(d,s,A.Helper14,47935,{pos={x=100.0, y=0.0, z=95.0}, rotation=-5e-05})
    end),
    At(5.869, 480, function(d,s)
        C.Action(d,s,A.Helper16,47935,{pos={x=100.0, y=0.0, z=125.0}, rotation=-5e-05})
    end),
    At(5.869, 481, function(d,s)
        C.Action(d,s,A.Helper15,47935,{pos={x=85.0, y=0.0, z=110.0}, rotation=-5e-05})
    end),
    At(8.274, 482, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.10593)
    end),
    At(8.578, 483, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.12443)
    end),
}
