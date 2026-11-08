-- DSR：三位一体。修改本文件不会被录像重新提取覆盖。
local r={}
local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/DSR.lua")
local function put(ids,v) for _,id in ipairs(ids) do r[id]=v end end
r[28063]={kind="trinity",rank=1,statuses={status.light},damage=85000}
r[28064]={kind="trinity",rank=2,statuses={status.dark},damage=85000}
r[28065]={kind="trinity",nearest=true,physical=true,damage=50000,statuses={status.light,status.dark,status.physical}}
return {actions=r,resolve=function(d,s,e,p,U)
    local rule=r[e.action]
    local id=rule.nearest and U.players(d,d:position(U.boss(d,s)))[1] or U.hate(d,s)[rule.rank]
    p.radius=3
    return not U.select(d,p,id,"circle")
end}
