-- 混沌末世 [47931]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 286, function(d,s)
        C.Cast(d,s,A.Boss,47931,3.7,{spell=47931, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(0.0, 287, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.14159)
    end),
    At(2.429, 288, function(d,s)
        C.Move(d,s,A.Helper14,{x=105.0, y=0.0, z=70.0},-0.78546)
    end),
    At(2.429, 289, function(d,s)
        C.Move(d,s,A.Helper13,{x=120.0, y=0.0, z=85.0},-0.78546)
    end),
    At(2.492, 290, function(d,s)
        C.Cast(d,s,A.Helper13,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=119.9817, y=-0.0153, z=84.9775}, pos={x=120.0, y=0.0, z=85.0}, rotation=-0.78546, target=A.Helper13})
    end),
    At(2.492, 291, function(d,s)
        C.Cast(d,s,A.Helper14,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=104.9973, y=-0.0153, z=69.9931}, pos={x=105.0, y=0.0, z=70.0}, rotation=-0.78546, target=A.Helper14})
    end),
    At(3.915, 292, function(d,s)
        C.Action(d,s,A.Helper16,47932,{pos={x=70.0, y=0.0, z=95.0}, rotation=0.78536, target=A.Helper16})
    end),
    At(3.915, 293, function(d,s)
        C.Action(d,s,A.Helper15,47932,{pos={x=85.0, y=0.0, z=80.0}, rotation=0.78536, target=A.Helper15})
    end),
    At(3.915, 294, function(d,s)
        C.Action(d,s,A.Boss,47931,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.14159, target=A.Boss})
    end),
    At(4.509, 295, function(d,s)
        C.Move(d,s,A.Helper11,{x=90.0, y=0.0, z=85.0},-5e-05)
    end),
    At(4.509, 296, function(d,s)
        C.Move(d,s,A.Helper12,{x=75.0, y=0.0, z=100.0},-5e-05)
    end),
    At(4.564, 297, function(d,s)
        C.Action(d,s,A.Helper12,47933,{pos={x=75.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(4.564, 298, function(d,s)
        C.Action(d,s,A.Helper11,47933,{pos={x=90.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(4.865, 299, function(d,s)
        C.Move(d,s,A.Helper08,{x=80.0, y=0.0, z=85.0},0.78536)
    end),
    At(4.865, 300, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(4.865, 301, function(d,s)
        C.Move(d,s,A.Helper07,{x=95.0, y=0.0, z=70.0},0.78536)
    end),
    At(4.945, 302, function(d,s)
        C.Cast(d,s,A.Helper08,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=79.9725, y=-0.0153, z=84.9775}, pos={x=80.0, y=0.0, z=85.0}, rotation=0.78536, target=A.Helper08})
    end),
    At(4.945, 303, function(d,s)
        C.Cast(d,s,A.Helper07,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=94.9874, y=-0.0153, z=69.9931}, pos={x=95.0, y=0.0, z=70.0}, rotation=0.78536, target=A.Helper07})
    end),
    At(5.009, 304, function(d,s)
        C.Move(d,s,A.Helper09,{x=80.0, y=0.0, z=105.0},-5e-05)
    end),
    At(5.009, 305, function(d,s)
        C.Move(d,s,A.Helper10,{x=95.0, y=0.0, z=90.0},-5e-05)
    end),
    At(5.131, 306, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=80.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(5.131, 307, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=95.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(5.502, 308, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=95.0},-5e-05)
    end),
    At(5.502, 309, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(5.502, 310, function(d,s)
        C.Move(d,s,A.Helper16,{x=85.0, y=0.0, z=110.0},-5e-05)
    end),
    At(5.502, 311, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(5.625, 312, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=85.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(5.625, 313, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=100.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(6.011, 314, function(d,s)
        C.Move(d,s,A.Helper05,{x=90.0, y=0.0, z=115.0},-5e-05)
    end),
    At(6.011, 315, function(d,s)
        C.Move(d,s,A.Helper06,{x=105.0, y=0.0, z=100.0},-5e-05)
    end),
    At(6.101, 316, function(d,s)
        C.Action(d,s,A.Helper05,47933,{pos={x=90.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(6.101, 317, function(d,s)
        C.Action(d,s,A.Helper06,47933,{pos={x=105.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(6.462, 318, function(d,s)
        C.Action(d,s,A.Helper13,47932,{pos={x=120.0, y=0.0, z=85.0}, rotation=-0.78546, target=A.Helper13})
    end),
    At(6.462, 319, function(d,s)
        C.Action(d,s,A.Helper14,47932,{pos={x=105.0, y=0.0, z=70.0}, rotation=-0.78546, target=A.Helper14})
    end),
    At(6.514, 320, function(d,s)
        C.Move(d,s,A.Helper11,{x=110.0, y=0.0, z=105.0},-5e-05)
    end),
    At(6.514, 321, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(6.514, 322, function(d,s)
        C.Move(d,s,A.Helper12,{x=95.0, y=0.0, z=120.0},-5e-05)
    end),
    At(6.514, 323, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(6.594, 324, function(d,s)
        C.Action(d,s,A.Helper12,47933,{pos={x=95.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(6.594, 325, function(d,s)
        C.Action(d,s,A.Helper11,47933,{pos={x=110.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(7.034, 326, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=75.0},-5e-05)
    end),
    At(7.034, 327, function(d,s)
        C.Move(d,s,A.Helper10,{x=115.0, y=0.0, z=90.0},-5e-05)
    end),
    At(7.102, 328, function(d,s)
        C.Move(d,s,A.Helper03,{x=100.0, y=0.0, z=125.0},-5e-05)
    end),
    At(7.102, 329, function(d,s)
        C.Move(d,s,A.Helper04,{x=115.0, y=0.0, z=110.0},-5e-05)
    end),
    At(7.102, 330, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=100.0, y=0.0, z=75.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(7.102, 331, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=115.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(7.165, 332, function(d,s)
        C.Action(d,s,A.Helper04,47933,{pos={x=115.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(7.165, 333, function(d,s)
        C.Action(d,s,A.Helper03,47933,{pos={x=100.0, y=0.0, z=125.0}, rotation=-5e-05, target=A.Helper03})
    end),
    At(7.367, 334, function(d,s)
        C.Move(d,s,A.Helper06,{x=110.0, y=0.0, z=75.0},-0.78546)
    end),
    At(7.367, 335, function(d,s)
        C.Move(d,s,A.Helper05,{x=125.0, y=0.0, z=90.0},-0.78546)
    end),
    At(7.487, 336, function(d,s)
        C.Cast(d,s,A.Helper05,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=124.9866, y=-0.0153, z=89.9825}, pos={x=125.0, y=0.0, z=90.0}, rotation=-0.78546, target=A.Helper05})
    end),
    At(7.487, 337, function(d,s)
        C.Cast(d,s,A.Helper06,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=109.9718, y=-0.0153, z=74.9981}, pos={x=110.0, y=0.0, z=75.0}, rotation=-0.78546, target=A.Helper06})
    end),
    At(7.553, 338, function(d,s)
        C.Move(d,s,A.Helper15,{x=110.0, y=0.0, z=95.0},-5e-05)
    end),
    At(7.553, 339, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(7.553, 340, function(d,s)
        C.Move(d,s,A.Helper16,{x=95.0, y=0.0, z=80.0},-5e-05)
    end),
    At(7.553, 341, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(7.607, 342, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=95.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(7.607, 343, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=110.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(8.044, 344, function(d,s)
        C.Move(d,s,A.Helper01,{x=90.0, y=0.0, z=85.0},-5e-05)
    end),
    At(8.044, 345, function(d,s)
        C.Move(d,s,A.Helper02,{x=105.0, y=0.0, z=100.0},-5e-05)
    end),
    At(8.181, 346, function(d,s)
        C.Action(d,s,A.Helper01,47933,{pos={x=90.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper01})
    end),
    At(8.181, 347, function(d,s)
        C.Action(d,s,A.Helper02,47933,{pos={x=105.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper02})
    end),
    At(8.518, 348, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=105.0},-5e-05)
    end),
    At(8.518, 349, function(d,s)
        C.Move(d,s,A.Helper14,{x=85.0, y=0.0, z=90.0},-5e-05)
    end),
    At(8.618, 350, function(d,s)
        C.Action(d,s,A.Helper13,47933,{pos={x=100.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper13})
    end),
    At(8.618, 351, function(d,s)
        C.Action(d,s,A.Helper14,47933,{pos={x=85.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper14})
    end),
    At(8.928, 352, function(d,s)
        C.Action(d,s,A.Helper08,47932,{pos={x=80.0, y=0.0, z=85.0}, rotation=0.78536, target=A.Helper08})
    end),
    At(8.928, 353, function(d,s)
        C.Action(d,s,A.Helper07,47932,{pos={x=95.0, y=0.0, z=70.0}, rotation=0.78536, target=A.Helper07})
    end),
    At(9.1, 354, function(d,s)
        C.Move(d,s,A.Helper11,{x=80.0, y=0.0, z=95.0},-5e-05)
    end),
    At(9.1, 355, function(d,s)
        C.Move(d,s,A.Helper12,{x=95.0, y=0.0, z=110.0},-5e-05)
    end),
    At(9.163, 356, function(d,s)
        C.Action(d,s,A.Helper12,47933,{pos={x=95.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(9.163, 357, function(d,s)
        C.Action(d,s,A.Helper11,47933,{pos={x=80.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(9.478, 358, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=0.0, z=75.0},-5e-05)
    end),
    At(9.478, 359, function(d,s)
        C.Move(d,s,A.Helper16,{x=85.0, y=0.0, z=90.0},-5e-05)
    end),
    At(9.6, 360, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=85.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(9.6, 361, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=100.0, y=0.0, z=75.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(9.6, 362, function(d,s)
        C.Move(d,s,A.Helper09,{x=90.0, y=0.0, z=115.0},-5e-05)
    end),
    At(9.6, 363, function(d,s)
        C.Move(d,s,A.Helper10,{x=75.0, y=0.0, z=100.0},-5e-05)
    end),
    At(9.733, 364, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=90.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(9.733, 365, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=75.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.865, 366, function(d,s)
        C.Move(d,s,A.Helper14,{x=75.0, y=0.0, z=90.0},0.78536)
    end),
    At(9.865, 367, function(d,s)
        C.Move(d,s,A.Helper13,{x=90.0, y=0.0, z=75.0},0.78536)
    end),
    At(9.953, 368, function(d,s)
        C.Cast(d,s,A.Helper13,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=89.9825, y=-0.0153, z=74.9981}, pos={x=90.0, y=0.0, z=75.0}, rotation=0.78536, target=A.Helper13})
    end),
    At(9.953, 369, function(d,s)
        C.Cast(d,s,A.Helper14,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=74.9981, y=-0.0153, z=89.9825}, pos={x=75.0, y=0.0, z=90.0}, rotation=0.78536, target=A.Helper14})
    end),
    At(10.02, 370, function(d,s)
        C.Move(d,s,A.Helper03,{x=90.0, y=0.0, z=95.0},-5e-05)
    end),
    At(10.02, 371, function(d,s)
        C.Move(d,s,A.Helper04,{x=105.0, y=0.0, z=80.0},-5e-05)
    end),
    At(10.146, 372, function(d,s)
        C.Action(d,s,A.Helper04,47933,{pos={x=105.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(10.146, 373, function(d,s)
        C.Action(d,s,A.Helper03,47933,{pos={x=90.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper03})
    end),
    At(10.523, 374, function(d,s)
        C.Move(d,s,A.Helper07,{x=110.0, y=0.0, z=85.0},-5e-05)
    end),
    At(10.523, 375, function(d,s)
        C.Move(d,s,A.Helper08,{x=95.0, y=0.0, z=100.0},-5e-05)
    end),
    At(10.639, 376, function(d,s)
        C.Action(d,s,A.Helper08,47933,{pos={x=95.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(10.639, 377, function(d,s)
        C.Action(d,s,A.Helper07,47933,{pos={x=110.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(11.017, 378, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=105.0},-5e-05)
    end),
    At(11.017, 379, function(d,s)
        C.Move(d,s,A.Helper12,{x=115.0, y=0.0, z=90.0},-5e-05)
    end),
    At(11.089, 380, function(d,s)
        C.Action(d,s,A.Helper12,47933,{pos={x=115.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper12})
    end),
    At(11.089, 381, function(d,s)
        C.Action(d,s,A.Helper11,47933,{pos={x=100.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper11})
    end),
    At(11.435, 382, function(d,s)
        C.Action(d,s,A.Helper05,47932,{pos={x=125.0, y=0.0, z=90.0}, rotation=-0.78546, target=A.Helper05})
    end),
    At(11.435, 383, function(d,s)
        C.Action(d,s,A.Helper06,47932,{pos={x=110.0, y=0.0, z=75.0}, rotation=-0.78546, target=A.Helper06})
    end),
    At(11.5, 384, function(d,s)
        C.Move(d,s,A.Helper15,{x=120.0, y=0.0, z=95.0},-5e-05)
    end),
    At(11.5, 385, function(d,s)
        C.Move(d,s,A.Helper16,{x=105.0, y=0.0, z=110.0},-5e-05)
    end),
    At(11.628, 386, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=105.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(11.628, 387, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=120.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(11.982, 388, function(d,s)
        C.Move(d,s,A.Helper09,{x=105.0, y=0.0, z=80.0},-5e-05)
    end),
    At(11.982, 389, function(d,s)
        C.Move(d,s,A.Helper10,{x=120.0, y=0.0, z=95.0},-5e-05)
    end),
    At(12.045, 390, function(d,s)
        C.Move(d,s,A.Helper03,{x=110.0, y=0.0, z=115.0},-5e-05)
    end),
    At(12.045, 391, function(d,s)
        C.Move(d,s,A.Helper04,{x=125.0, y=0.0, z=100.0},-5e-05)
    end),
    At(12.106, 392, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=105.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(12.106, 393, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=120.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(12.106, 394, function(d,s)
        C.Action(d,s,A.Helper04,47933,{pos={x=125.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(12.106, 395, function(d,s)
        C.Action(d,s,A.Helper03,47933,{pos={x=110.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper03})
    end),
    At(12.434, 396, function(d,s)
        C.Move(d,s,A.Helper12,{x=115.0, y=0.0, z=80.0},-0.78546)
    end),
    At(12.434, 397, function(d,s)
        C.Move(d,s,A.Helper11,{x=130.0, y=0.0, z=95.0},-0.78546)
    end),
    At(12.488, 398, function(d,s)
        C.Cast(d,s,A.Helper12,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=114.9767, y=-0.0153, z=79.9725}, pos={x=115.0, y=0.0, z=80.0}, rotation=-0.78546, target=A.Helper12})
    end),
    At(12.488, 399, function(d,s)
        C.Cast(d,s,A.Helper11,47932,3.7,{spell=47932, omen_delay=0, cast_pos={x=129.9916, y=-0.0153, z=94.9874}, pos={x=130.0, y=0.0, z=95.0}, rotation=-0.78546, target=A.Helper11})
    end),
    At(12.554, 400, function(d,s)
        C.Move(d,s,A.Helper07,{x=115.0, y=0.0, z=100.0},-5e-05)
    end),
    At(12.554, 401, function(d,s)
        C.Move(d,s,A.Helper08,{x=100.0, y=0.0, z=85.0},-5e-05)
    end),
    At(12.617, 402, function(d,s)
        C.Action(d,s,A.Helper08,47933,{pos={x=100.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(12.617, 403, function(d,s)
        C.Action(d,s,A.Helper07,47933,{pos={x=115.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(13.047, 404, function(d,s)
        C.Move(d,s,A.Helper05,{x=95.0, y=0.0, z=90.0},-5e-05)
    end),
    At(13.047, 405, function(d,s)
        C.Move(d,s,A.Helper06,{x=110.0, y=0.0, z=105.0},-5e-05)
    end),
    At(13.165, 406, function(d,s)
        C.Action(d,s,A.Helper05,47933,{pos={x=95.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(13.165, 407, function(d,s)
        C.Action(d,s,A.Helper06,47933,{pos={x=110.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(13.54, 408, function(d,s)
        C.Move(d,s,A.Helper15,{x=105.0, y=0.0, z=110.0},-5e-05)
    end),
    At(13.54, 409, function(d,s)
        C.Move(d,s,A.Helper16,{x=90.0, y=0.0, z=95.0},-5e-05)
    end),
    At(13.626, 410, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=90.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(13.626, 411, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=105.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(13.94, 412, function(d,s)
        C.Action(d,s,A.Helper13,47932,{pos={x=90.0, y=0.0, z=75.0}, rotation=0.78536, target=A.Helper13})
    end),
    At(13.94, 413, function(d,s)
        C.Action(d,s,A.Helper14,47932,{pos={x=75.0, y=0.0, z=90.0}, rotation=0.78536, target=A.Helper14})
    end),
    At(14.08, 414, function(d,s)
        C.Move(d,s,A.Helper09,{x=85.0, y=0.0, z=100.0},-5e-05)
    end),
    At(14.08, 415, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.0, y=0.0, z=115.0},-5e-05)
    end),
    At(14.167, 416, function(d,s)
        C.Action(d,s,A.Helper09,47933,{pos={x=85.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper09})
    end),
    At(14.167, 417, function(d,s)
        C.Action(d,s,A.Helper10,47933,{pos={x=100.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.48, 418, function(d,s)
        C.Move(d,s,A.Helper07,{x=80.0, y=0.0, z=95.0},-5e-05)
    end),
    At(14.48, 419, function(d,s)
        C.Move(d,s,A.Helper08,{x=95.0, y=0.0, z=80.0},-5e-05)
    end),
    At(14.564, 420, function(d,s)
        C.Action(d,s,A.Helper08,47933,{pos={x=95.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper08})
    end),
    At(14.564, 421, function(d,s)
        C.Action(d,s,A.Helper07,47933,{pos={x=80.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper07})
    end),
    At(14.603, 422, function(d,s)
        C.Move(d,s,A.Helper03,{x=95.0, y=0.0, z=120.0},-5e-05)
    end),
    At(14.603, 423, function(d,s)
        C.Move(d,s,A.Helper04,{x=80.0, y=0.0, z=105.0},-5e-05)
    end),
    At(14.723, 424, function(d,s)
        C.Action(d,s,A.Helper04,47933,{pos={x=80.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(14.723, 425, function(d,s)
        C.Action(d,s,A.Helper03,47933,{pos={x=95.0, y=0.0, z=120.0}, rotation=-5e-05, target=A.Helper03})
    end),
    At(15.065, 426, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=85.0},-5e-05)
    end),
    At(15.065, 427, function(d,s)
        C.Move(d,s,A.Helper06,{x=85.0, y=0.0, z=100.0},-5e-05)
    end),
    At(15.124, 428, function(d,s)
        C.Action(d,s,A.Helper05,47933,{pos={x=100.0, y=0.0, z=85.0}, rotation=-5e-05, target=A.Helper05})
    end),
    At(15.124, 429, function(d,s)
        C.Action(d,s,A.Helper06,47933,{pos={x=85.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(15.503, 430, function(d,s)
        C.Move(d,s,A.Helper15,{x=90.0, y=0.0, z=105.0},-5e-05)
    end),
    At(15.503, 431, function(d,s)
        C.Move(d,s,A.Helper16,{x=105.0, y=0.0, z=90.0},-5e-05)
    end),
    At(15.594, 432, function(d,s)
        C.Action(d,s,A.Helper16,47933,{pos={x=105.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(15.594, 433, function(d,s)
        C.Action(d,s,A.Helper15,47933,{pos={x=90.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper15})
    end),
    At(16.037, 434, function(d,s)
        C.Move(d,s,A.Helper13,{x=110.0, y=0.0, z=95.0},-5e-05)
    end),
    At(16.037, 435, function(d,s)
        C.Move(d,s,A.Helper14,{x=95.0, y=0.0, z=110.0},-5e-05)
    end),
}
