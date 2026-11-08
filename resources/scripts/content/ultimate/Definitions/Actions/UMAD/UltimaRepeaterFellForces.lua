local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/UMAD.lua")
local actions={}
for _,id in ipairs({47936,50173,50770}) do actions[id]={kind="visual"} end
actions[49738]={kind="raid",damage=140000}
actions[47937]={kind="raid",damage=135000}
-- 三组魔击同刻结算，魔法易伤使重叠组致死。
actions[50771]={kind="circle",radius=3,damage=880000,split=true,status=2941,status_duration=1.5,punish_status=2941}
actions[50772]={kind="circle",radius=5,damage=220000,split=true,min_players=2,status=2941,status_duration=1.5,punish_status=2941}
actions[50773]={kind="circle",radius=5,damage=440000,split=true,min_players=4,status=2941,status_duration=1.5,punish_status=2941}
return {actions=actions,resolve=function(d,s,e,p,U)
    local selected
    if e.action==50771 then selected=U.hate(d,s)[1]
    elseif e.action==50772 then local list=U.players(d,nil,function(id)return U.healer(d,id)end);selected=list[math.random(math.max(1,#list))]
    elseif e.action==50773 then local list=U.players(d,nil,function(id)return not U.tank(d,id) and not U.healer(d,id)end);selected=list[math.random(math.max(1,#list))] end
    if e.action==50771 or e.action==50772 or e.action==50773 then return not U.select(d,p,selected) end
end}
