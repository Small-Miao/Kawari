-- 五本最终阶段的公共生命周期；演员模板和显式调用均来自 Definitions。
local M={}
local ROOT=CONTENT_DIR.."/ultimate/"
local Mechanics=dofile(ROOT.."mechanics.lua")
local Timeline=dofile(ROOT.."timeline.lua")
local Scene=dofile(ROOT.."scene.lua")
local Actors=dofile(ROOT.."actors.lua")
local Control=dofile(ROOT.."control.lua")

function M.install(content)
    local data=dofile(ROOT.."Definitions/Actors/"..content..".lua")
    local rules=dofile(ROOT..content.."_rules.lua")
    local state
    local function setup(d)
        state={phase="waiting",geometry={},casts={},counts={},selected={},groups={},rules=rules,data=data}
        state.scene=Scene.new(rules.scene)
        state.timeline=Timeline.new(rules)
        state.actor_motion=Actors.new()
        d:set_var("timeline.name",rules.name);d:set_var("timeline.state","等待木桩")
        d:set_reset_on_deaggro(false);d:set_director_flag(data.director_flag);d:set_limit_break(0)
        state.scene:Apply(d,"initial")
        for _,key in ipairs(data.initial) do Control.Spawn(d,state,key,false) end
        if rules.scene.spawn_objects then rules.scene.spawn_objects(d,state.scene) end
        for _,key in ipairs(data.initial) do
            local spec=data.templates[key]
            if spec.owner then Control.Owner(d,state,key,spec.owner) end
        end
        local dummy=d:spawn_actor("trigger",{base=11744,name=541,hp=99999999,level=1,
            pos={x=100,y=0,z=100},rotation=math.pi,targetable=true,boss=true})
        d:arm_hit_trigger(dummy);d:set_ai_enabled(dummy,true)
    end
    function onSetup(d) setup(d) end
    function onReset(d) d:director_event(0x8000001B,{1,0,0,0});setup(d) end
    function onStop(d)
        state.timeline:cancel();state.actor_motion:Clear();state.phase="stopped"
        d:director_event(0x8000001B,{1,0,0,0})
        state.scene:ClearEObjs(d);state.scene:Apply(d,"initial")
        d:set_var("timeline.name",rules.name);d:set_var("timeline.state","已停止")
    end
    function onBattleStart(d)
        if state.phase~="waiting" then return end
        state.phase="transition";state.timeline:start();d:despawn_registered("trigger")
        Mechanics.start(d,state)
    end
    function onTick(d,dt,t)
        if state.phase=="waiting" or state.phase=="complete" or state.phase=="stopped" then return end
        Mechanics.tick(d,state,t)
        state.timeline:update(d,t,state)
        state.actor_motion:Update(d,dt,t)
    end
    function onActorDeath(d,base,pos,actor_id)
        if state.phase=="waiting" or state.phase=="complete" then return end
        actor_id=actor_id or (base==data.boss_base and d:actor_id(data.boss))
        if not actor_id then return end
        state.dead=state.dead or {};if state.dead[actor_id] then return end;state.dead[actor_id]=true
        Mechanics.actor_death(d,state,base,pos,actor_id)
        if actor_id==d:actor_id(data.boss) and state.phase=="battle" then
            state.phase="complete";state.timeline:cancel();state.actor_motion:Clear()
            d:cancel_pending();d:complete_duty()
        end
    end
    function onGimmickAccessor(d,player,id)
        if id==2000139 then d:abandon_duty(player) end
        d:finish_gimmick(player)
    end
    return data,rules
end
return M
