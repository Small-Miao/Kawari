-- 节点内的显式调用：At 是相对秒数，Order 只约束同一时刻的执行先后。
local M={}
function M.At(at,order,run) return {At=at,Order=order,Run=run} end
function M.Merge(...)
    local result={}
    for _,track in ipairs({...}) do for _,entry in ipairs(track) do result[#result+1]=entry end end
    return result
end
return M
