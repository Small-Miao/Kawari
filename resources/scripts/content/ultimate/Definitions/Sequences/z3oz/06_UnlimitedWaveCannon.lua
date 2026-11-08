-- 波动炮：限制解除 [31660]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 280, function(d,s)
        C.Cast(d,s,A.Helper30,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=83.0243, y=-0.0153, z=83.0243}, pos={x=83.0294, y=0.0, z=83.0294}, rotation=0.78536, target=A.Helper30})
    end),
    At(0.0, 281, function(d,s)
        C.Cast(d,s,A.Boss,31660,4.7,{spell=31660, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13718, target=A.Boss})
    end),
    At(0.935, 282, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(0.935, 283, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(0.935, 284, function(d,s)
        C.Move(d,s,A.Helper32,{x=76.0, y=-0.0, z=100.0},1.57077)
    end),
    At(1.049, 285, function(d,s)
        C.Cast(d,s,A.Helper32,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=75.9747, y=-0.0153, z=99.9924}, pos={x=76.0, y=-0.0, z=100.0}, rotation=1.57077, target=A.Helper32})
    end),
    At(1.947, 286, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(1.947, 287, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(1.947, 288, function(d,s)
        C.Move(d,s,A.Helper31,{x=83.0294, y=0.0, z=116.9706},2.35618)
    end),
    At(2.021, 289, function(d,s)
        C.Cast(d,s,A.Helper31,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=83.0243, y=-0.0153, z=116.9604}, pos={x=83.0294, y=0.0, z=116.9706}, rotation=2.35618, target=A.Helper31})
    end),
    At(2.968, 290, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(2.968, 291, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(2.968, 292, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=-0.0, z=124.0},3.14159)
    end),
    At(3.01, 293, function(d,s)
        C.Cast(d,s,A.Helper29,31661,11.7,{spell=31661, omen_delay=40, cast_pos={x=99.9924, y=-0.0153, z=123.9796}, pos={x=100.0, y=-0.0, z=124.0}, rotation=3.14159, target=A.Helper29})
    end),
    At(5.003, 294, function(d,s)
        C.Action(d,s,A.Boss,31660,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13718, target=A.Boss})
    end),
    At(9.94, 295, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(9.94, 296, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(9.94, 297, function(d,s)
        C.Move(d,s,A.Helper28,{x=99.9782, y=0.0, z=100.1058},-5e-05)
    end),
    At(9.94, 298, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(9.94, 299, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(9.94, 300, function(d,s)
        C.Move(d,s,A.Helper27,{x=99.8903, y=0.0, z=100.3256},-5e-05)
    end),
    At(9.94, 301, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(9.94, 302, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(9.94, 303, function(d,s)
        C.Move(d,s,A.Helper26,{x=99.9132, y=0.0, z=100.6242},-5e-05)
    end),
    At(9.94, 304, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(9.94, 305, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(9.94, 306, function(d,s)
        C.Move(d,s,A.Helper25,{x=100.1329, y=0.0, z=100.2001},-5e-05)
    end),
    At(9.94, 307, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(9.94, 308, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(9.94, 309, function(d,s)
        C.Move(d,s,A.Helper24,{x=99.8354, y=0.0, z=100.1322},-5e-05)
    end),
    At(9.94, 310, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(9.94, 311, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(9.94, 312, function(d,s)
        C.Move(d,s,A.Helper23,{x=99.9826, y=0.0, z=99.9994},-5e-05)
    end),
    At(9.94, 313, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(9.94, 314, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(9.94, 315, function(d,s)
        C.Move(d,s,A.Helper22,{x=99.5565, y=0.0, z=100.2955},-5e-05)
    end),
    At(9.94, 316, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(9.94, 317, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(9.94, 318, function(d,s)
        C.Move(d,s,A.Helper21,{x=100.0439, y=0.0, z=100.0769},-5e-05)
    end),
    At(10.09, 319, function(d,s)
        C.Cast(d,s,A.Helper21,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.0229, y=-0.0153, z=100.0534}, pos={x=100.0439, y=0.0, z=100.0769}, rotation=-5e-05, target=A.Helper21})
    end),
    At(10.09, 320, function(d,s)
        C.Cast(d,s,A.Helper22,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.5346, y=-0.0153, z=100.267}, pos={x=99.5565, y=0.0, z=100.2955}, rotation=-5e-05, target=A.Helper22})
    end),
    At(10.09, 321, function(d,s)
        C.Cast(d,s,A.Helper24,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.8093, y=-0.0153, z=100.1144}, pos={x=99.8354, y=0.0, z=100.1322}, rotation=-5e-05, target=A.Helper24})
    end),
    At(10.09, 322, function(d,s)
        C.Cast(d,s,A.Helper23,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9619, y=-0.0153, z=99.9924}, pos={x=99.9826, y=0.0, z=99.9994}, rotation=-5e-05, target=A.Helper23})
    end),
    At(10.09, 323, function(d,s)
        C.Cast(d,s,A.Helper26,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9008, y=-0.0153, z=100.6027}, pos={x=99.9132, y=0.0, z=100.6242}, rotation=-5e-05, target=A.Helper26})
    end),
    At(10.09, 324, function(d,s)
        C.Cast(d,s,A.Helper28,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.9619, y=-0.0153, z=100.0839}, pos={x=99.9782, y=0.0, z=100.1058}, rotation=-5e-05, target=A.Helper28})
    end),
    At(10.09, 325, function(d,s)
        C.Cast(d,s,A.Helper27,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.8703, y=-0.0153, z=100.2976}, pos={x=99.8903, y=0.0, z=100.3256}, rotation=-5e-05, target=A.Helper27})
    end),
    At(10.09, 326, function(d,s)
        C.Cast(d,s,A.Helper25,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.1144, y=-0.0153, z=100.1755}, pos={x=100.1329, y=0.0, z=100.2001}, rotation=-5e-05, target=A.Helper25})
    end),
    At(10.157, 327, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.02762)
    end),
    At(10.489, 328, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.32507)
    end),
    At(10.781, 329, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.79332)
    end),
    At(11.08, 330, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.68772)
    end),
    At(11.4, 331, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.71878)
    end),
    At(11.972, 332, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(11.972, 333, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(11.972, 334, function(d,s)
        C.Move(d,s,A.Helper20,{x=102.2156, y=0.0, z=95.3766},-5e-05)
    end),
    At(11.972, 335, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(11.972, 336, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(11.972, 337, function(d,s)
        C.Move(d,s,A.Helper19,{x=103.0841, y=0.0, z=93.0024},-5e-05)
    end),
    At(11.972, 338, function(d,s)
        C.Owner(d,s,A.Helper18,nil)
    end),
    At(11.972, 339, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(11.972, 340, function(d,s)
        C.Move(d,s,A.Helper18,{x=102.1489, y=0.0, z=94.8117},-5e-05)
    end),
    At(11.972, 341, function(d,s)
        C.Owner(d,s,A.Helper17,nil)
    end),
    At(11.972, 342, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(11.972, 343, function(d,s)
        C.Move(d,s,A.Helper17,{x=102.2101, y=0.0, z=94.9583},-5e-05)
    end),
    At(11.972, 344, function(d,s)
        C.Owner(d,s,A.Helper16,A.Boss)
    end),
    At(11.972, 345, function(d,s)
        C.Move(d,s,A.Helper16,{x=101.3638, y=0.0, z=96.6851},-5e-05)
    end),
    At(11.972, 346, function(d,s)
        C.Owner(d,s,A.Helper15,A.Boss)
    end),
    At(11.972, 347, function(d,s)
        C.Move(d,s,A.Helper15,{x=103.0436, y=0.0, z=93.7431},-5e-05)
    end),
    At(11.972, 348, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(11.972, 349, function(d,s)
        C.Move(d,s,A.Helper14,{x=102.3968, y=0.0, z=93.8491},-5e-05)
    end),
    At(11.972, 350, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.972, 351, function(d,s)
        C.Move(d,s,A.Helper13,{x=102.3928, y=0.0, z=94.6001},-5e-05)
    end),
    At(11.972, 352, function(d,s)
        C.Action(d,s,A.Helper30,31661,{pos={x=83.0294, y=0.0, z=83.0294}, rotation=0.78536, target=A.Helper30})
    end),
    At(12.017, 353, function(d,s)
        C.Cast(d,s,A.Helper13,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=102.3728, y=-0.0153, z=94.5907}, pos={x=102.3928, y=0.0, z=94.6001}, rotation=-5e-05, target=A.Helper13})
    end),
    At(12.017, 354, function(d,s)
        C.Cast(d,s,A.Helper14,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=102.3728, y=-0.0153, z=93.8277}, pos={x=102.3968, y=0.0, z=93.8491}, rotation=-5e-05, target=A.Helper14})
    end),
    At(12.017, 355, function(d,s)
        C.Cast(d,s,A.Helper15,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=103.0137, y=-0.0153, z=93.7362}, pos={x=103.0436, y=0.0, z=93.7431}, rotation=-5e-05, target=A.Helper15})
    end),
    At(12.017, 356, function(d,s)
        C.Cast(d,s,A.Helper16,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=101.3352, y=-0.0153, z=96.6659}, pos={x=101.3638, y=0.0, z=96.6851}, rotation=-5e-05, target=A.Helper16})
    end),
    At(12.017, 357, function(d,s)
        C.Cast(d,s,A.Helper17,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=102.1897, y=-0.0153, z=94.9569}, pos={x=102.2101, y=0.0, z=94.9583}, rotation=-5e-05, target=A.Helper17})
    end),
    At(12.017, 358, function(d,s)
        C.Cast(d,s,A.Helper18,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=102.1286, y=-0.0153, z=94.8043}, pos={x=102.1489, y=0.0, z=94.8117}, rotation=-5e-05, target=A.Helper18})
    end),
    At(12.017, 359, function(d,s)
        C.Cast(d,s,A.Helper20,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=102.1897, y=-0.0153, z=95.3536}, pos={x=102.2156, y=0.0, z=95.3766}, rotation=-5e-05, target=A.Helper20})
    end),
    At(12.017, 360, function(d,s)
        C.Cast(d,s,A.Helper19,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=103.0747, y=-0.0153, z=92.9732}, pos={x=103.0841, y=0.0, z=93.0024}, rotation=-5e-05, target=A.Helper19})
    end),
    At(13.011, 361, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(13.011, 362, function(d,s)
        C.Move(d,s,A.Helper12,{x=88.6863, y=0.0, z=88.6863},-2.35628)
    end),
    At(13.011, 363, function(d,s)
        C.Action(d,s,A.Helper21,31663,{pos={x=100.0439, y=0.0, z=100.0769}, rotation=-5e-05, target=A.Helper21})
    end),
    At(13.011, 364, function(d,s)
        C.Action(d,s,A.Helper22,31663,{pos={x=99.5565, y=0.0, z=100.2955}, rotation=-5e-05, target=A.Helper22})
    end),
    At(13.011, 365, function(d,s)
        C.Action(d,s,A.Helper24,31663,{pos={x=99.8354, y=0.0, z=100.1322}, rotation=-5e-05, target=A.Helper24})
    end),
    At(13.011, 366, function(d,s)
        C.Action(d,s,A.Helper23,31663,{pos={x=99.9826, y=0.0, z=99.9994}, rotation=-5e-05, target=A.Helper23})
    end),
    At(13.011, 367, function(d,s)
        C.Action(d,s,A.Helper26,31663,{pos={x=99.9132, y=0.0, z=100.6242}, rotation=-5e-05, target=A.Helper26})
    end),
    At(13.011, 368, function(d,s)
        C.Action(d,s,A.Helper28,31663,{pos={x=99.9782, y=0.0, z=100.1058}, rotation=-5e-05, target=A.Helper28})
    end),
    At(13.011, 369, function(d,s)
        C.Action(d,s,A.Helper27,31663,{pos={x=99.8903, y=0.0, z=100.3256}, rotation=-5e-05, target=A.Helper27})
    end),
    At(13.011, 370, function(d,s)
        C.Action(d,s,A.Helper25,31663,{pos={x=100.1329, y=0.0, z=100.2001}, rotation=-5e-05, target=A.Helper25})
    end),
    At(13.011, 371, function(d,s)
        C.Action(d,s,A.Helper32,31661,{pos={x=76.0, y=-0.0, z=100.0}, rotation=1.57077, target=A.Helper32})
    end),
    At(13.103, 372, function(d,s)
        C.Action(d,s,A.Helper12,31662,{pos={x=88.6863, y=0.0, z=88.6863}, rotation=-2.35628, target=A.Helper12})
    end),
    At(13.252, 373, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.73642)
    end),
    At(13.952, 374, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(13.952, 375, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(13.952, 376, function(d,s)
        C.Move(d,s,A.Helper30,{x=105.2303, y=0.0, z=86.911},-5e-05)
    end),
    At(13.952, 377, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(13.952, 378, function(d,s)
        C.Move(d,s,A.Helper11,{x=106.1795, y=0.0, z=85.4091},-5e-05)
    end),
    At(13.952, 379, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(13.952, 380, function(d,s)
        C.Move(d,s,A.Helper10,{x=105.1669, y=0.0, z=87.8177},-5e-05)
    end),
    At(13.952, 381, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(13.952, 382, function(d,s)
        C.Move(d,s,A.Helper09,{x=105.7863, y=0.0, z=85.6221},-5e-05)
    end),
    At(13.952, 383, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(13.952, 384, function(d,s)
        C.Move(d,s,A.Helper08,{x=105.178, y=0.0, z=88.2112},-5e-05)
    end),
    At(13.952, 385, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(13.952, 386, function(d,s)
        C.Move(d,s,A.Helper07,{x=105.6522, y=0.0, z=87.6207},-5e-05)
    end),
    At(13.952, 387, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(13.952, 388, function(d,s)
        C.Move(d,s,A.Helper06,{x=106.0639, y=0.0, z=85.8486},-5e-05)
    end),
    At(13.952, 389, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(13.952, 390, function(d,s)
        C.Move(d,s,A.Helper05,{x=105.4635, y=0.0, z=87.9742},-5e-05)
    end),
    At(13.996, 391, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(13.996, 392, function(d,s)
        C.Move(d,s,A.Helper04,{x=94.3431, y=0.0, z=94.3431},-2.35628)
    end),
    At(13.996, 393, function(d,s)
        C.Action(d,s,A.Helper31,31661,{pos={x=83.0294, y=0.0, z=116.9706}, rotation=2.35618, target=A.Helper31})
    end),
    At(14.069, 394, function(d,s)
        C.Cast(d,s,A.Helper05,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.4551, y=-0.0153, z=87.9683}, pos={x=105.4635, y=0.0, z=87.9742}, rotation=-5e-05, target=A.Helper05})
    end),
    At(14.069, 395, function(d,s)
        C.Cast(d,s,A.Helper06,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.0349, y=-0.0153, z=85.832}, pos={x=106.0639, y=0.0, z=85.8486}, rotation=-5e-05, target=A.Helper06})
    end),
    At(14.069, 396, function(d,s)
        C.Cast(d,s,A.Helper07,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.6382, y=-0.0153, z=87.602}, pos={x=105.6522, y=0.0, z=87.6207}, rotation=-5e-05, target=A.Helper07})
    end),
    At(14.069, 397, function(d,s)
        C.Cast(d,s,A.Helper08,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.1499, y=-0.0153, z=88.1819}, pos={x=105.178, y=0.0, z=88.2112}, rotation=-5e-05, target=A.Helper08})
    end),
    At(14.069, 398, function(d,s)
        C.Cast(d,s,A.Helper09,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.7603, y=-0.0153, z=85.6184}, pos={x=105.7863, y=0.0, z=85.6221}, rotation=-5e-05, target=A.Helper09})
    end),
    At(14.069, 399, function(d,s)
        C.Cast(d,s,A.Helper10,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.1499, y=-0.0153, z=87.8157}, pos={x=105.1669, y=0.0, z=87.8177}, rotation=-5e-05, target=A.Helper10})
    end),
    At(14.069, 400, function(d,s)
        C.Cast(d,s,A.Helper11,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=106.157, y=-0.0153, z=85.4047}, pos={x=106.1795, y=0.0, z=85.4091}, rotation=-5e-05, target=A.Helper11})
    end),
    At(14.069, 401, function(d,s)
        C.Cast(d,s,A.Helper30,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=105.211, y=-0.0153, z=86.9001}, pos={x=105.2303, y=0.0, z=86.911}, rotation=-5e-05, target=A.Helper30})
    end),
    At(14.069, 402, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(14.069, 403, function(d,s)
        C.Move(d,s,A.Helper03,{x=84.0, y=0.0, z=100.0},-1.57087)
    end),
    At(14.069, 404, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=94.3431, y=0.0, z=94.3431}, rotation=-2.35628, target=A.Helper04})
    end),
    At(14.139, 405, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=84.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper03})
    end),
    At(14.928, 406, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.86423)
    end),
    At(15.001, 407, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(15.001, 408, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(15.001, 409, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=100.0},-2.35628)
    end),
    At(15.001, 410, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(15.001, 411, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(15.001, 412, function(d,s)
        C.Move(d,s,A.Helper28,{x=92.0, y=0.0, z=100.0},-1.57087)
    end),
    At(15.001, 413, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(15.001, 414, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(15.001, 415, function(d,s)
        C.Move(d,s,A.Helper27,{x=88.6863, y=0.0, z=111.3137},-0.78546)
    end),
    At(15.001, 416, function(d,s)
        C.Action(d,s,A.Helper13,31663,{pos={x=102.3928, y=0.0, z=94.6001}, rotation=-5e-05, target=A.Helper13})
    end),
    At(15.001, 417, function(d,s)
        C.Action(d,s,A.Helper14,31663,{pos={x=102.3968, y=0.0, z=93.8491}, rotation=-5e-05, target=A.Helper14})
    end),
    At(15.001, 418, function(d,s)
        C.Action(d,s,A.Helper15,31663,{pos={x=103.0436, y=0.0, z=93.7431}, rotation=-5e-05, target=A.Helper15})
    end),
    At(15.001, 419, function(d,s)
        C.Action(d,s,A.Helper16,31663,{pos={x=101.3638, y=0.0, z=96.6851}, rotation=-5e-05, target=A.Helper16})
    end),
    At(15.001, 420, function(d,s)
        C.Action(d,s,A.Helper17,31663,{pos={x=102.2101, y=0.0, z=94.9583}, rotation=-5e-05, target=A.Helper17})
    end),
    At(15.001, 421, function(d,s)
        C.Action(d,s,A.Helper18,31663,{pos={x=102.1489, y=0.0, z=94.8117}, rotation=-5e-05, target=A.Helper18})
    end),
    At(15.001, 422, function(d,s)
        C.Action(d,s,A.Helper20,31663,{pos={x=102.2156, y=0.0, z=95.3766}, rotation=-5e-05, target=A.Helper20})
    end),
    At(15.001, 423, function(d,s)
        C.Action(d,s,A.Helper19,31663,{pos={x=103.0841, y=0.0, z=93.0024}, rotation=-5e-05, target=A.Helper19})
    end),
    At(15.001, 424, function(d,s)
        C.Action(d,s,A.Helper29,31661,{pos={x=100.0, y=-0.0, z=124.0}, rotation=3.14159, target=A.Helper29})
    end),
    At(15.094, 425, function(d,s)
        C.Action(d,s,A.Helper28,31662,{pos={x=92.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper28})
    end),
    At(15.094, 426, function(d,s)
        C.Action(d,s,A.Helper27,31662,{pos={x=88.6863, y=0.0, z=111.3137}, rotation=-0.78546, target=A.Helper27})
    end),
    At(15.094, 427, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-2.35628, target=A.Helper32})
    end),
    At(15.232, 428, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.95272)
    end),
    At(15.534, 429, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.03565)
    end),
    At(15.859, 430, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.07237)
    end),
    At(15.942, 431, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(15.942, 432, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(15.942, 433, function(d,s)
        C.Move(d,s,A.Helper31,{x=101.2633, y=0.0, z=83.1451},-5e-05)
    end),
    At(15.942, 434, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(15.942, 435, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(15.942, 436, function(d,s)
        C.Move(d,s,A.Helper26,{x=98.2669, y=0.0, z=83.5539},-5e-05)
    end),
    At(15.942, 437, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(15.942, 438, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(15.942, 439, function(d,s)
        C.Move(d,s,A.Helper25,{x=98.7513, y=0.0, z=83.7145},-5e-05)
    end),
    At(15.942, 440, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(15.942, 441, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(15.942, 442, function(d,s)
        C.Move(d,s,A.Helper24,{x=98.7929, y=0.0, z=82.595},-5e-05)
    end),
    At(15.942, 443, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(15.942, 444, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(15.942, 445, function(d,s)
        C.Move(d,s,A.Helper23,{x=99.3509, y=0.0, z=82.8636},-5e-05)
    end),
    At(15.942, 446, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(15.942, 447, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(15.942, 448, function(d,s)
        C.Move(d,s,A.Helper22,{x=98.2034, y=0.0, z=83.6774},-5e-05)
    end),
    At(15.942, 449, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(15.942, 450, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(15.942, 451, function(d,s)
        C.Move(d,s,A.Helper21,{x=100.8049, y=0.0, z=82.1893},-5e-05)
    end),
    At(15.942, 452, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(15.942, 453, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(15.942, 454, function(d,s)
        C.Move(d,s,A.Helper12,{x=101.1823, y=0.0, z=83.908},-5e-05)
    end),
    At(16.009, 455, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(16.009, 456, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(16.009, 457, function(d,s)
        C.Move(d,s,A.Helper04,{x=105.6569, y=0.0, z=105.6569},-2.35628)
    end),
    At(16.009, 458, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(16.009, 459, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(16.009, 460, function(d,s)
        C.Move(d,s,A.Helper03,{x=94.3431, y=0.0, z=105.6569},-0.78546)
    end),
    At(16.033, 461, function(d,s)
        C.Cast(d,s,A.Helper12,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=101.1521, y=-0.0153, z=83.8788}, pos={x=101.1823, y=0.0, z=83.908}, rotation=-5e-05, target=A.Helper12})
    end),
    At(16.033, 462, function(d,s)
        C.Cast(d,s,A.Helper21,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=100.7858, y=-0.0153, z=82.1698}, pos={x=100.8049, y=0.0, z=82.1893}, rotation=-5e-05, target=A.Helper21})
    end),
    At(16.033, 463, function(d,s)
        C.Cast(d,s,A.Helper22,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=98.1918, y=-0.0153, z=83.6652}, pos={x=98.2034, y=0.0, z=83.6774}, rotation=-5e-05, target=A.Helper22})
    end),
    At(16.033, 464, function(d,s)
        C.Cast(d,s,A.Helper24,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=98.7716, y=-0.0153, z=82.5666}, pos={x=98.7929, y=0.0, z=82.595}, rotation=-5e-05, target=A.Helper24})
    end),
    At(16.033, 465, function(d,s)
        C.Cast(d,s,A.Helper23,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=99.321, y=-0.0153, z=82.8412}, pos={x=99.3509, y=0.0, z=82.8636}, rotation=-5e-05, target=A.Helper23})
    end),
    At(16.033, 466, function(d,s)
        C.Cast(d,s,A.Helper26,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=98.2528, y=-0.0153, z=83.5431}, pos={x=98.2669, y=0.0, z=83.5539}, rotation=-5e-05, target=A.Helper26})
    end),
    At(16.033, 467, function(d,s)
        C.Cast(d,s,A.Helper25,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=98.7411, y=-0.0153, z=83.6957}, pos={x=98.7513, y=0.0, z=83.7145}, rotation=-5e-05, target=A.Helper25})
    end),
    At(16.033, 468, function(d,s)
        C.Cast(d,s,A.Helper31,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=101.2436, y=-0.0153, z=83.1159}, pos={x=101.2633, y=0.0, z=83.1451}, rotation=-5e-05, target=A.Helper31})
    end),
    At(16.033, 469, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(16.033, 470, function(d,s)
        C.Move(d,s,A.Helper02,{x=100.0, y=0.0, z=100.0},-1.57087)
    end),
    At(16.033, 471, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(16.033, 472, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=116.0},-5e-05)
    end),
    At(16.056, 473, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=94.3431, y=0.0, z=105.6569}, rotation=-0.78546, target=A.Helper03})
    end),
    At(16.056, 474, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=105.6569, y=0.0, z=105.6569}, rotation=-2.35628, target=A.Helper04})
    end),
    At(16.144, 475, function(d,s)
        C.Action(d,s,A.Helper01,31662,{pos={x=100.0, y=0.0, z=116.0}, rotation=-5e-05, target=A.Helper01})
    end),
    At(16.144, 476, function(d,s)
        C.Action(d,s,A.Helper02,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper02})
    end),
    At(16.849, 477, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.95885)
    end),
    At(17.007, 478, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(17.007, 479, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(17.007, 480, function(d,s)
        C.Move(d,s,A.Helper32,{x=111.3137, y=0.0, z=111.3137},-2.35628)
    end),
    At(17.007, 481, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(17.007, 482, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(17.007, 483, function(d,s)
        C.Move(d,s,A.Helper29,{x=108.0, y=0.0, z=100.0},-1.57087)
    end),
    At(17.007, 484, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(17.007, 485, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(17.007, 486, function(d,s)
        C.Move(d,s,A.Helper28,{x=100.0, y=0.0, z=100.0},-0.78546)
    end),
    At(17.007, 487, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(17.007, 488, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(17.007, 489, function(d,s)
        C.Move(d,s,A.Helper27,{x=100.0, y=0.0, z=108.0},-5e-05)
    end),
    At(17.007, 490, function(d,s)
        C.Action(d,s,A.Helper05,31663,{pos={x=105.4635, y=0.0, z=87.9742}, rotation=-5e-05, target=A.Helper05})
    end),
    At(17.007, 491, function(d,s)
        C.Action(d,s,A.Helper06,31663,{pos={x=106.0639, y=0.0, z=85.8486}, rotation=-5e-05, target=A.Helper06})
    end),
    At(17.007, 492, function(d,s)
        C.Action(d,s,A.Helper07,31663,{pos={x=105.6522, y=0.0, z=87.6207}, rotation=-5e-05, target=A.Helper07})
    end),
    At(17.007, 493, function(d,s)
        C.Action(d,s,A.Helper08,31663,{pos={x=105.178, y=0.0, z=88.2112}, rotation=-5e-05, target=A.Helper08})
    end),
    At(17.007, 494, function(d,s)
        C.Action(d,s,A.Helper09,31663,{pos={x=105.7863, y=0.0, z=85.6221}, rotation=-5e-05, target=A.Helper09})
    end),
    At(17.007, 495, function(d,s)
        C.Action(d,s,A.Helper10,31663,{pos={x=105.1669, y=0.0, z=87.8177}, rotation=-5e-05, target=A.Helper10})
    end),
    At(17.007, 496, function(d,s)
        C.Action(d,s,A.Helper11,31663,{pos={x=106.1795, y=0.0, z=85.4091}, rotation=-5e-05, target=A.Helper11})
    end),
    At(17.007, 497, function(d,s)
        C.Action(d,s,A.Helper30,31663,{pos={x=105.2303, y=0.0, z=86.911}, rotation=-5e-05, target=A.Helper30})
    end),
    At(17.084, 498, function(d,s)
        C.Action(d,s,A.Helper28,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.78546, target=A.Helper28})
    end),
    At(17.084, 499, function(d,s)
        C.Action(d,s,A.Helper27,31662,{pos={x=100.0, y=0.0, z=108.0}, rotation=-5e-05, target=A.Helper27})
    end),
    At(17.084, 500, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=111.3137, y=0.0, z=111.3137}, rotation=-2.35628, target=A.Helper32})
    end),
    At(17.084, 501, function(d,s)
        C.Action(d,s,A.Helper29,31662,{pos={x=108.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper29})
    end),
    At(17.377, 502, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.78983)
    end),
    At(17.697, 503, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.58561)
    end),
    At(17.97, 504, function(d,s)
        C.Owner(d,s,A.Helper20,nil)
    end),
    At(17.97, 505, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(17.97, 506, function(d,s)
        C.Move(d,s,A.Helper20,{x=91.4, y=0.0, z=86.1047},-5e-05)
    end),
    At(17.97, 507, function(d,s)
        C.Owner(d,s,A.Helper19,nil)
    end),
    At(17.97, 508, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(17.97, 509, function(d,s)
        C.Move(d,s,A.Helper19,{x=91.0315, y=0.0, z=86.4677},-5e-05)
    end),
    At(17.97, 510, function(d,s)
        C.Owner(d,s,A.Helper18,nil)
    end),
    At(17.97, 511, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(17.97, 512, function(d,s)
        C.Move(d,s,A.Helper18,{x=90.976, y=0.0, z=85.4782},-5e-05)
    end),
    At(17.97, 513, function(d,s)
        C.Owner(d,s,A.Helper17,nil)
    end),
    At(17.97, 514, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(17.97, 515, function(d,s)
        C.Move(d,s,A.Helper17,{x=91.1636, y=0.0, z=86.0437},-5e-05)
    end),
    At(17.97, 516, function(d,s)
        C.Owner(d,s,A.Helper16,nil)
    end),
    At(17.97, 517, function(d,s)
        C.Owner(d,s,A.Helper16,A.Boss)
    end),
    At(17.97, 518, function(d,s)
        C.Move(d,s,A.Helper16,{x=90.3885, y=0.0, z=86.3497},-5e-05)
    end),
    At(17.97, 519, function(d,s)
        C.Owner(d,s,A.Helper15,nil)
    end),
    At(17.97, 520, function(d,s)
        C.Owner(d,s,A.Helper15,A.Boss)
    end),
    At(17.97, 521, function(d,s)
        C.Move(d,s,A.Helper15,{x=93.8858, y=0.0, z=86.1864},-5e-05)
    end),
    At(17.97, 522, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(17.97, 523, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(17.97, 524, function(d,s)
        C.Move(d,s,A.Helper14,{x=92.1252, y=0.0, z=87.1663},-5e-05)
    end),
    At(17.97, 525, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(17.97, 526, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(17.97, 527, function(d,s)
        C.Move(d,s,A.Helper13,{x=90.8604, y=0.0, z=86.863},-5e-05)
    end),
    At(18.044, 528, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(18.044, 529, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(18.044, 530, function(d,s)
        C.Move(d,s,A.Helper04,{x=116.9706, y=-0.0, z=116.9706},-2.35628)
    end),
    At(18.044, 531, function(d,s)
        C.Owner(d,s,A.Helper03,nil)
    end),
    At(18.044, 532, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(18.044, 533, function(d,s)
        C.Move(d,s,A.Helper03,{x=105.6569, y=0.0, z=94.3431},-0.78546)
    end),
    At(18.044, 534, function(d,s)
        C.Cast(d,s,A.Helper13,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=90.837, y=-0.0153, z=86.8391}, pos={x=90.8604, y=0.0, z=86.863}, rotation=-5e-05, target=A.Helper13})
    end),
    At(18.044, 535, function(d,s)
        C.Cast(d,s,A.Helper14,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=92.1187, y=-0.0153, z=87.1443}, pos={x=92.1252, y=0.0, z=87.1663}, rotation=-5e-05, target=A.Helper14})
    end),
    At(18.044, 536, function(d,s)
        C.Cast(d,s,A.Helper15,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=93.8582, y=-0.0153, z=86.1677}, pos={x=93.8858, y=0.0, z=86.1864}, rotation=-5e-05, target=A.Helper15})
    end),
    At(18.044, 537, function(d,s)
        C.Cast(d,s,A.Helper16,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=90.3792, y=-0.0153, z=86.3203}, pos={x=90.3885, y=0.0, z=86.3497}, rotation=-5e-05, target=A.Helper16})
    end),
    At(18.044, 538, function(d,s)
        C.Cast(d,s,A.Helper17,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=91.1421, y=-0.0153, z=86.0151}, pos={x=91.1636, y=0.0, z=86.0437}, rotation=-5e-05, target=A.Helper17})
    end),
    At(18.044, 539, function(d,s)
        C.Cast(d,s,A.Helper18,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=90.959, y=-0.0153, z=85.4658}, pos={x=90.976, y=0.0, z=85.4782}, rotation=-5e-05, target=A.Helper18})
    end),
    At(18.044, 540, function(d,s)
        C.Cast(d,s,A.Helper20,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=91.3863, y=-0.0153, z=86.0761}, pos={x=91.4, y=0.0, z=86.1047}, rotation=-5e-05, target=A.Helper20})
    end),
    At(18.044, 541, function(d,s)
        C.Cast(d,s,A.Helper19,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=91.0201, y=-0.0153, z=86.4424}, pos={x=91.0315, y=0.0, z=86.4677}, rotation=-5e-05, target=A.Helper19})
    end),
    At(18.044, 542, function(d,s)
        C.Owner(d,s,A.Helper02,nil)
    end),
    At(18.044, 543, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(18.044, 544, function(d,s)
        C.Move(d,s,A.Helper02,{x=116.0, y=0.0, z=100.0},-1.57087)
    end),
    At(18.044, 545, function(d,s)
        C.Owner(d,s,A.Helper01,nil)
    end),
    At(18.044, 546, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(18.044, 547, function(d,s)
        C.Move(d,s,A.Helper01,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(18.093, 548, function(d,s)
        C.Action(d,s,A.Helper03,31662,{pos={x=105.6569, y=0.0, z=94.3431}, rotation=-0.78546, target=A.Helper03})
    end),
    At(18.093, 549, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=116.9706, y=-0.0, z=116.9706}, rotation=-2.35628, target=A.Helper04})
    end),
    At(18.17, 550, function(d,s)
        C.Action(d,s,A.Helper01,31662,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper01})
    end),
    At(18.17, 551, function(d,s)
        C.Action(d,s,A.Helper02,31662,{pos={x=116.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper02})
    end),
    At(18.867, 552, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.46922)
    end),
    At(19.016, 553, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(19.016, 554, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(19.016, 555, function(d,s)
        C.Move(d,s,A.Helper32,{x=124.0, y=-0.0, z=100.0},-1.57087)
    end),
    At(19.016, 556, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(19.016, 557, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(19.016, 558, function(d,s)
        C.Move(d,s,A.Helper30,{x=111.3137, y=0.0, z=88.6863},-0.78546)
    end),
    At(19.016, 559, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(19.016, 560, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(19.016, 561, function(d,s)
        C.Move(d,s,A.Helper29,{x=100.0, y=0.0, z=92.0},-5e-05)
    end),
    At(19.016, 562, function(d,s)
        C.Action(d,s,A.Helper12,31663,{pos={x=101.1823, y=0.0, z=83.908}, rotation=-5e-05, target=A.Helper12})
    end),
    At(19.016, 563, function(d,s)
        C.Action(d,s,A.Helper21,31663,{pos={x=100.8049, y=0.0, z=82.1893}, rotation=-5e-05, target=A.Helper21})
    end),
    At(19.016, 564, function(d,s)
        C.Action(d,s,A.Helper22,31663,{pos={x=98.2034, y=0.0, z=83.6774}, rotation=-5e-05, target=A.Helper22})
    end),
    At(19.016, 565, function(d,s)
        C.Action(d,s,A.Helper24,31663,{pos={x=98.7929, y=0.0, z=82.595}, rotation=-5e-05, target=A.Helper24})
    end),
    At(19.016, 566, function(d,s)
        C.Action(d,s,A.Helper23,31663,{pos={x=99.3509, y=0.0, z=82.8636}, rotation=-5e-05, target=A.Helper23})
    end),
    At(19.016, 567, function(d,s)
        C.Action(d,s,A.Helper26,31663,{pos={x=98.2669, y=0.0, z=83.5539}, rotation=-5e-05, target=A.Helper26})
    end),
    At(19.016, 568, function(d,s)
        C.Action(d,s,A.Helper25,31663,{pos={x=98.7513, y=0.0, z=83.7145}, rotation=-5e-05, target=A.Helper25})
    end),
    At(19.016, 569, function(d,s)
        C.Action(d,s,A.Helper31,31663,{pos={x=101.2633, y=0.0, z=83.1451}, rotation=-5e-05, target=A.Helper31})
    end),
    At(19.106, 570, function(d,s)
        C.Action(d,s,A.Helper30,31662,{pos={x=111.3137, y=0.0, z=88.6863}, rotation=-0.78546, target=A.Helper30})
    end),
    At(19.106, 571, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=124.0, y=-0.0, z=100.0}, rotation=-1.57087, target=A.Helper32})
    end),
    At(19.106, 572, function(d,s)
        C.Action(d,s,A.Helper29,31662,{pos={x=100.0, y=0.0, z=92.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(19.197, 573, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.27862)
    end),
    At(19.506, 574, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.02676)
    end),
    At(19.969, 575, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(19.969, 576, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(19.969, 577, function(d,s)
        C.Move(d,s,A.Helper28,{x=86.1116, y=0.0, z=92.3997},-5e-05)
    end),
    At(19.969, 578, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(19.969, 579, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(19.969, 580, function(d,s)
        C.Move(d,s,A.Helper27,{x=85.5535, y=0.0, z=93.5325},-5e-05)
    end),
    At(19.969, 581, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(19.969, 582, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(19.969, 583, function(d,s)
        C.Move(d,s,A.Helper11,{x=85.9319, y=0.0, z=92.5557},-5e-05)
    end),
    At(19.969, 584, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(19.969, 585, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(19.969, 586, function(d,s)
        C.Move(d,s,A.Helper10,{x=85.0254, y=0.0, z=92.6568},-5e-05)
    end),
    At(19.969, 587, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(19.969, 588, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(19.969, 589, function(d,s)
        C.Move(d,s,A.Helper09,{x=84.8241, y=0.0, z=95.5282},-5e-05)
    end),
    At(19.969, 590, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(19.969, 591, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(19.969, 592, function(d,s)
        C.Move(d,s,A.Helper08,{x=87.8035, y=0.0, z=91.1286},-5e-05)
    end),
    At(19.969, 593, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(19.969, 594, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(19.969, 595, function(d,s)
        C.Move(d,s,A.Helper07,{x=86.8512, y=0.0, z=93.7714},-5e-05)
    end),
    At(19.969, 596, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(19.969, 597, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(19.969, 598, function(d,s)
        C.Move(d,s,A.Helper06,{x=86.4372, y=0.0, z=92.5154},-5e-05)
    end),
    At(20.04, 599, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(20.04, 600, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(20.04, 601, function(d,s)
        C.Move(d,s,A.Helper05,{x=116.9706, y=-0.0, z=83.0294},-0.78546)
    end),
    At(20.106, 602, function(d,s)
        C.Cast(d,s,A.Helper06,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=86.4118, y=-0.0153, z=92.5154}, pos={x=86.4372, y=0.0, z=92.5154}, rotation=-5e-05, target=A.Helper06})
    end),
    At(20.106, 603, function(d,s)
        C.Cast(d,s,A.Helper07,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=86.8391, y=-0.0153, z=93.7667}, pos={x=86.8512, y=0.0, z=93.7714}, rotation=-5e-05, target=A.Helper07})
    end),
    At(20.106, 604, function(d,s)
        C.Cast(d,s,A.Helper08,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=87.7852, y=-0.0153, z=91.1116}, pos={x=87.8035, y=0.0, z=91.1286}, rotation=-5e-05, target=A.Helper08})
    end),
    At(20.106, 605, function(d,s)
        C.Cast(d,s,A.Helper09,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=84.7944, y=-0.0153, z=95.5062}, pos={x=84.8241, y=0.0, z=95.5282}, rotation=-5e-05, target=A.Helper09})
    end),
    At(20.106, 606, function(d,s)
        C.Cast(d,s,A.Helper10,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=85.008, y=-0.0153, z=92.6375}, pos={x=85.0254, y=0.0, z=92.6568}, rotation=-5e-05, target=A.Helper10})
    end),
    At(20.106, 607, function(d,s)
        C.Cast(d,s,A.Helper11,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=85.9236, y=-0.0153, z=92.546}, pos={x=85.9319, y=0.0, z=92.5557}, rotation=-5e-05, target=A.Helper11})
    end),
    At(20.106, 608, function(d,s)
        C.Cast(d,s,A.Helper28,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=86.1067, y=-0.0153, z=92.3934}, pos={x=86.1116, y=0.0, z=92.3997}, rotation=-5e-05, target=A.Helper28})
    end),
    At(20.106, 609, function(d,s)
        C.Cast(d,s,A.Helper27,31663,2.7,{spell=31663, omen_delay=0, cast_pos={x=85.5268, y=-0.0153, z=93.5225}, pos={x=85.5535, y=0.0, z=93.5325}, rotation=-5e-05, target=A.Helper27})
    end),
    At(20.106, 610, function(d,s)
        C.Owner(d,s,A.Helper04,nil)
    end),
    At(20.106, 611, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(20.106, 612, function(d,s)
        C.Move(d,s,A.Helper04,{x=100.0, y=0.0, z=84.0},-5e-05)
    end),
    At(20.106, 613, function(d,s)
        C.Action(d,s,A.Helper05,31662,{pos={x=116.9706, y=-0.0, z=83.0294}, rotation=-0.78546, target=A.Helper05})
    end),
    At(20.176, 614, function(d,s)
        C.Action(d,s,A.Helper04,31662,{pos={x=100.0, y=0.0, z=84.0}, rotation=-5e-05, target=A.Helper04})
    end),
    At(20.715, 615, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.98313)
    end),
    At(21.029, 616, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(21.029, 617, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(21.029, 618, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=76.0},-5e-05)
    end),
    At(21.029, 619, function(d,s)
        C.Action(d,s,A.Helper13,31663,{pos={x=90.8604, y=0.0, z=86.863}, rotation=-5e-05, target=A.Helper13})
    end),
    At(21.029, 620, function(d,s)
        C.Action(d,s,A.Helper14,31663,{pos={x=92.1252, y=0.0, z=87.1663}, rotation=-5e-05, target=A.Helper14})
    end),
    At(21.029, 621, function(d,s)
        C.Action(d,s,A.Helper15,31663,{pos={x=93.8858, y=0.0, z=86.1864}, rotation=-5e-05, target=A.Helper15})
    end),
    At(21.029, 622, function(d,s)
        C.Action(d,s,A.Helper16,31663,{pos={x=90.3885, y=0.0, z=86.3497}, rotation=-5e-05, target=A.Helper16})
    end),
    At(21.029, 623, function(d,s)
        C.Action(d,s,A.Helper17,31663,{pos={x=91.1636, y=0.0, z=86.0437}, rotation=-5e-05, target=A.Helper17})
    end),
    At(21.078, 624, function(d,s)
        C.Action(d,s,A.Helper18,31663,{pos={x=90.976, y=0.0, z=85.4782}, rotation=-5e-05, target=A.Helper18})
    end),
    At(21.078, 625, function(d,s)
        C.Action(d,s,A.Helper20,31663,{pos={x=91.4, y=0.0, z=86.1047}, rotation=-5e-05, target=A.Helper20})
    end),
    At(21.078, 626, function(d,s)
        C.Action(d,s,A.Helper19,31663,{pos={x=91.0315, y=0.0, z=86.4677}, rotation=-5e-05, target=A.Helper19})
    end),
    At(21.123, 627, function(d,s)
        C.Action(d,s,A.Helper32,31662,{pos={x=100.0, y=0.0, z=76.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(21.257, 628, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.78189)
    end),
    At(21.596, 629, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.54527)
    end),
    At(21.868, 630, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.31383)
    end),
    At(22.177, 631, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.14585)
    end),
    At(22.503, 632, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.96264)
    end),
    At(22.852, 633, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.88872)
    end),
    At(23.024, 634, function(d,s)
        C.Action(d,s,A.Helper06,31663,{pos={x=86.4372, y=0.0, z=92.5154}, rotation=-5e-05, target=A.Helper06})
    end),
    At(23.024, 635, function(d,s)
        C.Action(d,s,A.Helper07,31663,{pos={x=86.8512, y=0.0, z=93.7714}, rotation=-5e-05, target=A.Helper07})
    end),
    At(23.024, 636, function(d,s)
        C.Action(d,s,A.Helper08,31663,{pos={x=87.8035, y=0.0, z=91.1286}, rotation=-5e-05, target=A.Helper08})
    end),
    At(23.024, 637, function(d,s)
        C.Action(d,s,A.Helper09,31663,{pos={x=84.8241, y=0.0, z=95.5282}, rotation=-5e-05, target=A.Helper09})
    end),
    At(23.024, 638, function(d,s)
        C.Action(d,s,A.Helper10,31663,{pos={x=85.0254, y=0.0, z=92.6568}, rotation=-5e-05, target=A.Helper10})
    end),
    At(23.024, 639, function(d,s)
        C.Action(d,s,A.Helper11,31663,{pos={x=85.9319, y=0.0, z=92.5557}, rotation=-5e-05, target=A.Helper11})
    end),
    At(23.024, 640, function(d,s)
        C.Action(d,s,A.Helper28,31663,{pos={x=86.1116, y=0.0, z=92.3997}, rotation=-5e-05, target=A.Helper28})
    end),
    At(23.024, 641, function(d,s)
        C.Action(d,s,A.Helper27,31663,{pos={x=85.5535, y=0.0, z=93.5325}, rotation=-5e-05, target=A.Helper27})
    end),
}
