-- 节点按顺序执行；duration 可编辑，recording_* 仅指定该节点的原生表现素材。
local phases={
    {name="转场",nodes={
        {name="木桩后转场",duration=67.329,recording_from=0,recording_to=67.329},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现",duration=7.189,recording_from=67.329,recording_to=74.518},
        {name="宇宙记忆 [31649]",duration=14.334,recording_from=74.518,recording_to=88.852},
        {name="宇宙天箭 [31650]",duration=15.081,recording_from=88.852,recording_to=103.933},
        {name="宇宙龙炎 [31654]",duration=19.028,recording_from=103.933,recording_to=122.961},
        {name="波动炮：限制解除 [31660]",duration=23.186,recording_from=122.961,recording_to=146.147},
        {name="波动炮 [31657]",duration=19.531,recording_from=146.147,recording_to=165.678},
        {name="宇宙天箭 [31650]",duration=14.075,recording_from=165.678,recording_to=179.753},
        {name="波动炮 [31657]",duration=19.788,recording_from=179.753,recording_to=199.541},
        {name="波动炮：限制解除 [31660]",duration=18.078,recording_from=199.541,recording_to=217.619},
        {name="宇宙龙炎 [31654]",duration=22.326,recording_from=217.619,recording_to=239.945},
        {name="宇宙流星 [31664]",duration=35.306,recording_from=239.945,recording_to=275.251},
        {name="魔数 [31670]",duration=16.193,recording_from=275.251,recording_to=291.444},
        {name="魔数 [31670]",duration=14.174,recording_from=291.444,recording_to=305.618},
        {name="代码：＊能＊ [31648]",duration=31.3,recording_from=305.618,recording_to=330.445},
    }},
}
return {phases=phases,name="欧米茄绝境验证战",phase=6,arena_radius=20,enrage_cast=31648,enrage_delay=30.3,
    add_deadlines={{role="CosmoComet",delay=0.3},{role="CosmoMeteor",delay=8.3}},
    definitions={"TOP/Transition","TOP/CosmoArrow","TOP/WaveCannon","TOP/CosmoMeteor"}}
