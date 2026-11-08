-- 节点按顺序执行；duration 可编辑，recording_* 仅指定该节点的原生表现素材。
local phases={
    {name="转场",nodes={
        {name="木桩后转场",duration=37.225,recording_from=0,recording_to=37.225},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现",duration=3.083,recording_from=37.225,recording_to=40.308},
        {name="连续究极 [47936]",duration=16.626,recording_from=40.308,recording_to=56.934},
        {name="洪水 [49471]",duration=13.133,recording_from=56.934,recording_to=70.067},
        {name="癫狂交响曲 [47952]",duration=21.704,recording_from=70.067,recording_to=91.771},
        {name="三星 [47938]",duration=9.183,recording_from=91.771,recording_to=100.954},
        {name="二选一的灾祟 [49743]",duration=12.116,recording_from=100.954,recording_to=113.07},
        {name="二选一的灾祟 [49743]",duration=9.16,recording_from=113.07,recording_to=122.23},
        {name="连续究极 [47936]",duration=14.639,recording_from=122.23,recording_to=136.869},
        {name="混沌末世 [47931]",duration=16.116,recording_from=136.869,recording_to=152.985},
        {name="混沌涡旋 [47934]",duration=9.169,recording_from=152.985,recording_to=162.154},
        {name="癫狂交响曲 [47952]",duration=24.762,recording_from=162.154,recording_to=186.916},
        {name="遗弃末世 [47925]",duration=44.566,recording_from=186.916,recording_to=231.482},
        {name="遗弃末点 [47930]",duration=27.0,recording_from=231.482,recording_to=254.796},
    }},
}
return {phases=phases,name="妖星乱舞绝境战",phase=5,arena_radius=28.2843,arena_square=20,arena_rotation=math.pi/4,
    enrage_cast=47930,enrage_delay=26,
    definitions={"UMAD/UltimaRepeaterFellForces","UMAD/Flood","UMAD/MaddeningOrchestra","UMAD/Celestriad","UMAD/StrayApocalypse","UMAD/Forsaken"}}
