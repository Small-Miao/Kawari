-- FRU：光暗之翼。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
r[40320]={kind="circle",radius=3,min_players=2,max_players=2,tanks=0,damage=90000}
r[40321]={kind="raid",damage=9999999,unmitigated=true}
r[40314]={kind="wing",offset=math.pi/3,radius=100,angle=240,damage=280000,status=2941,status_duration=7,punish_status=2941}
r[40315]={kind="wing",offset=-math.pi/3,radius=100,angle=240,damage=280000,status=2941,status_duration=7,punish_status=2941}
r[39879]={kind="distance_target",farthest=true,radius=4,damage=260000,status=2941,status_duration=4,punish_status=2941}
r[39880]={kind="distance_target",radius=4,damage=260000,status=2941,status_duration=4,punish_status=2941}
return {actions=r,prepare=function(d,s,e,U)
    if e.action==40313 or e.action==40233 then s.wing_target=U.hate(d,s)[1];s.wing_hit=0 end
end,resolve=function(d,s,e,p,U)
    local rule=r[e.action]
    if rule.kind=="wing" then
        local id=s.wing_hit==0 and s.wing_target or U.hate(d,s)[1]
        s.wing_hit=(s.wing_hit or 0)+1;p.pos=d:position(U.boss(d,s))
        p.rotation=id and U.angle(p.pos,d:position(id))+rule.offset or e.rotation;p.kind="cone"
    end
end}
