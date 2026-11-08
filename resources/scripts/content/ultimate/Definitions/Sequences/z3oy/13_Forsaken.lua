-- 遗弃末世 [47925]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 526, function(d,s)
        C.Cast(d,s,A.Boss,47925,9.7,{spell=47925, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13622, target=A.Boss})
    end),
    At(10.008, 527, function(d,s)
        C.Action(d,s,A.Boss,47925,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.13622, target=A.Boss})
    end),
    At(10.008, 528, function(d,s)
        C.Move(d,s,A.Helper16,{x=100.0, y=-0.0, z=100.0},-5e-05)
    end),
    At(10.008, 529, function(d,s)
        C.Move(d,s,A.Helper15,{x=113.5, y=-0.0, z=113.5},-5e-05)
    end),
    At(10.008, 530, function(d,s)
        C.Move(d,s,A.Helper14,{x=93.0, y=0.0, z=106.75},-5e-05)
    end),
    At(10.076, 531, function(d,s)
        C.Cast(d,s,A.Helper14,47928,4.7,{spell=47928, omen_delay=0, cast_pos={x=92.9732, y=-0.0153, z=106.7369}, pos={x=93.0, y=0.0, z=106.75}, rotation=-5e-05, target=A.Helper14})
    end),
    At(10.076, 532, function(d,s)
        C.Cast(d,s,A.Helper16,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=100.0, y=-0.0, z=100.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(10.076, 533, function(d,s)
        C.Cast(d,s,A.Helper15,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=113.4813, y=-0.0153, z=113.4813}, pos={x=113.5, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(13.219, 535, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.83529)
    end),
    At(13.585, 536, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.87316)
    end),
    At(13.855, 537, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.01774)
    end),
    At(14.163, 538, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.04583)
    end),
    At(14.723, 539, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.1558)
    end),
    At(15.041, 540, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.20806)
    end),
    At(15.098, 541, function(d,s)
        C.Action(d,s,A.Helper14,47928,{pos={x=93.0, y=0.0, z=106.75}, rotation=-5e-05, target=A.Helper14})
    end),
    At(15.098, 542, function(d,s)
        C.Action(d,s,A.Helper16,47927,{pos={x=100.0, y=-0.0, z=100.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(15.098, 543, function(d,s)
        C.Action(d,s,A.Helper15,47927,{pos={x=113.5, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(15.098, 544, function(d,s)
        C.Action(d,s,A.Helper13,47929,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(15.311, 545, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.33892)
    end),
    At(18.197, 549, function(d,s)
        C.Action(d,s,A.Boss,47926,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.33892, target=A.Boss})
    end),
    At(18.197, 550, function(d,s)
        C.Move(d,s,A.Helper16,{x=86.5, y=-0.0, z=86.5},-5e-05)
    end),
    At(18.197, 551, function(d,s)
        C.Move(d,s,A.Helper15,{x=86.5, y=-0.0, z=113.5},-5e-05)
    end),
    At(18.197, 552, function(d,s)
        C.Move(d,s,A.Helper14,{x=93.25, y=0.0, z=93.25},-5e-05)
    end),
    At(18.262, 553, function(d,s)
        C.Cast(d,s,A.Helper14,47928,4.7,{spell=47928, omen_delay=0, cast_pos={x=93.2479, y=-0.0153, z=93.2479}, pos={x=93.25, y=0.0, z=93.25}, rotation=-5e-05, target=A.Helper14})
    end),
    At(18.262, 554, function(d,s)
        C.Cast(d,s,A.Helper16,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=86.4729, y=-0.0153, z=86.4729}, pos={x=86.5, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper16})
    end),
    At(18.262, 555, function(d,s)
        C.Cast(d,s,A.Helper15,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=86.4729, y=-0.0153, z=113.4813}, pos={x=86.5, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(21.393, 557, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.7601)
    end),
    At(21.935, 558, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.69596)
    end),
    At(22.245, 559, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.42128)
    end),
    At(23.222, 560, function(d,s)
        C.Action(d,s,A.Helper13,47929,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(23.222, 561, function(d,s)
        C.Action(d,s,A.Helper14,47928,{pos={x=93.25, y=0.0, z=93.25}, rotation=-5e-05, target=A.Helper14})
    end),
    At(23.222, 562, function(d,s)
        C.Action(d,s,A.Helper16,47927,{pos={x=86.5, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper16})
    end),
    At(23.222, 563, function(d,s)
        C.Action(d,s,A.Helper15,47927,{pos={x=86.5, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(24.758, 566, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.33557)
    end),
    At(25.95, 567, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.36424)
    end),
    At(26.29, 569, function(d,s)
        C.Action(d,s,A.Boss,47926,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=2.36424, target=A.Boss})
    end),
    At(26.29, 570, function(d,s)
        C.Move(d,s,A.Helper16,{x=113.5, y=-0.0, z=86.5},-5e-05)
    end),
    At(26.29, 571, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=-0.0, z=86.5},-5e-05)
    end),
    At(26.29, 572, function(d,s)
        C.Move(d,s,A.Helper14,{x=107.0, y=0.0, z=93.25},-5e-05)
    end),
    At(26.354, 573, function(d,s)
        C.Cast(d,s,A.Helper14,47928,4.7,{spell=47928, omen_delay=0, cast_pos={x=106.981, y=-0.0153, z=93.2479}, pos={x=107.0, y=0.0, z=93.25}, rotation=-5e-05, target=A.Helper14})
    end),
    At(26.354, 574, function(d,s)
        C.Cast(d,s,A.Helper16,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=113.4813, y=-0.0153, z=86.4729}, pos={x=113.5, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper16})
    end),
    At(26.354, 575, function(d,s)
        C.Cast(d,s,A.Helper15,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=86.4729}, pos={x=100.0, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(29.375, 577, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.33156)
    end),
    At(29.678, 578, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},1.24422)
    end),
    At(29.987, 579, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.91192)
    end),
    At(30.581, 580, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.88258)
    end),
    At(30.842, 581, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.80703)
    end),
    At(31.371, 582, function(d,s)
        C.Action(d,s,A.Helper13,47929,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(31.371, 583, function(d,s)
        C.Action(d,s,A.Helper14,47928,{pos={x=107.0, y=0.0, z=93.25}, rotation=-5e-05, target=A.Helper14})
    end),
    At(31.371, 584, function(d,s)
        C.Action(d,s,A.Helper16,47927,{pos={x=113.5, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper16})
    end),
    At(31.371, 585, function(d,s)
        C.Action(d,s,A.Helper15,47927,{pos={x=100.0, y=-0.0, z=86.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(34.402, 589, function(d,s)
        C.Action(d,s,A.Boss,47926,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=0.80703, target=A.Boss})
    end),
    At(34.402, 590, function(d,s)
        C.Move(d,s,A.Helper16,{x=113.5, y=-0.0, z=100.0},-5e-05)
    end),
    At(34.402, 591, function(d,s)
        C.Move(d,s,A.Helper15,{x=100.0, y=-0.0, z=113.5},-5e-05)
    end),
    At(34.402, 592, function(d,s)
        C.Move(d,s,A.Helper14,{x=106.75, y=0.0, z=106.75},-5e-05)
    end),
    At(34.523, 593, function(d,s)
        C.Cast(d,s,A.Helper14,47928,4.7,{spell=47928, omen_delay=0, cast_pos={x=106.7369, y=-0.0153, z=106.7369}, pos={x=106.75, y=0.0, z=106.75}, rotation=-5e-05, target=A.Helper14})
    end),
    At(34.523, 594, function(d,s)
        C.Cast(d,s,A.Helper16,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=113.4813, y=-0.0153, z=99.9924}, pos={x=113.5, y=-0.0, z=100.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(34.523, 595, function(d,s)
        C.Cast(d,s,A.Helper15,47927,4.7,{spell=47927, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=113.4813}, pos={x=100.0, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(37.576, 597, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.54011)
    end),
    At(38.11, 598, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.77846)
    end),
    At(38.501, 599, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.96513)
    end),
    At(38.99, 600, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.99217)
    end),
    At(39.488, 601, function(d,s)
        C.Action(d,s,A.Helper13,47929,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12443})
    end),
    At(39.488, 602, function(d,s)
        C.Action(d,s,A.Helper14,47928,{pos={x=106.75, y=0.0, z=106.75}, rotation=-5e-05, target=A.Helper14})
    end),
    At(39.488, 603, function(d,s)
        C.Action(d,s,A.Helper16,47927,{pos={x=113.5, y=-0.0, z=100.0}, rotation=-5e-05, target=A.Helper16})
    end),
    At(39.488, 604, function(d,s)
        C.Action(d,s,A.Helper15,47927,{pos={x=100.0, y=-0.0, z=113.5}, rotation=-5e-05, target=A.Helper15})
    end),
    At(40.866, 607, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.18765)
    end),
    At(41.144, 608, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.39427)
    end),
    At(41.704, 609, function(d,s)
        C.Move(d,s,A.Boss,{x=98.8022, y=0.0153, z=100.0534},-1.50261)
    end),
    At(41.974, 610, function(d,s)
        C.Move(d,s,A.Boss,{x=97.4899, y=0.0153, z=100.1144},-1.5259)
    end),
    At(42.295, 611, function(d,s)
        C.Move(d,s,A.Boss,{x=95.7809, y=0.0458, z=100.206},-1.51804)
    end),
    At(43.492, 612, function(d,s)
        C.Move(d,s,A.Boss,{x=95.7809, y=0.0458, z=100.206},-1.4352)
    end),
    At(43.802, 613, function(d,s)
        C.Move(d,s,A.Boss,{x=95.7809, y=0.0458, z=100.206},-1.21565)
    end),
}
