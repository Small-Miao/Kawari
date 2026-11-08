local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/UMAD.lua")
local actions={}
for _,id in ipairs({47952,47953}) do actions[id]={kind="visual"} end
actions[47954]={kind="circle",radius=5,damage=500000,status=2941,status_duration=2,punish_status=2941}
actions[47955]={kind="circle",radius=5,damage=900000,split=true,min_players=2,status=2941,status_duration=2,punish_status=2941}
actions[47956]={kind="circle",radius=5,damage=130000,status=2941,status_duration=4,punish_status=2941}
actions[47957]={kind="circle",radius=25,damage=9999999,unmitigated=true}
actions[47958]={kind="circle",radius=6,damage=1280000,split=true,min_players=4,status=2941,status_duration=2,punish_status=2941}
return {actions=actions,prepare=function(d,s,e,U)
    if e.action==47952 then s.orchestra={holy=0,flare=0} end
end,resolve=function(d,s,e,p,U)
    local a=e.action;local o=s.orchestra or {};s.orchestra=o
    -- 第一组圣光与核爆在同一帧，包的到达顺序不能改变随机选人。
    if (a==47954 or a==47956) and not o.tanks then
        o.tanks=U.hate(d,s);o.non_tanks={}
        for _,id in ipairs(U.shuffled(d)) do
            if id~=o.tanks[1] and id~=o.tanks[2] then o.non_tanks[#o.non_tanks+1]=id end
        end
    end
    local id
    if a==47954 then
        o.flare=(o.flare or 0)+1;id=o.tanks[o.flare]
        if o.flare==1 then
            for i,st in ipairs({status.surprise_flare,status.surprise_holy}) do
                if o.tanks[i] then d:gain_effect(o.tanks[i],st.id,0,st.duration,U.boss(d,s)) end
            end
        end
    elseif a==47956 then
        o.holy=(o.holy or 0)+1
        if o.holy<=3 then id=o.non_tanks[o.holy]
        else
            if o.holy==4 then o.nearest=U.players(d,d:position(U.boss(d,s))) end
            id=(o.nearest or {})[o.holy-3]
        end
    elseif a==47955 then id=U.hate(d,s)[1]
    elseif a==47957 then id=(o.tanks or {})[1];if id then d:remove_effect(id,status.surprise_flare.id) end
    elseif a==47958 then id=(o.tanks or {})[2];if id then d:remove_effect(id,status.surprise_holy.id) end end
    if a==47954 or a==47955 or a==47956 or a==47957 or a==47958 then
        if not id then return true end
        p.target=id;p.pos=d:position(id)
        -- 扩散中心是强攻击，周围是致死范围；中心坦克仍可按原生无敌承受。
        if a==47957 then p.damage=500000;p.unmitigated=false
            local bystanders=U.players(d,p.pos,function(v)return v~=id and U.distance(d:position(v),p.pos)<25^2 end)
            if #bystanders>0 then d:raidwide({source=p.source,targets=bystanders,action=0,damage=9999999,unmitigated=true}) end
            p.targets={id}
        end
    end
end}
