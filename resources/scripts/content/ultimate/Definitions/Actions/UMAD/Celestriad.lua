local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/UMAD.lua")
local elements={[47939]=status.fire,[47940]=status.ice,[47941]=status.thunder}
local actions={}
for _,id in ipairs({47938,49743,49746}) do actions[id]={kind="visual"} end
for id,st in pairs(elements) do actions[id]={kind="circle",radius=3,damage=240000,split=true,status=st.id,status_duration=20,punish_status=st.id} end
for _,id in ipairs({47942,47943,47944}) do actions[id]={kind="raid",damage=100000,status=status.damage_down.id,status_duration=status.damage_down.duration} end
actions[47946]={kind="circle",radius=10,damage=9999999,unmitigated=true}
actions[47947]={kind="donut",inner=10,outer=40,damage=9999999,unmitigated=true}
return {actions=actions,resolve=function(d,s,e,p,U)
    if e.action==47938 then
        local list=U.shuffled(d)
        for i,st in ipairs({status.fire,status.ice,status.thunder}) do
            for j=1,2 do local id=list[(i-1)*2+j];if id then d:gain_effect(id,st.id,0,st.duration,U.boss(d,s)) end end
        end
    elseif elements[e.action] then
        local inside=U.players(d,p.pos,function(id)return U.distance(d:position(id),p.pos)<=9 end)
        if #inside==0 then
            -- 漏塔有全团伤害和伤害降低；不把它冒充为成功塔或直接跳过。
            d:raidwide({source=p.source,effect_source=p.effect_source,action=e.action+3,
                damage=100000,status=status.damage_down.id,status_duration=status.damage_down.duration})
            return true
        end
    end
end}
