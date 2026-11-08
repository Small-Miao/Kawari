-- 百京核爆剑 [28059]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 109, function(d,s)
        C.Cast(d,s,A.Boss,28059,5.7,{spell=28059, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12702, target=A.Boss})
    end),
    At(0.0, 110, function(d,s)
        C.Cast(d,s,A.Helper08,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=93.0037, y=-0.0153, z=96.0861}, pos={x=93.0142, y=0.0, z=96.1015}, rotation=1.58535, target=A.Helper08})
    end),
    At(0.0, 111, function(d,s)
        C.Cast(d,s,A.Helper09,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=106.8589, y=-0.0153, z=95.8724}, pos={x=106.8691, y=0.0, z=95.8994}, rotation=-1.5563, target=A.Helper09})
    end),
    At(0.0, 112, function(d,s)
        C.Cast(d,s,A.Helper10,28060,6.6,{spell=28060, omen_delay=0, cast_pos={x=100.1144, y=-0.0153, z=107.9881}, pos={x=100.1167, y=0.0, z=107.9991}, rotation=-0.77089, target=A.Helper10})
    end),
    At(0.952, 113, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.063, 114, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.277, 115, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.779, 116, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(2.922, 117, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(3.544, 118, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(4.995, 119, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(5.896, 120, function(d,s)
        C.Status(d,s,A.Boss,{{id=2056, param=299, duration=0}})
    end),
    At(6.044, 121, function(d,s)
        C.Action(d,s,A.Boss,28059,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.12702, target=A.Boss})
    end),
    At(6.892, 122, function(d,s)
        C.Action(d,s,A.Helper08,28060,{pos={x=93.0142, y=0.0, z=96.1015}, rotation=1.58535, target=A.Helper08})
    end),
    At(6.892, 123, function(d,s)
        C.Action(d,s,A.Helper09,28060,{pos={x=106.8691, y=0.0, z=95.8994}, rotation=-1.5563, target=A.Helper09})
    end),
    At(6.892, 124, function(d,s)
        C.Action(d,s,A.Helper10,28060,{pos={x=100.1167, y=0.0, z=107.9991}, rotation=-0.77089, target=A.Helper10})
    end),
    At(7.11, 125, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(7.11, 126, function(d,s)
        C.Move(d,s,A.Helper07,{x=100.0, y=0.0, z=100.0},-3.12702)
    end),
    At(7.191, 127, function(d,s)
        C.Action(d,s,A.Helper07,28050,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12702, target=A.Helper07})
    end),
    At(8.799, 128, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(8.799, 129, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(8.799, 130, function(d,s)
        C.Move(d,s,A.Helper08,{x=92.9121, y=0.0, z=89.1022},-3.12702)
    end),
    At(8.799, 131, function(d,s)
        C.Owner(d,s,A.Helper06,A.Boss)
    end),
    At(8.799, 132, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.1163, y=0.0, z=103.1007},0.01453)
    end),
    At(8.799, 133, function(d,s)
        C.Owner(d,s,A.Helper05,A.Boss)
    end),
    At(8.799, 134, function(d,s)
        C.Move(d,s,A.Helper05,{x=100.0135, y=0.0, z=95.9994},1.58535)
    end),
    At(8.799, 135, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(8.799, 136, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(8.799, 137, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.9712, y=0.0, z=102.8986},0.01453)
    end),
    At(8.799, 138, function(d,s)
        C.Owner(d,s,A.Helper04,A.Boss)
    end),
    At(8.799, 139, function(d,s)
        C.Move(d,s,A.Helper04,{x=106.767, y=0.0, z=88.9001},-3.12702)
    end),
    At(8.799, 140, function(d,s)
        C.Owner(d,s,A.Helper03,A.Boss)
    end),
    At(8.799, 141, function(d,s)
        C.Move(d,s,A.Helper03,{x=99.8699, y=0.0, z=96.0015},-1.5563)
    end),
    At(8.799, 142, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(8.799, 143, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(8.799, 144, function(d,s)
        C.Move(d,s,A.Helper10,{x=105.1381, y=0.0, z=112.8762},0.79994)
    end),
    At(8.799, 145, function(d,s)
        C.Owner(d,s,A.Helper02,A.Boss)
    end),
    At(8.799, 146, function(d,s)
        C.Move(d,s,A.Helper02,{x=95.0953, y=0.0, z=103.1221},-2.34171)
    end),
    At(8.799, 147, function(d,s)
        C.Owner(d,s,A.Helper01,A.Boss)
    end),
    At(8.799, 148, function(d,s)
        C.Move(d,s,A.Helper01,{x=95.2396, y=0.0, z=113.0206},-0.77089)
    end),
    At(8.874, 149, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=92.9121, y=0.0, z=89.1022}, rotation=-3.12702, dest={x=92.9122, y=-0.0153, z=89.0974}})
    end),
    At(8.874, 150, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=106.9712, y=0.0, z=102.8986}, rotation=0.01453, dest={x=106.9505, y=-0.0153, z=102.8916}})
    end),
    At(8.874, 151, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=106.767, y=0.0, z=88.9001}, rotation=-3.12702, dest={x=106.7369, y=-0.0153, z=88.8838}})
    end),
    At(8.874, 152, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=105.1381, y=0.0, z=112.8762}, rotation=0.79994, dest={x=105.1194, y=-0.0153, z=112.871}})
    end),
    At(8.874, 153, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=95.0953, y=0.0, z=103.1221}, rotation=-2.34171, dest={x=95.079, y=-0.0153, z=103.1052}})
    end),
    At(8.874, 154, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=99.8699, y=0.0, z=96.0015}, rotation=-1.5563, dest={x=99.8398, y=-0.0153, z=95.9945}})
    end),
    At(8.874, 155, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=100.0135, y=0.0, z=95.9994}, rotation=1.58535, dest={x=99.9924, y=-0.0153, z=95.9945}})
    end),
    At(8.874, 156, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=93.1163, y=0.0, z=103.1007}, rotation=0.01453, dest={x=93.0953, y=-0.0153, z=103.0747}})
    end),
    At(8.874, 157, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=95.2396, y=0.0, z=113.0206}, rotation=-0.77089, dest={x=95.2316, y=-0.0153, z=112.9931}})
    end),
    At(10.204, 159, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.44316)
    end),
    At(10.521, 160, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},0.00762)
    end),
    At(10.667, 161, function(d,s)
        C.Move(d,s,A.Helper08,{x=92.81, y=0.0, z=82.103},-3.12702)
    end),
    At(10.667, 162, function(d,s)
        C.Move(d,s,A.Helper09,{x=107.0733, y=0.0, z=109.8979},0.01453)
    end),
    At(10.667, 163, function(d,s)
        C.Move(d,s,A.Helper04,{x=106.665, y=0.0, z=81.9009},-3.12702)
    end),
    At(10.667, 164, function(d,s)
        C.Move(d,s,A.Helper10,{x=110.1595, y=0.0, z=117.7532},0.79994)
    end),
    At(10.724, 165, function(d,s)
        C.Move(d,s,A.Helper02,{x=90.0739, y=0.0, z=98.2451},-2.34171)
    end),
    At(10.724, 166, function(d,s)
        C.Move(d,s,A.Helper03,{x=92.8706, y=0.0, z=96.1036},-1.5563)
    end),
    At(10.724, 167, function(d,s)
        C.Move(d,s,A.Helper05,{x=107.0127, y=0.0, z=95.8973},1.58535)
    end),
    At(10.724, 168, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.2184, y=0.0, z=110.1},0.01453)
    end),
    At(10.724, 169, function(d,s)
        C.Move(d,s,A.Helper01,{x=90.3626, y=0.0, z=118.042},-0.77089)
    end),
    At(10.724, 170, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=92.81, y=0.0, z=82.103}, rotation=-3.12702, dest={x=92.7901, y=-0.0153, z=82.0783}})
    end),
    At(10.724, 171, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=107.0733, y=0.0, z=109.8979}, rotation=0.01453, dest={x=107.0726, y=-0.0153, z=109.8802}})
    end),
    At(10.724, 172, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=106.665, y=0.0, z=81.9009}, rotation=-3.12702, dest={x=106.6453, y=-0.0153, z=81.8952}})
    end),
    At(10.724, 173, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=110.1595, y=0.0, z=117.7532}, rotation=0.79994, dest={x=110.1549, y=-0.0153, z=117.7234}})
    end),
    At(10.724, 174, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=90.0739, y=0.0, z=98.2451}, rotation=-2.34171, dest={x=90.0435, y=-0.0153, z=98.2223}})
    end),
    At(10.724, 175, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=92.8706, y=0.0, z=96.1036}, rotation=-1.5563, dest={x=92.8511, y=-0.0153, z=96.0861}})
    end),
    At(10.724, 176, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=107.0127, y=0.0, z=95.8973}, rotation=1.58535, dest={x=107.0115, y=-0.0153, z=95.8724}})
    end),
    At(10.724, 177, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=93.2184, y=0.0, z=110.1}, rotation=0.01453, dest={x=93.2174, y=-0.0153, z=110.0938}})
    end),
    At(10.724, 178, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=90.3626, y=0.0, z=118.042}, rotation=-0.77089, dest={x=90.3487, y=-0.0153, z=118.0285}})
    end),
    At(11.959, 179, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.06582)
    end),
    At(12.27, 180, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-0.50972)
    end),
    At(12.509, 181, function(d,s)
        C.Move(d,s,A.Helper08,{x=92.7079, y=0.0, z=75.1037},-3.12702)
    end),
    At(12.509, 182, function(d,s)
        C.Move(d,s,A.Helper09,{x=107.1754, y=0.0, z=116.8971},0.01453)
    end),
    At(12.509, 183, function(d,s)
        C.Move(d,s,A.Helper04,{x=106.5629, y=0.0, z=74.9016},-3.12702)
    end),
    At(12.509, 184, function(d,s)
        C.Move(d,s,A.Helper10,{x=115.1809, y=0.0, z=122.6302},0.79994)
    end),
    At(12.55, 185, function(d,s)
        C.Move(d,s,A.Helper02,{x=85.0525, y=0.0, z=93.368},-2.34171)
    end),
    At(12.55, 186, function(d,s)
        C.Move(d,s,A.Helper03,{x=85.8714, y=0.0, z=96.2057},-1.5563)
    end),
    At(12.55, 187, function(d,s)
        C.Move(d,s,A.Helper05,{x=114.012, y=0.0, z=95.7952},1.58535)
    end),
    At(12.55, 188, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.3205, y=0.0, z=117.0992},0.01453)
    end),
    At(12.55, 189, function(d,s)
        C.Move(d,s,A.Helper01,{x=85.4856, y=0.0, z=123.0634},-0.77089)
    end),
    At(12.55, 190, function(d,s)
        C.Action(d,s,A.Helper08,28061,{pos={x=92.7079, y=0.0, z=75.1037}, rotation=-3.12702, dest={x=92.6986, y=-0.0153, z=75.0896}})
    end),
    At(12.55, 191, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=107.1754, y=0.0, z=116.8971}, rotation=0.01453, dest={x=107.1641, y=-0.0153, z=116.8688}})
    end),
    At(12.55, 192, function(d,s)
        C.Action(d,s,A.Helper04,28061,{pos={x=106.5629, y=0.0, z=74.9016}, rotation=-3.12702, dest={x=106.5537, y=-0.0153, z=74.876}})
    end),
    At(12.55, 193, function(d,s)
        C.Action(d,s,A.Helper10,28061,{pos={x=115.1809, y=0.0, z=122.6302}, rotation=0.79994, dest={x=115.1598, y=-0.0153, z=122.6062}})
    end),
    At(12.593, 194, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.1751)
    end),
    At(12.64, 195, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=85.0525, y=0.0, z=93.368}, rotation=-2.34171, dest={x=85.0385, y=-0.0153, z=93.3394}})
    end),
    At(12.64, 196, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=85.8714, y=0.0, z=96.2057}, rotation=-1.5563, dest={x=85.8625, y=-0.0153, z=96.1776}})
    end),
    At(12.64, 197, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=114.012, y=0.0, z=95.7952}, rotation=1.58535, dest={x=114.0002, y=-0.0153, z=95.7809}})
    end),
    At(12.64, 198, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=93.3205, y=0.0, z=117.0992}, rotation=0.01453, dest={x=93.3089, y=-0.0153, z=117.0825}})
    end),
    At(12.64, 199, function(d,s)
        C.Action(d,s,A.Helper01,28061,{pos={x=85.4856, y=0.0, z=123.0634}, rotation=-0.77089, dest={x=85.4658, y=-0.0153, z=123.0335}})
    end),
    At(12.899, 200, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.72667)
    end),
    At(13.193, 201, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.10422)
    end),
    At(13.539, 202, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.37459)
    end),
    At(13.816, 203, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.63192)
    end),
    At(14.173, 204, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-2.85656)
    end),
    At(14.173, 205, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-2.85656, target=A.Boss})
    end),
    At(14.384, 206, function(d,s)
        C.Move(d,s,A.Helper09,{x=107.2775, y=0.0, z=123.8964},0.01453)
    end),
    At(14.46, 207, function(d,s)
        C.Move(d,s,A.Helper02,{x=80.031, y=0.0, z=88.491},-2.34171)
    end),
    At(14.46, 208, function(d,s)
        C.Move(d,s,A.Helper03,{x=78.8721, y=0.0, z=96.3077},-1.5563)
    end),
    At(14.46, 209, function(d,s)
        C.Move(d,s,A.Helper05,{x=121.0112, y=0.0, z=95.6931},1.58535)
    end),
    At(14.46, 210, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.4226, y=0.0, z=124.0985},0.01453)
    end),
    At(14.46, 211, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=107.2775, y=0.0, z=123.8964}, rotation=0.01453, dest={x=107.2557, y=-0.0153, z=123.888}})
    end),
    At(14.537, 212, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=80.031, y=0.0, z=88.491}, rotation=-2.34171, dest={x=80.0031, y=-0.0153, z=88.4871}})
    end),
    At(14.537, 213, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=78.8721, y=0.0, z=96.3077}, rotation=-1.5563, dest={x=78.8434, y=-0.0153, z=96.2997}})
    end),
    At(14.537, 214, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=121.0112, y=0.0, z=95.6931}, rotation=1.58535, dest={x=120.9888, y=-0.0153, z=95.6893}})
    end),
    At(14.537, 215, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=93.4226, y=0.0, z=124.0985}, rotation=0.01453, dest={x=93.4005, y=-0.0153, z=124.0711}})
    end),
    At(15.189, 216, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(15.189, 217, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(15.189, 218, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(15.189, 219, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(15.189, 220, function(d,s)
        C.Owner(d,s,A.Helper07,nil)
    end),
    At(15.189, 221, function(d,s)
        C.Owner(d,s,A.Helper07,A.Boss)
    end),
    At(15.224, 222, function(d,s)
        C.Action(d,s,A.Helper08,28064,{pos={x=92.7079, y=0.0, z=75.1037}, rotation=-3.12702})
    end),
    At(15.224, 223, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=115.1809, y=0.0, z=122.6302}, rotation=0.79994})
    end),
    At(15.224, 224, function(d,s)
        C.Action(d,s,A.Helper07,28065,{pos={x=100.0, y=0.0, z=100.0}, rotation=-3.12702})
    end),
    At(15.333, 225, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-3.13268)
    end),
    At(16.334, 226, function(d,s)
        C.Move(d,s,A.Helper09,{x=107.3796, y=0.0, z=130.8956},0.01453)
    end),
    At(16.334, 227, function(d,s)
        C.Move(d,s,A.Helper02,{x=75.0096, y=0.0, z=83.614},-2.34171)
    end),
    At(16.334, 228, function(d,s)
        C.Move(d,s,A.Helper03,{x=71.8729, y=0.0, z=96.4098},-1.5563)
    end),
    At(16.334, 229, function(d,s)
        C.Move(d,s,A.Helper05,{x=128.0105, y=0.0, z=95.591},1.58535)
    end),
    At(16.334, 230, function(d,s)
        C.Move(d,s,A.Helper06,{x=93.5246, y=0.0, z=131.0977},0.01453)
    end),
    At(16.334, 231, function(d,s)
        C.Action(d,s,A.Helper09,28061,{pos={x=107.3796, y=0.0, z=130.8956}, rotation=0.01453, dest={x=107.3777, y=-0.0153, z=130.8766}})
    end),
    At(16.402, 232, function(d,s)
        C.Action(d,s,A.Helper02,28061,{pos={x=75.0096, y=0.0, z=83.614}, rotation=-2.34171, dest={x=74.9981, y=-0.0153, z=83.6042}})
    end),
    At(16.402, 233, function(d,s)
        C.Action(d,s,A.Helper03,28061,{pos={x=71.8729, y=0.0, z=96.4098}, rotation=-1.5563, dest={x=71.8547, y=-0.0153, z=96.3912}})
    end),
    At(16.402, 234, function(d,s)
        C.Action(d,s,A.Helper05,28061,{pos={x=128.0105, y=0.0, z=95.591}, rotation=1.58535, dest={x=128.0079, y=-0.0153, z=95.5673}})
    end),
    At(16.402, 235, function(d,s)
        C.Action(d,s,A.Helper06,28061,{pos={x=93.5246, y=0.0, z=131.0977}, rotation=0.01453, dest={x=93.5225, y=-0.0153, z=131.0903}})
    end),
    At(18.239, 236, function(d,s)
        C.Action(d,s,A.Boss,28062,{pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-3.13248, target=A.Boss})
    end),
    At(19.246, 237, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(19.246, 238, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(19.246, 239, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(19.246, 240, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(19.246, 241, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(19.246, 242, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(19.315, 243, function(d,s)
        C.Action(d,s,A.Helper08,28065,{pos={x=92.7079, y=0.0, z=75.1037}, rotation=-3.12702})
    end),
    At(19.315, 244, function(d,s)
        C.Action(d,s,A.Helper09,28064,{pos={x=107.3796, y=0.0, z=130.8956}, rotation=0.01453})
    end),
    At(19.315, 245, function(d,s)
        C.Action(d,s,A.Helper10,28063,{pos={x=115.1809, y=0.0, z=122.6302}, rotation=0.79994})
    end),
    At(21.139, 246, function(d,s)
        C.Owner(d,s,A.Helper10,nil)
    end),
    At(21.139, 247, function(d,s)
        C.Owner(d,s,A.Helper10,A.Boss)
    end),
    At(21.139, 248, function(d,s)
        C.Move(d,s,A.Helper10,{x=100.073, y=0.0, z=107.9997},-5e-05)
    end),
    At(21.139, 249, function(d,s)
        C.Owner(d,s,A.Helper09,nil)
    end),
    At(21.139, 250, function(d,s)
        C.Owner(d,s,A.Helper09,A.Boss)
    end),
    At(21.139, 251, function(d,s)
        C.Move(d,s,A.Helper09,{x=106.8914, y=0.0, z=95.937},-5e-05)
    end),
    At(21.139, 252, function(d,s)
        C.Owner(d,s,A.Helper08,nil)
    end),
    At(21.139, 253, function(d,s)
        C.Owner(d,s,A.Helper08,A.Boss)
    end),
    At(21.139, 254, function(d,s)
        C.Move(d,s,A.Helper08,{x=93.0356, y=0.0, z=96.0633},-5e-05)
    end),
    At(21.139, 255, function(d,s)
        C.Model(d,s,A.Boss,4)
    end),
}
