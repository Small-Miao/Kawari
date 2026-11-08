-- DSR：转场与狂暴。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({25584,29050,25587,29365,25588,28059,28062,28051,28052,28053,28057,28206,28207},{kind="visual"})
r[26810]={kind="raid",damage=75000}
r[29156]={kind="raid",damage=100000}
r[29752]={kind="raid",damage=150000}
r[28209]={kind="raid",damage=9999999,unmitigated=true}
return {actions=r}
