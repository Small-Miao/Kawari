-- 原生演员运动；参考 MechanicSim Motion，坐标和朝向由世界服统一同步。
local Actors = {}
Actors.__index = Actors

local function finite(n)
    return type(n) == "number" and n == n and math.abs(n) < math.huge
end

local function check_position(p)
    assert(p and finite(p.x) and finite(p.y) and finite(p.z), "无效目标坐标")
end

local function actor_id(d, key)
    return type(key) == "number" and key or d:actor_id(key)
end

function Actors.new()
    return setmetatable({ plans = {}, locks = {} }, Actors)
end

function Actors:set(d, key, plan)
    assert(finite(plan.speed or 0) and (plan.speed or 0) >= 0, "无效移动速度")
    assert(finite(plan.distance or 0) and (plan.distance or 0) >= 0, "无效停止距离")
    if plan.destination then
        check_position(plan.destination)
        local p = plan.destination
        plan.destination = { x = p.x, y = p.y, z = p.z }
    end
    self.plans[key] = plan
    local actor = actor_id(d, key)
    if actor then d:set_ai_enabled(actor, false) end
end

function Actors:MoveTo(d, key, destination, speed)
    self:set(d, key, { destination = destination, speed = speed or 6 })
end

function Actors:Follow(d, key, target, speed, distance)
    self:set(d, key, { target = target, speed = speed or 6, distance = distance or 3 })
end

function Actors:FaceTarget(d, key, target)
    self:set(d, key, { target = target, face = true })
end

function Actors:FaceEnmity(d, key)
    self:set(d, key, { enmity = true, face = true })
end

-- 与 C# Motion 的命名兼容；两者均实时读取服务器最高仇恨。
Actors.FaceAggro = Actors.FaceEnmity

function Actors:LockFacing(key, until_time)
    assert(finite(until_time), "无效锁定时间")
    self.locks[key] = until_time
end

function Actors:Stop(d, key, resume_ai)
    self.plans[key] = nil
    self.locks[key] = nil
    local actor = actor_id(d, key)
    if actor then d:set_ai_enabled(actor, resume_ai == true) end
end

function Actors:Teleport(d, key, p, rotation)
    check_position(p)
    assert(finite(rotation), "无效朝向")
    self:Stop(d, key)
    local actor = actor_id(d, key)
    if actor then d:move_actor(actor, p, rotation) end
end

function Actors:Clear()
    self.plans = {}
    self.locks = {}
end

function Actors:Update(d, dt, now)
    assert(finite(dt) and dt >= 0 and finite(now), "无效运动时间")
    for key, plan in pairs(self.plans) do
        local actor = actor_id(d, key)
        if actor and not d:is_alive(actor) then
            self.plans[key] = nil
            self.locks[key] = nil
        elseif actor and now >= (self.locks[key] or 0) then
            local target = plan.enmity and d:enmity_order(actor)[1] or plan.target
            if target and not d:is_alive(target) then
                if not plan.enmity then self.plans[key] = nil end
                target = nil
            end
            local to = plan.destination or (target and d:position(target))
            if to then
                local from = d:position(actor)
                local dx, dz = to.x - from.x, to.z - from.z
                local length = math.sqrt(dx * dx + dz * dz)
                if length > 0.001 then
                    local facing = math.atan(dx, dz)
                    local step = plan.face and 0 or math.min(
                        math.max(0, length - (plan.distance or 0)),
                        (plan.speed or 0) * math.min(dt, 0.5)
                    )
                    local rotation_delta = facing - d:rotation(actor)
                    local turning = math.abs(math.atan(math.sin(rotation_delta), math.cos(rotation_delta))) > 0.001
                    if step > 0 or turning then
                        d:slide_actor(actor, {
                            x = from.x + dx / length * step,
                            y = from.y,
                            z = from.z + dz / length * step,
                        }, facing)
                    end
                    if plan.destination and length - step < 0.001 then self.plans[key] = nil end
                elseif plan.destination then
                    self.plans[key] = nil
                end
                if target then d:set_target(actor, target) end
            end
        end
    end
end

return Actors
