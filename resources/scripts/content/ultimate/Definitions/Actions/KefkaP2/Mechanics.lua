-- 凯夫卡 P2 一运：原模拟器机制迁入原生 Lua；动作和目标按录像区分本体/分身。
local S=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/KefkaP2.lua")
local M={}
local C={x=100,y=0,z=100}
local function dist(a,b) return (a.x-b.x)^2+(a.z-b.z)^2 end
local function angle(a,b) return math.atan(b.x-a.x,b.z-a.z) end
local function actor(d,key) return assert(d:actor_id(key),"缺少演员 "..key) end
local function players(d,p)
    local list=d:alive_players()
    table.sort(list,function(a,b)
        local x,y=p and dist(d:position(a),p) or 0,p and dist(d:position(b),p) or 0
        return x==y and a<b or x<y
    end)
    return list
end
local function shuffle(list) for i=#list,2,-1 do local j=math.random(i);list[i],list[j]=list[j],list[i] end;return list end
local function inside(d,p,r) local list={} for _,id in ipairs(players(d,p)) do if dist(d:position(id),p)<=r*r then list[#list+1]=id end end return list end
local function wipe(d,ids) d:raidwide({source=actor(d,"boss"),targets=ids,action=0,damage=9999999,unmitigated=true}) end
local function effect(d,s,action,p,rotation,target)
    s.effect_index=s.effect_index+1;local key="p2-effect-"..s.effect_index
    local id=d:spawn_actor(key,{base=9020,name=7131,hp=1,level=100,model=480,pos=p,rotation=rotation or 0,targetable=false})
    d:aoe_circle({source=actor(d,"boss"),effect_source=id,action=action,pos=p,rotation=rotation or 0,
        target=target or id,radius=0,targets={},damage=0,delay=0})
    d:schedule(8,function(x) x:despawn_registered(key) end)
end
local function hurt(d,s,list)
    for _,id in ipairs(list) do
        if (s.vulnerable[id] or 0)>s.time or d:has_effect(id,S.magic_vulnerability) then wipe(d,{id})
        else
            s.vulnerable[id]=s.time+3
            d:gain_effect(id,S.magic_vulnerability,0,3,actor(d,"boss"))
            d:raidwide({source=actor(d,"boss"),targets={id},action=0,damage=100000,delay=0})
        end
    end
end
local function assign(d,s,id,kind)
    if not kind or s.pool[kind]<=0 then
        for _,candidate in ipairs({"stack","circle","cone"}) do if s.pool[candidate]>0 then kind=candidate;break end end
    end
    if kind and s.pool[kind]>0 then s.pool[kind]=s.pool[kind]-1;s.markers[id]=kind;d:set_target_icon(id,S.marker[kind]) end
end
function M.Setup(d,s)
    s.pool={stack=8,circle=12,cone=12};s.markers={};s.stacks={};s.vulnerable={};s.effect_index=0
    s.begin_tower=math.random(0,7);s.direction=math.random(2)==1 and 1 or -1
    d:spawn_actor("boss",{base=19506,layout=12326696,name=7131,model=4967,hp=44109275,level=100,pos=C,rotation=0,boss=true,targetable=false})
    d:set_ai_enabled(actor(d,"boss"),false)
    for i=1,3 do
        local key="clone"..i
        d:spawn_actor(key,{base=19513,layout=12326703,name=7131,model=2137,hp=188300,level=100,pos=C,rotation=0,targetable=false,visible=false})
        d:set_ai_enabled(actor(d,key),false)
    end
end
function M.Forsaken(d,s)
    s.scene:Apply(d,"battle")
    local boss=actor(d,"boss");s.actor_motion:LockFacing("boss",s.time+7)
    d:begin_cast(boss,47804,6.7,boss,0,C)
    d:schedule(7,function(x)
        x:end_cast(boss,47804);x:play_action_targeted(boss,47804,boss)
        s.scene:MapEffect(x,17,1,2)
        for _,id in ipairs(players(x)) do s.stacks[id]=4;x:gain_effect(id,S.casting_crisis,4,0,boss) end
    end)
end
function M.Markers(d,s)
    local all=shuffle(players(d));local support,dps={},{}
    for _,id in ipairs(all) do local job=d:job(id);local st=job==19 or job==21 or job==32 or job==37 or job==24 or job==28 or job==33 or job==40
        local list=st and support or dps;list[#list+1]=id
    end
    local used={}
    for _,list in ipairs({support,dps}) do
        local selected;for _,id in ipairs(list) do if not used[id] then selected=id;break end end
        if not selected then for _,id in ipairs(all) do if not used[id] then selected=id;break end end end
        if selected then used[selected]=true;assign(d,s,selected,"stack") end
    end
    local circle_group=math.random(2)==1 and support or dps;local order={}
    for _,id in ipairs(circle_group) do if not used[id] then order[#order+1]=id;used[id]=true end end
    for _,id in ipairs(all) do if not used[id] then order[#order+1]=id;used[id]=true end end
    for i,id in ipairs(order) do assign(d,s,id,i<=3 and "circle" or "cone") end
end
local function consume(d,s,id)
    local kind=s.markers[id];s.markers[id]=nil;s.stacks[id]=math.max(0,(s.stacks[id] or 0)-1)
    if s.stacks[id]>0 then d:gain_effect(id,S.casting_crisis,s.stacks[id],0,actor(d,"boss")) else d:remove_effect(id,S.casting_crisis) end
    local p=d:position(id)
    if kind=="stack" then
        effect(d,s,47808,p,0,id);local hit=inside(d,p,5)
        if #hit~=3 then wipe(d,players(d)) end;hurt(d,s,hit)
    elseif kind=="circle" then effect(d,s,47809,p,0,id);hurt(d,s,inside(d,p,5))
    elseif kind=="cone" then
        local nearest;for _,other in ipairs(players(d,p)) do if other~=id then nearest=other;break end end
        if nearest then
            local r=angle(p,d:position(nearest));effect(d,s,47810,p,r)
            local hit={};for _,other in ipairs(players(d)) do if other~=id then
                local q=d:position(other);local diff=math.atan(math.sin(angle(p,q)-r),math.cos(angle(p,q)-r))
                if dist(p,q)<=10000 and math.abs(diff)<=math.pi/4 then hit[#hit+1]=other end
            end end;hurt(d,s,hit)
        end
    end
end
function M.Towers(d,s,round)
    local indexes={(s.begin_tower+s.direction*round)%8,(s.begin_tower+s.direction*round+2)%8}
    local positions={}
    for _,i in ipairs(indexes) do
        local r=i*math.pi/4;local p={x=100+8*math.sin(r),y=0,z=100+8*math.cos(r)};positions[#positions+1]=p
        local map=((math.floor(math.atan(p.x-100,100-p.z)/(math.pi/4)+0.5)+8)%8)+1
        s.scene:MapEffect(d,map,1,2)
        d:schedule(3,function(x) s.scene:MapEffect(x,map,4,8) end)
    end
    d:schedule(10,function(x)
        local soaked,seen={},{}
        for _,p in ipairs(positions) do
            local hit=shuffle(inside(x,p,4));while #hit>2 do table.remove(hit) end
            effect(x,s,#hit==2 and 47806 or 47807,p,0)
            if #hit~=2 then wipe(x,players(x)) end
            for _,id in ipairs(hit) do if not seen[id] then seen[id]=true;soaked[#soaked+1]=id end end
        end
        -- 塔结算与魔法发动是两次独立表现，录像间隔约 0.67 秒。
        x:schedule(0.67,function(y)
            for _,id in ipairs(soaked) do if y:is_alive(id) then consume(y,s,id) end end
            if round<=5 then
                local requested=round%2==0 and {"circle","circle","cone","cone"} or {"stack","stack","circle","cone"}
                for i,id in ipairs(shuffle(soaked)) do if y:is_alive(id) then assign(y,s,id,requested[i]) end end
            end
        end)
    end)
end
function M.EndOfWorld(d,s)
    s.future=math.random(2)==1
    local action=s.future and 47826 or 47827;local boss=actor(d,"boss")
    s.actor_motion:LockFacing("boss",s.time+6.7)
    d:begin_cast(boss,action,6.1,boss,0,d:position(boss))
    d:schedule(6.4,function(x) x:end_cast(boss,action);x:play_action_targeted(boss,action,boss) end)
end
function M.Jump(d,s)
    local list=players(d,d:position(actor(d,"boss")))
    for i,key in ipairs({"boss","clone1","clone2","clone3"}) do
        local target=list[i]
        if target then
            local source=actor(d,key);local p=d:position(source);local to=d:position(target);local r=angle(p,to)
            local action=key=="boss" and (s.future and 47830 or 47831) or (s.future and 47832 or 47833)
            s.actor_motion:LockFacing(key,s.time+1);d:set_visible(source,true);d:slide_actor(source,p,r)
            d:play_action_targeted(source,action,target)
            d:schedule(0.5,function(x)
                local length=math.sqrt(dist(p,to));local destination=p
                if length>5 then destination={x=to.x-(to.x-p.x)/length*5,y=to.y,z=to.z-(to.z-p.z)/length*5} end
                x:slide_actor(source,destination,r);hurt(x,s,inside(x,to,5))
            end)
        end
    end
end
function M.Feet(d,s)
    local rear=not s.future;local action=rear and 47837 or 47836
    for _,key in ipairs({"boss","clone1","clone2","clone3"}) do
        local source=actor(d,key);local p=d:position(source);local nearest=players(d,p)[1]
        if nearest then
            local r=angle(p,d:position(nearest));s.actor_motion:LockFacing(key,s.time+5.1)
            d:slide_actor(source,p,r);d:begin_cast(source,action,4.7,source,0,p)
            d:schedule(5,function(x)
                x:end_cast(source,action)
                x:aoe_cone({source=source,action=action,target=source,pos=p,rotation=r+(rear and math.pi or 0),
                    radius=100,angle=180,damage=9999999,unmitigated=true,delay=0})
                if key~="boss" then x:schedule(3,function(y) y:play_timeline(source,7737) end) end
            end)
        end
    end
end
return M
