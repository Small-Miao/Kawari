-- 未来确定β [19220]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 490, function(d,s)
        C.Cast(d,s,A.Boss,19220,34.7,{spell=19220, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(1.167, 491, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=93.1563, y=-0.0153, z=103.5935},1.39724)
    end),
    At(1.167, 492, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=100.6332, y=-0.0153, z=109.3004},2.57152)
    end),
    At(1.167, 493, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=94.6212, y=-0.0153, z=109.0562},-3.03862)
    end),
    At(1.167, 494, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=101.0605, y=-0.0153, z=106.3401},1.54527)
    end),
    At(1.167, 495, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=99.5041, y=-0.0153, z=110.5516},-2.56941)
    end),
    At(1.167, 496, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=108.2322, y=-0.0153, z=93.9803},-0.33993)
    end),
    At(1.167, 497, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=100.145, y=-0.0153, z=104.2039},-2.35225)
    end),
    At(1.167, 498, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=99.9619, y=-0.0153, z=90.3182},0.41816)
    end),
    At(1.553, 499, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=94.2245, y=0.0153, z=105.1194},0.61509)
    end),
    At(1.553, 500, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=102.3423, y=-0.0153, z=108.5374},1.98179)
    end),
    At(1.553, 501, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=93.0037, y=0.0153, z=108.1102},-2.1047)
    end),
    At(1.553, 502, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=102.8611, y=-0.0153, z=106.8284},1.30271)
    end),
    At(1.553, 503, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=97.734, y=-0.0153, z=109.9718},-1.88467)
    end),
    At(1.553, 504, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=107.6524, y=-0.0153, z=95.7504},-0.32257)
    end),
    At(1.553, 505, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=98.497, y=-0.0153, z=105.0278},-1.1145)
    end),
    At(1.553, 506, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=100.7248, y=-0.0153, z=91.9966},0.41816)
    end),
    At(1.8, 507, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=94.6517, y=0.0153, z=105.7298},1.17644)
    end),
    At(1.8, 508, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.0513, y=0.0153, z=107.805},1.98179)
    end),
    At(1.8, 509, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7291, y=0.0153, z=107.9271},-3.0346)
    end),
    At(1.8, 510, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=104.6616, y=0.0153, z=107.3167},1.30271)
    end),
    At(1.8, 511, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=95.964, y=-0.0153, z=109.3919},-1.88467)
    end),
    At(1.8, 512, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=107.0726, y=-0.0153, z=97.5509},-0.32257)
    end),
    At(1.8, 513, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=96.788, y=0.0153, z=105.8518},-1.1145)
    end),
    At(1.8, 514, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=101.4878, y=-0.0153, z=93.7057},0.41816)
    end),
    At(2.118, 515, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=94.6517, y=0.0153, z=105.7298},2.39338)
    end),
    At(2.118, 516, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=105.7603, y=0.0153, z=107.042},1.98179)
    end),
    At(2.118, 517, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7291, y=0.0153, z=107.9271},2.40134)
    end),
    At(2.118, 518, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=106.4622, y=0.0153, z=107.8355},1.30271)
    end),
    At(2.118, 519, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=94.1939, y=0.0153, z=108.8121},-1.88467)
    end),
    At(2.118, 520, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=106.4622, y=0.0153, z=99.321},-0.32257)
    end),
    At(2.118, 521, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=95.14, y=0.0153, z=106.6758},-1.1145)
    end),
    At(2.118, 522, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=102.2202, y=-0.0153, z=95.4147},0.41816)
    end),
    At(2.411, 523, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=107.4693, y=0.0153, z=106.3096},1.98179)
    end),
    At(2.411, 524, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=106.8589, y=0.0153, z=107.9271},2.04833)
    end),
    At(2.411, 525, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=92.3934, y=0.0153, z=108.2322},-1.88467)
    end),
    At(2.411, 526, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=105.8824, y=0.0153, z=101.091},-0.32257)
    end),
    At(2.411, 527, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=93.4615, y=0.0153, z=107.4998},-1.1145)
    end),
    At(2.411, 528, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=102.9831, y=0.0153, z=97.1237},0.41816)
    end),
    At(2.766, 529, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=108.8121, y=0.0153, z=105.7298},2.17028)
    end),
    At(2.766, 530, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=106.8589, y=0.0153, z=107.9271},-2.92376)
    end),
    At(2.766, 531, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=90.6233, y=0.0153, z=107.6524},-1.88467)
    end),
    At(2.766, 532, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=105.272, y=0.0153, z=102.8611},-0.32257)
    end),
    At(2.766, 533, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=93.4615, y=0.0153, z=107.4998},-2.23711)
    end),
    At(2.766, 534, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=103.7461, y=0.0153, z=98.8632},0.41816)
    end),
    At(3.066, 535, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=108.8121, y=0.0153, z=105.7298},-2.80603)
    end),
    At(3.066, 536, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=106.8589, y=0.0153, z=107.9271},-2.4279)
    end),
    At(3.066, 537, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=89.6468, y=0.0153, z=107.3167},-2.25753)
    end),
    At(3.066, 538, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=104.6921, y=0.0153, z=104.6311},-0.32257)
    end),
    At(3.066, 539, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=93.4615, y=0.0153, z=107.4998},2.7392)
    end),
    At(3.066, 540, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=104.509, y=0.0153, z=100.5722},0.41816)
    end),
    At(3.367, 541, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=108.8121, y=0.0153, z=105.7298},-2.14813)
    end),
    At(3.367, 542, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=89.6468, y=0.0153, z=107.3167},2.723)
    end),
    At(3.367, 543, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=104.0818, y=0.0153, z=106.4012},-0.32257)
    end),
    At(3.367, 544, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=93.4615, y=0.0153, z=107.4998},2.42684)
    end),
    At(3.386, 545, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=105.272, y=0.0153, z=102.2812},0.41816)
    end),
    At(3.649, 546, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=89.6468, y=0.0153, z=107.3167},2.18773)
    end),
    At(3.649, 547, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=103.7766, y=0.0153, z=107.3472},-0.69543)
    end),
    At(3.649, 548, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=106.0349, y=0.0153, z=103.9902},0.41816)
    end),
    At(3.984, 549, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=103.7766, y=0.0153, z=107.3472},-1.99809)
    end),
    At(3.984, 550, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=106.7979, y=0.0153, z=105.6992},0.41816)
    end),
    At(4.3, 551, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=103.7766, y=0.0153, z=107.3472},-2.66576)
    end),
    At(4.3, 552, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=107.5608, y=0.0153, z=107.4083},0.41816)
    end),
    At(4.617, 553, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=107.5914, y=0.0153, z=107.4998},-0.51595)
    end),
    At(4.934, 554, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=107.5914, y=0.0153, z=107.4998},-1.81871)
    end),
    At(5.1, 555, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=94.8653, y=0.0153, z=105.8824},2.20901)
    end),
    At(5.1, 556, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7291, y=0.0153, z=107.6829},2.58561)
    end),
    At(5.1, 557, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=89.8604, y=0.0153, z=107.1946},2.08898)
    end),
    At(5.137, 558, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=106.3401, y=0.0153, z=107.8965},-2.05513)
    end),
    At(5.229, 559, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=107.9576, y=0.0153, z=106.3706},-1.40251)
    end),
    At(5.229, 560, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=92.3934, y=0.0153, z=107.4693},-3.11072)
    end),
    At(5.229, 561, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=106.7063, y=0.0153, z=108.1102},-1.45007)
    end),
    At(5.266, 562, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=102.8611, y=0.0153, z=108.3238},-1.73577)
    end),
    At(5.422, 563, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=96.3302, y=0.0153, z=107.0726},0.90214)
    end),
    At(5.422, 564, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7596, y=0.0153, z=105.7908},3.12894)
    end),
    At(5.422, 565, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=91.4778, y=0.0153, z=106.2791},2.08898)
    end),
    At(5.452, 566, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=104.4785, y=0.0153, z=107.7745},-1.63357)
    end),
    At(5.532, 567, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=107.042, y=0.0153, z=107.042},-1.29571)
    end),
    At(5.532, 568, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=90.5013, y=0.0153, z=107.4388},-1.79963)
    end),
    At(5.532, 569, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=105.1499, y=0.0153, z=109.1478},-0.97778)
    end),
    At(5.6, 570, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=101.6098, y=0.0153, z=109.6971},-0.74711)
    end),
    At(5.716, 571, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=97.7951, y=0.0153, z=108.2322},0.89629)
    end),
    At(5.716, 572, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7901, y=0.0153, z=103.9292},3.12894)
    end),
    At(5.716, 573, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=93.1258, y=0.0153, z=105.333},2.08898)
    end),
    At(5.766, 574, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=102.5864, y=0.0153, z=107.6524},-1.63357)
    end),
    At(5.85, 575, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=107.042, y=0.0153, z=107.042},-2.35628)
    end),
    At(5.85, 576, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=88.6397, y=0.0153, z=107.4083},-1.5933)
    end),
    At(5.85, 577, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=103.5935, y=0.0153, z=110.1854},-0.97778)
    end),
    At(5.899, 578, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=100.3281, y=0.0153, z=111.0704},-0.74711)
    end),
    At(6.016, 579, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=99.2599, y=0.0153, z=109.3919},0.89629)
    end),
    At(6.016, 580, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.7901, y=0.0153, z=102.0371},3.12894)
    end),
    At(6.016, 581, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=94.7433, y=0.0153, z=104.4175},2.08898)
    end),
    At(6.066, 582, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=100.7248, y=0.0153, z=107.5608},-1.63357)
    end),
    At(6.15, 583, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=86.7781, y=0.0153, z=107.3472},-1.5933)
    end),
    At(6.15, 584, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=102.0371, y=0.0153, z=111.2535},-0.97778)
    end),
    At(6.216, 585, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=99.0463, y=0.0153, z=112.4437},-0.74711)
    end),
    At(6.339, 586, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=99.9924, y=0.0153, z=109.9718},1.26493)
    end),
    At(6.339, 587, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.8206, y=0.0153, z=100.1755},3.12894)
    end),
    At(6.339, 588, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=96.3912, y=0.0153, z=103.4714},2.08898)
    end),
    At(6.383, 589, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=98.8632, y=0.0153, z=107.4388},-1.63357)
    end),
    At(6.469, 590, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=84.8859, y=0.0153, z=107.3167},-1.5933)
    end),
    At(6.469, 591, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=100.4807, y=0.0153, z=112.2911},-0.97778)
    end),
    At(6.516, 592, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=97.7646, y=0.0153, z=113.8476},-0.74711)
    end),
    At(6.666, 593, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=99.9924, y=0.0153, z=109.9718},2.58015)
    end),
    At(6.666, 594, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.8511, y=0.0153, z=98.2834},3.12894)
    end),
    At(6.666, 595, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=98.0087, y=0.0153, z=102.5559},2.08898)
    end),
    At(6.682, 596, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=96.9711, y=0.0153, z=107.3167},-1.63357)
    end),
    At(6.782, 597, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=83.0243, y=0.0153, z=107.2557},-1.5933)
    end),
    At(6.782, 598, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=98.9548, y=0.0153, z=113.3288},-0.97778)
    end),
    At(6.849, 599, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=96.5133, y=0.0153, z=115.2209},-0.74711)
    end),
    At(6.967, 600, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=99.9924, y=0.0153, z=109.9718},3.14159)
    end),
    At(6.967, 601, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.8817, y=0.0153, z=96.4218},3.12894)
    end),
    At(6.967, 602, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=99.6262, y=0.0153, z=101.6098},2.08898)
    end),
    At(7.0, 603, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=95.1095, y=0.0153, z=107.1946},-1.63357)
    end),
    At(7.116, 604, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=82.4445, y=0.0153, z=107.2557},-2.34314)
    end),
    At(7.116, 605, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=97.3983, y=0.0153, z=114.3969},-0.97778)
    end),
    At(7.203, 606, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=95.3536, y=0.0153, z=116.4416},-0.74711)
    end),
    At(7.299, 607, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.8817, y=0.0153, z=94.5296},3.12894)
    end),
    At(7.299, 608, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=101.2741, y=0.0153, z=100.6943},2.08898)
    end),
    At(7.333, 609, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.2479, y=0.0153, z=107.0726},-1.63357)
    end),
    At(7.417, 610, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=82.4445, y=0.0153, z=107.2557},2.63317)
    end),
    At(7.417, 611, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=95.8419, y=0.0153, z=115.4345},-0.97778)
    end),
    At(7.449, 612, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=95.3536, y=0.0153, z=116.4416},-2.0582)
    end),
    At(7.583, 613, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.9122, y=0.0153, z=92.9122},3.12894)
    end),
    At(7.583, 614, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=102.8916, y=0.0153, z=99.7787},2.08898)
    end),
    At(7.633, 615, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9122, y=0.0153, z=107.042},-2.56768)
    end),
    At(7.749, 616, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=82.4445, y=0.0153, z=107.2557},1.96348)
    end),
    At(7.749, 617, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=94.2855, y=0.0153, z=116.4721},-0.97778)
    end),
    At(7.782, 618, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=95.3536, y=0.0153, z=116.4416},2.91811)
    end),
    At(7.932, 619, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.9122, y=0.0153, z=92.9122},1.81784)
    end),
    At(7.932, 620, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=104.5396, y=0.0153, z=98.8327},2.08898)
    end),
    At(7.95, 621, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9122, y=0.0153, z=107.042},2.40441)
    end),
    At(8.033, 622, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=92.7291, y=0.0153, z=117.5402},-0.97778)
    end),
    At(8.101, 623, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=95.3536, y=0.0153, z=116.4416},2.8671)
    end),
    At(8.212, 624, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.9122, y=0.0153, z=92.9122},0.78536)
    end),
    At(8.212, 625, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=106.157, y=0.0153, z=97.9171},2.08898)
    end),
    At(8.254, 626, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9122, y=0.0153, z=107.042},2.35618)
    end),
    At(8.365, 627, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=92.7291, y=0.0153, z=117.5402},-2.09569)
    end),
    At(8.534, 628, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=107.7745, y=0.0153, z=96.9711},2.08898)
    end),
    At(8.682, 629, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=92.7291, y=0.0153, z=117.5402},2.88474)
    end),
    At(8.833, 630, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=109.2088, y=0.0153, z=96.1471},2.08898)
    end),
    At(8.983, 631, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=92.7291, y=0.0153, z=117.5402},2.74889)
    end),
    At(9.133, 632, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=109.2088, y=0.0153, z=96.1471},-2.88733)
    end),
    At(9.466, 633, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=109.2088, y=0.0153, z=96.1471},-1.57624)
    end),
    At(9.767, 634, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=109.2088, y=0.0153, z=96.1471},-1.17816)
    end),
    At(10.049, 635, function(d,s)
        C.Status(d,s,A.FateProjection16,{{id=2195, param=133, duration=40}})
    end),
    At(10.049, 636, function(d,s)
        C.Status(d,s,A.FateProjection16,{{id=2195, param=133, duration=4.0}})
    end),
    At(10.049, 637, function(d,s)
        C.Status(d,s,A.FateProjection15,{{id=2195, param=132, duration=40}})
    end),
    At(10.049, 638, function(d,s)
        C.Status(d,s,A.FateProjection15,{{id=2195, param=132, duration=4.0}})
    end),
    At(10.049, 639, function(d,s)
        C.Status(d,s,A.FateProjection14,{{id=2195, param=133, duration=40}})
    end),
    At(10.049, 640, function(d,s)
        C.Status(d,s,A.FateProjection14,{{id=2195, param=133, duration=4.0}})
    end),
    At(10.049, 641, function(d,s)
        C.Status(d,s,A.FateProjection13,{{id=2195, param=132, duration=40}})
    end),
    At(10.049, 642, function(d,s)
        C.Status(d,s,A.FateProjection13,{{id=2195, param=132, duration=4.0}})
    end),
    At(10.049, 643, function(d,s)
        C.Status(d,s,A.FateProjection12,{{id=2195, param=133, duration=40}})
    end),
    At(10.049, 644, function(d,s)
        C.Status(d,s,A.FateProjection12,{{id=2195, param=133, duration=4.0}})
    end),
    At(10.049, 645, function(d,s)
        C.Status(d,s,A.FateProjection11,{{id=2195, param=132, duration=40}})
    end),
    At(10.049, 646, function(d,s)
        C.Status(d,s,A.FateProjection11,{{id=2195, param=132, duration=4.0}})
    end),
    At(10.049, 647, function(d,s)
        C.Status(d,s,A.FateProjection10,{{id=2195, param=133, duration=40}})
    end),
    At(10.049, 648, function(d,s)
        C.Status(d,s,A.FateProjection10,{{id=2195, param=133, duration=4.0}})
    end),
    At(10.049, 649, function(d,s)
        C.Status(d,s,A.FateProjection09,{{id=2195, param=132, duration=40}})
    end),
    At(10.049, 650, function(d,s)
        C.Status(d,s,A.FateProjection09,{{id=2195, param=132, duration=4.0}})
    end),
    At(10.049, 651, function(d,s)
        C.Tether(d,s,A.FateProjection12,A.FateProjection11,28,0)
    end),
    At(10.049, 652, function(d,s)
        C.Tether(d,s,A.FateProjection10,A.FateProjection09,29,0)
    end),
    At(10.133, 653, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9122, y=0.0153, z=106.7979},2.54467)
    end),
    At(10.175, 654, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=99.443, y=0.0153, z=109.9107},-2.76883)
    end),
    At(10.175, 655, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=106.92, y=0.0153, z=106.5232},-2.72904)
    end),
    At(10.175, 656, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=95.8419, y=0.0153, z=116.2585},2.49424)
    end),
    At(10.333, 657, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=92.1187, y=0.0153, z=93.9803},-0.14875)
    end),
    At(10.333, 658, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=107.9881, y=0.0153, z=96.6659},-1.17864)
    end),
    At(10.449, 659, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9427, y=0.0153, z=104.9058},3.12453)
    end),
    At(10.499, 660, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=97.612, y=0.0153, z=109.6056},-1.72504)
    end),
    At(10.499, 661, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=106.4927, y=0.0153, z=104.7227},-2.90133)
    end),
    At(10.499, 662, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=97.5814, y=0.0153, z=115.5261},1.96367)
    end),
    At(10.633, 663, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=91.0201, y=0.0153, z=95.5062},-0.63119)
    end),
    At(10.633, 664, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=106.2486, y=0.0153, z=97.3983},-1.17864)
    end),
    At(10.749, 665, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=92.9732, y=0.0153, z=103.0442},3.12453)
    end),
    At(10.799, 666, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=95.7504, y=0.0153, z=109.3309},-1.72504)
    end),
    At(10.799, 667, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=106.0349, y=0.0153, z=102.8916},-2.90133)
    end),
    At(10.799, 668, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=99.2905, y=0.0153, z=114.8241},1.96367)
    end),
    At(10.983, 669, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=89.9214, y=0.0153, z=97.0016},-0.63119)
    end),
    At(10.983, 670, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=104.5396, y=0.0153, z=98.1003},-1.17864)
    end),
    At(11.066, 671, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.0037, y=0.0153, z=101.1826},3.12453)
    end),
    At(11.116, 672, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=93.9193, y=0.0153, z=109.0562},-1.72504)
    end),
    At(11.116, 673, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=105.6077, y=0.0153, z=101.091},-2.90133)
    end),
    At(11.116, 674, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=101.03, y=0.0153, z=114.0917},1.96367)
    end),
    At(11.269, 675, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=88.8228, y=0.0153, z=98.5275},-0.63119)
    end),
    At(11.269, 676, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=102.8, y=0.0153, z=98.8022},-1.17864)
    end),
    At(11.383, 677, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.0343, y=0.0153, z=99.321},3.12453)
    end),
    At(11.417, 678, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=92.0577, y=0.0153, z=108.751},-1.72504)
    end),
    At(11.417, 679, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=105.1499, y=0.0153, z=99.2905},-2.90133)
    end),
    At(11.417, 680, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=102.739, y=0.0153, z=113.3898},1.96367)
    end),
    At(11.566, 681, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=87.7241, y=0.0153, z=100.0229},-0.63119)
    end),
    At(11.566, 682, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=101.091, y=0.0153, z=99.5346},-1.17864)
    end),
    At(11.699, 683, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.0648, y=0.0153, z=97.4594},3.12453)
    end),
    At(11.733, 684, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=90.2266, y=0.0153, z=108.4764},-1.72504)
    end),
    At(11.733, 685, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.6921, y=0.0153, z=97.4594},-2.90133)
    end),
    At(11.733, 686, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=104.4785, y=0.0153, z=112.6574},1.96367)
    end),
    At(11.882, 687, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=86.6255, y=0.0153, z=101.5488},-0.63119)
    end),
    At(11.882, 688, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=99.3515, y=0.0153, z=100.2365},-1.17864)
    end),
    At(11.999, 689, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.0953, y=0.0153, z=95.5673},3.12453)
    end),
    At(12.033, 690, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=88.365, y=0.0153, z=108.1712},-1.72504)
    end),
    At(12.033, 691, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.2649, y=0.0153, z=95.6283},-2.90133)
    end),
    At(12.033, 692, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=106.2181, y=0.0153, z=111.9554},1.96367)
    end),
    At(12.187, 693, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=85.4963, y=0.0153, z=103.0442},-0.63119)
    end),
    At(12.187, 694, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=97.612, y=0.0153, z=100.9689},-1.17864)
    end),
    At(12.283, 695, function(d,s)
        C.Action(d,s,A.Helper12,18588,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931, target=A.FateProjection10})
    end),
    At(12.317, 696, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.1563, y=0.0153, z=93.7057},3.12453)
    end),
    At(12.365, 697, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=86.5339, y=0.0153, z=107.8965},-1.72504)
    end),
    At(12.365, 698, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.1428, y=0.0153, z=95.14},-2.15571)
    end),
    At(12.365, 699, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=107.9271, y=0.0153, z=111.223},1.96367)
    end),
    At(12.483, 700, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=84.3977, y=0.0153, z=104.5396},-0.63119)
    end),
    At(12.483, 701, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=95.903, y=0.0153, z=101.6709},-1.17864)
    end),
    At(12.633, 702, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.1868, y=0.0153, z=91.8441},3.12453)
    end),
    At(12.666, 703, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=84.6723, y=0.0153, z=107.5914},-1.72504)
    end),
    At(12.666, 704, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.1428, y=0.0153, z=95.14},-0.84883)
    end),
    At(12.666, 705, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=109.6666, y=0.0153, z=110.5211},1.96367)
    end),
    At(12.816, 706, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=83.299, y=0.0153, z=106.0655},-0.63119)
    end),
    At(12.816, 707, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=94.1634, y=0.0153, z=102.3728},-1.17864)
    end),
    At(12.95, 708, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.2174, y=0.0153, z=89.9519},3.12453)
    end),
    At(12.97, 709, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=82.8412, y=0.0153, z=107.3167},-1.72504)
    end),
    At(12.97, 710, function(d,s)
        C.Move(d,s,A.FateProjection10,{x=104.1428, y=0.0153, z=95.14},-0.70933)
    end),
    At(12.97, 711, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=111.3756, y=0.0153, z=109.8192},1.96367)
    end),
    At(13.116, 712, function(d,s)
        C.Action(d,s,A.Helper11,18588,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.FateProjection12})
    end),
    At(13.116, 713, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=82.4445, y=0.0153, z=107.2557},-0.63119)
    end),
    At(13.116, 714, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=92.4544, y=0.0153, z=103.1052},-1.17864)
    end),
    At(13.205, 715, function(d,s)
        C.Action(d,s,A.Helper09,18587,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729, target=A.FateProjection11})
    end),
    At(13.205, 716, function(d,s)
        C.Action(d,s,A.Helper10,18587,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05, target=A.FateProjection09})
    end),
    At(13.267, 717, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.2174, y=0.0153, z=89.6162},2.19876)
    end),
    At(13.309, 718, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=82.4445, y=0.0153, z=107.2557},-2.46644)
    end),
    At(13.309, 719, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=113.1151, y=0.0153, z=109.0867},1.96367)
    end),
    At(13.434, 720, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=82.4445, y=0.0153, z=107.2557},0.67156)
    end),
    At(13.434, 721, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=90.7149, y=0.0153, z=103.8071},-1.17864)
    end),
    At(13.565, 722, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.2174, y=0.0153, z=89.6162},0.88344)
    end),
    At(13.616, 723, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=82.4445, y=0.0153, z=107.2557},2.50565)
    end),
    At(13.616, 724, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=114.8547, y=0.0153, z=108.3848},1.96367)
    end),
    At(13.749, 725, function(d,s)
        C.Move(d,s,A.FateProjection11,{x=82.4445, y=0.0153, z=107.2557},1.96348)
    end),
    At(13.749, 726, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=88.9754, y=0.0153, z=104.5396},-1.17864)
    end),
    At(13.883, 727, function(d,s)
        C.Move(d,s,A.FateProjection12,{x=93.2174, y=0.0153, z=89.6162},0.57818)
    end),
    At(13.915, 728, function(d,s)
        C.Move(d,s,A.FateProjection09,{x=82.4445, y=0.0153, z=107.2557},1.96348)
    end),
    At(13.915, 729, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=116.5942, y=0.0153, z=107.6524},1.96367)
    end),
    At(14.049, 730, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=87.2663, y=0.0153, z=105.2415},-1.17864)
    end),
    At(14.235, 731, function(d,s)
        C.Action(d,s,A.Helper12,18598,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931, target=A.FateProjection13})
    end),
    At(14.235, 732, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=117.5402, y=0.0153, z=107.2557},2.33643)
    end),
    At(14.357, 733, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=87.0222, y=0.0153, z=105.333},-0.24453)
    end),
    At(14.533, 734, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=117.5402, y=0.0153, z=107.2557},-2.644)
    end),
    At(14.666, 735, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=87.0222, y=0.0153, z=105.333},1.054)
    end),
    At(14.866, 736, function(d,s)
        C.Move(d,s,A.FateProjection14,{x=117.5402, y=0.0153, z=107.2557},-1.96357)
    end),
    At(14.984, 737, function(d,s)
        C.Move(d,s,A.FateProjection13,{x=87.0222, y=0.0153, z=105.333},1.80375)
    end),
    At(15.152, 738, function(d,s)
        C.Action(d,s,A.PerfectAlexander03,18589,{pos={x=78.2888, y=0.0, z=91.0069}, rotation=1.17807, dest={x=117.5402, y=0.0153, z=107.2557}})
    end),
    At(15.152, 739, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18589,{pos={x=108.9931, y=0.0, z=78.2888}, rotation=-0.39275, dest={x=92.7291, y=0.0153, z=117.5402}})
    end),
    At(15.152, 740, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18589,{pos={x=121.7112, y=0.0, z=91.0069}, rotation=-1.17816, dest={x=82.4445, y=0.0153, z=107.2557}})
    end),
    At(16.101, 741, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=117.5402, y=0.0153, z=107.2557},1.17807)
    end),
    At(16.101, 742, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=92.7291, y=0.0153, z=117.5402},-0.39275)
    end),
    At(16.101, 743, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=82.4445, y=0.0153, z=107.2557},-1.17816)
    end),
    At(20.683, 744, function(d,s)
        C.Action(d,s,A.PerfectAlexander02,18592,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander02})
    end),
    At(22.206, 745, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=92.8206, y=0.0153, z=117.2961},2.74889)
    end),
    At(22.283, 746, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=83.1769, y=0.0153, z=106.9505},1.96348)
    end),
    At(22.506, 747, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=93.5225, y=0.0153, z=115.5566},2.74889)
    end),
    At(22.593, 748, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=84.9165, y=0.0153, z=106.2181},1.96348)
    end),
    At(22.768, 749, function(d,s)
        C.Action(d,s,A.Helper11,18594,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.FateProjection16})
    end),
    At(22.768, 750, function(d,s)
        C.Action(d,s,A.Helper12,18594,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931, target=A.FateProjection15})
    end),
    At(22.833, 751, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=94.255, y=0.0153, z=113.817},2.74889)
    end),
    At(22.833, 752, function(d,s)
        C.Despawn(d,s,A.FateProjection10)
    end),
    At(22.934, 753, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=86.6255, y=0.0153, z=105.5161},1.96348)
    end),
    At(23.136, 754, function(d,s)
        C.Move(d,s,A.FateProjection16,{x=94.9569, y=0.0153, z=112.108},2.74889)
    end),
    At(23.219, 755, function(d,s)
        C.Move(d,s,A.FateProjection15,{x=87.8767, y=0.0153, z=104.9973},1.96348)
    end),
    At(23.632, 756, function(d,s)
        C.Despawn(d,s,A.FateProjection09)
    end),
    At(23.632, 757, function(d,s)
        C.Despawn(d,s,A.FateProjection11)
    end),
    At(23.632, 758, function(d,s)
        C.Despawn(d,s,A.FateProjection12)
    end),
    At(24.898, 759, function(d,s)
        C.Despawn(d,s,A.FateProjection13)
    end),
    At(26.017, 760, function(d,s)
        C.Despawn(d,s,A.FateProjection14)
    end),
    At(26.211, 761, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18590,{pos={x=82.4445, y=0.0153, z=107.2557}, rotation=-1.17816, target=A.PerfectAlexander05})
    end),
    At(31.298, 762, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7737)
    end),
    At(31.298, 763, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7737)
    end),
    At(31.298, 764, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7737)
    end),
    At(31.298, 765, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7737)
    end),
    At(32.832, 766, function(d,s)
        C.Despawn(d,s,A.FateProjection15)
    end),
    At(32.832, 767, function(d,s)
        C.Despawn(d,s,A.FateProjection16)
    end),
    At(34.983, 768, function(d,s)
        C.Action(d,s,A.Boss,19220,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(34.983, 769, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=121.7112, y=0.0, z=91.0069},-1.17816)
    end),
    At(34.983, 770, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=108.9931, y=0.0, z=78.2888},-0.39275)
    end),
    At(34.983, 771, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=78.2888, y=0.0, z=91.0069},1.17807)
    end),
    At(34.983, 772, function(d,s)
        C.Move(d,s,A.PerfectAlexander02,{x=91.0069, y=0.0, z=78.2888},0.39266)
    end),
    At(35.115, 773, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7747)
    end),
    At(35.115, 774, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7747)
    end),
    At(35.115, 775, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7747)
    end),
    At(35.115, 776, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7747)
    end),
    At(36.176, 781, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(38.068, 782, function(d,s)
        C.Targetable(d,s,A.Boss,false)
    end),
    At(38.17, 783, function(d,s)
        C.Timeline(d,s,A.Boss,7737)
    end),
    At(47.115, 784, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(47.115, 785, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(47.115, 786, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(47.115, 787, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(47.115, 788, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(47.115, 789, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(47.215, 790, function(d,s)
        C.Action(d,s,A.Helper10,18530,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(47.215, 791, function(d,s)
        C.Action(d,s,A.Helper11,18531,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.Helper11})
    end),
    At(47.215, 792, function(d,s)
        C.Action(d,s,A.Helper12,18531,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931, target=A.Helper12})
    end),
    At(48.181, 793, function(d,s)
        C.Action(d,s,A.PerfectAlexander03,18565,{pos={x=78.2888, y=0.0, z=91.0069}, rotation=1.35544, dest={x=118.822, y=-0.0153, z=99.8703}})
    end),
    At(48.181, 794, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18565,{pos={x=108.9931, y=0.0, z=78.2888}, rotation=-0.23676, dest={x=99.4736, y=-0.0153, z=117.6928}})
    end),
    At(48.181, 795, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18565,{pos={x=121.7112, y=0.0, z=91.0069}, rotation=-1.36291, dest={x=81.7121, y=-0.0153, z=99.443}})
    end),
    At(48.285, 796, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=78.2635, y=-0.0153, z=90.9895},1.35544)
    end),
    At(48.285, 797, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=108.9647, y=-0.0153, z=78.2635},-0.23676)
    end),
    At(48.285, 798, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=121.6907, y=-0.0153, z=90.9895},-1.36291)
    end),
    At(49.132, 799, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=118.822, y=0.0153, z=99.8703},1.35544)
    end),
    At(49.132, 800, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=99.4736, y=0.0153, z=117.6928},-0.23676)
    end),
    At(49.132, 801, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=81.7121, y=0.0153, z=99.443},-1.36291)
    end),
    At(52.199, 802, function(d,s)
        C.Action(d,s,A.PerfectAlexander02,18861,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander02})
    end),
    At(54.211, 803, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(54.211, 804, function(d,s)
        C.Owner(d,s,A.Helper12,A.PerfectAlexander02)
    end),
    At(54.211, 805, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(54.211, 806, function(d,s)
        C.Owner(d,s,A.Helper11,A.PerfectAlexander02)
    end),
    At(54.211, 807, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(54.211, 808, function(d,s)
        C.Owner(d,s,A.Helper10,A.PerfectAlexander02)
    end),
    At(54.211, 809, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(54.211, 810, function(d,s)
        C.Owner(d,s,A.Helper09,A.PerfectAlexander02)
    end),
    At(54.211, 811, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(54.211, 812, function(d,s)
        C.Owner(d,s,A.Helper08,A.PerfectAlexander02)
    end),
    At(54.211, 813, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(54.211, 814, function(d,s)
        C.Owner(d,s,A.Helper07,A.PerfectAlexander02)
    end),
    At(54.211, 815, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(54.211, 816, function(d,s)
        C.Owner(d,s,A.Helper06,A.PerfectAlexander02)
    end),
    At(54.211, 817, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(54.211, 818, function(d,s)
        C.Owner(d,s,A.Helper05,A.PerfectAlexander02)
    end),
    At(54.286, 819, function(d,s)
        C.Action(d,s,A.Helper08,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(54.286, 820, function(d,s)
        C.Action(d,s,A.Helper09,18572,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(54.286, 821, function(d,s)
        C.Action(d,s,A.Helper10,18572,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(54.286, 822, function(d,s)
        C.Action(d,s,A.Helper11,18572,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(54.286, 823, function(d,s)
        C.Action(d,s,A.Helper12,18572,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(54.286, 824, function(d,s)
        C.Action(d,s,A.Helper05,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(54.286, 825, function(d,s)
        C.Action(d,s,A.Helper06,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(54.286, 826, function(d,s)
        C.Action(d,s,A.Helper07,18572,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(59.214, 827, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18566,{pos={x=81.7121, y=0.0153, z=99.443}, rotation=-1.36291, target=A.PerfectAlexander05})
    end),
    At(63.231, 828, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7737)
    end),
    At(63.231, 829, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7737)
    end),
    At(63.231, 830, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7737)
    end),
    At(63.231, 831, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7737)
    end),
    At(64.215, 832, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(64.298, 833, function(d,s)
        C.Timeline(d,s,A.Boss,7747)
    end),
    At(65.548, 834, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.23682)
    end),
    At(65.864, 835, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.10669)
    end),
    At(66.398, 836, function(d,s)
        C.Action(d,s,A.Boss,19083,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.10669})
    end),
    At(68.665, 837, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.12884)
    end),
}
