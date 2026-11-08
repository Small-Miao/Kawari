-- α：先在投影展示分配，再以当前玩家位置结算；十字圣礼保留投影演员朝向。
local actions={}
for _,id in ipairs({18556,18584,19213,19214,18596,18597,18598,18858,18585,18586,18591}) do actions[id]={kind="visual"} end
actions[18528]={kind="circle",radius=30,damage=140000}
actions[18530]={kind="circle",radius=4,damage=240000,split=true,min_players=3}
actions[18529]={kind="single",damage=10000}
actions[18569]={kind="visual"}
local M={actions=actions}
function M.resolve(d,s,e,p,U)
    local c=s.calibration;local projection=s.projection
    if not c or not projection then return end
    local owner=projection.owners[e.target]
    if e.action==18596 then
        local closest,dist
        for key,player in pairs(projection.owners) do
            local id=d:actor_id(key)
            if id then local n=U.distance(d:position(id),e.pos);if not dist or n<dist then closest=player;dist=n end end
        end
        c.defamation=closest
    elseif e.action==18598 then
        c.shared=owner
        if owner then d:projection_death(d:actor_id(e.target)) end
    elseif e.action==18597 then
        if owner then c.assault[#c.assault+1]=owner;d:projection_death(d:actor_id(e.target)) end
    elseif e.action==18585 or e.action==18586 then
        if e.target and d:actor_id(e.target) then d:projection_death(d:actor_id(e.target)) end
    elseif e.action==18528 then return not U.select(d,p,c.defamation)
    elseif e.action==18530 then
        if not U.select(d,p,c.shared) then return true end
        if projection.phase=="alpha" then
            local failed={}
            for _,id in ipairs(c.assault) do
                if d:is_alive(id) and U.distance(d:position(id),p.pos)<=16 then failed[#failed+1]=id end
            end
            U.fail(d,s,failed)
        end
    elseif e.action==18529 then
        c.assault_index=(c.assault_index or 0)+1
        return not U.select(d,p,c.assault[c.assault_index])
    elseif e.action==18569 then
        local source=d:actor_id(e.actor);local center=d:position(source);local rotation=d:rotation(source)
        d:play_action_targeted(source,e.action,source)
        -- 两条贯穿演员原点的矩形；只播放一次原生十字动作。
        for _,r in ipairs({rotation,rotation+math.pi/2}) do
            d:aoe_rect({source=U.boss(d,s),action=0,pos={x=center.x-100*math.sin(r),y=center.y,z=center.z-100*math.cos(r)},
                rotation=r,length=200,width=16,damage=9999999,unmitigated=true})
        end
        return true
    end
end
return M
