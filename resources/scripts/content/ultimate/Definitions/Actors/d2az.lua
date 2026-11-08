-- 演员命名和模板；创建/移动/施法时点分别见同名机制的 Sequences。
return {
    boss = "a7",
    boss_base = 11349,
    director_flag = 1,
    names = {
        Alexander = "a1", -- BNpcBase 6358
        PerfectAlexanderCutscene = "a2", -- BNpcBase 11423
        AlexanderPrimeCutscene = "a3", -- BNpcBase 11422
        CruiseChaserCutscene = "a4", -- BNpcBase 11421
        BruteJustice = "a5", -- BNpcBase 11340
        CruiseChaser = "a6", -- BNpcBase 11342
        Boss = "a7", -- BNpcBase 11349
        AlexanderPrime = "a8", -- BNpcBase 11347
        Helper01 = "a9", -- BNpcBase 9020
        Helper02 = "a10", -- BNpcBase 9020
        Helper03 = "a11", -- BNpcBase 9020
        Helper04 = "a12", -- BNpcBase 9020
        Helper05 = "a13", -- BNpcBase 9020
        Helper06 = "a14", -- BNpcBase 9020
        Helper07 = "a15", -- BNpcBase 9020
        Helper08 = "a16", -- BNpcBase 9020
        Helper09 = "a17", -- BNpcBase 9020
        Helper10 = "a18", -- BNpcBase 9020
        Helper11 = "a19", -- BNpcBase 9020
        Helper12 = "a20", -- BNpcBase 9020
        PerfectAlexander02 = "a21", -- BNpcBase 11349
        PerfectAlexander03 = "a22", -- BNpcBase 11349
        PerfectAlexander04 = "a23", -- BNpcBase 11349
        PerfectAlexander05 = "a24", -- BNpcBase 11349
        FateProjection01 = "a25", -- BNpcBase 11350
        FateProjection02 = "a26", -- BNpcBase 11350
        FateProjection03 = "a27", -- BNpcBase 11350
        FateProjection04 = "a28", -- BNpcBase 11350
        FateProjection05 = "a29", -- BNpcBase 11350
        FateProjection06 = "a30", -- BNpcBase 11350
        FateProjection07 = "a31", -- BNpcBase 11350
        FateProjection08 = "a32", -- BNpcBase 11350
        FateProjection09 = "a33", -- BNpcBase 11350
        FateProjection10 = "a34", -- BNpcBase 11350
        FateProjection11 = "a35", -- BNpcBase 11350
        FateProjection12 = "a36", -- BNpcBase 11350
        FateProjection13 = "a37", -- BNpcBase 11350
        FateProjection14 = "a38", -- BNpcBase 11350
        FateProjection15 = "a39", -- BNpcBase 11350
        FateProjection16 = "a40", -- BNpcBase 11350
    },
    initial = {"a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17", "a18", "a19", "a20"},
    templates = {
        a16 = {base=9020, name=9220, hp=44, level=1, pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a6", boss=false, targetable=false} , -- Helper08
        a17 = {base=9020, name=9220, hp=44, level=1, pos={x=110.247, y=0.0, z=115.6343}, rotation=-1.04729, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a8", boss=false, targetable=false} , -- Helper09
        a18 = {base=9020, name=9220, hp=44, level=1, pos={x=111.0866, y=0.0, z=104.5922}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a8", boss=false, targetable=false} , -- Helper10
        a19 = {base=9020, name=9220, hp=44, level=1, pos={x=99.9717, y=0.0, z=93.2008}, rotation=-3.09557, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a5", boss=false, targetable=false} , -- Helper11
        a20 = {base=9020, name=9220, hp=44, level=1, pos={x=91.0, y=0.0, z=106.0}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a5", boss=false, targetable=false} , -- Helper12
        a1 = {base=6358, name=9225, hp=42687, level=80, pos={x=109.8293, y=0.0, z=88.8354}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Alexander", layout=8147090, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Alexander
        a2 = {base=11423, name=9042, hp=3853782, level=80, pos={x=87.7861, y=0.0, z=102.6487}, rotation=-5e-05, flags=393224, model_state=0, animation_state=0, role="PerfectAlexanderCutscene", layout=8153901, model=2784, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- PerfectAlexanderCutscene
        a3 = {base=11422, name=9220, hp=3853782, level=80, pos={x=108.2277, y=0.0, z=80.1366}, rotation=-0.39275, flags=393224, model_state=0, animation_state=0, role="AlexanderPrimeCutscene", layout=8153900, model=2782, model_attribute_flags=16, owner=nil, boss=false, targetable=false} , -- AlexanderPrimeCutscene
        a4 = {base=11421, name=9218, hp=3853782, level=80, pos={x=87.2021, y=0.0, z=95.0504}, rotation=-5e-05, flags=393224, model_state=0, animation_state=0, role="CruiseChaserCutscene", layout=8153899, model=1605, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- CruiseChaserCutscene
        a5 = {base=11340, name=9216, hp=2168926, level=80, pos={x=91.0, y=0.0, z=106.0}, rotation=-5e-05, flags=393224, model_state=4, animation_state=0, role="BruteJustice", layout=8136064, model=1357, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- BruteJustice
        a6 = {base=11342, name=9218, hp=2168926, level=80, pos={x=109.0, y=0.0, z=106.0}, rotation=-5e-05, flags=393224, model_state=0, animation_state=0, role="CruiseChaser", layout=8136066, model=1606, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- CruiseChaser
        a7 = {base=11349, name=9042, hp=7535109, level=80, pos={x=99.9822, y=0.0, z=96.2461}, rotation=-5e-05, flags=393224, model_state=0, animation_state=0, role="PerfectAlexander", layout=8136072, model=2783, model_attribute_flags=0, owner=nil, boss=true, targetable=false} , -- Boss
        a8 = {base=11347, name=9220, hp=3180181, level=80, pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, flags=393224, model_state=21, animation_state=0, role="AlexanderPrime", layout=8136070, model=1583, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- AlexanderPrime
        a9 = {base=9020, name=9220, hp=44, level=1, pos={x=97.3954, y=0.0, z=108.3706}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper01
        a10 = {base=9020, name=9220, hp=44, level=1, pos={x=100.0, y=0.0, z=85.0}, rotation=1.08037, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper02
        a11 = {base=9020, name=9220, hp=44, level=1, pos={x=100.0, y=0.0, z=115.0}, rotation=-2.01343, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper03
        a12 = {base=9020, name=9220, hp=44, level=1, pos={x=85.0, y=0.0, z=100.0}, rotation=0.44002, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper04
        a13 = {base=9020, name=9220, hp=44, level=1, pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a6", boss=false, targetable=false} , -- Helper05
        a14 = {base=9020, name=9220, hp=44, level=1, pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a6", boss=false, targetable=false} , -- Helper06
        a15 = {base=9020, name=9220, hp=44, level=1, pos={x=95.4037, y=0.0308, z=108.4593}, rotation=-1.14624, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a6", boss=false, targetable=false} , -- Helper07
        a21 = {base=11349, name=9042, hp=7535109, level=80, pos={x=99.9822, y=0.0, z=96.2461}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="PerfectAlexander", layout=8136072, model=2783, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- PerfectAlexander02
        a22 = {base=11349, name=9042, hp=7535109, level=80, pos={x=99.9822, y=0.0, z=96.2461}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="PerfectAlexander", layout=8136072, model=2783, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- PerfectAlexander03
        a24 = {base=11349, name=9042, hp=7535109, level=80, pos={x=99.9822, y=0.0, z=96.2461}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="PerfectAlexander", layout=8136072, model=2783, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- PerfectAlexander05
        a23 = {base=11349, name=9042, hp=7535109, level=80, pos={x=99.9822, y=0.0, z=96.2461}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="PerfectAlexander", layout=8136072, model=2783, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- PerfectAlexander04
        a26 = {base=11350, name=108, hp=38418, level=80, pos={x=87.8266, y=0.0, z=99.3561}, rotation=1.51852, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection02
        a25 = {base=11350, name=108, hp=38418, level=80, pos={x=100.7629, y=0.0, z=109.1918}, rotation=-3.05818, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection01
        a28 = {base=11350, name=108, hp=38418, level=80, pos={x=100.109, y=0.0, z=109.4952}, rotation=-2.98886, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection04
        a27 = {base=11350, name=108, hp=38418, level=80, pos={x=93.1199, y=0.0, z=109.3616}, rotation=2.88378, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection03
        a31 = {base=11350, name=108, hp=38418, level=80, pos={x=91.2974, y=0.0, z=103.8976}, rotation=1.99291, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection07
        a29 = {base=11350, name=108, hp=38418, level=80, pos={x=105.5241, y=0.0, z=102.6468}, rotation=-2.01822, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection05
        a30 = {base=11350, name=108, hp=38418, level=80, pos={x=107.7524, y=0.0, z=99.5531}, rotation=-1.5144, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection06
        a32 = {base=11350, name=108, hp=38418, level=80, pos={x=100.1501, y=0.0, z=92.1542}, rotation=0.08039, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection08
        a33 = {base=11350, name=108, hp=38418, level=80, pos={x=92.7119, y=0.0, z=102.9664}, rotation=1.95849, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection09
        a34 = {base=11350, name=108, hp=38418, level=80, pos={x=99.909, y=0.0, z=109.6217}, rotation=3.13277, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection10
        a35 = {base=11350, name=108, hp=38418, level=80, pos={x=95.3171, y=0.0, z=109.4705}, rotation=2.68331, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection11
        a36 = {base=11350, name=108, hp=38418, level=80, pos={x=100.3067, y=0.0, z=106.1411}, rotation=2.10662, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection12
        a37 = {base=11350, name=108, hp=38418, level=80, pos={x=100.2986, y=0.0, z=110.8001}, rotation=-3.13066, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection13
        a38 = {base=11350, name=108, hp=38418, level=80, pos={x=108.5132, y=0.0, z=93.2464}, rotation=-0.90118, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection14
        a39 = {base=11350, name=108, hp=38418, level=80, pos={x=100.8944, y=0.0, z=103.8776}, rotation=-2.9136, flags=264715, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection15
        a40 = {base=11350, name=108, hp=38418, level=80, pos={x=99.6474, y=0.0, z=89.5846}, rotation=0.03312, flags=262667, model_state=0, animation_state=0, role="FateProjection", layout=8136073, model=0, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- FateProjection16
    },
    death_effects = {},
}
