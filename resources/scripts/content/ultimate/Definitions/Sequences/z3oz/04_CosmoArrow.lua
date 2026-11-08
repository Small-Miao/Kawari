-- 宇宙天箭 [31650]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 72, function(d,s)
        C.Cast(d,s,A.Helper23,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=79.9725, y=-0.0153, z=114.9767}, pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper23})
    end),
    At(0.0, 73, function(d,s)
        C.Cast(d,s,A.Helper24,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=79.9725, y=-0.0153, z=114.9767}, pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper24})
    end),
    At(0.0, 74, function(d,s)
        C.Cast(d,s,A.Helper26,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=114.9767, y=-0.0153, z=119.9817}, pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper26})
    end),
    At(0.0, 75, function(d,s)
        C.Cast(d,s,A.Helper27,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=119.9817, y=-0.0153, z=84.9775}, pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper27})
    end),
    At(0.0, 76, function(d,s)
        C.Cast(d,s,A.Helper28,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=119.9817, y=-0.0153, z=84.9775}, pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper28})
    end),
    At(0.0, 77, function(d,s)
        C.Cast(d,s,A.Helper30,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=84.9775, y=-0.0153, z=79.9725}, pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper30})
    end),
    At(0.0, 78, function(d,s)
        C.Cast(d,s,A.Helper25,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=114.9767, y=-0.0153, z=119.9817}, pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper25})
    end),
    At(0.0, 79, function(d,s)
        C.Cast(d,s,A.Helper29,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=84.9775, y=-0.0153, z=79.9725}, pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(0.0, 80, function(d,s)
        C.Cast(d,s,A.Boss,31650,5.7,{spell=31650, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(1.892, 81, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(1.892, 82, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(1.892, 83, function(d,s)
        C.Move(d,s,A.Helper32,{x=100.0, y=0.0, z=80.0},-5e-05)
    end),
    At(1.892, 84, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(1.892, 85, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(1.892, 86, function(d,s)
        C.Move(d,s,A.Helper31,{x=100.0, y=0.0, z=80.0},-5e-05)
    end),
    At(1.892, 87, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(1.892, 88, function(d,s)
        C.Move(d,s,A.Helper22,{x=80.0, y=0.0, z=100.0},1.57077)
    end),
    At(1.892, 89, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(1.892, 90, function(d,s)
        C.Move(d,s,A.Helper21,{x=80.0, y=0.0, z=100.0},1.57077)
    end),
    At(1.961, 91, function(d,s)
        C.Cast(d,s,A.Helper21,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=79.9725, y=-0.0153, z=99.9924}, pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper21})
    end),
    At(1.961, 92, function(d,s)
        C.Cast(d,s,A.Helper22,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=79.9725, y=-0.0153, z=99.9924}, pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper22})
    end),
    At(1.961, 93, function(d,s)
        C.Cast(d,s,A.Helper31,31651,7.7,{spell=31651, omen_delay=20, cast_pos={x=99.9924, y=-0.0153, z=79.9725}, pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper31})
    end),
    At(1.961, 94, function(d,s)
        C.Cast(d,s,A.Helper32,32337,5.2,{spell=32337, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=79.9725}, pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(5.459, 95, function(d,s)
        C.Action(d,s,A.Helper24,32337,{pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper24})
    end),
    At(5.459, 96, function(d,s)
        C.Action(d,s,A.Helper26,32337,{pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper26})
    end),
    At(5.459, 97, function(d,s)
        C.Action(d,s,A.Helper28,32337,{pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper28})
    end),
    At(5.459, 98, function(d,s)
        C.Action(d,s,A.Helper30,32337,{pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper30})
    end),
    At(5.967, 99, function(d,s)
        C.Action(d,s,A.Boss,31650,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.07649, target=A.Boss})
    end),
    At(7.451, 100, function(d,s)
        C.Action(d,s,A.Helper22,32337,{pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper22})
    end),
    At(7.451, 101, function(d,s)
        C.Action(d,s,A.Helper32,32337,{pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(7.909, 102, function(d,s)
        C.Action(d,s,A.Helper23,31651,{pos={x=80.0, y=0.0, z=115.0}, rotation=1.57077, target=A.Helper23})
    end),
    At(7.909, 103, function(d,s)
        C.Action(d,s,A.Helper27,31651,{pos={x=120.0, y=0.0, z=85.0}, rotation=-1.57087, target=A.Helper27})
    end),
    At(7.909, 104, function(d,s)
        C.Action(d,s,A.Helper25,31651,{pos={x=115.0, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper25})
    end),
    At(7.909, 105, function(d,s)
        C.Action(d,s,A.Helper29,31651,{pos={x=85.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(9.952, 106, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(9.952, 107, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(9.952, 108, function(d,s)
        C.Move(d,s,A.Helper32,{x=92.5, y=0.0, z=80.0},-5e-05)
    end),
    At(9.952, 109, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(9.952, 110, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(9.952, 111, function(d,s)
        C.Move(d,s,A.Helper30,{x=120.0, y=0.0, z=92.5},-1.57087)
    end),
    At(9.952, 112, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(9.952, 113, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(9.952, 114, function(d,s)
        C.Move(d,s,A.Helper28,{x=107.5, y=0.0, z=120.0},-3.14159)
    end),
    At(9.952, 115, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(9.952, 116, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(9.952, 117, function(d,s)
        C.Move(d,s,A.Helper26,{x=80.0, y=0.0, z=107.5},1.57077)
    end),
    At(9.952, 118, function(d,s)
        C.Action(d,s,A.Helper21,31651,{pos={x=80.0, y=0.0, z=100.0}, rotation=1.57077, target=A.Helper21})
    end),
    At(9.952, 119, function(d,s)
        C.Action(d,s,A.Helper31,31651,{pos={x=100.0, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper31})
    end),
    At(10.067, 120, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=80.0, y=0.0, z=107.5}, rotation=1.57077, target=A.Helper26})
    end),
    At(10.067, 121, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=107.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper28})
    end),
    At(10.067, 122, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=120.0, y=0.0, z=92.5}, rotation=-1.57087, target=A.Helper30})
    end),
    At(10.067, 123, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=92.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
    At(11.94, 124, function(d,s)
        C.Owner(d,s,A.Helper29,nil)
    end),
    At(11.94, 125, function(d,s)
        C.Owner(d,s,A.Helper29,A.Boss)
    end),
    At(11.94, 126, function(d,s)
        C.Move(d,s,A.Helper29,{x=97.5, y=0.0, z=80.0},-5e-05)
    end),
    At(11.94, 127, function(d,s)
        C.Owner(d,s,A.Helper27,nil)
    end),
    At(11.94, 128, function(d,s)
        C.Owner(d,s,A.Helper27,A.Boss)
    end),
    At(11.94, 129, function(d,s)
        C.Move(d,s,A.Helper27,{x=120.0, y=0.0, z=97.5},-1.57087)
    end),
    At(11.94, 130, function(d,s)
        C.Owner(d,s,A.Helper25,nil)
    end),
    At(11.94, 131, function(d,s)
        C.Owner(d,s,A.Helper25,A.Boss)
    end),
    At(11.94, 132, function(d,s)
        C.Move(d,s,A.Helper25,{x=102.5, y=0.0, z=120.0},-3.14159)
    end),
    At(11.94, 133, function(d,s)
        C.Owner(d,s,A.Helper24,nil)
    end),
    At(11.94, 134, function(d,s)
        C.Owner(d,s,A.Helper24,A.Boss)
    end),
    At(11.94, 135, function(d,s)
        C.Move(d,s,A.Helper24,{x=80.0, y=0.0, z=102.5},1.57077)
    end),
    At(11.94, 136, function(d,s)
        C.Owner(d,s,A.Helper23,nil)
    end),
    At(11.94, 137, function(d,s)
        C.Owner(d,s,A.Helper23,A.Boss)
    end),
    At(11.94, 138, function(d,s)
        C.Move(d,s,A.Helper23,{x=92.5, y=0.0, z=80.0},-5e-05)
    end),
    At(11.94, 139, function(d,s)
        C.Owner(d,s,A.Helper22,nil)
    end),
    At(11.94, 140, function(d,s)
        C.Owner(d,s,A.Helper22,A.Boss)
    end),
    At(11.94, 141, function(d,s)
        C.Move(d,s,A.Helper22,{x=107.5, y=0.0, z=80.0},-5e-05)
    end),
    At(11.94, 142, function(d,s)
        C.Owner(d,s,A.Helper20,A.Boss)
    end),
    At(11.94, 143, function(d,s)
        C.Move(d,s,A.Helper20,{x=79.9999, y=-0.0, z=92.5},1.57077)
    end),
    At(11.997, 144, function(d,s)
        C.Owner(d,s,A.Helper19,A.Boss)
    end),
    At(11.997, 145, function(d,s)
        C.Move(d,s,A.Helper19,{x=80.0, y=-0.0, z=107.5},1.57077)
    end),
    At(12.066, 146, function(d,s)
        C.Action(d,s,A.Helper20,31652,{pos={x=79.9999, y=-0.0, z=92.5}, rotation=1.57077, target=A.Helper20})
    end),
    At(12.066, 147, function(d,s)
        C.Action(d,s,A.Helper22,31652,{pos={x=107.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper22})
    end),
    At(12.066, 148, function(d,s)
        C.Action(d,s,A.Helper23,31652,{pos={x=92.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper23})
    end),
    At(12.066, 149, function(d,s)
        C.Action(d,s,A.Helper24,31652,{pos={x=80.0, y=0.0, z=102.5}, rotation=1.57077, target=A.Helper24})
    end),
    At(12.066, 150, function(d,s)
        C.Action(d,s,A.Helper27,31652,{pos={x=120.0, y=0.0, z=97.5}, rotation=-1.57087, target=A.Helper27})
    end),
    At(12.066, 151, function(d,s)
        C.Action(d,s,A.Helper25,31652,{pos={x=102.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper25})
    end),
    At(12.066, 152, function(d,s)
        C.Action(d,s,A.Helper19,31652,{pos={x=80.0, y=-0.0, z=107.5}, rotation=1.57077, target=A.Helper19})
    end),
    At(12.066, 153, function(d,s)
        C.Action(d,s,A.Helper29,31652,{pos={x=97.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper29})
    end),
    At(13.947, 154, function(d,s)
        C.Owner(d,s,A.Helper32,nil)
    end),
    At(13.947, 155, function(d,s)
        C.Owner(d,s,A.Helper32,A.Boss)
    end),
    At(13.947, 156, function(d,s)
        C.Move(d,s,A.Helper32,{x=102.5, y=0.0, z=80.0},-5e-05)
    end),
    At(13.947, 157, function(d,s)
        C.Owner(d,s,A.Helper31,nil)
    end),
    At(13.947, 158, function(d,s)
        C.Owner(d,s,A.Helper31,A.Boss)
    end),
    At(13.947, 159, function(d,s)
        C.Move(d,s,A.Helper31,{x=120.0, y=0.0, z=102.5},-1.57087)
    end),
    At(13.947, 160, function(d,s)
        C.Owner(d,s,A.Helper30,nil)
    end),
    At(13.947, 161, function(d,s)
        C.Owner(d,s,A.Helper30,A.Boss)
    end),
    At(13.947, 162, function(d,s)
        C.Move(d,s,A.Helper30,{x=97.5, y=0.0, z=120.0},-3.14159)
    end),
    At(13.947, 163, function(d,s)
        C.Owner(d,s,A.Helper28,nil)
    end),
    At(13.947, 164, function(d,s)
        C.Owner(d,s,A.Helper28,A.Boss)
    end),
    At(13.947, 165, function(d,s)
        C.Move(d,s,A.Helper28,{x=80.0, y=0.0, z=97.5},1.57077)
    end),
    At(13.947, 166, function(d,s)
        C.Owner(d,s,A.Helper26,nil)
    end),
    At(13.947, 167, function(d,s)
        C.Owner(d,s,A.Helper26,A.Boss)
    end),
    At(13.947, 168, function(d,s)
        C.Move(d,s,A.Helper26,{x=87.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(13.947, 169, function(d,s)
        C.Owner(d,s,A.Helper21,nil)
    end),
    At(13.947, 170, function(d,s)
        C.Owner(d,s,A.Helper21,A.Boss)
    end),
    At(13.947, 171, function(d,s)
        C.Move(d,s,A.Helper21,{x=112.5, y=-0.0, z=80.0},-5e-05)
    end),
    At(13.947, 172, function(d,s)
        C.Owner(d,s,A.Helper18,A.Boss)
    end),
    At(13.947, 173, function(d,s)
        C.Move(d,s,A.Helper18,{x=80.0, y=-0.0, z=87.5},1.57077)
    end),
    At(13.947, 174, function(d,s)
        C.Owner(d,s,A.Helper17,A.Boss)
    end),
    At(13.947, 175, function(d,s)
        C.Move(d,s,A.Helper17,{x=80.0, y=-0.0, z=112.5},1.57077)
    end),
    At(14.077, 176, function(d,s)
        C.Action(d,s,A.Helper17,31652,{pos={x=80.0, y=-0.0, z=112.5}, rotation=1.57077, target=A.Helper17})
    end),
    At(14.077, 177, function(d,s)
        C.Action(d,s,A.Helper18,31652,{pos={x=80.0, y=-0.0, z=87.5}, rotation=1.57077, target=A.Helper18})
    end),
    At(14.077, 178, function(d,s)
        C.Action(d,s,A.Helper21,31652,{pos={x=112.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper21})
    end),
    At(14.077, 179, function(d,s)
        C.Action(d,s,A.Helper26,31652,{pos={x=87.5, y=-0.0, z=80.0}, rotation=-5e-05, target=A.Helper26})
    end),
    At(14.077, 180, function(d,s)
        C.Action(d,s,A.Helper28,31652,{pos={x=80.0, y=0.0, z=97.5}, rotation=1.57077, target=A.Helper28})
    end),
    At(14.077, 181, function(d,s)
        C.Action(d,s,A.Helper30,31652,{pos={x=97.5, y=0.0, z=120.0}, rotation=-3.14159, target=A.Helper30})
    end),
    At(14.077, 182, function(d,s)
        C.Action(d,s,A.Helper31,31652,{pos={x=120.0, y=0.0, z=102.5}, rotation=-1.57087, target=A.Helper31})
    end),
    At(14.077, 183, function(d,s)
        C.Action(d,s,A.Helper32,31652,{pos={x=102.5, y=0.0, z=80.0}, rotation=-5e-05, target=A.Helper32})
    end),
}
