-- 时间牢狱由独立函数控制；初始状态和各轮场景调用位于 d2az 子目录。
local Initial=dofile(CONTENT_DIR.."/ultimate/Definitions/Scenes/d2az/Initial.lua")
return {
    initial=function(d,scene) Initial.Reset(d,scene);scene.prisons={"prison_08", "prison_07", "prison_06", "prison_05", "prison_04", "prison_03", "prison_02", "prison_01"} end,
    spawn_objects=Initial.SpawnObjects,
    prison_prepare=function(d,scene)
        for _,key in ipairs(scene.prisons) do scene:AnimateEObj(d,key,0x10,0x20) end
    end,
    prison_warning=function(d,scene,p) scene:AnimateEObj(d,scene.prisons[p.index],0x400,0x840) end,
    prison_close=function(d,scene,p) scene:AnimateEObj(d,scene.prisons[p.index],0x1000,0x2000) end,
}
