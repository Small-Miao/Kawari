-- 原生场景接口；具体地图、物件与演出由 Definitions/Scenes 中的函数直接调用。
local M={};M.__index=M
function M.new(definition) return setmetatable({definition=definition or {},objects={}},M) end
function M:MapEffect(d,index,state,timeline) d:map_effect(index,timeline,state) end
function M:SpawnEObj(d,key,spec)
    assert(type(key)=="string" and key~="","EObj 必须有唯一名称")
    if d:actor_id(key) then d:despawn_registered(key) end
    local actor=d:spawn_event_object(key,spec);self.objects[key]=true
    if spec.animation then d:object_animation(actor,spec.animation[1],spec.animation[2]) end
    return actor
end
function M:AnimateEObj(d,key,a,b) d:object_animation(assert(d:actor_id(key),"场景物件不存在："..key),a,b) end
function M:RemoveEObj(d,key) d:despawn_registered(key);self.objects[key]=nil end
function M:ClearEObjs(d)
    for key in pairs(self.objects) do d:despawn_registered(key) end
    self.objects={}
end
function M:Apply(d,name,data)
    local scene=assert(self.definition[name],"场景未定义："..name)
    if type(scene)=="function" then scene(d,self,data);return end
    -- 普通具名场景仍允许声明固定参数，供已有 P2 定义使用。
    if scene.map_setup then d:setup_map_effects(scene.map_setup.states,scene.map_setup.flag) end
    for _,e in ipairs(scene.maps or {}) do self:MapEffect(d,e.index,e.state,e.timeline) end
    if scene.weather then d:set_weather(scene.weather,scene.fade or 0) end
    if scene.bgm and scene.bgm>0 then d:set_bgm(scene.bgm) end
    for _,key in ipairs(scene.remove or {}) do self:RemoveEObj(d,key) end
    for key,spec in pairs(scene.objects or {}) do self:SpawnEObj(d,key,spec) end
    if scene.on_enter then scene.on_enter(d,self,data) end
end
return M
