-- β：投影光暗/远近线映射、强制移动、真实最远目标跳跃与落点环形圣礼。
local S=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/TEA.lua")
local March=dofile(CONTENT_DIR.."/ultimate/Definitions/Actions/TEA/ForcedMarch.lua")
local actions={}
for _,id in ipairs({19220,18587,18588,18589,18590,18592,18593,18594,18595,18531}) do actions[id]={kind="visual"} end
actions[18565]={kind="circle",radius=10,damage=9999999,unmitigated=true}
actions[18566]={kind="donut",inner=8,outer=60,damage=9999999,unmitigated=true}
local M={actions=actions}
function M.event(d,s,e,id,U)
    local p=s.projection;local c=s.calibration
    if not p or p.phase~="beta" then return end
    if e.kind=="status" then
        for _,status in ipairs(e.data) do
            if status.id==S.projection_color and p.owners[e.actor] then c.colors[p.owners[e.actor]]=status.param end
        end
    elseif e.kind=="tether" and (e.id==28 or e.id==29) then
        local pair={p.owners[e.actor],p.owners[e.target]}
        if pair[1] and pair[2] then c[e.id==28 and "near" or "far"]=pair end
    end
end
function M.before_event(d,s,e)
    -- 跳跃后的演员位置由实时诱导目标决定，后续录像移动不能把它拉回旧落点。
    if e.kind=="move" and s.calibration and s.calibration.jumps[e.actor] then return false end
end
function M.resolve(d,s,e,p,U)
    local c=s.calibration;local projection=s.projection
    if not c or not projection then return end
    local id=projection.owners[e.target]
    if e.action==18587 or e.action==18588 or e.action==18594 or e.action==18595 then
        if id then
            if (e.action==18594 or e.action==18595) and c.colors[id] then c.beacons[c.colors[id]]=id end
            d:projection_death(d:actor_id(e.target))
        end
    elseif e.action==19220 then
        local roles={}
        for player,color in pairs(c.colors) do
            roles[player]=color==132 and (c.beacons[132]==player and "light_beacon" or "light_follow")
                or (c.beacons[133]==player and "dark_beacon" or "dark_follow")
        end
        -- 确定结束后先等待本体消失，再给玩家强制移动；远近线于跳跃前结算。
        d:schedule(5.1,function(x)
            March.begin(x,s,roles,U)
            for _,entry in ipairs({{c.near,28,S.near},{c.far,29,S.far}}) do
                local pair,tether,status=table.unpack(entry)
                if pair and pair[1] and pair[2] then
                    x:tether(pair[1],pair[2],tether,1)
                    for _,player in ipairs(pair) do x:gain_effect(player,status,0,7.2,U.boss(x,s)) end
                end
            end
        end)
    elseif e.action==18531 then
        if c.links_resolved then return true end;c.links_resolved=true
        for _,entry in ipairs({{c.near,28,true},{c.far,29,false}}) do
            local pair,tether,near=table.unpack(entry)
            if pair and pair[1] and pair[2] then
                local a,b=pair[1],pair[2]
                local alive=d:is_alive(a) and d:is_alive(b)
                local distance=alive and U.distance(d:position(a),d:position(b)) or 0
                if not alive or (near and distance>25) or (not near and distance<900) then U.fail(d,s,pair,18562) end
                d:tether_cancel(a,tether,1)
            end
        end
        return true
    elseif e.action==18565 then
        local source=d:actor_id(e.actor);local players=U.players(d,d:position(source));local target=players[#players]
        if not U.select(d,p,target) then return true end
        c.jumps[e.actor]=U.copy(p.pos)
        p.rotation=U.angle(d:position(source),p.pos)
        d:move_actor(source,p.pos,p.rotation)
    elseif e.action==18566 then
        p.pos=c.jumps[e.actor] or d:position(d:actor_id(e.actor))
    end
end
return M
