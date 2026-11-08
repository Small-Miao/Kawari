-- 录像提前击杀未录完的牢狱，由真实塔占用和服务器计时完成；不伪造击杀。
local S=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/TEA.lua")
local M={actions={[18582]={kind="visual"},[18583]={kind="raid",damage=9999999,unmitigated=true}}}
function M.start(d,s) s.prisoned={} end
function M.resolve(d,s,e)
    if e.action==18582 then s.scene:Apply(d,"prison_prepare") end
end
function M.prepare(d,s,e,U)
    if e.action~=18583 then return end
    s.enrage_at=nil -- 最后一个全场牢狱统一负责狂暴，避免执行两次伤害。
    for i=1,7 do
        local r=-math.pi-i*math.pi/4
        local pos={x=100+12*math.sin(r),y=0,z=100+12*math.cos(r)}
        d:schedule(1.866+(i-1)*5,function(x) s.scene:Apply(x,"prison_warning",{index=i}) end)
        d:schedule(9.866+(i-1)*5,function(x)
            s.scene:Apply(x,"prison_close",{index=i})
            local occupants=U.players(x,pos,function(id)return not s.prisoned[id] and U.distance(x:position(id),pos)<=16 end)
            if #occupants~=1 then U.fail(x,s,U.players(x));return end
            local id=occupants[1];s.prisoned[id]=U.copy(x:position(id))
            x:gain_effect(id,S.prison,0,0,U.boss(x,s));x:interrupt_cast({target=id})
        end)
    end
    d:schedule(42,function(x)
        s.scene:Apply(x,"prison_close",{index=8})
        for _,id in ipairs(U.players(x)) do s.prisoned[id]=U.copy(x:position(id));x:gain_effect(id,S.prison,0,0,U.boss(x,s)) end
        U.fail(x,s,U.players(x),18583)
    end)
end
function M.tick(d,s,t,U)
    for id,pos in pairs(s.prisoned) do
        if d:is_alive(id) and U.distance(d:position(id),pos)>0.001 then d:move_actor(id,pos,d:rotation(id)) end
    end
end
return M
