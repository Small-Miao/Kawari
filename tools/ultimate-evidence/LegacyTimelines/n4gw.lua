-- 节点按顺序执行；duration 可编辑，recording_* 仅指定该节点的原生表现素材。
local phases={
    {name="转场",nodes={
        {name="木桩后转场",duration=77.099,recording_from=0,recording_to=77.099},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现",duration=5.284,recording_from=77.099,recording_to=82.383},
        {name="光尘之剑 [40306]",duration=24.988,recording_from=82.383,recording_to=107.371},
        {name="死亡轮回 [40310]",duration=12.266,recording_from=107.371,recording_to=119.637},
        {name="复乐园 [40319]",duration=7.126,recording_from=119.637,recording_to=126.763},
        {name="光与暗的孤翼 [40313]",duration=21.823,recording_from=126.763,recording_to=148.586},
        {name="星灵之剑 [40316]",duration=8.657,recording_from=148.586,recording_to=157.243},
        {name="星灵之剑 [40234]",duration=4.612,recording_from=157.243,recording_to=161.855},
        {name="星灵之剑 [40234]",duration=4.643,recording_from=161.855,recording_to=166.498},
        {name="星灵之剑 [40234]",duration=10.958,recording_from=166.498,recording_to=177.456},
        {name="潘多拉魔盒 [40326]",duration=18.141,recording_from=177.456,recording_to=195.597},
        {name="光尘之剑 [40306]",duration=24.919,recording_from=195.597,recording_to=220.516},
        {name="死亡轮回 [40310]",duration=16.409,recording_from=220.516,recording_to=236.925},
        {name="复乐园 [40319]",duration=7.134,recording_from=236.925,recording_to=244.059},
        {name="光与暗的孤翼 [40313]",duration=16.646,recording_from=244.059,recording_to=260.705},
        {name="星灵之剑 [40316]",duration=8.628,recording_from=260.705,recording_to=269.333},
        {name="星灵之剑 [40234]",duration=4.625,recording_from=269.333,recording_to=273.958},
        {name="星灵之剑 [40234]",duration=4.581,recording_from=273.958,recording_to=278.539},
        {name="星灵之剑 [40234]",duration=7.731,recording_from=278.539,recording_to=286.27},
        {name="光尘之剑 [40306]",duration=24.852,recording_from=286.27,recording_to=311.122},
        {name="死亡轮回 [40310]",duration=16.417,recording_from=311.122,recording_to=327.539},
        {name="失乐园 [40327]",duration=22.5,recording_from=327.539,recording_to=347.048},
    }},
}
return {phases=phases,name="光暗未来绝境战",phase=5,arena_radius=20,enrage_cast=40327,enrage_delay=21.5,
    definitions={"FRU/Transition","FRU/FulgentBlade","FRU/Wings","FRU/PolarizingStrikes"}}
