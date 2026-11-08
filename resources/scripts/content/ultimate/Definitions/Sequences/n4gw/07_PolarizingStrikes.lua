-- 星灵之剑 [40316]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 378, function(d,s)
        C.Cast(d,s,A.Boss,40316,6.2,{spell=40316, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(6.528, 379, function(d,s)
        C.Action(d,s,A.Boss,40316,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(6.528, 380, function(d,s)
        C.Owner(d,s,A.Helper14,nil)
    end),
    At(6.528, 381, function(d,s)
        C.Owner(d,s,A.Helper14,A.Boss)
    end),
    At(6.528, 382, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.528, 383, function(d,s)
        C.Owner(d,s,A.Helper13,nil)
    end),
    At(6.528, 384, function(d,s)
        C.Owner(d,s,A.Helper13,A.Boss)
    end),
    At(6.528, 385, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.601, 386, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.601, 387, function(d,s)
        C.Cast(d,s,A.Helper13,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.85526, target=A.Helper13})
    end),
    At(6.601, 388, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.601, 389, function(d,s)
        C.Cast(d,s,A.Helper14,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=2.42339, target=A.Helper14})
    end),
    At(6.667, 390, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.667, 391, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.667, 392, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.667, 393, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.74, 394, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.74, 395, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.782, 396, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.782, 397, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.854, 398, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.854, 399, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.854, 400, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.854, 401, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.93, 402, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.93, 403, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.93, 404, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.93, 405, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(6.964, 406, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(6.964, 407, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.022, 408, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.022, 409, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.096, 410, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.096, 411, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.096, 412, function(d,s)
        C.Action(d,s,A.Helper13,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.85526, target=A.Helper13})
    end),
    At(7.096, 413, function(d,s)
        C.Action(d,s,A.Helper14,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.42339, target=A.Helper14})
    end),
    At(7.161, 414, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.161, 415, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.161, 416, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.161, 417, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.229, 418, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.229, 419, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.284, 420, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.284, 421, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.303, 422, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.303, 423, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.323, 424, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.323, 425, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.402, 426, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.402, 427, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.478, 428, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.478, 429, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.478, 430, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.478, 431, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.545, 432, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(7.545, 433, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.583, 434, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85554)
    end),
    At(7.583, 435, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.607, 436, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85554)
    end),
    At(7.607, 437, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(7.646, 438, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85554)
    end),
    At(7.646, 439, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.709, 440, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85554)
    end),
    At(7.709, 441, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.735, 442, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85554)
    end),
    At(7.735, 443, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.779, 444, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.8565)
    end),
    At(7.779, 445, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.8, 446, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.96446)
    end),
    At(7.8, 447, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.858, 448, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(7.858, 449, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.901, 450, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(7.901, 451, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.944, 452, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(7.944, 453, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42291)
    end),
    At(7.985, 454, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(7.985, 455, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.042, 456, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(8.042, 457, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.091, 458, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(8.091, 459, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.112, 460, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(8.112, 461, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.157, 462, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.0146)
    end),
    At(8.157, 463, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.203, 464, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.2121)
    end),
    At(8.203, 465, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.284, 466, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.2121)
    end),
    At(8.284, 467, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.324, 468, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.324, 469, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.22474)
    end),
    At(8.372, 470, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.372, 471, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.9468)
    end),
    At(8.391, 472, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.391, 473, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.9468)
    end),
    At(8.437, 474, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.437, 475, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.9468)
    end),
    At(8.479, 476, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.479, 477, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.8397)
    end),
    At(8.6, 478, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.6, 479, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.8397)
    end),
    At(8.6, 480, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(8.6, 481, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.8397)
    end),
}
