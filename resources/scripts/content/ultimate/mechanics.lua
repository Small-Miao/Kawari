-- 通用机制分发与命中提交；技能、选人、Buff 和阶段行为在 Definitions/Actions。
local M={}
local U=dofile(CONTENT_DIR.."/ultimate/mechanic_utils.lua")
function M.before_event(d,s,e)
    for _,m in ipairs(s.rules.modules) do
        if m.before_event and m.before_event(d,s,e,U)==false then return false end
    end
    return true
end
function M.event(d,s,e,id)
    for _,m in ipairs(s.rules.modules) do if m.event then m.event(d,s,e,id,U) end end
end
function M.actor_death(d,s,base,pos,id)
    for _,m in ipairs(s.rules.modules) do if m.actor_death then m.actor_death(d,s,base,pos,id,U) end end
end
function M.spawn(d,s,key,spec)
    for _,m in ipairs(s.rules.modules) do if m.spawn then spec=m.spawn(d,s,key,spec,U) or spec end end
    return spec
end
function M.start(d,s)
    s.adds={};s.t=0
    d:set_limit_break(30000)
    for _,m in ipairs(s.rules.modules) do if m.start then m.start(d,s,U) end end
end
function M.engage(d,s)
    for _,m in ipairs(s.rules.modules) do if m.engage then m.engage(d,s,U) end end
end
function M.prepare(d,s,e)
    if e.actor==s.data.boss then
        s.boss_cast_until=e.t+e.seconds+0.5
        s.actor_motion:LockFacing(s.data.boss,s.boss_cast_until)
    end
    local rule=assert(s.rules.actions[e.action],"未分类技能 "..e.action)
    if e.action==s.rules.enrage_cast then s.enrage_at=e.t+s.rules.enrage_delay end
    local geometry
    for _,m in ipairs(s.rules.modules) do
        if m.prepare then geometry=m.prepare(d,s,e,U) or geometry end
    end
    if geometry then s.geometry[e.actor]=geometry;return geometry end
    local p={pos=e.pos,rotation=e.rotation}
    if e.actor==s.data.boss and s.phase=="battle" then
        local b=U.boss(d,s);local target=U.hate(d,s)[1]
        p.pos=d:position(b);p.rotation=target and U.angle(p.pos,d:position(target)) or d:rotation(b)
    end
    if rule.kind=="puddle" then
        local target=U.next_target(d,s,e.action,e.t)
        if target then p.pos=d:position(target);p.cast_pos=p.pos;s.geometry[e.actor]=p end
    end
    return p
end
function M.resolve(d,s,e,source,target)
    local rule=assert(s.rules.actions[e.action],"未分类技能 "..e.action)
    local p=U.copy(rule);p.source=source;p.action=e.action;p.delay=0
    local boss=U.boss(d,s);local bp=boss and d:position(boss) or U.center
    if boss then p.source=boss;p.effect_source=source end
    local geometry=s.geometry[e.actor]
    p.pos=geometry and geometry.pos or e.pos;p.rotation=geometry and geometry.rotation or e.rotation
    if source==boss and s.phase=="battle" then p.rotation=d:rotation(boss) end
    p.target=target
    for _,m in ipairs(s.rules.modules) do if m.before_resolve then m.before_resolve(d,s,e,p,U) end end
    for _,m in ipairs(s.rules.modules) do
        if m.actions[e.action] and m.resolve and m.resolve(d,s,e,p,U) then return end
    end
    local kind=p.kind;p.kind=nil
    if kind=="ignore" then return end
    if kind=="visual" then
        p.radius=0;p.targets={};p.damage=0;p.pos=e.dest or p.pos
        d:aoe_circle(p);return
    end
    local selected
    if kind=="tank_auto" then
        selected=U.next_target(d,s,e.action,e.t,U.hate(d,s));p.radius=0;p.physical=true;kind="single"
    elseif kind=="distance_target" then
        local list=U.players(d,bp);selected=rule.farthest and list[#list] or list[1];kind="circle"
    elseif kind=="puddle" then kind="circle"
    elseif kind=="spread" then
        selected=U.next_target(d,s,e.action,e.t,s.spreads or U.players(d));kind="circle"
    end
    if selected then
        if not U.select(d,p,selected) then return end
        if kind=="single" then p.targets={selected};kind="raid" end
    elseif kind=="single" then
        if not p.target then return end
        p.targets={p.target};kind="raid"
    end
    if source~=boss then d:move_actor(source,p.pos,p.rotation) end
    if kind=="circle" then d:aoe_circle(p)
    elseif kind=="donut" then d:aoe_donut(p)
    elseif kind=="rect" then d:aoe_rect(p)
    elseif kind=="cone" then d:aoe_cone(p)
    elseif kind=="raid" then d:raidwide(p)
    else error("未知判定类型 "..tostring(kind)) end
end
function M.tick(d,s,t)
    s.t=t
    for _,m in ipairs(s.rules.modules) do if m.tick then m.tick(d,s,t,U) end end
    local boss=U.boss(d,s)
    if s.enrage_at and t>=s.enrage_at and boss then
        s.enrage_at=nil;U.fail(d,s,U.players(d))
    end
    if s.phase=="battle" and boss then
        if not s.facing_started then s.actor_motion:FaceEnmity(d,s.data.boss);s.facing_started=true end
        local outside={}
        for _,id in ipairs(U.players(d)) do
            local p=d:position(id);local fail=U.distance(p,U.center)>s.rules.arena_radius^2
            if s.rules.arena_square then
                local a=s.rules.arena_rotation or 0;local x,z=p.x-U.center.x,p.z-U.center.z
                fail=math.abs(x*math.cos(a)-z*math.sin(a))>s.rules.arena_square or math.abs(x*math.sin(a)+z*math.cos(a))>s.rules.arena_square
            end
            if fail then outside[#outside+1]=id end
        end
        U.fail(d,s,outside)
    end
end
return M
