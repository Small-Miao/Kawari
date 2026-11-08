-- 节点按顺序执行；duration 可编辑，recording_* 仅指定该节点的原生表现素材。
local phases={
    {name="转场",nodes={
        {name="木桩后转场",duration=73.364,recording_from=0,recording_to=73.364},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现",duration=10.185,recording_from=73.364,recording_to=83.549},
        {name="终审判决 [18557]",duration=7.157,recording_from=83.549,recording_to=90.706},
        {name="行动命令 [18558]",duration=11.114,recording_from=90.706,recording_to=101.82},
        {name="静止命令 [18559]",duration=11.165,recording_from=101.82,recording_to=112.985},
        {name="制导 [18571]",duration=6.141,recording_from=112.985,recording_to=119.126},
        {name="制导 [18570]",duration=12.985,recording_from=119.126,recording_to=132.111},
        {name="未来观测α [18555]",duration=8.181,recording_from=132.111,recording_to=140.292},
        {name="未来确定α [18556]",duration=44.484,recording_from=140.292,recording_to=184.776},
        {name="加重诛罚 [18578]",duration=7.17,recording_from=184.776,recording_to=191.946},
        {name="诛罚 [18577]",duration=15.392,recording_from=191.946,recording_to=207.338},
        {name="未来观测β [19219]",duration=7.85,recording_from=207.338,recording_to=215.188},
        {name="未来确定β [19220]",duration=69.551,recording_from=215.188,recording_to=284.739},
        {name="加重诛罚 [18578]",duration=7.147,recording_from=284.739,recording_to=291.886},
        {name="诛罚 [18577]",duration=12.183,recording_from=291.886,recording_to=304.069},
        {name="神圣大审判 [18574]",duration=14.134,recording_from=304.069,recording_to=318.203},
        {name="株连 [18580]",duration=12.183,recording_from=318.203,recording_to=330.386},
        {name="加重诛罚 [18578]",duration=7.177,recording_from=330.386,recording_to=337.563},
        {name="诛罚 [18577]",duration=8.14,recording_from=337.563,recording_to=345.703},
        {name="神圣大审判 [18574]",duration=14.186,recording_from=345.703,recording_to=359.889},
        {name="株连 [18580]",duration=14.915,recording_from=359.889,recording_to=374.804},
        {name="时空干涉 [18582]",duration=8.25,recording_from=374.804,recording_to=383.054},
        {name="时间牢狱 [18583]",duration=43.0,recording_from=383.054,recording_to=388.072},
    }},
}
return {phases=phases,name="亚历山大绝境战",phase=4,arena_radius=20,enrage_cast=18583,enrage_delay=42,
    definitions={"TEA/TransitionPunishment","TEA/FinalWord","TEA/FateProjection","TEA/FateCalibrationAlpha","TEA/FateCalibrationBeta","TEA/OpticalSightAlmightyJudgment","TEA/TemporalPrison"}}
