-- 完整显式 Lua：每个节点直接装配战斗序列与场景函数，无录像时间范围。
local ROOT=CONTENT_DIR.."/ultimate/Definitions/"
local Merge=dofile(CONTENT_DIR.."/ultimate/commands.lua").Merge
local phases={
    {name="转场",nodes={
        {name="木桩后转场", duration=67.329, events=Merge(dofile(ROOT.."Sequences/z3oz/01_Transition.lua"), dofile(ROOT.."Scenes/z3oz/01_Transition.lua"))},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现", duration=7.189, events=Merge(dofile(ROOT.."Sequences/z3oz/02_Engage.lua"), dofile(ROOT.."Scenes/z3oz/02_Engage.lua"))},
        {name="宇宙记忆 [31649]", duration=14.334, events=Merge(dofile(ROOT.."Sequences/z3oz/03_CosmoMemory.lua"))},
        {name="宇宙天箭 [31650]", duration=15.081, events=Merge(dofile(ROOT.."Sequences/z3oz/04_CosmoArrow.lua"))},
        {name="宇宙龙炎 [31654]", duration=19.028, events=Merge(dofile(ROOT.."Sequences/z3oz/05_CosmoDive.lua"))},
        {name="波动炮：限制解除 [31660]", duration=23.186, events=Merge(dofile(ROOT.."Sequences/z3oz/06_UnlimitedWaveCannon.lua"))},
        {name="波动炮 [31657]", duration=19.531, events=Merge(dofile(ROOT.."Sequences/z3oz/07_WaveCannon.lua"))},
        {name="宇宙天箭 [31650]", duration=14.075, events=Merge(dofile(ROOT.."Sequences/z3oz/08_CosmoArrow.lua"))},
        {name="波动炮 [31657]", duration=19.788, events=Merge(dofile(ROOT.."Sequences/z3oz/09_WaveCannon.lua"))},
        {name="波动炮：限制解除 [31660]", duration=18.078, events=Merge(dofile(ROOT.."Sequences/z3oz/10_UnlimitedWaveCannon.lua"))},
        {name="宇宙龙炎 [31654]", duration=22.326, events=Merge(dofile(ROOT.."Sequences/z3oz/11_CosmoDive.lua"))},
        {name="宇宙流星 [31664]", duration=35.306, events=Merge(dofile(ROOT.."Sequences/z3oz/12_CosmoMeteor.lua"), dofile(ROOT.."Scenes/z3oz/12_CosmoMeteor.lua"))},
        {name="魔数 [31670]", duration=16.193, events=Merge(dofile(ROOT.."Sequences/z3oz/13_MagicNumber.lua"))},
        {name="魔数 [31670]", duration=14.174, events=Merge(dofile(ROOT.."Sequences/z3oz/14_MagicNumber.lua"))},
        {name="代码：＊能＊ [31648]", duration=31.3, events=Merge(dofile(ROOT.."Sequences/z3oz/15_Enrage.lua"))},
    }},
}
return {phases=phases,name="欧米茄绝境验证战",phase=6,arena_radius=20,enrage_cast=31648,enrage_delay=30.3,
    add_deadlines={{role="CosmoComet",delay=0.3},{role="CosmoMeteor",delay=8.3}},
    definitions={"TOP/Transition","TOP/CosmoArrow","TOP/WaveCannon","TOP/CosmoMeteor"}}
