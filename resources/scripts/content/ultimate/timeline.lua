-- 纯函数回调时间轴：节点内相对时间、稳定同帧顺序、条件超时和取消。
local M={};M.__index=M
local function finite(v) return type(v)=="number" and v==v and math.abs(v)<math.huge end
local EPSILON=0.00000001
function M.new(definition)
    local self=setmetatable({definition=definition,nodes={},index=1,elapsed=0,active=false},M)
    for _,phase in ipairs(assert(definition.phases or definition.Phases,"缺少阶段定义")) do
        phase.name=phase.name or phase.Name;phase.nodes=phase.nodes or phase.Nodes
        assert(type(phase.name)=="string","阶段缺少名称")
        for _,node in ipairs(phase.nodes) do
            node.name=node.name or node.Name;node.duration=node.duration or node.Duration or 0
            node.events=node.events or node.Events
            node.on_enter=node.on_enter or node.OnEnter;node.on_update=node.on_update or node.OnUpdate
            node.on_exit=node.on_exit or node.OnExit;node.wait_until=node.wait_until or node.WaitUntil
            node.timeout=node.timeout or node.Timeout;node.on_timeout=node.on_timeout or node.OnTimeout
            assert(not node.recording_from and not node.recording_to,"时间轴仅接受显式 Lua 回调")
            assert(type(node.name)=="string" and finite(node.duration) and node.duration>=0,"无效的时间轴节点")
            assert(node.duration>0 or node.wait_until or node.on_enter or node.events,"空的零时长节点")
            if node.wait_until then assert(finite(node.timeout) and node.timeout>0,"条件节点必须设置超时") end
            local entry={definition=node,phase=phase.name,callbacks={}}
            for i,e in ipairs(node.events or {}) do
                local at=e.at or e.At or 0;local run=e.run or e.Run;local order=e.order or e.Order or i
                assert(finite(at) and at>=0 and (at<=node.duration+EPSILON or node.wait_until),"节点事件超出范围")
                assert(type(run)=="function" and finite(order),"节点事件缺少函数或顺序无效")
                entry.callbacks[#entry.callbacks+1]={at=at,run=run,order=order,index=i}
            end
            table.sort(entry.callbacks,function(a,b)
                if a.at~=b.at then return a.at<b.at end
                if a.order~=b.order then return a.order<b.order end
                return a.index<b.index
            end)
            self.nodes[#self.nodes+1]=entry
        end
    end
    assert(#self.nodes>0,"时间轴没有节点")
    return self
end
function M:start() self.active=true;self.index=1;self.elapsed=0;self.entered=false;self.callback_cursor=1;self.last_time=0 end
function M:cancel() self.active=false;self.entered=false;self.callback_cursor=1 end
function M:update(d,now,context,legacy_context)
    -- 保留既有 P2 调用的第四个上下文参数；不再接收或分发录像事件。
    context=legacy_context or context or {}
    if not self.active then return end
    assert(finite(now) and now>=0,"无效的时间轴时间")
    assert(now>=self.last_time,"时间轴时间倒退");self.last_time=now
    for _=1,#self.nodes+1 do
        local entry=self.nodes[self.index]
        if not entry then self.active=false;d:set_var("timeline.state","等待本体击杀");return end
        local node=entry.definition
        if not self.entered then
            self.entered=true;self.callback_cursor=1
            d:set_var("timeline.phase",entry.phase);d:set_var("timeline.node",node.name);d:set_var("timeline.index",self.index)
            if node.on_enter then node.on_enter(d,context) end
            if not self.active then return end
        end
        local relative=now-self.elapsed
        d:set_var("timeline.elapsed",relative)
        d:set_var("timeline.state",node.wait_until and "等待条件" or "运行中")
        while entry.callbacks[self.callback_cursor] and entry.callbacks[self.callback_cursor].at<=relative+EPSILON do
            local callback=entry.callbacks[self.callback_cursor];self.callback_cursor=self.callback_cursor+1
            context.event_time=self.elapsed+callback.at
            callback.run(d,context,relative)
            context.event_time=nil
            if not self.active then return end
        end
        if node.on_update then node.on_update(d,context,relative) end
        if not self.active then return end
        local ready=relative+EPSILON>=node.duration
        if ready and node.wait_until then ready=node.wait_until(d,context) end
        if not self.active then return end
        if node.wait_until and relative>=node.timeout and not ready then
            if node.on_timeout then node.on_timeout(d,context) end
            local reason="条件超时："..node.name
            self:cancel();d:stop_encounter(reason);d:set_var("timeline.state",reason);return
        end
        if not ready then return end
        if node.on_exit then node.on_exit(d,context) end
        if not self.active then return end
        self.elapsed=node.wait_until and now or self.elapsed+node.duration
        self.index=self.index+1;self.entered=false
    end
    error("单次推进超过节点数量")
end
return M
