-- 共用玩家查询和几何工具，不包含副本技能 ID。
local C={x=100,y=0,z=100}
local function copy(t) local r={} for k,v in pairs(t or {}) do r[k]=v end return r end
local function tank(d,id) local j=d:job(id); return j==1 or j==3 or j==19 or j==21 or j==32 or j==37 end
local function distance(a,b) return (a.x-b.x)^2+(a.z-b.z)^2 end
local function angle(a,b) return math.atan(b.x-a.x,b.z-a.z) end
local function boss(d,s) return d:actor_id(s.data.boss) end
local function players(d,origin,filter)
    local p={}
    for _,id in ipairs(d:alive_players()) do if not filter or filter(id) then p[#p+1]=id end end
    table.sort(p,function(a,b)
        if origin then
            local da,db=distance(d:position(a),origin),distance(d:position(b),origin)
            if da~=db then return da<db end
        end
        return a<b
    end)
    return p
end
local function hate(d,s)
    local b=boss(d,s)
    local p={}
    for _,id in ipairs(b and d:enmity_order(b) or {}) do if d:is_alive(id) then p[#p+1]=id end end
    local all=players(d)
    table.sort(all,function(a,c) if tank(d,a)~=tank(d,c) then return tank(d,a) end return a<c end)
    local seen={} for _,id in ipairs(p) do seen[id]=true end
    for _,id in ipairs(all) do if not seen[id] then p[#p+1]=id end end
    return p
end
local function shuffled(d)
    local p=players(d)
    for i=#p,2,-1 do local j=math.random(i);p[i],p[j]=p[j],p[i] end
    return p
end
local function next_target(d,s,key,t,list)
    local g=s.groups[key]
    if not g or t-g.t>0.25 then g={t=t,n=0,list=list or players(d)};s.groups[key]=g end
    g.n=g.n+1
    return g.list[(g.n-1)%math.max(1,#g.list)+1]
end
local function side_target(d,s,side)
    local b=boss(d,s);local p=b and d:position(b) or C;local r=b and d:rotation(b) or 0
    return players(d,p,function(id)
        local q=d:position(id);local left=(q.x-p.x)*math.cos(r)-(q.z-p.z)*math.sin(r)
        return side*left>0
    end)[1]
end

local U={players=players,shuffled=shuffled,hate=hate,tank=tank,distance=distance,angle=angle,boss=boss,copy=copy,center=C,next_target=next_target,side_target=side_target}
function U.healer(d,id) local j=d:job(id);return j==6 or j==24 or j==28 or j==33 or j==40 end
function U.select(d,p,id,kind)
    if not id or not d:is_alive(id) then return false end
    p.target=id;p.pos=d:position(id);if kind then p.kind=kind end;return true
end
function U.fail(d,s,targets,action)
    if #targets>0 then d:raidwide({source=boss(d,s),targets=targets,action=action or 0,damage=9999999,unmitigated=true}) end
end
return U
