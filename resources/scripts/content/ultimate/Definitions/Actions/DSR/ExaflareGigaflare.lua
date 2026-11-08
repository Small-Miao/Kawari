-- DSR：地火与核爆。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({28060,28061},{kind="circle",radius=6,damage=9999999,unmitigated=true})
r[28049]={kind="circle",radius=8,damage=9999999,unmitigated=true}
r[28050]={kind="donut",inner=8,outer=50,damage=9999999,unmitigated=true}
put({28058,28114,28115},{kind="circle",radius=50,damage=300000,falloff=25})
return {actions=r}
