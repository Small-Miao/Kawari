-- 星灵之剑 [40234]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/n4gw.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 482, function(d,s)
        C.Cast(d,s,A.Boss,40234,2.2,{spell=40234, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(0.0, 483, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.0, 484, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.8397)
    end),
    At(0.0, 485, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.0, 486, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.69397)
    end),
    At(0.081, 487, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.081, 488, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.69397)
    end),
    At(0.156, 489, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.156, 490, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.69397)
    end),
    At(0.156, 491, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.156, 492, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.69397)
    end),
    At(0.194, 493, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.194, 494, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.275, 495, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.275, 496, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.336, 497, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.336, 498, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.336, 499, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.336, 500, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.396, 501, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.396, 502, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.396, 503, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.396, 504, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.482, 505, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},1.21747)
    end),
    At(0.482, 506, function(d,s)
        C.Move(d,s,A.Helper13,{x=100.0, y=0.0, z=100.0},0.85526)
    end),
    At(0.482, 507, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},1.58803)
    end),
    At(0.482, 508, function(d,s)
        C.Move(d,s,A.Helper14,{x=100.0, y=0.0, z=100.0},2.42339)
    end),
    At(0.557, 509, function(d,s)
        C.Action(d,s,A.Helper13,40119,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.85526, target=A.Helper13})
    end),
    At(0.557, 510, function(d,s)
        C.Action(d,s,A.Helper14,40120,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.42339, target=A.Helper14})
    end),
    At(2.504, 511, function(d,s)
        C.Action(d,s,A.Boss,40234,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.53664, target=A.Boss})
    end),
    At(2.504, 512, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(2.504, 513, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(2.504, 514, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.36261)
    end),
    At(2.504, 515, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(2.504, 516, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(2.504, 517, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.544, 518, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.544, 519, function(d,s)
        C.Cast(d,s,A.Helper11,40317,0.2,{spell=40317, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=0.81441, target=A.Helper11})
    end),
    At(2.544, 520, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.544, 521, function(d,s)
        C.Cast(d,s,A.Helper12,40318,0.2,{spell=40318, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=0.0, z=100.0}, rotation=2.38015, target=A.Helper12})
    end),
    At(2.591, 522, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.591, 523, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.628, 524, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.628, 525, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.67, 526, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.67, 527, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.75, 528, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.75, 529, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.804, 530, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.804, 531, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.804, 532, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.804, 533, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.878, 534, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.878, 535, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.968, 536, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.968, 537, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(2.968, 538, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(2.968, 539, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.03, 540, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.03, 541, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.03, 542, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.03, 543, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.03, 544, function(d,s)
        C.Action(d,s,A.Helper11,40317,{pos={x=100.0, y=0.0, z=100.0}, rotation=0.81441, target=A.Helper11})
    end),
    At(3.03, 545, function(d,s)
        C.Action(d,s,A.Helper12,40318,{pos={x=100.0, y=0.0, z=100.0}, rotation=2.38015, target=A.Helper12})
    end),
    At(3.073, 546, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.073, 547, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.141, 548, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.141, 549, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.208, 550, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.208, 551, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.208, 552, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.208, 553, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.288, 554, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81441)
    end),
    At(3.288, 555, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.346, 556, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.346, 557, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.346, 558, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.346, 559, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.419, 560, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.419, 561, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.462, 562, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.462, 563, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.501, 564, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.501, 565, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.38015)
    end),
    At(3.521, 566, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.521, 567, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.567, 568, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.567, 569, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.621, 570, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},0.81681)
    end),
    At(3.621, 571, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.665, 572, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.665, 573, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.707, 574, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.707, 575, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.75, 576, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.75, 577, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.836, 578, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.836, 579, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.836, 580, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.836, 581, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.37689)
    end),
    At(3.883, 582, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.883, 583, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(3.922, 584, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.922, 585, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(3.959, 586, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.09974)
    end),
    At(3.959, 587, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.021, 588, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.021, 589, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.058, 590, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.058, 591, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.108, 592, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.108, 593, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.151, 594, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.151, 595, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.192, 596, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.192, 597, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},2.193)
    end),
    At(4.234, 598, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.41335)
    end),
    At(4.234, 599, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.272, 600, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.4306)
    end),
    At(4.272, 601, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.31, 602, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.31, 603, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.371, 604, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.371, 605, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.427, 606, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.427, 607, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.487, 608, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.487, 609, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.506, 610, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.506, 611, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.96626)
    end),
    At(4.547, 612, function(d,s)
        C.Move(d,s,A.Helper11,{x=100.0, y=0.0, z=100.0},1.63338)
    end),
    At(4.547, 613, function(d,s)
        C.Move(d,s,A.Helper12,{x=100.0, y=0.0, z=100.0},1.77873)
    end),
}
