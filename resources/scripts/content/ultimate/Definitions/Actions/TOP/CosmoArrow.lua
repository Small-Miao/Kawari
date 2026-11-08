-- TOP：宇宙天箭。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
r[31651]={kind="rect",length=40,width=10,damage=9999999,unmitigated=true}
r[31652]={kind="rect",length=100,width=5,damage=9999999,unmitigated=true}
r[31655]={kind="dive_tank",radius=8,damage=270000,status=2941,status_duration=2,punish_status=2941}
r[31656]={kind="dive_stack",radius=6,min_players=6,split=true,damage=570000,status=2941,status_duration=2,punish_status=2941}
return {actions=r,resolve=function(d,s,e,p,U)
    local rule=r[e.action]
    if rule.kind=="dive_tank" then
        return not U.select(d,p,U.next_target(d,s,e.action,e.t,U.players(d,d:position(U.boss(d,s)))),"circle")
    elseif rule.kind=="dive_stack" then return not U.select(d,p,U.players(d,d:position(U.boss(d,s)))[3],"circle") end
end}
