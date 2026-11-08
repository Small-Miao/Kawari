-- 完整显式 Lua：每个节点直接装配战斗序列与场景函数，无录像时间范围。
local ROOT=CONTENT_DIR.."/ultimate/Definitions/"
local Merge=dofile(CONTENT_DIR.."/ultimate/commands.lua").Merge
local phases={
    {name="转场",nodes={
        {name="木桩后转场", duration=62.206, events=Merge(dofile(ROOT.."Sequences/r1fz/01_Transition.lua"), dofile(ROOT.."Scenes/r1fz/01_Transition.lua"))},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现", duration=4.286, events=Merge(dofile(ROOT.."Sequences/r1fz/02_Engage.lua"), dofile(ROOT.."Scenes/r1fz/02_Engage.lua"))},
        {name="百京核爆剑 [28059]", duration=21.216, events=Merge(dofile(ROOT.."Sequences/r1fz/03_ExaflaresEdge.lua"), dofile(ROOT.."Scenes/r1fz/03_ExaflaresEdge.lua"))},
        {name="死亡轮回剑 [28051]", duration=24.509, events=Merge(dofile(ROOT.."Sequences/r1fz/04_AkhMornsEdge.lua"))},
        {name="十亿核爆剑 [28057]", duration=33.273, events=Merge(dofile(ROOT.."Sequences/r1fz/05_GigaflaresEdge.lua"))},
        {name="百京核爆剑 [28059]", duration=21.145, events=Merge(dofile(ROOT.."Sequences/r1fz/06_ExaflaresEdge.lua"))},
        {name="死亡轮回剑 [28051]", duration=25.585, events=Merge(dofile(ROOT.."Sequences/r1fz/07_AkhMornsEdge.lua"))},
        {name="十亿核爆剑 [28057]", duration=33.281, events=Merge(dofile(ROOT.."Sequences/r1fz/08_GigaflaresEdge.lua"))},
        {name="百京核爆剑 [28059]", duration=21.186, events=Merge(dofile(ROOT.."Sequences/r1fz/09_ExaflaresEdge.lua"))},
        {name="死亡轮回剑 [28051]", duration=26.67, events=Merge(dofile(ROOT.."Sequences/r1fz/10_AkhMornsEdge.lua"))},
        {name="无尽顿悟剑 [28206]", duration=19.1, events=Merge(dofile(ROOT.."Sequences/r1fz/11_Enrage.lua"))},
    }},
}
return {phases=phases,name="幻想龙诗绝境战",phase=7,arena_radius=21,enrage_cast=28206,enrage_delay=18.1,
    definitions={"DSR/Transition","DSR/Trinity","DSR/ExaflareGigaflare","DSR/AkhMorn"}}
