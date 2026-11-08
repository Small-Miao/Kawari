-- 定义加载器：时间轴选择机制模块，机制模块引用独立状态定义。
local M={}
local root=CONTENT_DIR.."/ultimate/Definitions/"
function M.load(content)
    local timeline=dofile(root.."Timelines/"..content..".lua")
    timeline.scene=dofile(root.."Scenes/"..content..".lua")
    timeline.actions={};timeline.modules={}
    for _,path in ipairs(timeline.definitions) do
        local definition=dofile(root.."Actions/"..path..".lua")
        timeline.modules[#timeline.modules+1]=definition
        for id,action in pairs(definition.actions) do
            assert(not timeline.actions[id],"重复技能定义 "..id)
            timeline.actions[id]=action
        end
    end
    return timeline
end
return M
