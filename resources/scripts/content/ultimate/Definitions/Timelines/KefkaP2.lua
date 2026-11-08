-- 节点等待时长均为相对前一节点；技能细节放 Actions，场地放 Scenes。
local A=dofile(CONTENT_DIR.."/ultimate/Definitions/Actions/KefkaP2/Mechanics.lua")
local nodes={};local previous=0
local function at(time,name,run)
    local duration=time-previous;previous=time
    nodes[#nodes+1]={Name=name,Duration=duration,Events={{At=duration,Run=run}}}
end
at(3,"遗弃末世 [47804]",A.Forsaken)
at(12,"咏唱危机初始点名",A.Markers)
for i,time in ipairs({13.059,23.089,34.157,44.191,55.162,65.236,76.258,86.266}) do
    local round=i-1
    -- 临时收集绝对节点，末尾统一转成可编辑的相对 Duration。
    nodes[#nodes+1]={absolute=time,Name="第"..i.."轮双塔",run=function(d,s) A.Towers(d,s,round) end}
end
for i,times in ipairs({{26.17,32.916,39.044},{47.074,53.709,59.981},{67.983,74.657,80.894},{88.927,95.554,101.897}}) do
    nodes[#nodes+1]={absolute=times[1],Name="第"..i.."轮未来／过去终结",run=A.EndOfWorld}
    nodes[#nodes+1]={absolute=times[2],Name="本体与分身跳跃",run=A.Jump}
    nodes[#nodes+1]={absolute=times[3],Name="消灭之脚",run=A.Feet}
end
nodes[1].absolute=3;nodes[1].run=A.Forsaken;nodes[2].absolute=12;nodes[2].run=A.Markers
table.sort(nodes,function(a,b)return a.absolute<b.absolute end)
previous=0
for _,node in ipairs(nodes) do
    node.Duration=node.absolute-previous;previous=node.absolute
    node.Events={{At=node.Duration,Run=node.run}};node.absolute=nil;node.run=nil
end
nodes[#nodes+1]={Name="等待一运结算完成",Duration=10}
return {Name="凯夫卡 P2 一运",Phases={{Name="P2 一运",Nodes=nodes}},actions=A}
