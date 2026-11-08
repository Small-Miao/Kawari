-- 宇宙龙炎 [31654]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 184, function(d,s)
        C.Cast(d,s,A.Boss,31654,5.3,{spell=31654, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(0.888, 185, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(0.888, 186, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(0.888, 187, function(d,s)
        C.Move(d,s,A.Helper29,{x=107.5, y=0.0, z=80.0},-5e-05)
    end),
    At(0.888, 188, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(0.888, 189, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(0.888, 190, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=107.5},-1.57087)
    end),
    At(0.888, 191, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(0.888, 192, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(0.888, 193, function(d,s)
        C.Move(d,s,A.Helper25,{x=92.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(0.888, 194, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(0.888, 195, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(0.888, 196, function(d,s)
        C.Move(d,s,A.Helper24,{x=80.0, y=0.0, z=92.5},1.57077)
    end),
    At(0.888, 197, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(0.888, 198, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(0.888, 199, function(d,s)
        C.Move(d,s,A.Helper23,{x=82.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(0.888, 200, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(0.888, 201, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(0.888, 202, function(d,s)
        C.Move(d,s,A.Helper22,{x=117.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(0.888, 203, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(0.888, 204, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(0.888, 205, function(d,s)
        C.Move(d,s,A.Helper20,{x=80.0, y=-0.0, z=82.5},1.57077)
    end),
    At(0.888, 206, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(0.888, 207, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(0.888, 208, function(d,s)
        C.Move(d,s,A.Helper19,{x=80.0, y=-0.0, z=117.5},1.57077)
    end),
    At(0.957, 209, function(d,s)
        C.Action(d,s,A.Helper20,31652,{pos={x=80.0, y=-0.0, z=82.5}, rotation=1.57077, target=A.Helper20})
    end),
    At(0.957, 210, function(d,s)
        C.Action(d,s,A.Helper22,31652,{pos={x=117.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper22})
    end),
    At(0.957, 211, function(d,s)
        C.Action(d,s,A.Helper23,31652,{pos={x=82.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper23})
    end),
    At(0.957, 212, function(d,s)
        C.Action(d,s,A.Helper24,31652,{pos={x=80.0, y=0.0, z=92.5}, rotation=1.57077, target=A.Helper24})
    end),
    At(0.957, 213, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=120.0, y=0.0, z=107.5}, rotation=-1.57087, target=A.Helper27})
    end),
    At(0.957, 214, function(d,s)
        C.Action(d,s,A.Helper25,31652,{pos={x=92.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper25})
    end),
    At(0.957, 215, function(d,s)
        C.Action(d,s,A.Helper19,31652,{pos={x=80.0, y=-0.0, z=117.5}, rotation=1.57077, target=A.Helper19})
    end),
    At(0.957, 216, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=107.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(2.87, 217, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(2.87, 218, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(2.87, 219, function(d,s)
        C.Move(d,s,A.Helper32,{x=112.5, y=0.0, z=80.0},-5e-05)
    end),
    At(2.87, 220, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(2.87, 221, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(2.87, 222, function(d,s)
        C.Move(d,s,A.Helper31,{x=120.0, y=0.0, z=112.5},-1.57087)
    end),
    At(2.87, 223, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(2.87, 224, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(2.87, 225, function(d,s)
        C.Move(d,s,A.Helper30,{x=87.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(2.87, 226, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(2.87, 227, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(2.87, 228, function(d,s)
        C.Move(d,s,A.Helper28,{x=80.0, y=0.0, z=87.5},1.57077)
    end),
    At(2.977, 229, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=80.0, y=0.0, z=87.5}, rotation=1.57077, target=A.Helper28})
    end),
    At(2.977, 230, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=87.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper30})
    end),
    At(2.977, 231, function(d,s)
        C.Action(d,s,A.Helper31,31652,{pos={x=120.0, y=0.0, z=112.5}, rotation=-1.57087, target=A.Helper31})
    end),
    At(2.977, 232, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=112.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(4.838, 233, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(4.838, 234, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(4.838, 235, function(d,s)
        C.Move(d,s,A.Helper29,{x=117.5, y=0.0, z=80.0},-5e-05)
    end),
    At(4.838, 236, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(4.838, 237, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(4.838, 238, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=117.5},-1.57087)
    end),
    At(4.838, 239, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(4.838, 240, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(4.838, 241, function(d,s)
        C.Move(d,s,A.Helper26,{x=82.5, y=-0.0, z=120.0},-3.14159)
    end),
    At(4.838, 242, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(4.838, 243, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(4.838, 244, function(d,s)
        C.Move(d,s,A.Helper25,{x=80.0, y=0.0, z=82.5},1.57077)
    end),
    At(4.947, 245, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=82.5, y=-0.0, z=120.0}, rotation=-3.14159, target=A.Helper26})
    end),
    At(4.947, 246, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=120.0, y=0.0, z=117.5}, rotation=-1.57087, target=A.Helper27})
    end),
    At(4.947, 247, function(d,s)
        C.Action(d,s,A.Helper25,31652,{pos={x=80.0, y=0.0, z=82.5}, rotation=1.57077, target=A.Helper25})
    end),
    At(4.947, 248, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=117.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(5.625, 249, function(d,s)
        C.Action(d,s,A.Boss,31654,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(7.937, 250, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(7.937, 251, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(7.937, 252, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-3.07649)
    end),
    At(7.937, 253, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(7.937, 254, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(7.937, 255, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=100.0},-3.07649)
    end),
    At(7.937, 256, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(7.937, 257, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(7.937, 258, function(d,s)
        C.Move(d,s,A.Helper30,{x=100.0, y=0.0, z=100.0},-3.07649)
    end),
    At(8.002, 259, function(d,s)
        C.Action(d,s,A.Helper30,31656,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(8.002, 260, function(d,s)
        C.Action(d,s,A.Helper31,31655,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(8.002, 261, function(d,s)
        C.Action(d,s,A.Helper32,31655,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(14.74, 262, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(15.55, 263, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(15.55, 264, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(15.55, 265, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(15.55, 266, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(15.623, 267, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(15.623, 268, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(16.025, 269, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.13718)
    end),
    At(17.913, 270, function(d,s)
        C.Action(d,s,A.Boss,31747,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13718, target=A.Boss})
    end),
    At(18.698, 271, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(18.698, 272, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(18.698, 273, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(18.698, 274, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(18.742, 275, function(d,s)
        C.Action(d,s,A.Helper31,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(18.742, 276, function(d,s)
        C.Action(d,s,A.Helper32,32223,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.07649})
    end),
    At(18.967, 277, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(18.967, 278, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(18.967, 279, function(d,s)
        C.Move(d,s,A.Helper30,{x=83.0294, y=0.0, z=83.0294},0.78536)
    end),
}
