-- 无尽顿悟剑 [28206]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/r1fz.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 1049, function(d,s)
        C.Cast(d,s,A.Boss,28206,9.7,{spell=28206, omen_delay=0, cast_pos={x=99.9924, y=-0.0153, z=99.9924}, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=-1.59004, target=A.Boss})
    end),
    At(0.0, 1050, function(d,s)
        C.Cast(d,s,A.Helper08,29456,10.4,{spell=29456, omen_delay=20, cast_pos={x=95.8419, y=-0.0153, z=106.8284}, pos={x=95.8676, y=0.0, z=106.8501}, rotation=-5e-05, target=A.Helper08})
    end),
    At(0.0, 1051, function(d,s)
        C.Cast(d,s,A.Helper09,29455,10.4,{spell=29455, omen_delay=10, cast_pos={x=96.1166, y=-0.0153, z=92.9732}, pos={x=96.1338, y=0.0, z=92.9962}, rotation=-5e-05, target=A.Helper09})
    end),
    At(0.0, 1052, function(d,s)
        C.Cast(d,s,A.Helper10,29457,10.4,{spell=29457, omen_delay=30, cast_pos={x=107.9881, y=-0.0153, z=100.145}, pos={x=107.9985, y=0.0, z=100.1537}, rotation=-5e-05, target=A.Helper10})
    end),
    At(0.0, 1053, function(d,s)
        C.Move(d,s,A.Boss,{x=99.9924, y=-0.0153, z=99.9924},-1.59004)
    end),
}
