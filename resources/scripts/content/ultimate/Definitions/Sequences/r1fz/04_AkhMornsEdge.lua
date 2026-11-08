-- 死亡轮回剑 [28051]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 256, function(d,s)
        C.Cast(d,s,A.Boss,28051,5.7,{spell=28051, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(0.0, 257, function(d,s)
        C.Cast(d,s,A.Helper08,29453,6.4,{spell=29453, omen_delay=20, cast_pos={x=93.0343, y=-0.0153, z=96.0555}, pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.0, 258, function(d,s)
        C.Cast(d,s,A.Helper09,29452,6.4,{spell=29452, omen_delay=10, cast_pos={x=106.8894, y=-0.0153, z=95.9335}, pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.0, 259, function(d,s)
        C.Cast(d,s,A.Helper10,29454,6.4,{spell=29454, omen_delay=30, cast_pos={x=100.0534, y=-0.0153, z=107.9881}, pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.948, 260, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(1.75, 261, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.152, 262, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(4.761, 263, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.371, 264, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.644, 265, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(6.0, 266, function(d,s)
        C.Action(d,s,A.Boss,28051,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(6.441, 267, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(6.73, 268, function(d,s)
        C.Action(d,s,A.Helper08,29453,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper08})
    end),
    At(6.73, 269, function(d,s)
        C.Action(d,s,A.Helper09,29452,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper09})
    end),
    At(6.73, 270, function(d,s)
        C.Action(d,s,A.Helper10,29454,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper10})
    end),
    At(6.79, 271, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(6.79, 272, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(6.79, 273, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},-3.13248)
    end),
    At(6.865, 274, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.13248, target=A.Helper07})
    end),
    At(8.146, 275, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(8.877, 276, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.877, 277, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.877, 278, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.073, y=0.0, z=107.9997},-5e-05)
    end),
    At(8.877, 279, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.877, 280, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.877, 281, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.8914, y=0.0, z=95.937},-5e-05)
    end),
    At(8.877, 282, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.877, 283, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.877, 284, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.0356, y=0.0, z=96.0633},-5e-05)
    end),
    At(8.951, 285, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper08})
    end),
    At(8.951, 286, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper09})
    end),
    At(8.951, 287, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.155, 288, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(9.961, 289, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.961, 290, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.961, 291, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.073, y=0.0, z=107.9997},-5e-05)
    end),
    At(9.961, 292, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(9.961, 293, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(9.961, 294, function(d,s)
        C.Move(d,s,A.Helper06,{x=106.8914, y=0.0, z=95.937},-5e-05)
    end),
    At(9.961, 295, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(9.961, 296, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(9.961, 297, function(d,s)
        C.Move(d,s,A.Helper05,{x=93.0356, y=0.0, z=96.0633},-5e-05)
    end),
    At(10.014, 298, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper05})
    end),
    At(10.014, 299, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper06})
    end),
    At(10.014, 300, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper07})
    end),
    At(10.23, 301, function(d,s)
        C.Action(d,s,A.Boss,28052,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(11.057, 302, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(11.057, 303, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(11.057, 304, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.073, y=0.0, z=107.9997},-5e-05)
    end),
    At(11.057, 305, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(11.057, 306, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(11.057, 307, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.8914, y=0.0, z=95.937},-5e-05)
    end),
    At(11.057, 308, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(11.057, 309, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(11.057, 310, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.0356, y=0.0, z=96.0633},-5e-05)
    end),
    At(11.057, 311, function(d,s)
        C.Action(d,s,A.Helper08,28054,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper08})
    end),
    At(11.057, 312, function(d,s)
        C.Action(d,s,A.Helper09,28054,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper09})
    end),
    At(11.057, 313, function(d,s)
        C.Action(d,s,A.Helper10,28055,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper10})
    end),
    At(11.276, 314, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(11.298, 315, function(d,s)
        C.Action(d,s,A.Boss,28053,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(12.123, 316, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(12.123, 317, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(12.123, 318, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.073, y=0.0, z=107.9997},-5e-05)
    end),
    At(12.123, 319, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(12.123, 320, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(12.123, 321, function(d,s)
        C.Move(d,s,A.Helper06,{x=106.8914, y=0.0, z=95.937},-5e-05)
    end),
    At(12.123, 322, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(12.123, 323, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(12.123, 324, function(d,s)
        C.Move(d,s,A.Helper05,{x=93.0356, y=0.0, z=96.0633},-5e-05)
    end),
    At(12.123, 325, function(d,s)
        C.Action(d,s,A.Helper05,28054,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05, target=A.Helper05})
    end),
    At(12.123, 326, function(d,s)
        C.Action(d,s,A.Helper06,28054,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05, target=A.Helper06})
    end),
    At(12.123, 327, function(d,s)
        C.Action(d,s,A.Helper07,28055,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05, target=A.Helper07})
    end),
    At(13.41, 328, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.01966)
    end),
    At(13.737, 329, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.21826)
    end),
    At(14.074, 330, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.4892)
    end),
    At(14.357, 331, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.80741)
    end),
    At(14.675, 332, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.65948)
    end),
    At(15.045, 333, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.38969)
    end),
    At(15.328, 334, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.28671)
    end),
    At(15.62, 335, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.17176)
    end),
    At(15.916, 336, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.02277)
    end),
    At(16.263, 337, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.02699)
    end),
    At(17.491, 338, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.02335, target=A.Boss})
    end),
    At(18.49, 339, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(18.49, 340, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(18.49, 341, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(18.49, 342, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(18.49, 343, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(18.49, 344, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(18.556, 345, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05})
    end),
    At(18.556, 346, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05})
    end),
    At(18.556, 347, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05})
    end),
    At(21.454, 348, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01184, target=A.Boss})
    end),
    At(22.496, 349, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(22.496, 350, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(22.496, 351, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(22.496, 352, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(22.496, 353, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(22.496, 354, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(22.531, 355, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=93.0356, y=0.0, z=96.0633}, rotation=-5e-05})
    end),
    At(22.531, 356, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=106.8914, y=0.0, z=95.937}, rotation=-5e-05})
    end),
    At(22.531, 357, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.073, y=0.0, z=107.9997}, rotation=-5e-05})
    end),
    At(24.458, 358, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(24.458, 359, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(24.458, 360, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.1651, y=0.0, z=86.001},-5e-05)
    end),
    At(24.458, 361, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(24.458, 362, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(24.458, 363, function(d,s)
        C.Move(d,s,A.Helper09,{x=87.7939, y=0.0, z=106.8565},-5e-05)
    end),
    At(24.458, 364, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(24.458, 365, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(24.458, 366, function(d,s)
        C.Move(d,s,A.Helper08,{x=112.041, y=0.0, z=107.1425},-5e-05)
    end),
}
