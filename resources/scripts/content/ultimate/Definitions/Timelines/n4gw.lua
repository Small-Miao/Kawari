-- 完整显式 Lua：每个节点直接装配战斗序列与场景函数，无录像时间范围。
local ROOT=CONTENT_DIR.."/ultimate/Definitions/"
local Merge=dofile(CONTENT_DIR.."/ultimate/commands.lua").Merge
local phases={
    {name="转场",nodes={
        {name="木桩后转场", duration=77.099, events=Merge(dofile(ROOT.."Sequences/n4gw/01_Transition.lua"), dofile(ROOT.."Scenes/n4gw/01_Transition.lua"))},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现", duration=5.284, events=Merge(dofile(ROOT.."Sequences/n4gw/02_Engage.lua"), dofile(ROOT.."Scenes/n4gw/02_Engage.lua"))},
        {name="光尘之剑 [40306]", duration=24.988, events=Merge(dofile(ROOT.."Sequences/n4gw/03_FulgentBlade.lua"), dofile(ROOT.."Scenes/n4gw/03_FulgentBlade.lua"))},
        {name="死亡轮回 [40310]", duration=12.266, events=Merge(dofile(ROOT.."Sequences/n4gw/04_AkhMorn.lua"), dofile(ROOT.."Scenes/n4gw/04_AkhMorn.lua"))},
        {name="复乐园 [40319]", duration=7.126, events=Merge(dofile(ROOT.."Sequences/n4gw/05_ParadiseRegained.lua"), dofile(ROOT.."Scenes/n4gw/05_ParadiseRegained.lua"))},
        {name="光与暗的孤翼 [40313]", duration=21.823, events=Merge(dofile(ROOT.."Sequences/n4gw/06_Wings.lua"), dofile(ROOT.."Scenes/n4gw/06_Wings.lua"))},
        {name="星灵之剑 [40316]", duration=8.657, events=Merge(dofile(ROOT.."Sequences/n4gw/07_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=4.612, events=Merge(dofile(ROOT.."Sequences/n4gw/08_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=4.643, events=Merge(dofile(ROOT.."Sequences/n4gw/09_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=10.958, events=Merge(dofile(ROOT.."Sequences/n4gw/10_PolarizingStrikes.lua"), dofile(ROOT.."Scenes/n4gw/10_PolarizingStrikes.lua"))},
        {name="潘多拉魔盒 [40326]", duration=18.141, events=Merge(dofile(ROOT.."Sequences/n4gw/11_PandorasBox.lua"), dofile(ROOT.."Scenes/n4gw/11_PandorasBox.lua"))},
        {name="光尘之剑 [40306]", duration=24.919, events=Merge(dofile(ROOT.."Sequences/n4gw/12_FulgentBlade.lua"), dofile(ROOT.."Scenes/n4gw/12_FulgentBlade.lua"))},
        {name="死亡轮回 [40310]", duration=16.409, events=Merge(dofile(ROOT.."Sequences/n4gw/13_AkhMorn.lua"), dofile(ROOT.."Scenes/n4gw/13_AkhMorn.lua"))},
        {name="复乐园 [40319]", duration=7.134, events=Merge(dofile(ROOT.."Sequences/n4gw/14_ParadiseRegained.lua"), dofile(ROOT.."Scenes/n4gw/14_ParadiseRegained.lua"))},
        {name="光与暗的孤翼 [40313]", duration=16.646, events=Merge(dofile(ROOT.."Sequences/n4gw/15_Wings.lua"), dofile(ROOT.."Scenes/n4gw/15_Wings.lua"))},
        {name="星灵之剑 [40316]", duration=8.628, events=Merge(dofile(ROOT.."Sequences/n4gw/16_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=4.625, events=Merge(dofile(ROOT.."Sequences/n4gw/17_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=4.581, events=Merge(dofile(ROOT.."Sequences/n4gw/18_PolarizingStrikes.lua"))},
        {name="星灵之剑 [40234]", duration=7.731, events=Merge(dofile(ROOT.."Sequences/n4gw/19_PolarizingStrikes.lua"))},
        {name="光尘之剑 [40306]", duration=24.852, events=Merge(dofile(ROOT.."Sequences/n4gw/20_FulgentBlade.lua"), dofile(ROOT.."Scenes/n4gw/20_FulgentBlade.lua"))},
        {name="死亡轮回 [40310]", duration=16.417, events=Merge(dofile(ROOT.."Sequences/n4gw/21_AkhMorn.lua"), dofile(ROOT.."Scenes/n4gw/21_AkhMorn.lua"))},
        {name="失乐园 [40327]", duration=22.5, events=Merge(dofile(ROOT.."Sequences/n4gw/22_Enrage.lua"), dofile(ROOT.."Scenes/n4gw/22_Enrage.lua"))},
    }},
}
return {phases=phases,name="光暗未来绝境战",phase=5,arena_radius=20,enrage_cast=40327,enrage_delay=21.5,
    definitions={"FRU/Transition","FRU/FulgentBlade","FRU/Wings","FRU/PolarizingStrikes"}}
