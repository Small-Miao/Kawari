-- TOP：波动炮。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({31661,31662},{kind="circle",radius=8,damage=9999999,unmitigated=true})
r[31663]={kind="puddle",radius=6,damage=9999999,unmitigated=true}
r[31659]={kind="protean",length=100,width=8,damage=95000,status=2941,status_duration=2,punish_status=2941}
r[31658]={kind="wildcharge",length=100,width=8,damage=95000,min_players=8,front_tanks=2,front_damage=370000}
return {actions=r,prepare=function(d,s,e,U)
    if e.action==31657 then
        s.proteans=U.shuffled(d);s.protean_index=0
        s.charge_target=U.players(d,nil,function(id)return not U.tank(d,id)end)[1]
    end
end,resolve=function(d,s,e,p,U)
    local id
    if e.action==31659 then s.protean_index=(s.protean_index or 0)+1;id=(s.proteans or U.players(d))[s.protean_index]
    elseif e.action==31658 then id=s.charge_target
    else return end
    p.pos=d:position(U.boss(d,s));p.rotation=id and U.angle(p.pos,d:position(id)) or e.rotation;p.kind="rect"
end}
