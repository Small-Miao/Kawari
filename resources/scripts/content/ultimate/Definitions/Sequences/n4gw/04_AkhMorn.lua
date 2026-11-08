-- 死亡轮回 [40310]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 215, function(d,s)
        C.Cast(d,s,A.Boss,40310,7.7,{spell=40310, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.56943, target=A.Boss})
    end),
    At(0.077, 218, function(d,s)
        C.Action(d,s,A.Helper03,40118,{pos={x=89.3934, y=0.0, z=89.3934}, rotation=0.78536, target=A.Helper03})
    end),
    At(0.077, 219, function(d,s)
        C.Action(d,s,A.Helper04,40307,{pos={x=89.3934, y=0.0, z=89.3934}, rotation=-2.35628, target=A.Helper04})
    end),
    At(0.077, 220, function(d,s)
        C.Action(d,s,A.Helper05,40118,{pos={x=100.0, y=0.0, z=90.0}, rotation=3.14159, target=A.Helper05})
    end),
    At(0.077, 221, function(d,s)
        C.Action(d,s,A.Helper06,40307,{pos={x=100.0, y=0.0, z=90.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(0.215, 222, function(d,s)
        C.Move(d,s,A.Helper07,{x=113.0, y=0.0, z=100.0},1.57077)
    end),
    At(0.215, 223, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.0, y=0.0, z=100.0},-1.57087)
    end),
    At(0.215, 224, function(d,s)
        C.Move(d,s,A.Helper13,{x=96.5147, y=0.0, z=103.4853},-0.78546)
    end),
    At(0.215, 225, function(d,s)
        C.Move(d,s,A.Helper14,{x=110.6569, y=0.0, z=89.3432},2.35618)
    end),
    At(0.292, 226, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=113.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper07})
    end),
    At(0.292, 227, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=93.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(0.292, 228, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=96.5147, y=0.0, z=103.4853}, rotation=-0.78546, target=A.Helper13})
    end),
    At(0.292, 229, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=110.6569, y=0.0, z=89.3432}, rotation=2.35618, target=A.Helper14})
    end),
    At(0.292, 230, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=90.0},-3.14159)
    end),
    At(0.292, 231, function(d,s)
        C.Move(d,s,A.Helper12,{x=89.4436, y=0.0, z=89.4436},-2.35628)
    end),
    At(0.372, 232, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=90.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(0.372, 233, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=89.4436, y=0.0, z=89.4436}, rotation=-2.35628, target=A.Helper12})
    end),
    At(2.191, 234, function(d,s)
        C.Move(d,s,A.Helper03,{x=92.9289, y=0.0, z=92.9289},0.78536)
    end),
    At(2.191, 235, function(d,s)
        C.Move(d,s,A.Helper04,{x=85.8578, y=0.0, z=85.8578},-2.35628)
    end),
    At(2.191, 236, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=85.0},3.14159)
    end),
    At(2.191, 237, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=95.0},-5e-05)
    end),
    At(2.191, 238, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=92.9289, y=0.0, z=92.9289}, rotation=0.78536, target=A.Helper03})
    end),
    At(2.191, 239, function(d,s)
        C.Action(d,s,A.Helper04,40308,{pos={x=85.8578, y=0.0, z=85.8578}, rotation=-2.35628, target=A.Helper04})
    end),
    At(2.191, 240, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=85.0}, rotation=3.14159, target=A.Helper05})
    end),
    At(2.191, 241, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=95.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(2.252, 242, function(d,s)
        C.Move(d,s,A.Helper07,{x=118.0, y=0.0, z=100.0},1.57077)
    end),
    At(2.252, 243, function(d,s)
        C.Move(d,s,A.Helper08,{x=88.0, y=0.0, z=100.0},-1.57087)
    end),
    At(2.252, 244, function(d,s)
        C.Move(d,s,A.Helper13,{x=92.9792, y=0.0, z=107.0208},-0.78546)
    end),
    At(2.252, 245, function(d,s)
        C.Move(d,s,A.Helper14,{x=114.1924, y=0.0, z=85.8076},2.35618)
    end),
    At(2.333, 246, function(d,s)
        C.Action(d,s,A.Helper07,40309,{pos={x=118.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper07})
    end),
    At(2.333, 247, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=88.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(2.333, 248, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=92.9792, y=0.0, z=107.0208}, rotation=-0.78546, target=A.Helper13})
    end),
    At(2.333, 249, function(d,s)
        C.Action(d,s,A.Helper14,40308,{pos={x=114.1924, y=0.0, z=85.8076}, rotation=2.35618, target=A.Helper14})
    end),
    At(2.393, 250, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=85.0},-3.14159)
    end),
    At(2.393, 251, function(d,s)
        C.Move(d,s,A.Helper12,{x=85.9081, y=0.0, z=85.9081},-2.35628)
    end),
    At(2.393, 254, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=85.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(2.393, 255, function(d,s)
        C.Action(d,s,A.Helper12,40308,{pos={x=85.9081, y=0.0, z=85.9081}, rotation=-2.35628, target=A.Helper12})
    end),
    At(4.164, 256, function(d,s)
        C.Move(d,s,A.Helper03,{x=96.4644, y=0.0, z=96.4645},0.78536)
    end),
    At(4.164, 257, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0, y=0.0, z=80.0},3.14159)
    end),
    At(4.164, 258, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=100.0},-5e-05)
    end),
    At(4.225, 259, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=96.4644, y=0.0, z=96.4645}, rotation=0.78536, target=A.Helper03})
    end),
    At(4.225, 260, function(d,s)
        C.Action(d,s,A.Helper05,40309,{pos={x=100.0, y=0.0, z=80.0}, rotation=3.14159, target=A.Helper05})
    end),
    At(4.225, 261, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(4.341, 262, function(d,s)
        C.Move(d,s,A.Helper08,{x=83.0, y=0.0, z=100.0},-1.57087)
    end),
    At(4.341, 263, function(d,s)
        C.Move(d,s,A.Helper13,{x=89.4436, y=0.0, z=110.5563},-0.78546)
    end),
    At(4.378, 264, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=83.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(4.378, 265, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=89.4436, y=0.0, z=110.5563}, rotation=-0.78546, target=A.Helper13})
    end),
    At(4.42, 266, function(d,s)
        C.Move(d,s,A.Helper09,{x=100.0, y=0.0, z=80.0},-3.14159)
    end),
    At(4.438, 267, function(d,s)
        C.Action(d,s,A.Helper09,40309,{pos={x=100.0, y=0.0, z=80.0}, rotation=-3.14159, target=A.Helper09})
    end),
    At(6.239, 268, function(d,s)
        C.Move(d,s,A.Helper03,{x=100.0, y=0.0, z=100.0},0.78536)
    end),
    At(6.239, 269, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=105.0},-5e-05)
    end),
    At(6.276, 270, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.78536, target=A.Helper03})
    end),
    At(6.276, 271, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=105.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(6.391, 272, function(d,s)
        C.Move(d,s,A.Helper08,{x=78.0, y=0.0, z=100.0},-1.57087)
    end),
    At(6.391, 273, function(d,s)
        C.Move(d,s,A.Helper13,{x=85.9081, y=0.0, z=114.0919},-0.78546)
    end),
    At(6.466, 274, function(d,s)
        C.Action(d,s,A.Helper08,40308,{pos={x=78.0, y=0.0, z=100.0}, rotation=-1.57087, target=A.Helper08})
    end),
    At(6.466, 275, function(d,s)
        C.Action(d,s,A.Helper13,40309,{pos={x=85.9081, y=0.0, z=114.0919}, rotation=-0.78546, target=A.Helper13})
    end),
    At(7.975, 276, function(d,s)
        C.Action(d,s,A.Boss,40310,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.56943, target=A.Boss})
    end),
    At(7.975, 277, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(7.975, 278, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(7.975, 279, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(7.975, 280, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(8.03, 281, function(d,s)
        C.Action(d,s,A.Helper12,40311,{pos={x=85.9081, y=0.0, z=85.9081}, rotation=-2.35628})
    end),
    At(8.03, 282, function(d,s)
        C.Action(d,s,A.Helper14,40312,{pos={x=114.1924, y=0.0, z=85.8076}, rotation=2.35618})
    end),
    At(8.31, 283, function(d,s)
        C.Move(d,s,A.Helper03,{x=103.5355, y=0.0, z=103.5355},0.78536)
    end),
    At(8.31, 284, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=110.0},-5e-05)
    end),
    At(8.386, 285, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=103.5355, y=0.0, z=103.5355}, rotation=0.78536, target=A.Helper03})
    end),
    At(8.386, 286, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=110.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(10.335, 287, function(d,s)
        C.Move(d,s,A.Helper03,{x=107.071, y=0.0, z=107.0711},0.78536)
    end),
    At(10.335, 288, function(d,s)
        C.Move(d,s,A.Helper06,{x=100.0, y=0.0, z=115.0},-5e-05)
    end),
    At(10.395, 289, function(d,s)
        C.Action(d,s,A.Helper03,40309,{pos={x=107.071, y=0.0, z=107.0711}, rotation=0.78536, target=A.Helper03})
    end),
    At(10.395, 290, function(d,s)
        C.Action(d,s,A.Helper06,40308,{pos={x=100.0, y=0.0, z=115.0}, rotation=-5e-05, target=A.Helper06})
    end),
    At(11.103, 291, function(d,s)
        C.Action(d,s,A.Boss,40114,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.56943, target=A.Boss})
    end),
    At(11.389, 292, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.11452)
    end),
    At(11.674, 293, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.51718)
    end),
    At(11.712, 294, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(11.712, 295, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(11.712, 296, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.51718)
    end),
    At(11.712, 297, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(11.712, 298, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(11.712, 299, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.51718)
    end),
    At(11.858, 300, function(d,s)
        C.Action(d,s,A.Helper13,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.51718})
    end),
    At(11.858, 301, function(d,s)
        C.Action(d,s,A.Helper14,40115,{pos={x=100.0, y=0.0, z=100.0}, rotation=1.51718})
    end),
}
