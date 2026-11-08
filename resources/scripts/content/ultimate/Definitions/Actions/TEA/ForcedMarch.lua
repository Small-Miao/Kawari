local S=dofile(CONTENT_DIR.."/ultimate/Definitions/Statuses/TEA.lua")
local M={}
function M.begin(d,s,roles,U)
    s.marches={};local positions={}
    for id,role in pairs(roles) do if d:is_alive(id) then positions[id]=d:position(id) end end
    local light,dark
    for id,role in pairs(roles) do if role=="light_beacon" then light=id elseif role=="dark_beacon" then dark=id end end
    for id,role in pairs(roles) do
        local p=positions[id]
        if p then
            local target=role=="light_follow" and light or role=="dark_follow" and dark
            local to=U.copy(p)
            if target and positions[target] then
                local b=positions[target];local length=math.sqrt(U.distance(p,b));local sign=role=="light_follow" and 1 or -1
                if (sign==1 and length<22) or (sign==-1 and length>5) then
                    d:raidwide({source=U.boss(d,s),targets={id},action=18563,damage=9999999,unmitigated=true})
                end
                if length>0.001 then to.x=p.x+(b.x-p.x)/length*20*sign;to.z=p.z+(b.z-p.z)/length*20*sign end
            end
            d:remove_effect(id,S.final_word[role])
            d:gain_effect(id,S.ordained[role],0,S.ordained.duration,target or id)
            s.marches[id]={from=p,to=to,start=s.t,finish=s.t+S.ordained.duration,rotation=d:rotation(id)}
        end
    end
end
function M.tick(d,s,t)
    for id,m in pairs(s.marches or {}) do
        if d:is_alive(id) then
            local f=math.min(1,(t-m.start)/(m.finish-m.start))
            d:move_actor(id,{x=m.from.x+(m.to.x-m.from.x)*f,y=m.from.y,z=m.from.z+(m.to.z-m.from.z)*f},m.rotation)
        end
        if t>=m.finish then s.marches[id]=nil end
    end
end
return M
