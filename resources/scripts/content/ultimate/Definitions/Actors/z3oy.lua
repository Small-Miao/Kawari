-- 演员命名和模板；创建/移动/施法时点分别见同名机制的 Sequences。
return {
    boss = "a18",
    boss_base = 19511,
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
        Helper11 = "a11", -- BNpcBase 9020
        Helper12 = "a12", -- BNpcBase 9020
        Helper13 = "a13", -- BNpcBase 9020
        Helper14 = "a14", -- BNpcBase 9020
        Helper15 = "a15", -- BNpcBase 9020
        Helper16 = "a16", -- BNpcBase 9020
        KefkaP4 = "a17", -- BNpcBase 18475
        Boss = "a18", -- BNpcBase 19511
    },
    initial = {"a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17"},
    templates = {
        a1 = {base=9020, name=7131, hp=44, level=1, pos={x=100.0, y=0.0, z=90.0}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper01
        a2 = {base=9020, name=7131, hp=44, level=1, pos={x=100.0, y=0.0, z=90.0}, rotation=-5e-05, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper02
        a3 = {base=9020, name=7131, hp=44, level=1, pos={x=89.3934, y=0.0, z=82.3223}, rotation=0.78536, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper03
        a4 = {base=9020, name=7131, hp=44, level=1, pos={x=96.4645, y=0.0, z=75.2513}, rotation=0.78536, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper04
        a5 = {base=9020, name=7131, hp=44, level=1, pos={x=75.2513, y=0.0, z=96.4645}, rotation=0.78536, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper05
        a6 = {base=9020, name=7131, hp=44, level=1, pos={x=82.3223, y=0.0, z=89.3934}, rotation=0.78536, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper06
        a7 = {base=9020, name=7131, hp=44, level=1, pos={x=100.0, y=0.0, z=100.0}, rotation=-2.35628, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper07
        a8 = {base=9020, name=7131, hp=44, level=1, pos={x=100.0, y=0.0, z=100.0}, rotation=0.78536, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper08
        a9 = {base=9020, name=7131, hp=44, level=1, pos={x=99.8414, y=0.0, z=100.1266}, rotation=2.29808, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper09
        a10 = {base=9020, name=7131, hp=44, level=1, pos={x=99.9989, y=0.0, z=99.9607}, rotation=-0.20599, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper10
        a11 = {base=9020, name=7131, hp=44, level=1, pos={x=99.7313, y=0.0, z=100.0749}, rotation=1.87709, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper11
        a12 = {base=9020, name=7131, hp=44, level=1, pos={x=100.0656, y=0.0, z=100.2862}, rotation=-2.89711, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper12
        a13 = {base=9020, name=7131, hp=44, level=1, pos={x=100.2621, y=0.0, z=100.1627}, rotation=-3.13268, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper13
        a14 = {base=9020, name=7131, hp=44, level=1, pos={x=99.877, y=0.0, z=100.6999}, rotation=2.98004, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper14
        a15 = {base=9020, name=7131, hp=44, level=1, pos={x=99.9731, y=0.0, z=100.0171}, rotation=2.48216, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper15
        a16 = {base=9020, name=7131, hp=44, level=1, pos={x=99.8723, y=0.0, z=99.8431}, rotation=0.67731, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- Helper16
        a17 = {base=18475, name=7131, hp=42678195, level=100, pos={x=99.9924, y=-0.0153, z=99.9924}, rotation=3.10746, flags=393227, model_state=0, animation_state=0, role="KefkaP4", layout=12743243, model=4966, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- KefkaP4
        a18 = {base=19511, name=7131, hp=56943803, level=100, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="UltimaKefka", layout=12326701, model=4965, model_attribute_flags=0, owner=nil, boss=true, targetable=false} , -- Boss
    },
    death_effects = {},
}
