-- 供机制脚本显式调用的演员接口；实时选人、命中与生命周期钩子统一从这里进入。
local Mechanics=dofile(CONTENT_DIR.."/ultimate/mechanics.lua")
local C={}
local function id(d,key) return key and d:actor_id(key) end
local function event(s,kind,key,options)
    local e={} for k,v in pairs(options or {}) do e[k]=v end
    e.kind=kind;e.actor=key;e.t=s.event_time or s.t or 0
    return e
end
function C.Spawn(d,s,key,notify)
    local spec=assert(s.data.templates[key],"演员模板不存在："..key)
    spec=Mechanics.spawn(d,s,key,spec)
    local actor=id(d,key)
    if actor then d:move_actor(actor,spec.pos,spec.rotation);d:set_model_state(actor,spec.model_state or 0)
    else
        actor=d:spawn_actor(key,spec)
        if spec.animation_state and spec.animation_state~=0 then d:set_animation_state(actor,0,spec.animation_state) end
    end
    if notify~=false and spec.owner then d:set_actor_owner(actor,id(d,spec.owner)) end
    if notify~=false then Mechanics.event(d,s,event(s,"spawn",key,{data=spec}),actor) end
    return actor
end
function C.Despawn(d,s,key)
    local e=event(s,"despawn",key)
    if not Mechanics.before_event(d,s,e) then return end
    if key~=s.data.boss then d:despawn_registered(key) end
    Mechanics.event(d,s,e,id(d,key))
end
function C.Move(d,s,key,pos,rotation)
    local e=event(s,"move",key,{pos=pos,rotation=rotation})
    if not Mechanics.before_event(d,s,e) then return end
    local actor=id(d,key)
    if actor and not s.geometry[key] and not (key==s.data.boss and s.phase=="battle") then d:move_actor(actor,pos,rotation) end
end
function C.Cast(d,s,key,action,seconds,options)
    local actor=id(d,key);if not actor then return end
    local e=event(s,"cast",key,options);e.action=action;e.seconds=seconds
    local p=Mechanics.prepare(d,s,e)
    d:move_actor(actor,p.pos or e.pos,p.rotation or e.rotation)
    d:begin_cast(actor,action,seconds,p.target or id(d,e.target) or actor,e.omen_delay or 0,p.cast_pos or e.cast_pos,e.spell)
end
function C.Action(d,s,key,action,options)
    local actor=id(d,key);if not actor then return end
    local e=event(s,"action",key,options);e.action=action
    d:end_cast(actor,action)
    Mechanics.resolve(d,s,e,actor,id(d,e.target));s.geometry[key]=nil
end
function C.Target(d,s,key,target)
    local actor,to=id(d,key),id(d,target)
    if actor and to then d:set_target(actor,to) end
end
function C.Owner(d,s,key,target)
    local actor=id(d,key);if actor then d:set_actor_owner(actor,id(d,target)) end
end
function C.Tether(d,s,key,target,tether,slot)
    local actor,to=id(d,key),id(d,target)
    if actor and to then d:tether(actor,to,tether,slot) end
    Mechanics.event(d,s,event(s,"tether",key,{target=target,id=tether,slot=slot}),actor)
end
function C.Untether(d,s,key,tether,slot)
    local actor=id(d,key);if actor then d:tether_cancel(actor,tether,slot) end
end
function C.Status(d,s,key,statuses)
    local actor=id(d,key)
    if actor then for _,status in ipairs(statuses) do d:gain_effect(actor,status.id,status.param,status.duration,actor) end end
    Mechanics.event(d,s,event(s,"status",key,{data=statuses}),actor)
end
function C.Targetable(d,s,key,enabled)
    local actor=id(d,key)
    if actor and key==s.data.boss then
        d:set_targetable(actor,enabled)
        if enabled and s.phase=="transition" then s.phase="battle";Mechanics.engage(d,s) end
    end
end
function C.Animation(d,s,key,a,b) local actor=id(d,key);if actor then d:set_animation_state(actor,a,b) end end
function C.Model(d,s,key,state) local actor=id(d,key);if actor then d:set_model_state(actor,state) end end
function C.Timeline(d,s,key,timeline) local actor=id(d,key);if actor then d:play_timeline(actor,timeline) end end
function C.Visible(d,s,key,visible,fade) local actor=id(d,key);if actor then d:set_visible(actor,visible,fade) end end
function C.Hide(d,s,key) local actor=id(d,key);if actor then d:hide_actor(actor) end end
function C.Presentation(d,s,key,operation,parameter,duration)
    local actor=id(d,key);if actor then d:actor_presentation(actor,operation,parameter,duration) end
end
function C.SynchronizedTimelines(d,s,entries)
    local actors={}
    for _,entry in ipairs(entries) do actors[#actors+1]={assert(id(d,entry[1]),"同步演出演员不存在："..entry[1]),entry[2]} end
    d:play_actor_timelines(actors)
end
return C
