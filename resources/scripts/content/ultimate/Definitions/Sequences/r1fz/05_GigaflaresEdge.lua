-- 十亿核爆剑 [28057]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 367, function(d,s)
        C.Cast(d,s,A.Boss,28057,7.7,{spell=28057, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01184, target=A.Boss})
    end),
    At(0.0, 368, function(d,s)
        C.Cast(d,s,A.Helper08,28114,12.7,{spell=28114, omen_delay=36, cast_pos={x=112.0165, y=-0.0153, z=107.1336}, pos={x=112.041, y=0.0, z=107.1425}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.0, 369, function(d,s)
        C.Cast(d,s,A.Helper09,28115,16.7,{spell=28115, omen_delay=54, cast_pos={x=87.7852, y=-0.0153, z=106.8284}, pos={x=87.7939, y=0.0, z=106.8565}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.0, 370, function(d,s)
        C.Cast(d,s,A.Helper10,28058,8.7,{spell=28058, omen_delay=18, cast_pos={x=100.145, y=-0.0153, z=85.9846}, pos={x=100.1651, y=0.0, z=86.001}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.927, 371, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(1.236, 372, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.97, 373, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(4.306, 374, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(7.3, 375, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(7.951, 376, function(d,s)
        C.Action(d,s,A.Boss,28057,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01184, target=A.Boss})
    end),
    At(8.98, 377, function(d,s)
        C.Action(d,s,A.Helper10,28058,{pos={x=100.1651, y=0.0, z=86.001}, rotation=-5e-05, target=A.Helper10})
    end),
    At(9.115, 378, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(9.115, 379, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(9.115, 380, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},-0.01184)
    end),
    At(9.115, 381, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=-0.01184, target=A.Helper07})
    end),
    At(12.142, 382, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.6957)
    end),
    At(12.509, 383, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.1536)
    end),
    At(12.8, 384, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.17785)
    end),
    At(13.017, 385, function(d,s)
        C.Action(d,s,A.Helper08,28114,{pos={x=112.041, y=0.0, z=107.1425}, rotation=-5e-05, target=A.Helper08})
    end),
    At(13.305, 386, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.1954)
    end),
    At(13.608, 387, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.36031)
    end),
    At(13.931, 388, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.61994)
    end),
    At(14.243, 389, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.02252)
    end),
    At(14.555, 390, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.90593)
    end),
    At(14.867, 391, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.46222)
    end),
    At(15.186, 392, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.22148)
    end),
    At(15.498, 393, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.07441)
    end),
    At(15.803, 394, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.00777)
    end),
    At(16.365, 395, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.94564)
    end),
    At(16.662, 396, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.85782)
    end),
    At(17.016, 397, function(d,s)
        C.Action(d,s,A.Helper09,28115,{pos={x=87.7939, y=0.0, z=106.8565}, rotation=-5e-05, target=A.Helper09})
    end),
    At(17.232, 398, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.7794)
    end),
    At(17.521, 399, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.67336)
    end),
    At(17.812, 400, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.50702)
    end),
    At(18.137, 401, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.30884)
    end),
    At(18.442, 402, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.08919)
    end),
    At(18.75, 403, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.85727)
    end),
    At(19.111, 404, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.61825)
    end),
    At(19.412, 405, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.36696)
    end),
    At(19.723, 406, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.15086)
    end),
    At(20.06, 407, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.04377)
    end),
    At(23.275, 408, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.01807)
    end),
    At(26.184, 409, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01807, target=A.Boss})
    end),
    At(27.161, 410, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(27.161, 411, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(27.161, 412, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(27.161, 413, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(27.161, 414, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(27.161, 415, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(27.195, 416, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=112.041, y=0.0, z=107.1425}, rotation=-5e-05})
    end),
    At(27.195, 417, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=87.7939, y=0.0, z=106.8565}, rotation=-5e-05})
    end),
    At(27.195, 418, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.1651, y=0.0, z=86.001}, rotation=-5e-05})
    end),
    At(30.178, 419, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-0.01807, target=A.Boss})
    end),
    At(31.179, 420, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(31.179, 421, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(31.179, 422, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(31.179, 423, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(31.179, 424, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(31.179, 425, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(31.265, 426, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=112.041, y=0.0, z=107.1425}, rotation=-5e-05})
    end),
    At(31.265, 427, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=87.7939, y=0.0, z=106.8565}, rotation=-5e-05})
    end),
    At(31.265, 428, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=100.1651, y=0.0, z=86.001}, rotation=-5e-05})
    end),
    At(33.115, 429, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(33.115, 430, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(33.115, 431, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.3663, y=0.0, z=92.0084},3.09576)
    end),
    At(33.115, 432, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(33.115, 433, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(33.115, 434, function(d,s)
        C.Move(d,s,A.Helper09,{x=92.8959, y=0.0, z=103.6785},2.31035)
    end),
    At(33.115, 435, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(33.115, 436, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(33.115, 437, function(d,s)
        C.Move(d,s,A.Helper08,{x=106.7378, y=0.0, z=104.3131},-1.6167)
    end),
    At(33.182, 438, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.04588)
    end),
}
