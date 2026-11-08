-- 投影复制当前实例玩家外观；录像别名随机映射到当前玩家，预演不伤害玩家。
local M={actions={[18581]={kind="visual"},[18555]={kind="visual"},[19219]={kind="visual"}}}
function M.prepare(d,s,e,U)
    if e.action==18555 or e.action==19219 then
        for _,id in ipairs(U.players(d)) do d:tether_cancel(id,98,0) end
        s.projection={phase=e.action==18555 and "alpha" or "beta",players=U.shuffled(d),owners={},order={}}
        s.calibration={assault={},colors={},near={},far={},beacons={},jumps={}}
    end
end
function M.spawn(d,s,key,spec,U)
    if spec.base~=11350 then return end
    local p=assert(s.projection,"未来观测尚未开始")
    if not p.order[key] then
        p.count=(p.count or 0)+1;p.order[key]=p.count;p.owners[key]=p.players[p.count]
    end
    local result=U.copy(spec)
    result.appearance_from=p.owners[key] or p.players[1]
    result.visible=true;result.targetable=false;result.boss=false
    return result
end
function M.event(d,s,e,id,U)
    local p=s.projection
    if not p then return end
    if e.kind=="spawn" and e.data.base==11350 and p.owners[e.actor] then
        d:tether(p.owners[e.actor],id,98,0)
    elseif e.kind=="despawn" and p.owners[e.actor] then d:tether_cancel(p.owners[e.actor],98,0) end
end
return M
