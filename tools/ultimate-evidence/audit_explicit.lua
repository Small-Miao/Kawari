-- 一次性迁移审计：逐项比较旧定义与显式调用的时间、顺序和有效参数。
-- 后续有意编辑机制时允许与旧录像不同，因此不纳入默认行为约束。
local root=CONTENT_DIR.."/ultimate/"
local original=dofile
local scene_kinds={map=true,object_spawn=true,object_animation=true,object_despawn=true,bgm=true,weather=true,director=true}
local function copy(source) local t={} for k,v in pairs(source or {}) do t[k]=v end return t end
local function same(a,b,path)
    if type(a)=="number" and type(b)=="number" then assert(math.abs(a-b)<0.000001,path..": 数值不同 "..a.." / "..b);return end
    assert(type(a)==type(b),path..": 类型不同")
    if type(a)~="table" then assert(a==b,path..": 值不同 "..tostring(a).." / "..tostring(b));return end
    for k,v in pairs(a) do same(v,b[k],path.."/"..tostring(k)) end
    for k in pairs(b) do assert(a[k]~=nil,path..": 多出 "..tostring(k)) end
end
local counts={}
for _,content in ipairs({"r1fz","n4gw","z3oz","d2az","z3oy"}) do
    local data=original(EVIDENCE_DIR.."/"..content.."_data.lua")
    local old_scene=original(EVIDENCE_DIR.."/SceneTables/"..content..".lua")
    local old_timeline=original(EVIDENCE_DIR.."/LegacyTimelines/"..content..".lua")
    local catalog=original(root.."Definitions/Actors/"..content..".lua")
    local actual,expected={},{};local current=0
    local function record(kind,key,options)
        local e=copy(options);e.kind=kind;e.actor=key;e.t=current;actual[#actual+1]=e
    end
    local C={}
    function C.Spawn(d,s,key) record("spawn",key,{data=catalog.templates[key]}) end
    function C.Despawn(d,s,key) record("despawn",key) end
    function C.Move(d,s,key,pos,rotation) record("move",key,{pos=pos,rotation=rotation}) end
    function C.Cast(d,s,key,action,seconds,options) local e=copy(options);e.action=action;e.seconds=seconds;record("cast",key,e) end
    function C.Action(d,s,key,action,options) local e=copy(options);e.action=action;record("action",key,e) end
    function C.Target(d,s,key,target) record("target",key,{target=target}) end
    function C.Owner(d,s,key,target) record("owner",key,{target=target}) end
    function C.Tether(d,s,key,target,id,slot) record("tether",key,{target=target,id=id,slot=slot}) end
    function C.Untether(d,s,key,id,slot) record("untether",key,{id=id,slot=slot}) end
    function C.Status(d,s,key,statuses) record("status",key,{data=statuses}) end
    function C.Targetable(d,s,key,enabled) record("control",key,{category=54,params={enabled and 1 or 0}}) end
    function C.Animation(d,s,key,a,b) record("control",key,{category=62,params={a,b}}) end
    function C.Model(d,s,key,state) record("control",key,{category=63,params={state}}) end
    function C.Timeline(d,s,key,timeline) record("control",key,{category=407,params={timeline}}) end
    function C.Visible(d,s,key,visible,fade) record("control",key,{category=414,params={visible and 1 or 0,fade}}) end
    function C.Hide(d,s,key) record("control",key,{category=415,params={}}) end
    function C.Presentation(d,s,key,operation,parameter,duration) record("presentation",key,{operation=operation,parameter=parameter,duration=duration}) end
    function C.SynchronizedTimelines(d,s,entries) record("timelines",nil,{entries=entries}) end
    local function object(key) local suffix=assert(key:match("_(%d+)$"),"未知物件键");return (key:match("^prison_") and "s" or "o")..tonumber(suffix) end
    local scene={}
    function scene:MapEffect(d,index,state,timeline) record("map",nil,{index=index,state=state,timeline=timeline}) end
    function scene:SpawnEObj(d,key,spec) record("object_spawn",object(key),{data=spec}) end
    function scene:AnimateEObj(d,key,a,b) record("object_animation",object(key),{params={a,b}}) end
    function scene:RemoveEObj(d,key) record("object_despawn",object(key)) end
    local d={actor_id=function(_,key)return key end,
        director_event=function(_,id,args)record("director",nil,{id=id,args=args})end,
        set_weather=function(_,id,fade)record("weather",nil,{id=id,fade=fade})end,
        set_bgm=function(_,id)record("bgm",nil,{id=id})end}
    dofile=function(path)
        if path==root.."control.lua" then return C end
        if path==root.."Definitions/Actions/TOP/CosmoMeteor.lua" then return {Mark=function()record("mark_meteors")end} end
        return original(path)
    end
    local timeline=original(root.."timeline.lua").new(dofile(root.."Definitions/Timelines/"..content..".lua"))
    dofile=original
    local elapsed=0
    for _,node in ipairs(timeline.nodes) do
        for _,call in ipairs(node.callbacks) do current=elapsed+call.at;call.run(d,{scene=scene}) end
        elapsed=elapsed+node.definition.duration
    end
    local old_events={}
    for i,e in ipairs(data.events) do if not scene_kinds[e.kind] then local c=copy(e);c.order=i;old_events[#old_events+1]=c end end
    for _,e in ipairs(old_scene.events) do old_events[#old_events+1]=e end
    if content=="z3oz" then
        for _,e in ipairs(data.events) do if e.kind=="action" and e.action==31668 then old_events[#old_events+1]={kind="mark_meteors",t=e.t-8.1,order=-1};break end end
    end
    table.sort(old_events,function(a,b)return a.t==b.t and a.order<b.order or a.t<b.t end)
    elapsed=0
    for _,phase in ipairs(old_timeline.phases) do for _,node in ipairs(phase.nodes) do
        for _,e in ipairs(old_events) do if e.t>=node.recording_from and e.t<node.recording_to then
            local c=copy(e);c.order=nil;c.t=elapsed+e.t-node.recording_from
            if c.kind=="control" then
                c.params={table.unpack(c.params,1,(c.category==62 or c.category==414) and 2 or c.category==415 and 0 or 1)}
            end
            expected[#expected+1]=c
        end end
        elapsed=elapsed+node.duration
    end end
    same(expected,actual,content)
    for key,spec in pairs(data.initial) do same(spec,catalog.templates[key],content.."/初始演员/"..key) end
    counts[content]=#actual
end
return counts
