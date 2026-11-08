-- DSR：死亡轮回。修改本文件不会被录像重新提取覆盖。
local r={}
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
put({29452,29453,28054},{kind="circle",radius=4,min_players=1,split=true,damage=225000})
put({29454,28055},{kind="circle",radius=4,min_players=1,split=true,physical=true,damage=360000})
r[28056]={kind="raid",damage=9999999,unmitigated=true}
put({29455,29456,29457,28208},{kind="circle",radius=4,damage=9999999,min_players=1,unmitigated=true})
return {actions=r}
