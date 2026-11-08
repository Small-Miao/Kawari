-- FRU：光暗分摊。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
r[40311]={kind="side_stack",side=1,radius=4,min_players=4,split=true,damage=480000}
r[40312]={kind="side_stack",side=-1,radius=4,min_players=4,split=true,damage=480000}
r[40317]={kind="polarizing",side=1,length=100,width=6,damage=450000,split=true,min_players=4,first_status=4164,first_status_duration=16,status=2941,status_duration=1,punish_status=4164}
r[40318]={kind="polarizing",side=-1,length=100,width=6,damage=450000,split=true,min_players=4,first_status=3323,first_status_duration=16,status=2941,status_duration=1,punish_status=3323}
r[40119]={kind="afterglow",side=1,length=100,width=6,damage=9999999,unmitigated=true}
r[40120]={kind="afterglow",side=-1,length=100,width=6,damage=9999999,unmitigated=true}
return {actions=r,start=function(d,s) s.afterglow={} end,
prepare=function(d,s,e,U)
    local rule=r[e.action]
    if rule and rule.kind=="polarizing" then
        local id=U.side_target(d,s,rule.side)
        if id then
            local p=d:position(U.boss(d,s))
            return {pos=p,rotation=U.angle(p,d:position(id)),target=id,cast_pos=d:position(id)}
        end
    end
end,resolve=function(d,s,e,p,U)
    local rule=r[e.action]
    if rule.kind=="side_stack" then return not U.select(d,p,U.side_target(d,s,rule.side),"circle")
    elseif rule.kind=="polarizing" then
        local g=s.geometry[e.actor];local id=g and g.target or U.side_target(d,s,rule.side)
        p.pos=d:position(U.boss(d,s));p.rotation=g and g.rotation or (id and U.angle(p.pos,d:position(id)) or e.rotation)
        if id and (d:has_effect(id,4164) or d:has_effect(id,3323)) then p.damage=9999999;p.unmitigated=true end
        s.afterglow[rule.side]={pos=p.pos,rotation=p.rotation};p.kind="rect"
    elseif rule.kind=="afterglow" then
        local g=s.afterglow[rule.side];if g then p.pos=g.pos;p.rotation=g.rotation end;p.kind="rect"
    end
end}
