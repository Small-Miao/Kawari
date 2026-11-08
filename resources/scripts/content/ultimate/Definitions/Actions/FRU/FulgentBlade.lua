-- FRU：光尘之剑。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({40307,40308,40118,40309},{kind="rect",length=5,width=80,damage=9999999,unmitigated=true})
return {actions=r}
