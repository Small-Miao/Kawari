-- 遗弃末点 [47930]：演员 / 读条 / 技能 / 状态。
-- At 为本节点开始后的秒数；Order 保留同一时刻的先后关系。
local At=dofile(CONTENT_DIR.."/ultimate/commands.lua").At
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actors/z3oy.lua").names
local C=dofile(CONTENT_DIR.."/ultimate/control.lua")
return {
    At(0.0, 614, function(d,s)
        C.Cast(d,s,A.Boss,47930,25.7,{spell=47930, omen_delay=0, cast_pos={x=95.7809, y=0.0458, z=100.206}, pos={x=95.7809, y=0.0458, z=100.206}, rotation=-1.21565, target=A.Boss})
    end),
}
