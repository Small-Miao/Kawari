-- TOP：转场与狂暴。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({31555,31623,31747,31650,32337,31654,31660,31657,31664,31665},{kind="visual"})
r[32626]={kind="raid",damage=60000}
r[31649]={kind="raid",damage=400000,requires_lb=true}
r[32223]={kind="flash_gale",radius=5,damage=80000}
r[31670]={kind="raid",damage=400000,requires_lb=true,status=3532,status_duration=6}
r[31648]={kind="raid",damage=9999999,unmitigated=true}
return {actions=r,engage=function(d,s,U)
    for _,id in ipairs(U.players(d)) do d:gain_effect(id,3444,3,0) end
end,before_resolve=function(d,s,e,p)
    p.requires_dynamis=e.action~=31649 and e.action~=32626 and e.action~=31670
end,resolve=function(d,s,e,p,U)
    if e.action==32223 then
        local far=U.players(d,d:position(U.boss(d,s)))
        return not U.select(d,p,U.next_target(d,s,e.action,e.t,{U.hate(d,s)[1],far[#far]}),"circle")
    elseif e.action==31649 then
        d:schedule(0.2,function(x)
            for _,id in ipairs(x:alive_players()) do x:remove_effect(id,3444);x:gain_effect(id,3446,0,0) end
            x:set_limit_break(30000)
        end)
    end
end}
