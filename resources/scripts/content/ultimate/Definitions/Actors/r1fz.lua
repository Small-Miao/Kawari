-- 演员命名和模板；创建/移动/施法时点分别见同名机制的 Sequences。
return {
    boss = "a18",
    boss_base = 12616,
    director_flag = 1,
    names = {
        Helper01 = "a1", -- BNpcBase 9020
        Helper02 = "a2", -- BNpcBase 9020
        Helper03 = "a3", -- BNpcBase 9020
        Helper04 = "a4", -- BNpcBase 9020
        Helper05 = "a5", -- BNpcBase 9020
        Helper06 = "a6", -- BNpcBase 9020
        Helper07 = "a7", -- BNpcBase 9020
        Helper08 = "a8", -- BNpcBase 9020
        Helper09 = "a9", -- BNpcBase 9020
        Helper10 = "a10", -- BNpcBase 9020
        HraesvelgrP6 = "a11", -- BNpcBase 12613
        NidhoggP6 = "a12", -- BNpcBase 12612
        RightEye = "a13", -- BNpcBase 12610
        LeftEye01 = "a14", -- BNpcBase 12609
        Estinien = "a15", -- BNpcBase 13119
        Alphinaud = "a16", -- BNpcBase 13769
        BossP5 = "a17", -- BNpcBase 12611
        Boss = "a18", -- BNpcBase 12616
        LeftEye02 = "a19", -- BNpcBase 12609
        LeftEye03 = "a20", -- BNpcBase 12609
    },
    initial = {"a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12"},
    templates = {
        a1 = {base=9020, name=3642, hp=44, level=1, pos={x=108.4853, y=-0.0, z=91.5147}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper01
        a2 = {base=9020, name=3642, hp=44, level=1, pos={x=100.0, y=0.0, z=100.0}, rotation=-2.36836, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper02
        a3 = {base=9020, name=3642, hp=44, level=1, pos={x=100.0, y=0.0, z=100.0}, rotation=0.01002, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper03
        a4 = {base=9020, name=3642, hp=44, level=1, pos={x=83.1617, y=-0.0, z=88.6463}, rotation=-0.42679, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper04
        a5 = {base=9020, name=3642, hp=44, level=1, pos={x=110.374, y=-0.0, z=89.8522}, rotation=-1.26714, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper05
        a6 = {base=9020, name=3642, hp=44, level=1, pos={x=114.6972, y=-0.0, z=82.0039}, rotation=-3.03901, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper06
        a7 = {base=9020, name=3642, hp=44, level=1, pos={x=78.0, y=0.0, z=100.0}, rotation=2.12905, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper07
        a8 = {base=9020, name=3642, hp=44, level=1, pos={x=78.0, y=0.0, z=100.0}, rotation=0.70444, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper08
        a9 = {base=9020, name=3642, hp=44, level=1, pos={x=78.0, y=0.0, z=100.0}, rotation=1.9026, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper09
        a10 = {base=9020, name=3642, hp=44, level=1, pos={x=99.7941, y=-0.0, z=83.0291}, rotation=-0.49965, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a12", boss=false, targetable=false} , -- Helper10
        a11 = {base=12613, name=4954, hp=4535368, level=90, pos={x=100.0, y=0.0, z=125.0}, rotation=-3.14159, flags=393227, model_state=27, animation_state=0, role="HraesvelgrP6", layout=8904725, model=3386, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- HraesvelgrP6
        a12 = {base=12612, name=3458, hp=4535368, level=90, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, flags=393227, model_state=27, animation_state=0, role="NidhoggP6", layout=8981065, model=3444, model_attribute_flags=16, owner=nil, boss=false, targetable=false} , -- NidhoggP6
        a13 = {base=12610, name=11318, hp=4860608, level=90, pos={x=97.9781, y=-0.0153, z=99.9923}, rotation=0.78536, flags=393227, model_state=28, animation_state=0, role="RightEye", layout=8904700, model=3141, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- RightEye
        a14 = {base=12609, name=11317, hp=3979000, level=90, pos={x=102.0, y=-0.0, z=100.0}, rotation=-0.78546, flags=393227, model_state=28, animation_state=0, role="LeftEye", layout=8904699, model=3140, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- LeftEye01
        a15 = {base=13119, name=11312, hp=6920000, level=90, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, flags=393227, model_state=5, animation_state=0, role="Estinien", layout=8904694, model=3291, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Estinien
        a16 = {base=13769, name=4130, hp=69200, level=90, pos={x=100.0, y=0.0, z=110.0}, rotation=-3.14159, flags=393736, model_state=0, animation_state=0, role="Alphinaud", layout=8904696, model=3499, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Alphinaud
        a17 = {base=12611, name=3632, hp=5821796, level=90, pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="BossP5", layout=8904724, model=3269, model_attribute_flags=16, owner=nil, boss=false, targetable=false} , -- BossP5
        a18 = {base=12616, name=11319, hp=12178508, level=90, pos={x=100.0, y=0.0, z=88.0}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="DragonKingThordan", layout=8954831, model=2969, model_attribute_flags=0, owner=nil, boss=true, targetable=false} , -- Boss
        a19 = {base=12609, name=108, hp=3979000, level=90, pos={x=104.0, y=0.0, z=122.0}, rotation=-3.14159, flags=262155, model_state=5, animation_state=0, role="LeftEye", layout=9278010, model=3140, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- LeftEye02
        a20 = {base=12609, name=108, hp=3979000, level=90, pos={x=105.0, y=0.0, z=120.5}, rotation=-3.14159, flags=262155, model_state=5, animation_state=0, role="LeftEye", layout=9278010, model=3140, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- LeftEye03
    },
    death_effects = {},
}
