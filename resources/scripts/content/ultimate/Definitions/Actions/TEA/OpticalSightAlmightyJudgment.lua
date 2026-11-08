-- 光学瞄准的当前玩家分散/分摊，以及按录像顺序爆炸的大审判地面图案。
local actions={}
for _,id in ipairs({18570,18571,18861,18862,18574,18575}) do actions[id]={kind="visual"} end
actions[18572]={kind="circle",radius=6,damage=100000}
actions[18573]={kind="circle",radius=6,damage=240000,split=true,min_players=4,max_players=4}
actions[18576]={kind="circle",radius=6,damage=9999999,unmitigated=true}
actions[18580]={kind="circle",radius=6,damage=560000,split=true,min_players=8}
local M={actions=actions}
local function mark(d,s,stack,U,beta)
    local list=U.shuffled(d)
    if stack and beta then
        list={}
        for _,color in ipairs({132,133}) do local id=(s.calibration.beacons or {})[color];if id then list[#list+1]=id end end
    elseif stack then list={list[1],list[2]} end
    s.optical={targets=list,index=0}
    for _,id in ipairs(list) do d:set_target_icon(id,stack and 62 or 139) end
end
function M.prepare(d,s,e,U)
    if e.action==18580 then
        s.grace_target=U.shuffled(d)[1]
        if s.grace_target then d:set_target_icon(s.grace_target,62) end
    end
end
function M.resolve(d,s,e,p,U)
    if e.action==18570 or e.action==18571 or e.action==18861 or e.action==18862 then
        mark(d,s,e.action==18571 or e.action==18862,U,e.action==18862)
    elseif e.action==18572 or e.action==18573 then
        local optical=s.optical or {targets=U.players(d),index=0};s.optical=optical;optical.index=optical.index+1
        return not U.select(d,p,optical.targets[optical.index])
    elseif e.action==18580 then return not U.select(d,p,s.grace_target) end
end
return M
