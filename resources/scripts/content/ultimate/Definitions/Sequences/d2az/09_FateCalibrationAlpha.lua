-- 未来确定α [18556]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/d2az.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 187, function(d,s)
        C.Cast(d,s,A.Boss,18556,21.7,{spell=18556, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(1.167, 188, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=88.6091, y=-0.0153, z=99.2294},1.69915)
    end),
    At(1.167, 189, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=100.2365, y=-0.0153, z=108.5374},-2.49683)
    end),
    At(1.167, 190, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=100.6943, y=-0.0153, z=108.9342},2.73307)
    end),
    At(1.167, 191, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=92.8817, y=-0.0153, z=108.5679},-2.87065)
    end),
    At(1.167, 192, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=107.2862, y=0.0153, z=99.7787},-1.13732)
    end),
    At(1.167, 193, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=104.7227, y=-0.0153, z=102.4643},-1.76463)
    end),
    At(1.167, 194, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=100.6943, y=-0.0153, z=92.6986},0.64165)
    end),
    At(1.167, 195, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=91.5389, y=-0.0153, z=103.1052},2.55416)
    end),
    At(1.466, 196, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=90.4707, y=-0.0153, z=98.9853},1.69915)
    end),
    At(1.466, 197, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=99.0768, y=-0.0153, z=107.1031},-2.46366)
    end),
    At(1.466, 198, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=102.0981, y=-0.0153, z=107.6829},2.30163)
    end),
    At(1.466, 199, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=92.3934, y=-0.0153, z=106.7674},-2.87065)
    end),
    At(1.466, 200, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=107.2862, y=0.0153, z=99.7787},-1.5445)
    end),
    At(1.466, 201, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=102.8916, y=-0.0153, z=102.1286},-1.76463)
    end),
    At(1.466, 202, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=102.0371, y=-0.0153, z=94.0108},0.79073)
    end),
    At(1.466, 203, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=92.1187, y=0.0153, z=101.3352},2.82003)
    end),
    At(1.781, 204, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=92.3323, y=-0.0153, z=98.7716},1.69915)
    end),
    At(1.781, 205, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=97.8866, y=-0.0153, z=105.6382},-2.46366)
    end),
    At(1.781, 206, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=103.4714, y=0.0153, z=106.4317},2.30163)
    end),
    At(1.781, 207, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=91.8746, y=0.0153, z=104.9668},-2.87065)
    end),
    At(1.781, 208, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=101.03, y=-0.0153, z=101.7624},-1.76463)
    end),
    At(1.781, 209, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=103.3799, y=-0.0153, z=95.3536},0.79073)
    end),
    At(1.781, 210, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=92.4544, y=0.0153, z=100.3586},2.44726)
    end),
    At(2.085, 211, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=94.1634, y=-0.0153, z=98.5275},1.69915)
    end),
    At(2.085, 212, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=96.7269, y=-0.0153, z=104.1733},-2.46366)
    end),
    At(2.085, 213, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=104.8753, y=0.0153, z=105.1804},2.30163)
    end),
    At(2.085, 214, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=91.3863, y=0.0153, z=103.1662},-2.87065)
    end),
    At(2.085, 215, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=99.1989, y=0.0153, z=101.3962},-1.76463)
    end),
    At(2.085, 216, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=104.6921, y=0.0153, z=96.6659},0.79073)
    end),
    At(2.085, 217, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=92.4544, y=0.0153, z=100.3586},1.62159)
    end),
    At(2.4, 218, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=96.025, y=0.0153, z=98.2834},1.69915)
    end),
    At(2.4, 219, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=95.5367, y=0.0153, z=102.7085},-2.46366)
    end),
    At(2.4, 220, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=106.2791, y=0.0153, z=103.9597},2.30163)
    end),
    At(2.4, 221, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=91.3252, y=0.0153, z=102.9831},2.47842)
    end),
    At(2.4, 222, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=97.3678, y=0.0153, z=101.03},-1.76463)
    end),
    At(2.4, 223, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=106.0349, y=0.0153, z=97.9782},0.79073)
    end),
    At(2.747, 224, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=97.8866, y=0.0153, z=98.0392},1.69915)
    end),
    At(2.747, 225, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=94.3771, y=0.0153, z=101.2436},-2.46366)
    end),
    At(2.747, 226, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=107.3472, y=0.0153, z=102.9831},2.4859)
    end),
    At(2.747, 227, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=91.3252, y=0.0153, z=102.9831},1.9048)
    end),
    At(2.747, 228, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=95.5367, y=0.0153, z=100.6638},-1.76463)
    end),
    At(2.747, 229, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=107.3777, y=0.0153, z=99.2905},0.79073)
    end),
    At(3.032, 230, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=99.7482, y=0.0153, z=97.7951},1.69915)
    end),
    At(3.032, 231, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=93.1868, y=0.0153, z=99.8093},-2.46366)
    end),
    At(3.032, 232, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=107.3472, y=0.0153, z=102.9831},-2.49453)
    end),
    At(3.032, 233, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=93.7057, y=0.0153, z=100.3281},-1.76463)
    end),
    At(3.032, 234, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=108.4459, y=0.0153, z=100.3586},0.79073)
    end),
    At(3.334, 235, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=101.6098, y=0.0153, z=97.5509},1.69915)
    end),
    At(3.334, 236, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=92.0272, y=0.0153, z=98.3444},-2.46366)
    end),
    At(3.334, 237, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=107.3472, y=0.0153, z=102.9831},-1.9582)
    end),
    At(3.334, 238, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=91.8746, y=0.0153, z=99.9619},-1.76463)
    end),
    At(3.334, 239, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=108.4459, y=0.0153, z=100.3586},-0.51614)
    end),
    At(3.672, 240, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=103.4409, y=0.0153, z=97.3068},1.69915)
    end),
    At(3.672, 241, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=90.8675, y=0.0153, z=96.8795},-2.46366)
    end),
    At(3.672, 242, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=91.2947, y=0.0153, z=99.8398},-2.50594)
    end),
    At(3.672, 243, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=108.4459, y=0.0153, z=100.3586},-1.61603)
    end),
    At(3.968, 244, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=105.333, y=0.0153, z=97.0932},1.69915)
    end),
    At(3.968, 245, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=90.837, y=0.0153, z=96.8795},2.69711)
    end),
    At(3.968, 246, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=91.2947, y=0.0153, z=99.8398},2.46615)
    end),
    At(4.299, 247, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=106.8589, y=0.0153, z=96.8795},1.69905)
    end),
    At(4.299, 248, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=90.837, y=0.0153, z=96.8795},1.39868)
    end),
    At(4.299, 249, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=91.2947, y=0.0153, z=99.8398},1.55419)
    end),
    At(4.603, 250, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=106.8589, y=0.0153, z=96.8795},0.3964)
    end),
    At(4.603, 251, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=90.837, y=0.0153, z=96.8795},1.24355)
    end),
    At(4.899, 252, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=106.8589, y=0.0153, z=96.8795},-0.91048)
    end),
    At(5.085, 253, function(d,s)
        C.Cast(d,s,A.PerfectAlexander04,18584,0.7,{spell=18584, omen_delay=0, cast_pos={x=90.9895, y=-0.0153, z=78.2635}, pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander04})
    end),
    At(5.217, 254, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=107.0115, y=0.0153, z=97.3983},-0.77788)
    end),
    At(5.217, 255, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=106.7979, y=0.0153, z=103.0137},-1.58956)
    end),
    At(5.267, 256, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=91.8135, y=0.0153, z=103.624},1.34767)
    end),
    At(5.267, 257, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=91.1727, y=0.0153, z=99.0463},2.11132)
    end),
    At(5.301, 258, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=107.9881, y=0.0153, z=99.4125},-2.35743)
    end),
    At(5.301, 259, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=92.9427, y=0.0153, z=99.1379},2.55148)
    end),
    At(5.332, 260, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=92.1798, y=0.0153, z=96.8185},1.61027)
    end),
    At(5.332, 261, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=106.8284, y=0.0153, z=101.03},-0.61883)
    end),
    At(5.588, 262, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=107.6219, y=0.0153, z=99.1684},0.33034)
    end),
    At(5.588, 263, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=104.9363, y=0.0153, z=103.1052},-1.52101)
    end),
    At(5.606, 264, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=92.9732, y=0.0153, z=105.0889},0.65785)
    end),
    At(5.606, 265, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=90.898, y=0.0153, z=97.1847},-2.99605)
    end),
    At(5.606, 266, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=107.1641, y=0.0153, z=97.734},-2.69223)
    end),
    At(5.606, 267, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=93.6141, y=0.0153, z=97.3678},2.77401)
    end),
    At(5.656, 268, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=94.0414, y=0.0153, z=96.7575},1.61027)
    end),
    At(5.656, 269, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=106.157, y=0.0153, z=102.8},-0.35191)
    end),
    At(5.852, 270, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=108.2322, y=0.0153, z=100.9384},0.33034)
    end),
    At(5.852, 271, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=103.0747, y=0.0153, z=103.1968},-1.52101)
    end),
    At(5.885, 272, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=94.1024, y=0.0153, z=106.5843},0.65785)
    end),
    At(5.885, 273, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=90.7454, y=0.0153, z=96.1471},2.91427)
    end),
    At(5.917, 274, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=106.3706, y=0.0153, z=96.025},-2.69223)
    end),
    At(5.917, 275, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=94.2855, y=0.0153, z=95.6283},2.77401)
    end),
    At(5.983, 276, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=95.9335, y=0.0153, z=96.6964},1.61027)
    end),
    At(5.983, 277, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=105.5161, y=0.0153, z=104.5701},-0.35191)
    end),
    At(6.05, 278, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18584,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander04})
    end),
    At(6.167, 279, function(d,s)
        C.Action(d,s,A.Helper08,19213,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, target=A.FateProjection04})
    end),
    At(6.167, 280, function(d,s)
        C.Action(d,s,A.Helper09,19213,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729, target=A.FateProjection05})
    end),
    At(6.167, 281, function(d,s)
        C.Action(d,s,A.Helper10,19213,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05, target=A.FateProjection06})
    end),
    At(6.167, 282, function(d,s)
        C.Action(d,s,A.Helper11,19213,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.FateProjection07})
    end),
    At(6.167, 283, function(d,s)
        C.Action(d,s,A.Helper12,19213,{pos={x=100.0, y=28.7, z=44.9}, rotation=-5e-05, target=A.FateProjection08})
    end),
    At(6.167, 284, function(d,s)
        C.Action(d,s,A.Helper05,19213,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, target=A.FateProjection01})
    end),
    At(6.167, 285, function(d,s)
        C.Action(d,s,A.Helper06,19213,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, target=A.FateProjection02})
    end),
    At(6.167, 286, function(d,s)
        C.Action(d,s,A.Helper07,19213,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, target=A.FateProjection03})
    end),
    At(6.167, 287, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=108.8426, y=0.0153, z=102.7085},0.33034)
    end),
    At(6.167, 288, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=101.2131, y=0.0153, z=103.2883},-1.52101)
    end),
    At(6.235, 289, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=95.2621, y=0.0153, z=108.0491},0.65785)
    end),
    At(6.235, 290, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=90.7454, y=0.0153, z=96.1471},1.6074)
    end),
    At(6.252, 291, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=105.5467, y=0.0153, z=94.3465},-2.69223)
    end),
    At(6.252, 292, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=94.9569, y=0.0153, z=93.8888},2.77401)
    end),
    At(6.269, 293, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=97.7951, y=0.0153, z=96.6049},1.61018)
    end),
    At(6.269, 294, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=104.8753, y=0.0153, z=106.3096},-0.35191)
    end),
    At(6.483, 295, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=109.2088, y=0.0153, z=103.8071},0.14185)
    end),
    At(6.483, 296, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=99.3515, y=0.0153, z=103.3799},-1.52101)
    end),
    At(6.499, 297, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=96.1471, y=0.0153, z=109.2088},0.65785)
    end),
    At(6.499, 298, function(d,s)
        C.Move(d,s,A.FateProjection05,{x=90.7454, y=0.0153, z=96.1471},1.17807)
    end),
    At(6.549, 299, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=104.7532, y=0.0153, z=92.668},-2.69223)
    end),
    At(6.549, 300, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=95.6283, y=0.0153, z=92.1492},2.77401)
    end),
    At(6.595, 301, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=99.6567, y=0.0153, z=96.5438},1.61018)
    end),
    At(6.595, 302, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=104.2344, y=0.0153, z=108.0797},-0.35191)
    end),
    At(6.783, 303, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=109.2088, y=0.0153, z=103.8071},-1.16925)
    end),
    At(6.783, 304, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=97.4594, y=0.0153, z=103.4714},-1.52101)
    end),
    At(6.817, 305, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=96.1471, y=0.0153, z=109.2088},1.96894)
    end),
    At(6.852, 306, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=103.9292, y=0.0153, z=90.9895},-2.69223)
    end),
    At(6.852, 307, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=96.1471, y=0.0153, z=90.7454},2.77401)
    end),
    At(6.917, 308, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=101.5183, y=0.0153, z=96.4523},1.61018)
    end),
    At(6.917, 309, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=103.8071, y=0.0153, z=109.2088},-0.53618)
    end),
    At(7.084, 310, function(d,s)
        C.Move(d,s,A.FateProjection02,{x=109.2088, y=0.0153, z=103.8071},-1.96357)
    end),
    At(7.084, 311, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=95.5978, y=0.0153, z=103.563},-1.52101)
    end),
    At(7.133, 312, function(d,s)
        C.Move(d,s,A.FateProjection03,{x=96.1471, y=0.0153, z=109.2088},2.74889)
    end),
    At(7.182, 313, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=103.8071, y=0.0153, z=90.7454},-1.75811)
    end),
    At(7.182, 314, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=96.1471, y=0.0153, z=90.7454},1.46713)
    end),
    At(7.199, 315, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=103.4104, y=0.0153, z=96.3912},1.61018)
    end),
    At(7.199, 316, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=103.8071, y=0.0153, z=109.2088},-1.84315)
    end),
    At(7.4, 317, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=93.7362, y=0.0153, z=103.6545},-1.52101)
    end),
    At(7.499, 318, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=103.8071, y=0.0153, z=90.7454},-0.45114)
    end),
    At(7.499, 319, function(d,s)
        C.Move(d,s,A.FateProjection07,{x=96.1471, y=0.0153, z=90.7454},0.39266)
    end),
    At(7.517, 320, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=105.272, y=0.0153, z=96.2997},1.61018)
    end),
    At(7.517, 321, function(d,s)
        C.Move(d,s,A.FateProjection06,{x=103.8071, y=0.0153, z=109.2088},-2.74898)
    end),
    At(7.699, 322, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=91.8746, y=0.0153, z=103.7461},-1.52101)
    end),
    At(7.811, 323, function(d,s)
        C.Move(d,s,A.FateProjection08,{x=103.8071, y=0.0153, z=90.7454},-0.39275)
    end),
    At(7.841, 324, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=107.1336, y=0.0153, z=96.2387},1.61018)
    end),
    At(8.018, 325, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=90.7454, y=0.0153, z=103.8071},-1.89397)
    end),
    At(8.156, 326, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=108.9952, y=0.0153, z=96.1776},1.61018)
    end),
    At(8.332, 327, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=90.7454, y=0.0153, z=103.8071},3.08234)
    end),
    At(8.461, 328, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=109.2088, y=0.0153, z=96.1471},0.68028)
    end),
    At(8.63, 329, function(d,s)
        C.Move(d,s,A.FateProjection04,{x=90.7454, y=0.0153, z=103.8071},1.96348)
    end),
    At(8.784, 330, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=109.2088, y=0.0153, z=96.1471},-0.62659)
    end),
    At(9.1, 331, function(d,s)
        C.Move(d,s,A.FateProjection01,{x=109.2088, y=0.0153, z=96.1471},-1.17816)
    end),
    At(12.016, 332, function(d,s)
        C.Move(d,s,A.Helper12,{x=96.1732, y=0.0369, z=90.7612},0.39266)
    end),
    At(12.133, 333, function(d,s)
        C.Action(d,s,A.Helper12,18596,{pos={x=96.1732, y=0.0369, z=90.7612}, rotation=0.39266, target=A.Helper12})
    end),
    At(12.75, 334, function(d,s)
        C.Action(d,s,A.Helper11,18598,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.FateProjection08})
    end),
    At(13.251, 335, function(d,s)
        C.Action(d,s,A.Helper08,18597,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, target=A.FateProjection04})
    end),
    At(13.251, 336, function(d,s)
        C.Action(d,s,A.Helper09,18597,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729, target=A.FateProjection05})
    end),
    At(13.251, 337, function(d,s)
        C.Action(d,s,A.Helper10,18597,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05, target=A.FateProjection06})
    end),
    At(13.251, 338, function(d,s)
        C.Cast(d,s,A.PerfectAlexander03,18858,0.7,{spell=18858, omen_delay=0, cast_pos={x=108.9647, y=-0.0153, z=78.2635}, pos={x=108.9931, y=0.0, z=78.2888}, rotation=-0.39275, target=A.PerfectAlexander03})
    end),
    At(14.183, 339, function(d,s)
        C.Action(d,s,A.PerfectAlexander03,18858,{pos={x=108.9931, y=0.0, z=78.2888}, rotation=-0.39275, target=A.PerfectAlexander03})
    end),
    At(14.972, 340, function(d,s)
        C.Action(d,s,A.Helper09,18585,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729, target=A.FateProjection01})
    end),
    At(14.972, 341, function(d,s)
        C.Action(d,s,A.Helper10,18585,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05, target=A.FateProjection02})
    end),
    At(14.972, 342, function(d,s)
        C.Action(d,s,A.Helper11,18585,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, target=A.FateProjection03})
    end),
    At(14.972, 343, function(d,s)
        C.Action(d,s,A.Helper12,18585,{pos={x=96.1732, y=0.0369, z=90.7612}, rotation=0.39266, target=A.FateProjection07})
    end),
    At(15.2, 344, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18591,{pos={x=78.2888, y=0.0, z=91.0069}, rotation=1.17807, target=A.PerfectAlexander05})
    end),
    At(15.721, 345, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18591,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander04})
    end),
    At(16.262, 346, function(d,s)
        C.Action(d,s,A.PerfectAlexander02,18591,{pos={x=121.7112, y=0.0, z=91.0069}, rotation=-1.17816, target=A.PerfectAlexander02})
    end),
    At(20.268, 347, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7737)
    end),
    At(20.268, 348, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7737)
    end),
    At(20.268, 349, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7737)
    end),
    At(20.268, 350, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7737)
    end),
    At(22.001, 351, function(d,s)
        C.Action(d,s,A.Boss,18556,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-5e-05, target=A.Boss})
    end),
    At(22.001, 352, function(d,s)
        C.Move(d,s,A.PerfectAlexander05,{x=78.2888, y=0.0, z=91.0069},1.17807)
    end),
    At(22.001, 353, function(d,s)
        C.Move(d,s,A.PerfectAlexander04,{x=91.0069, y=0.0, z=78.2888},0.39266)
    end),
    At(22.001, 354, function(d,s)
        C.Move(d,s,A.PerfectAlexander03,{x=108.9931, y=0.0, z=78.2888},-0.39275)
    end),
    At(22.001, 355, function(d,s)
        C.Move(d,s,A.PerfectAlexander02,{x=121.7112, y=0.0, z=91.0069},-1.17816)
    end),
    At(22.118, 356, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7747)
    end),
    At(22.118, 357, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7747)
    end),
    At(22.118, 358, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7747)
    end),
    At(22.118, 359, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7747)
    end),
    At(23.119, 364, function(d,s)
        C.Model(d,s,A.Boss,0)
    end),
    At(23.119, 365, function(d,s)
        C.Despawn(d,s,A.FateProjection08)
    end),
    At(23.536, 366, function(d,s)
        C.Despawn(d,s,A.FateProjection04)
    end),
    At(23.536, 367, function(d,s)
        C.Despawn(d,s,A.FateProjection06)
    end),
    At(23.536, 368, function(d,s)
        C.Despawn(d,s,A.FateProjection05)
    end),
    At(25.033, 369, function(d,s)
        C.Targetable(d,s,A.Boss,false)
    end),
    At(25.136, 370, function(d,s)
        C.Timeline(d,s,A.Boss,7737)
    end),
    At(25.534, 371, function(d,s)
        C.Despawn(d,s,A.FateProjection03)
    end),
    At(25.534, 372, function(d,s)
        C.Despawn(d,s,A.FateProjection01)
    end),
    At(25.534, 373, function(d,s)
        C.Despawn(d,s,A.FateProjection02)
    end),
    At(25.534, 374, function(d,s)
        C.Despawn(d,s,A.FateProjection07)
    end),
    At(29.116, 375, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18859,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander04})
    end),
    At(29.116, 376, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(29.116, 377, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(29.116, 378, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(29.116, 379, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(29.116, 380, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(29.116, 381, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(29.116, 382, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(29.116, 383, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(29.199, 384, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(29.199, 385, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(29.199, 386, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(29.199, 387, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(29.199, 388, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(29.199, 389, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(29.199, 390, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(29.199, 391, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(29.199, 392, function(d,s)
        C.Action(d,s,A.Helper05,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(29.199, 393, function(d,s)
        C.Action(d,s,A.Helper06,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(29.199, 394, function(d,s)
        C.Action(d,s,A.Helper07,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(29.248, 395, function(d,s)
        C.Action(d,s,A.Helper08,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(29.248, 396, function(d,s)
        C.Action(d,s,A.Helper09,19039,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(29.248, 397, function(d,s)
        C.Action(d,s,A.Helper10,19039,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(29.248, 398, function(d,s)
        C.Action(d,s,A.Helper11,19039,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(29.248, 399, function(d,s)
        C.Action(d,s,A.Helper12,19039,{pos={x=96.1732, y=0.0369, z=90.7612}, rotation=0.39266})
    end),
    At(32.05, 400, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(32.05, 401, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(32.05, 402, function(d,s)
        C.Move(d,s,A.Helper12,{x=105.9155, y=1.7502, z=84.1014},-1.04931)
    end),
    At(32.133, 403, function(d,s)
        C.Action(d,s,A.Helper12,18528,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931, target=A.Helper12})
    end),
    At(32.598, 404, function(d,s)
        C.Owner(d,s,A.Helper11,nil)
    end),
    At(32.598, 405, function(d,s)
        C.Owner(d,s,A.Helper11,A.Boss)
    end),
    At(32.666, 406, function(d,s)
        C.Action(d,s,A.Helper11,18530,{pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557})
    end),
    At(33.132, 407, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(33.132, 408, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(33.132, 409, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(33.132, 410, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(33.132, 411, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(33.132, 412, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(33.216, 413, function(d,s)
        C.Action(d,s,A.Helper08,18529,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(33.216, 414, function(d,s)
        C.Action(d,s,A.Helper09,18529,{pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729})
    end),
    At(33.216, 415, function(d,s)
        C.Action(d,s,A.Helper10,18529,{pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05})
    end),
    At(33.216, 416, function(d,s)
        C.Action(d,s,A.PerfectAlexander03,18859,{pos={x=108.9931, y=0.0, z=78.2888}, rotation=-0.39275, target=A.PerfectAlexander03})
    end),
    At(33.216, 417, function(d,s)
        C.Owner(d,s,A.Helper12,nil)
    end),
    At(33.216, 418, function(d,s)
        C.Owner(d,s,A.Helper12,A.Boss)
    end),
    At(33.216, 419, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(33.216, 420, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(33.216, 421, function(d,s)
        C.Owner(d,s,A.Helper06,nil)
    end),
    At(33.216, 422, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(33.216, 423, function(d,s)
        C.Owner(d,s,A.Helper05,nil)
    end),
    At(33.216, 424, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(33.216, 425, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(33.216, 426, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(33.216, 427, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(33.216, 428, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(33.216, 429, function(d,s)
        C.Action(d,s,A.PerfectAlexander05,18569,{pos={x=78.2888, y=0.0, z=91.0069}, rotation=1.17807, target=A.PerfectAlexander05})
    end),
    At(33.282, 430, function(d,s)
        C.Action(d,s,A.Helper01,19039,{pos={x=97.3954, y=0.0, z=108.3706}, rotation=-5e-05})
    end),
    At(33.282, 431, function(d,s)
        C.Action(d,s,A.Helper02,19039,{pos={x=100.0, y=0.0, z=85.0}, rotation=1.08037})
    end),
    At(33.282, 432, function(d,s)
        C.Action(d,s,A.Helper03,19039,{pos={x=100.0, y=0.0, z=115.0}, rotation=-2.01343})
    end),
    At(33.282, 433, function(d,s)
        C.Action(d,s,A.Helper04,19039,{pos={x=85.0, y=0.0, z=100.0}, rotation=0.44002})
    end),
    At(33.282, 434, function(d,s)
        C.Action(d,s,A.Helper05,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(33.282, 435, function(d,s)
        C.Action(d,s,A.Helper06,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(33.282, 436, function(d,s)
        C.Action(d,s,A.Helper07,19039,{pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624})
    end),
    At(33.332, 437, function(d,s)
        C.Action(d,s,A.Helper12,19039,{pos={x=105.9155, y=1.7502, z=84.1014}, rotation=-1.04931})
    end),
    At(33.742, 438, function(d,s)
        C.Action(d,s,A.PerfectAlexander04,18569,{pos={x=91.0069, y=0.0, z=78.2888}, rotation=0.39266, target=A.PerfectAlexander04})
    end),
    At(34.278, 439, function(d,s)
        C.Action(d,s,A.PerfectAlexander02,18569,{pos={x=121.7112, y=0.0, z=91.0069}, rotation=-1.17816, target=A.PerfectAlexander02})
    end),
    At(38.283, 440, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander02,7737)
    end),
    At(38.283, 441, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander03,7737)
    end),
    At(38.283, 442, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander04,7737)
    end),
    At(38.283, 443, function(d,s)
        C.Timeline(d,s,A.PerfectAlexander05,7737)
    end),
    At(39.263, 444, function(d,s)
        C.Targetable(d,s,A.Boss,true)
    end),
    At(39.333, 445, function(d,s)
        C.Timeline(d,s,A.Boss,7747)
    end),
    At(40.616, 446, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.14459)
    end),
    At(40.916, 447, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.68331)
    end),
    At(41.216, 448, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},2.87094)
    end),
    At(41.532, 449, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.02923)
    end),
    At(41.851, 450, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},3.12155)
    end),
}
