-- 光与暗的孤翼 [40313]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 316, function(d,s)
        C.Cast(d,s,A.Boss,40313,6.6,{spell=40313, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.51718, target=A.Boss})
    end),
    At(6.861, 323, function(d,s)
        C.Action(d,s,A.Boss,40313,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.51718, target=A.Boss})
    end),
    At(7.144, 325, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.05295)
    end),
    At(7.144, 326, function(d,s)
        C.Action(d,s,A.Boss,40314,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=1.05295, target=A.Boss})
    end),
    At(7.204, 327, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(7.204, 328, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(7.204, 329, function(d,s)
        C.Move(d,s,A.Helper14,{x=93.9378, y=0.0, z=96.5},1.0472)
    end),
    At(7.285, 331, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=93.9378, y=0.0, z=96.5}, rotation=1.0472, target=A.Helper14})
    end),
    At(7.884, 332, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(7.884, 333, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(7.948, 334, function(d,s)
        C.Action(d,s,A.Helper13,39879,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.51718})
    end),
    At(8.582, 335, function(d,s)
        C.Untether(d,s,A.Boss,0,0)
    end),
    At(10.732, 338, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(10.732, 339, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(10.732, 340, function(d,s)
        C.Move(d,s,A.Helper14,{x=106.0622, y=0.0, z=96.5},-1.0472)
    end),
    At(10.732, 342, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.50004)
    end),
    At(10.803, 343, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=106.0622, y=0.0, z=96.5}, rotation=-1.0472, target=A.Helper14})
    end),
    At(10.935, 344, function(d,s)
        C.Action(d,s,A.Boss,40315,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.7404, target=A.Boss})
    end),
    At(11.146, 345, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.7404)
    end),
    At(11.71, 346, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(11.71, 347, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.71, 348, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.71, 349, function(d,s)
        C.Action(d,s,A.Helper13,39880,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.51718})
    end),
    At(12.201, 350, function(d,s)
        C.Untether(d,s,A.Boss,0,0)
    end),
    At(14.205, 351, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(14.205, 352, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(14.205, 353, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=107.0},-3.14159)
    end),
    At(14.278, 355, function(d,s)
        C.Action(d,s,A.Helper14,40320,{pos={x=100.0, y=0.0, z=107.0}, rotation=-3.14159, target=A.Helper14})
    end),
    At(15.352, 356, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.95823)
    end),
    At(15.703, 357, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.27902)
    end),
    At(15.981, 358, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.43511)
    end),
    At(16.504, 359, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.44853, target=A.Boss})
    end),
    At(17.133, 360, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(17.133, 361, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(17.133, 362, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-1.45649)
    end),
    At(17.133, 363, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(17.133, 364, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(17.133, 365, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.45649)
    end),
    At(17.206, 366, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.52916)
    end),
    At(17.26, 367, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.45649})
    end),
    At(17.26, 368, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.45649})
    end),
    At(19.663, 369, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(20.304, 370, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(20.304, 371, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(20.304, 372, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},-1.53664)
    end),
    At(20.304, 373, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(20.304, 374, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(20.304, 375, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},-1.53664)
    end),
    At(20.383, 376, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.53664})
    end),
    At(20.383, 377, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=-1.53664})
    end),
}
