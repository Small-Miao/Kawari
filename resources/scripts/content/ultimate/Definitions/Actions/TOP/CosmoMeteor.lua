-- TOP：宇宙陨石。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
r[31666]={kind="puddle",radius=10,damage=9999999,unmitigated=true}
r[32699]={kind="spread",radius=5,damage=110000,status=2941,status_duration=1.2,punish_status=2941}
r[31667]={kind="meteor_stack",radius=6,min_players=5,split=true,damage=450000}
r[31668]={kind="flare",radius=100,damage=350000,falloff=30}
r[31669]={kind="raid",damage=9999999,unmitigated=true}
return {actions=r,prepare=function(d,s,e,U)
    if e.action==31664 then s.spreads=U.shuffled(d);s.spread_index=0 end
end,before_event=function(d,s,e)
    if e.kind=="despawn" and s.adds[e.actor] then return false end
end,event=function(d,s,e)
    if e.kind=="spawn" and (e.data.role=="CosmoMeteor" or e.data.role=="CosmoComet") then s.adds[e.actor]=e.data.role end
end,actor_death=function(d,s,base,pos,id)
    -- 天体破坏动画只跟随真实死亡，不能按录像的击杀时间提前播放。
    for key,e in pairs(s.data.death_effects or {}) do
        if d:actor_id(key)==id then s.scene:MapEffect(d,e.index,e.state,e.timeline) end
    end
end,resolve=function(d,s,e,p,U)
    if e.action==31668 then return not U.select(d,p,U.next_target(d,s,e.action,e.t,s.flare_targets),"circle")
    elseif e.action==31667 then return not U.select(d,p,s.meteor_stack,"circle") end
end,Mark=function(d,s)
    local U=dofile(CONTENT_DIR.."/ultimate/mechanic_utils.lua")
    local players=U.shuffled(d);s.flare_targets={players[1],players[2],players[3]};s.meteor_stack=players[4]
    for _,id in ipairs(s.flare_targets) do d:set_target_icon(id,346) end
    for _,deadline in ipairs(s.rules.add_deadlines or {}) do
        d:schedule(deadline.delay,function(x)
            for key,role in pairs(s.adds) do
                local id=x:actor_id(key)
                if role==deadline.role and id and x:is_alive(id) then
                    x:raidwide({source=id,action=31669,damage=9999999,unmitigated=true});break
                end
            end
        end)
    end
end}
