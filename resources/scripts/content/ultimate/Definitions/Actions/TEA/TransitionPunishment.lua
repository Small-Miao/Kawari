local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/TEA.lua")
local actions={
    [18553]={kind="visual"},[19034]={kind="visual"},
    [18554]={kind="raid",damage=400000,requires_lb=true},
    [19083]={kind="tank_auto",damage=50000,physical=true},
    [18578]={kind="visual"},
    [18579]={kind="circle",radius=4,damage=300000,split=true},
    [18577]={kind="circle",radius=5,damage=180000,status=status.physical_vulnerability.id,status_duration=10},
    [19073]={kind="raid",damage=9999999,unmitigated=true},
}
return {actions=actions,engage=function(d,s,U)
    for _,id in ipairs(U.players(d)) do d:gain_effect(id,status.enigma_codex,0,0,U.boss(d,s)) end
end,resolve=function(d,s,e,p,U)
    if e.action==18579 or e.action==18577 then
        local id=U.hate(d,s)[1];if not id then return true end
        p.target=id;p.pos=d:position(id)
    elseif e.action==19083 then
        p.punish_status=status.physical_vulnerability.id
    end
end}
