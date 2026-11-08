-- FRU：转场与狂暴。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({40231,40232,40114,40310,40319,40233,40313,40316,40234,40327},{kind="visual"})
r[40306]={kind="raid",damage=180000}
r[40115]={kind="tank_auto",damage=100000,physical=true}
r[40326]={kind="raid",damage=700000,requires_lb=true}
r[40328]={kind="raid",damage=9999999,unmitigated=true}
return {actions=r}
