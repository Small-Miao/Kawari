-- 妖星最终阶段：元素塔沿用原生 EObj；橙色地面与诱导判定共同使用同一格点。
local puddles={
    [29]={x=93.25,y=0,z=106.75},[30]={x=93.25,y=0,z=93.25},
    [31]={x=106.75,y=0,z=93.25},[32]={x=106.75,y=0,z=106.75},
}
local Initial=dofile(CONTENT_DIR.."/ultimate/Definitions/Scenes/z3oy/Initial.lua")
return {initial=Initial.Reset,spawn_objects=Initial.SpawnObjects,puddle_positions=puddles}
