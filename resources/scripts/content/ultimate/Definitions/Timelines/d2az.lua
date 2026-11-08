-- 完整显式 Lua：每个节点直接装配战斗序列与场景函数，无录像时间范围。
local ROOT=CONTENT_DIR.."/ultimate/Definitions/"
local Merge=dofile(CONTENT_DIR.."/ultimate/commands.lua").Merge
local phases={
    {name="转场",nodes={
        {name="木桩后转场", duration=73.364, events=Merge(dofile(ROOT.."Sequences/d2az/01_Transition.lua"), dofile(ROOT.."Scenes/d2az/01_Transition.lua"))},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现", duration=10.185, events=Merge(dofile(ROOT.."Sequences/d2az/02_Engage.lua"))},
        {name="终审判决 [18557]", duration=7.157, events=Merge(dofile(ROOT.."Sequences/d2az/03_FinalWord.lua"))},
        {name="行动命令 [18558]", duration=11.114, events=Merge(dofile(ROOT.."Sequences/d2az/04_OrdainedMotion.lua"))},
        {name="静止命令 [18559]", duration=11.165, events=Merge(dofile(ROOT.."Sequences/d2az/05_OrdainedStillness.lua"))},
        {name="制导 [18571]", duration=6.141, events=Merge(dofile(ROOT.."Sequences/d2az/06_OpticalSight.lua"))},
        {name="制导 [18570]", duration=12.985, events=Merge(dofile(ROOT.."Sequences/d2az/07_OpticalSight.lua"))},
        {name="未来观测α [18555]", duration=8.181, events=Merge(dofile(ROOT.."Sequences/d2az/08_FateProjectionAlpha.lua"), dofile(ROOT.."Scenes/d2az/08_FateProjectionAlpha.lua"))},
        {name="未来确定α [18556]", duration=44.484, events=Merge(dofile(ROOT.."Sequences/d2az/09_FateCalibrationAlpha.lua"), dofile(ROOT.."Scenes/d2az/09_FateCalibrationAlpha.lua"))},
        {name="加重诛罚 [18578]", duration=7.17, events=Merge(dofile(ROOT.."Sequences/d2az/10_CapitalPunishment.lua"))},
        {name="诛罚 [18577]", duration=15.392, events=Merge(dofile(ROOT.."Sequences/d2az/11_OrdainedPunishment.lua"))},
        {name="未来观测β [19219]", duration=7.85, events=Merge(dofile(ROOT.."Sequences/d2az/12_FateProjectionBeta.lua"), dofile(ROOT.."Scenes/d2az/12_FateProjectionBeta.lua"))},
        {name="未来确定β [19220]", duration=69.551, events=Merge(dofile(ROOT.."Sequences/d2az/13_FateCalibrationBeta.lua"), dofile(ROOT.."Scenes/d2az/13_FateCalibrationBeta.lua"))},
        {name="加重诛罚 [18578]", duration=7.147, events=Merge(dofile(ROOT.."Sequences/d2az/14_CapitalPunishment.lua"))},
        {name="诛罚 [18577]", duration=12.183, events=Merge(dofile(ROOT.."Sequences/d2az/15_OrdainedPunishment.lua"))},
        {name="神圣大审判 [18574]", duration=14.134, events=Merge(dofile(ROOT.."Sequences/d2az/16_AlmightyJudgment.lua"))},
        {name="株连 [18580]", duration=12.183, events=Merge(dofile(ROOT.."Sequences/d2az/17_IrresistibleGrace.lua"))},
        {name="加重诛罚 [18578]", duration=7.177, events=Merge(dofile(ROOT.."Sequences/d2az/18_CapitalPunishment.lua"))},
        {name="诛罚 [18577]", duration=8.14, events=Merge(dofile(ROOT.."Sequences/d2az/19_OrdainedPunishment.lua"), dofile(ROOT.."Scenes/d2az/19_OrdainedPunishment.lua"))},
        {name="神圣大审判 [18574]", duration=14.186, events=Merge(dofile(ROOT.."Sequences/d2az/20_AlmightyJudgment.lua"))},
        {name="株连 [18580]", duration=14.915, events=Merge(dofile(ROOT.."Sequences/d2az/21_IrresistibleGrace.lua"))},
        {name="时空干涉 [18582]", duration=8.25, events=Merge(dofile(ROOT.."Sequences/d2az/22_TemporalInterference.lua"))},
        {name="时间牢狱 [18583]", duration=43.0, events=Merge(dofile(ROOT.."Sequences/d2az/23_TemporalPrison.lua"))},
    }},
}
return {phases=phases,name="亚历山大绝境战",phase=4,arena_radius=20,enrage_cast=18583,enrage_delay=42,
    definitions={"TEA/TransitionPunishment","TEA/FinalWord","TEA/FateProjection","TEA/FateCalibrationAlpha","TEA/FateCalibrationBeta","TEA/OpticalSightAlmightyJudgment","TEA/TemporalPrison"}}
