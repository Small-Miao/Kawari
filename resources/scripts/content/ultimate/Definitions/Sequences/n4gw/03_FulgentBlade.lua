-- 光尘之剑 [40306]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 54, function(d,s)
        C.Cast(d,s,A.Boss,40306,5.7,{spell=40306, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347, target=A.Boss})
    end),
    At(6.057, 61, function(d,s)
        C.Action(d,s,A.Boss,40306,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347, target=A.Boss})
    end),
    At(9.171, 68, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01347, target=A.Boss})
    end),
    At(9.551, 69, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.0267)
    end),
    At(9.79, 70, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(9.79, 71, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(9.79, 72, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},0.02172)
    end),
    At(9.79, 73, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(9.79, 74, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(9.79, 75, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.02172)
    end),
    At(9.86, 76, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.02172})
    end),
    At(9.86, 77, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.02172})
    end),
    At(10.013, 79, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(10.013, 80, function(d,s)
        C.Move(d,s,A.Helper12,{x=103.5858, y=0.0, z=103.5858},-2.35628)
    end),
    At(10.013, 81, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(10.013, 82, function(d,s)
        C.Move(d,s,A.Helper11,{x=103.5858, y=0.0, z=103.5858},0.78536)
    end),
    At(10.013, 84, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(10.013, 85, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=110.0},-5e-05)
    end),
    At(10.013, 86, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(10.013, 87, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=110.0},-3.14159)
    end),
    At(10.099, 88, function(d,s)
        C.Cast(d,s,A.Helper09,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=109.9718}, pos={x=100.0, y=0.0, z=110.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(10.099, 89, function(d,s)
        C.Cast(d,s,A.Helper10,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=109.9718}, pos={x=100.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(10.099, 90, function(d,s)
        C.Cast(d,s,A.Helper11,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=103.563}, pos={x=103.5858, y=0.0, z=103.5858}, rotation=0.78536, target=A.Helper11})
    end),
    At(10.099, 91, function(d,s)
        C.Cast(d,s,A.Helper12,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=103.563}, pos={x=103.5858, y=0.0, z=103.5858}, rotation=-2.35628, target=A.Helper12})
    end),
    At(10.702, 92, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.07915)
    end),
    At(11.013, 93, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.32468)
    end),
    At(11.331, 94, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.56255)
    end),
    At(11.646, 95, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.15343)
    end),
    At(11.993, 96, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.57001)
    end),
    At(12.267, 97, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.76243)
    end),
    At(12.341, 98, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.76243, target=A.Boss})
    end),
    At(12.6, 99, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.7817)
    end),
    At(12.934, 100, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(12.934, 101, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(12.934, 102, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-1.78131)
    end),
    At(12.934, 103, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(12.934, 104, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(12.934, 105, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.78131)
    end),
    At(13.025, 106, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.78131})
    end),
    At(13.025, 107, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.78131})
    end),
    At(14.015, 109, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.015, 110, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.015, 111, function(d,s)
        C.Move(d,s,A.Helper14,{x=103.5858, y=0.0, z=96.4142},2.35618)
    end),
    At(14.015, 112, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(14.015, 113, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(14.015, 114, function(d,s)
        C.Move(d,s,A.Helper13,{x=103.5858, y=0.0, z=96.4142},-0.78546)
    end),
    At(14.015, 116, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(14.015, 117, function(d,s)
        C.Move(d,s,A.Helper08,{x=103.0, y=0.0, z=100.0},-1.57087)
    end),
    At(14.015, 118, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(14.015, 119, function(d,s)
        C.Move(d,s,A.Helper07,{x=103.0, y=0.0, z=100.0},1.57077)
    end),
    At(14.169, 120, function(d,s)
        C.Cast(d,s,A.Helper07,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=102.9831, y=-0.0153, z=99.9924}, pos={x=103.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper07})
    end),
    At(14.169, 121, function(d,s)
        C.Cast(d,s,A.Helper08,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=102.9831, y=-0.0153, z=99.9924}, pos={x=103.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(14.169, 122, function(d,s)
        C.Cast(d,s,A.Helper13,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=96.3912}, pos={x=103.5858, y=0.0, z=96.4142}, rotation=-0.78546, target=A.Helper13})
    end),
    At(14.169, 123, function(d,s)
        C.Cast(d,s,A.Helper14,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=103.563, y=-0.0153, z=96.3912}, pos={x=103.5858, y=0.0, z=96.4142}, rotation=2.35618, target=A.Helper14})
    end),
    At(15.468, 124, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.78812, target=A.Boss})
    end),
    At(16.11, 125, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(16.11, 126, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=100.0},-1.77297)
    end),
    At(16.11, 127, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(16.11, 128, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=100.0},-1.77297)
    end),
    At(16.238, 129, function(d,s)
        C.Action(d,s,A.Helper05,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.77297})
    end),
    At(16.238, 130, function(d,s)
        C.Action(d,s,A.Helper06,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.77297})
    end),
    At(17.078, 133, function(d,s)
        C.Action(d,s,A.Helper09,40118,{pos={x=100.0, y=0.0, z=110.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(17.078, 134, function(d,s)
        C.Action(d,s,A.Helper10,40307,{pos={x=100.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(17.078, 135, function(d,s)
        C.Action(d,s,A.Helper11,40118,{pos={x=103.5858, y=0.0, z=103.5858}, rotation=0.78536, target=A.Helper11})
    end),
    At(17.078, 136, function(d,s)
        C.Action(d,s,A.Helper12,40307,{pos={x=103.5858, y=0.0, z=103.5858}, rotation=-2.35628, target=A.Helper12})
    end),
    At(18.03, 138, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(18.03, 139, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(18.03, 140, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=90.0},-5e-05)
    end),
    At(18.03, 141, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(18.03, 142, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(18.03, 143, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=90.0},3.14159)
    end),
    At(18.03, 145, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(18.03, 146, function(d,s)
        C.Move(d,s,A.Helper04,{x=89.3934, y=0.0, z=89.3934},-2.35628)
    end),
    At(18.03, 147, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(18.03, 148, function(d,s)
        C.Move(d,s,A.Helper03,{x=89.3934, y=0.0, z=89.3934},0.78536)
    end),
    At(18.11, 149, function(d,s)
        C.Cast(d,s,A.Helper03,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=89.3721, y=-0.0153, z=89.3721}, pos={x=89.3934, y=0.0, z=89.3934}, rotation=0.78536, target=A.Helper03})
    end),
    At(18.11, 150, function(d,s)
        C.Cast(d,s,A.Helper04,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=89.3721, y=-0.0153, z=89.3721}, pos={x=89.3934, y=0.0, z=89.3934}, rotation=-2.35628, target=A.Helper04})
    end),
    At(18.11, 151, function(d,s)
        C.Cast(d,s,A.Helper05,40118,6.7,{spell=40118, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=89.9825}, pos={x=100.0, y=0.0, z=90.0}, rotation=3.14159, target=A.Helper05})
    end),
    At(18.11, 152, function(d,s)
        C.Cast(d,s,A.Helper06,40307,6.7,{spell=40307, omen_delay=50, cast_pos={x=99.9924, y=-0.0153, z=89.9825}, pos={x=100.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(18.462, 153, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.79924)
    end),
    At(18.671, 154, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.79924, target=A.Boss})
    end),
    At(19.162, 155, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=105.0},-3.14159)
    end),
    At(19.162, 156, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=115.0},-5e-05)
    end),
    At(19.162, 157, function(d,s)
        C.Move(d,s,A.Helper11,{x=107.1213, y=0.0, z=107.1213},0.78536)
    end),
    At(19.162, 158, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0503, y=0.0, z=100.0503},-2.35628)
    end),
    At(19.237, 159, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=105.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(19.237, 160, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=100.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(19.237, 161, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=107.1213, y=0.0, z=107.1213}, rotation=0.78536, target=A.Helper11})
    end),
    At(19.237, 162, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=100.0503, y=0.0, z=100.0503}, rotation=-2.35628, target=A.Helper12})
    end),
    At(19.306, 163, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(19.306, 164, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},-1.79924)
    end),
    At(19.306, 165, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(19.306, 166, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},-1.79924)
    end),
    At(19.352, 169, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.79924})
    end),
    At(19.352, 170, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.79924})
    end),
    At(20.31, 171, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.58065)
    end),
    At(20.689, 172, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.28506)
    end),
    At(20.948, 173, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.35026)
    end),
    At(21.108, 176, function(d,s)
        C.Action(d,s,A.Helper07,40118,{pos={x=103.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper07})
    end),
    At(21.108, 177, function(d,s)
        C.Action(d,s,A.Helper08,40307,{pos={x=103.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(21.108, 178, function(d,s)
        C.Action(d,s,A.Helper13,40118,{pos={x=103.5858, y=0.0, z=96.4142}, rotation=-0.78546, target=A.Helper13})
    end),
    At(21.108, 179, function(d,s)
        C.Action(d,s,A.Helper14,40307,{pos={x=103.5858, y=0.0, z=96.4142}, rotation=2.35618, target=A.Helper14})
    end),
    At(21.242, 180, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=100.0},-3.14159)
    end),
    At(21.242, 181, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=120.0},-5e-05)
    end),
    At(21.242, 182, function(d,s)
        C.Move(d,s,A.Helper11,{x=110.6569, y=0.0, z=110.6569},0.78536)
    end),
    At(21.242, 183, function(d,s)
        C.Move(d,s,A.Helper12,{x=96.5147, y=0.0, z=96.5147},-2.35628)
    end),
    At(21.242, 184, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(21.242, 185, function(d,s)
        C.Action(d,s,A.Helper10,40308,{pos={x=100.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(21.242, 186, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=110.6569, y=0.0, z=110.6569}, rotation=0.78536, target=A.Helper11})
    end),
    At(21.242, 187, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=96.5147, y=0.0, z=96.5147}, rotation=-2.35628, target=A.Helper12})
    end),
    At(21.792, 188, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.35026, target=A.Boss})
    end),
    At(22.205, 189, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.5377)
    end),
    At(22.484, 190, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(22.484, 191, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(22.484, 192, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},-1.55677)
    end),
    At(22.484, 193, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(22.484, 194, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(22.484, 195, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},-1.55677)
    end),
    At(22.484, 196, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.55677)
    end),
    At(22.562, 197, function(d,s)
        C.Action(d,s,A.Helper01,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.55677})
    end),
    At(22.562, 198, function(d,s)
        C.Action(d,s,A.Helper02,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.55677})
    end),
    At(23.194, 199, function(d,s)
        C.Move(d,s,A.Helper07,{x=108.0, y=0.0, z=100.0},1.57077)
    end),
    At(23.194, 200, function(d,s)
        C.Move(d,s,A.Helper08,{x=98.0, y=0.0, z=100.0},-1.57087)
    end),
    At(23.194, 201, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0503, y=0.0, z=99.9498},-0.78546)
    end),
    At(23.194, 202, function(d,s)
        C.Move(d,s,A.Helper14,{x=107.1213, y=0.0, z=92.8787},2.35618)
    end),
    At(23.194, 203, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=108.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper07})
    end),
    At(23.194, 204, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=98.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(23.194, 205, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=100.0503, y=0.0, z=99.9498}, rotation=-0.78546, target=A.Helper13})
    end),
    At(23.194, 206, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=107.1213, y=0.0, z=92.8787}, rotation=2.35618, target=A.Helper14})
    end),
    At(23.256, 207, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=95.0},-3.14159)
    end),
    At(23.256, 208, function(d,s)
        C.Move(d,s,A.Helper11,{x=114.1924, y=0.0, z=114.1924},0.78536)
    end),
    At(23.256, 209, function(d,s)
        C.Move(d,s,A.Helper12,{x=92.9792, y=0.0, z=92.9792},-2.35628)
    end),
    At(23.337, 210, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=95.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(23.337, 211, function(d,s)
        C.Action(d,s,A.Helper11,40309,{pos={x=114.1924, y=0.0, z=114.1924}, rotation=0.78536, target=A.Helper11})
    end),
    At(23.337, 212, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=92.9792, y=0.0, z=92.9792}, rotation=-2.35628, target=A.Helper12})
    end),
}
