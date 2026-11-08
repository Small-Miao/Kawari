local S=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/TEA.lua")
local March=dofile(CONTENT_DIR.."/ultimate/Definitions/Actions/TEA/ForcedMarch.lua")
local actions={}
for _,id in ipairs({18557,18558,18559,18859,18860}) do actions[id]={kind="visual"} end
-- 录像的成功/失败名单不决定当前玩家的结果。
for _,id in ipairs({19039,19040,18560,18561,18562,18563}) do actions[id]={kind="ignore"} end
return {actions=actions,start=function(d,s) s.motion={} end,tick=function(d,s,t,U)
    for _,id in ipairs(U.players(d)) do
        local p=d:position(id);local count=d:get_player_var(id,"__action_count") or 0;local m=s.motion[id]
        if not m then m={pos=p,count=count,last=-100};s.motion[id]=m end
        if U.distance(p,m.pos)>0.0001 or count~=m.count then m.last=t end
        m.pos=p;m.count=count
    end
    March.tick(d,s,t)
end,resolve=function(d,s,e,p,U)
    if e.action==18557 then
        local players=U.shuffled(d);local role_names={"light_beacon","dark_beacon","light_follow","dark_follow","light_follow","dark_follow","light_follow","dark_follow"}
        local roles={}
        for i,id in ipairs(players) do local role=role_names[i];if role then roles[id]=role;d:gain_effect(id,S.final_word[role],0,10,U.boss(d,s)) end end
        d:schedule(9.95,function(x) March.begin(x,s,roles,U) end)
    elseif e.action==18558 or e.action==18559 or e.action==18859 or e.action==18860 then
        local required=e.action==18558 or e.action==18859
        local failed={}
        for _,id in ipairs(U.players(d)) do
            local m=s.motion[id];local moving=m and s.t-m.last<0.75 or false
            if moving~=required then failed[#failed+1]=id end
        end
        if #failed>0 then d:raidwide({source=U.boss(d,s),targets=failed,action=required and 18560 or 18561,damage=9999999,unmitigated=true}) end
    end
end}
