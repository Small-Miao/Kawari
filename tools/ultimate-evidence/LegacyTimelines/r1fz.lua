-- 节点按顺序执行；duration 可编辑，recording_* 仅指定该节点的原生表现素材。
local phases={
    {name="转场",nodes={
        {name="木桩后转场",duration=62.206,recording_from=0,recording_to=62.206},
    }},
    {name="最终阶段",nodes={
        {name="最终本体出现",duration=4.286,recording_from=62.206,recording_to=66.492},
        {name="百京核爆剑 [28059]",duration=21.216,recording_from=66.492,recording_to=87.708},
        {name="死亡轮回剑 [28051]",duration=24.509,recording_from=87.708,recording_to=112.217},
        {name="十亿核爆剑 [28057]",duration=33.273,recording_from=112.217,recording_to=145.49},
        {name="百京核爆剑 [28059]",duration=21.145,recording_from=145.49,recording_to=166.635},
        {name="死亡轮回剑 [28051]",duration=25.585,recording_from=166.635,recording_to=192.22},
        {name="十亿核爆剑 [28057]",duration=33.281,recording_from=192.22,recording_to=225.501},
        {name="百京核爆剑 [28059]",duration=21.186,recording_from=225.501,recording_to=246.687},
        {name="死亡轮回剑 [28051]",duration=26.67,recording_from=246.687,recording_to=273.357},
        {name="无尽顿悟剑 [28206]",duration=19.1,recording_from=273.357,recording_to=276.244},
    }},
}
-- 幻想龙诗 P7：转场由木桩触发；原始表现数据与可编辑机制分离。
return {phases=phases,name="幻想龙诗绝境战",phase=7,arena_radius=21,enrage_cast=28206,enrage_delay=18.1,
    definitions={"DSR/Transition","DSR/Trinity","DSR/ExaflareGigaflare","DSR/AkhMorn"}}
