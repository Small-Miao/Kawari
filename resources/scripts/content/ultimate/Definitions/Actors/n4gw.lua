-- 演员命名和模板；创建/移动/施法时点分别见同名机制的 Sequences。
return {
    boss = "a19",
    boss_base = 17839,
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
        VisionOfGaia = "a15", -- BNpcBase 17845
        VisionOfRyne = "a16", -- BNpcBase 17844
        OracleOfDarknessP4 = "a17", -- BNpcBase 17835
        UsurperOfFrostP4 = "a18", -- BNpcBase 17833
        Boss = "a19", -- BNpcBase 17839
    },
    initial = {"a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11", "a12", "a13", "a14", "a15", "a16", "a17", "a18"},
    templates = {
        a15 = {base=17845, name=9830, hp=188300, level=100, pos={x=99.2876, y=0.0, z=84.0}, rotation=1.22169, flags=393739, model_state=31, animation_state=0, role="VisionOfGaia", layout=10858276, model=4436, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- VisionOfGaia
        a16 = {base=17844, name=9829, hp=188300, level=100, pos={x=100.7124, y=0.0, z=84.0}, rotation=-0.83781, flags=393738, model_state=5, animation_state=0, role="VisionOfRyne", layout=10858275, model=2720, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- VisionOfRyne
        a17 = {base=17835, name=9832, hp=11943869, level=100, pos={x=103.5325, y=0.0153, z=99.9924}, rotation=0.78536, flags=393227, model_state=0, animation_state=0, role="OracleOfDarknessP4", layout=10836994, model=3057, model_attribute_flags=0, owner=nil, boss=false, targetable=false} , -- OracleOfDarknessP4
        a18 = {base=17833, name=12809, hp=11943869, level=100, pos={x=96.4523, y=0.0153, z=99.9924}, rotation=-0.78546, flags=393227, model_state=4, animation_state=0, role="UsurperOfFrostP4", layout=10836993, model=4375, model_attribute_flags=252, owner=nil, boss=false, targetable=false} , -- UsurperOfFrostP4
        a1 = {base=9020, name=9707, hp=44, level=1, pos={x=92.7744, y=0.0, z=93.0652}, rotation=1.10281, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper01
        a2 = {base=9020, name=9707, hp=44, level=1, pos={x=92.9311, y=0.0, z=93.0115}, rotation=1.08794, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper02
        a3 = {base=9020, name=9707, hp=44, level=1, pos={x=106.1246, y=0.0, z=93.9212}, rotation=-2.65052, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper03
        a4 = {base=9020, name=9707, hp=44, level=1, pos={x=107.1324, y=0.0, z=92.9505}, rotation=-1.08957, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper04
        a5 = {base=9020, name=9707, hp=44, level=1, pos={x=93.0754, y=0.0, z=92.9467}, rotation=1.07213, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper05
        a6 = {base=9020, name=9707, hp=44, level=1, pos={x=92.4591, y=0.0, z=92.9938}, rotation=1.1123, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper06
        a7 = {base=9020, name=9707, hp=44, level=1, pos={x=100.0, y=0.04, z=100.0}, rotation=-3.14159, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper07
        a8 = {base=9020, name=9707, hp=44, level=1, pos={x=100.0, y=0.04, z=100.0}, rotation=-3.14159, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper08
        a9 = {base=9020, name=9707, hp=44, level=1, pos={x=100.0, y=0.04, z=100.0}, rotation=-3.14159, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper09
        a10 = {base=9020, name=9707, hp=44, level=1, pos={x=100.0, y=0.0, z=90.0}, rotation=-3.14159, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper10
        a11 = {base=9020, name=9707, hp=44, level=1, pos={x=99.9993, y=0.0, z=104.8233}, rotation=3.10717, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper11
        a12 = {base=9020, name=9707, hp=44, level=1, pos={x=99.8887, y=0.0, z=103.2928}, rotation=-0.08193, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper12
        a13 = {base=9020, name=9707, hp=44, level=1, pos={x=99.8047, y=0.0, z=103.7985}, rotation=-0.04684, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a17", boss=false, targetable=false} , -- Helper13
        a14 = {base=9020, name=9707, hp=44, level=1, pos={x=100.0, y=0.0, z=100.0}, rotation=-3.14159, flags=262152, model_state=0, animation_state=0, role="Helper", layout=0, model=480, model_attribute_flags=0, owner="a18", boss=false, targetable=false} , -- Helper14
        a19 = {base=17839, name=13561, hp=48541857, level=100, pos={x=100.0, y=0.0, z=100.0}, rotation=-5e-05, flags=393227, model_state=0, animation_state=0, role="BossP5", layout=10836998, model=4293, model_attribute_flags=0, owner=nil, boss=true, targetable=false} , -- Boss
    },
    death_effects = {},
}
