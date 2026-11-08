-- 完整显式 Lua：每个节点直接装配战斗序列与场景函数，无录像时间范围。
local ROOT=CONTENT_DIR.."/ultimate/Definitions/"
local Merge=dofile(CONTENT_DIR.."/ultimate/commands.lua").Merge
local phases={
    {name="转场",nodes={
        {name="木桩后转场", duration=37.225, events=Merge(dofile(ROOT.."Sequences/z3oy/01_Transition.lua"), dofile(ROOT.."Scenes/z3oy/01_Transition.lua"))},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现", duration=3.083, events=Merge(dofile(ROOT.."Sequences/z3oy/02_Engage.lua"), dofile(ROOT.."Scenes/z3oy/02_Engage.lua"))},
        {name="连续究极 [47936]", duration=16.626, events=Merge(dofile(ROOT.."Sequences/z3oy/03_UltimaRepeater.lua"))},
        {name="洪水 [49471]", duration=13.133, events=Merge(dofile(ROOT.."Sequences/z3oy/04_Flood.lua"))},
        {name="癫狂交响曲 [47952]", duration=21.704, events=Merge(dofile(ROOT.."Sequences/z3oy/05_MaddeningOrchestra.lua"), dofile(ROOT.."Scenes/z3oy/05_MaddeningOrchestra.lua"))},
        {name="三星 [47938]", duration=9.183, events=Merge(dofile(ROOT.."Sequences/z3oy/06_Celestriad.lua"), dofile(ROOT.."Scenes/z3oy/06_Celestriad.lua"))},
        {name="二选一的灾祟 [49743]", duration=12.116, events=Merge(dofile(ROOT.."Sequences/z3oy/07_Catastrophe.lua"), dofile(ROOT.."Scenes/z3oy/07_Catastrophe.lua"))},
        {name="二选一的灾祟 [49743]", duration=9.16, events=Merge(dofile(ROOT.."Sequences/z3oy/08_Catastrophe.lua"), dofile(ROOT.."Scenes/z3oy/08_Catastrophe.lua"))},
        {name="连续究极 [47936]", duration=14.639, events=Merge(dofile(ROOT.."Sequences/z3oy/09_UltimaRepeater.lua"), dofile(ROOT.."Scenes/z3oy/09_UltimaRepeater.lua"))},
        {name="混沌末世 [47931]", duration=16.116, events=Merge(dofile(ROOT.."Sequences/z3oy/10_StrayApocalypse.lua"))},
        {name="混沌涡旋 [47934]", duration=9.169, events=Merge(dofile(ROOT.."Sequences/z3oy/11_StrayWhirlwind.lua"))},
        {name="癫狂交响曲 [47952]", duration=24.762, events=Merge(dofile(ROOT.."Sequences/z3oy/12_MaddeningOrchestra.lua"), dofile(ROOT.."Scenes/z3oy/12_MaddeningOrchestra.lua"))},
        {name="遗弃末世 [47925]", duration=44.566, events=Merge(dofile(ROOT.."Sequences/z3oy/13_Forsaken.lua"), dofile(ROOT.."Scenes/z3oy/13_Forsaken.lua"))},
        {name="遗弃末点 [47930]", duration=27.0, events=Merge(dofile(ROOT.."Sequences/z3oy/14_Enrage.lua"), dofile(ROOT.."Scenes/z3oy/14_Enrage.lua"))},
    }},
}
return {phases=phases,name="妖星乱舞绝境战",phase=5,arena_radius=28.2843,arena_square=20,arena_rotation=math.pi/4,
    enrage_cast=47930,enrage_delay=26,
    definitions={"UMAD/UltimaRepeaterFellForces","UMAD/Flood","UMAD/MaddeningOrchestra","UMAD/Celestriad","UMAD/StrayApocalypse","UMAD/Forsaken"}}
