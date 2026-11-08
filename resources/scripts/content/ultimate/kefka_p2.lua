-- 原生 Lua 生命周期：木桩 → C# 原定义迁入的一运节点 → 实际本体死亡。
local root=CONTENT_DIR.."/ultimate/"
local Timeline=dofile(root.."timeline.lua")
local Scene=dofile(root.."scene.lua")
local Actors=dofile(root.."actors.lua")
local definition=dofile(root.."Definitions/Timelines/KefkaP2.lua")
local scene_definition=dofile(root.."Definitions/Scenes/KefkaP2.lua")
local state
local function setup(d)
    state={phase="waiting",time=0,timeline=Timeline.new(definition),scene=Scene.new(scene_definition),actor_motion=Actors.new()}
    d:set_director_flag(1);d:set_reset_on_deaggro(false);state.scene:Apply(d,"initial")
    definition.actions.Setup(d,state)
    local dummy=d:spawn_actor("trigger",{base=11744,name=541,hp=99999999,level=1,pos={x=100,y=0,z=100},rotation=math.pi,targetable=true,boss=true})
    d:arm_hit_trigger(dummy);d:set_ai_enabled(dummy,true)
    d:set_var("timeline.name",definition.Name);d:set_var("timeline.state","等待木桩")
end
function onSetup(d) setup(d) end
function onReset(d) d:director_event(0x8000001B,{1,0,0,0});setup(d) end
function onStop(d)
    state.timeline:cancel();state.actor_motion:Clear();state.phase="stopped"
    state.scene:ClearEObjs(d);state.scene:Apply(d,"initial")
    d:set_var("timeline.name",definition.Name);d:set_var("timeline.state","已停止")
end
function onBattleStart(d)
    if state.phase~="waiting" then return end
    state.phase="battle";d:despawn_registered("trigger");d:set_targetable(d:actor_id("boss"),true)
    state.actor_motion:FaceEnmity(d,"boss");state.timeline:start()
end
function onTick(d,dt,t)
    if state.phase~="battle" then return end
    state.time=t;state.timeline:update(d,t,function()end,state);state.actor_motion:Update(d,dt,t)
end
function onActorDeath(d,base,p,id)
    if state.phase=="battle" and id==d:actor_id("boss") then
        state.phase="complete";state.timeline:cancel();state.actor_motion:Clear();d:cancel_pending();d:complete_duty()
    end
end
function onEnterZone() end
function onTalk() end
function onEventActionCast() end
function onGimmickAccessor(d,player,id)
    if id==2000139 then d:abandon_duty(player) end;d:finish_gimmick(player)
end
