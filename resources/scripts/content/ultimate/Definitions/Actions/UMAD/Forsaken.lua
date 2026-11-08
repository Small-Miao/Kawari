local status=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/UMAD.lua")
local actions={
    [47925]={kind="raid",damage=380000},[47926]={kind="raid",damage=320000},
    [47927]={kind="circle",radius=8,damage=9999999,unmitigated=true,death_status=status.missing_existence},
    [47928]={kind="puddle",radius=8,damage=9999999,unmitigated=true},
    [47929]={kind="circle",radius=6,damage=2400000,split=true,min_players=8},
    [47930]={kind="raid",damage=9999999,unmitigated=true},
}
return {actions=actions,start=function(d,s) s.destroyed_floor={} end,
prepare=function(d,s,e,U)
    if e.action~=47928 then return end
    local id=U.shuffled(d)[1];if not id then return end
    local target=d:position(id);local index,distance
    -- 录像确认的四个橙圈格点；落点取当前玩家所在象限，与场景索引同步。
    for i,pos in pairs(s.scene.definition.puddle_positions) do
        local n=U.distance(target,pos)
        if not distance or n<distance or (n==distance and i<index) then index=i;distance=n end
    end
    s.forsaken_puddle_index=index
    local pos=U.copy(s.scene.definition.puddle_positions[index])
    return {pos=pos,cast_pos=pos,rotation=e.rotation}
end,
resolve=function(d,s,e,p,U)
    if e.action==47925 or e.action==47926 then
        s.forsaken_stack=U.shuffled(d)[1]
        if s.forsaken_stack then d:set_target_icon(s.forsaken_stack,161) end
    elseif e.action==47927 then s.destroyed_floor[#s.destroyed_floor+1]=U.copy(p.pos)
    elseif e.action==47929 then return not U.select(d,p,s.forsaken_stack) end
end,tick=function(d,s,t,U)
    if s.phase~="battle" or t<(s.floor_check or 0) then return end
    s.floor_check=t+0.25
    local caught={}
    for _,id in ipairs(U.players(d)) do
        for _,pos in ipairs(s.destroyed_floor or {}) do
            if U.distance(d:position(id),pos)<64 then caught[#caught+1]=id;break end
        end
    end
    if #caught>0 then d:raidwide({source=U.boss(d,s),targets=caught,action=0,damage=9999999,unmitigated=true,death_status=status.missing_existence}) end
end}
