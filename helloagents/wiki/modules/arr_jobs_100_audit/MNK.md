# 武僧（MNK）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 范围战技多目标暴击的斗气次数当前按每次技能最多一次，仍需专项证据。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 61 | 双掌打 | player | 5 | 109 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 65 | 真言 | player | 2 | 102 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 66 | 破碎拳 | player | 3 | 107 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 69 | 震脚 | player | 8 | 110 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 70 | 地烈劲 | player | 2 | 107 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 74 | 双龙脚 | player | 11 | 108 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 3547 | 阴阳斗气斩 | player | 5 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 4262 | 演武 | player | 3 | 2513 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 7394 | 金刚极意 | player | 2 | 1179,3841 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 7395 | 红莲极意 | player | 2 | 1181,3843 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 7396 | 义结金兰 | player | 2 | 1182,1185 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7542 | 浴血 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Bloodbath_07542.lua |
| 7546 | 真北 | role | 0 |  | 共用脚本：resources/scripts/actions/075/TrueNorth_07546.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7549 | 牵制 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Feint_07549.lua |
| 7863 | 扫腿 | role | 0 |  | 共用脚本：resources/scripts/actions/078/LegSweep_07863.lua |
| 16473 | 四面脚 | player | 2 | 109 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 16474 | 万象斗气圈 | player | 3 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 16476 | 六合星导脚 | player | 2 | 2514 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 25762 | 轻身步法 | player | 2 |  | 原生：servers/world/src/server/jobs/monk/mod.rs |
| 25764 | 必杀技 | player | 0 |  | 原生：servers/world/src/server/jobs/monk/mod.rs |
| 25765 | 翻天脚 | replacement | 2 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 25766 | 疾风极意 | player | 2 | 2687,3842 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 25767 | 破坏神脚 | player | 3 | 108 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 25768 | 凤凰舞 | replacement | 2 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 25769 | 梦幻斗舞 | replacement | 2 | 2513 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36942 | 阴阳斗气 | player | 5 |  | 原生：servers/world/src/server/jobs/monk/mod.rs |
| 36943 | 万象斗气 | player | 5 |  | 原生：servers/world/src/server/jobs/monk/mod.rs |
| 36944 | 金刚周天 | player | 2 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36945 | 猿舞连击 | player | 9 | 108 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36946 | 龙颚正拳 | player | 3 | 109 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36947 | 豹袭崩拳 | player | 4 | 107 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36948 | 真空波 | replacement | 2 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36949 | 绝空拳 | player | 2 |  | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |
| 36950 | 乾坤斗气弹 | player | 2 | 2513 | 原生：servers/world/src/server/jobs/monk/effects.rs、servers/world/src/server/jobs/monk/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 364 | 疾风迅雷 / 1 | 自动攻击间隔、战技与魔法的咏唱及复唱时间缩短5% | monk 职业资源、变招、威力和效果 |
| 365 | 疾风迅雷效果提高 / 20 | 自动攻击间隔、战技与魔法的咏唱及复唱时间缩短10% | monk 职业资源、变招、威力和效果 |
| 160 | 斗气积累提高 / 38 | 对自身附加斗气状态<br>发动条件：战技暴击时（发动几率80%） | monk 职业资源、变招、威力和效果 |
| 366 | 疾风迅雷效果提高II / 40 | 自动攻击间隔、战技与魔法的咏唱及复唱时间缩短15% | monk 职业资源、变招、威力和效果 |
| 428 | 铁山靠精通 / 54 | 铁山斗气变为阴阳斗气，铁山靠变为阴阳斗气斩 | monk 职业资源、变招、威力和效果 |
| 433 | 震脚效果提高 / 60 | 自身发动魔猿身形、盗龙身形、猛豹身形的战技时，获得对应的脉轮<br>魔猿身形的战技：猛豹脉轮<br>盗龙身形的战技：魔猿脉轮<br>猛豹身形的战技：盗龙脉轮<br>发动条件：震脚状态中 | monk 职业资源、变招、威力和效果 |
| 245 | 斗气积累提高II / 74 | 对自身附加斗气状态的几率上升到100%<br>发动条件：战技暴击时 | monk 职业资源、变招、威力和效果 |
| 429 | 空鸣拳精通 / 74 | 空鸣斗气变为万象斗气，空鸣拳变为万象斗气圈 | monk 职业资源、变招、威力和效果 |
| 367 | 疾风迅雷效果提高III / 76 | 自动攻击间隔、战技与魔法的咏唱及复唱时间缩短20% | monk 职业资源、变招、威力和效果 |
| 430 | 破坏神冲精通 / 82 | 破坏神冲变为破坏神脚 | monk 职业资源、变招、威力和效果 |
| 431 | 轻身步法效果提高 / 84 | 轻身步法的积蓄次数增加到3次 | monk + gamedata.rs 充能查询 |
| 518 | 技能威力提高 / 84 | 部分技能的威力提高<br><br>连击的威力：220<br>正拳的威力：300<br>崩拳的威力：270<br>双掌打的威力：380<br>破碎拳的威力：320<br>双龙脚的威力：280<br>阴阳斗气斩的威力：400 | monk 职业资源、变招、威力和效果 |
| 512 | 爆裂脚精通 / 86 | 爆裂脚变为凤凰舞 | monk 职业资源、变招、威力和效果 |
| 432 | 义结金兰效果提高 / 88 | 义结金兰：斗气状态下必定对自身附加斗气 | monk 职业资源、变招、威力和效果 |
| 513 | 斗魂旋风脚精通 / 90 | 斗魂旋风脚变为梦幻斗舞 | monk 职业资源、变招、威力和效果 |
| 577 | 象形拳 / 92 | 连击变为猿舞连击、正拳变为龙颚正拳、崩拳变为豹袭崩拳、苍气炮变为真空波 | monk 职业资源、变招、威力和效果 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 660 | 技能威力提高II / 94 | 部分技能的威力提高<br><br>双掌打的威力：420<br>破碎拳的威力：360<br>双龙脚的威力：320<br>六合星导脚的威力：780<br>梦幻斗舞的威力：1500 | monk 职业资源、变招、威力和效果 |
| 578 | 疾风极意效果提高 / 96 | 对自身附加绝空拳预备状态<br>持续时间：15秒<br>发动条件：疾风极意发动时 | monk 职业资源、变招、威力和效果 |
| 641 | 牵制效果提高 / 98 | 牵制的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 579 | 红莲极意效果提高 / 100 | 对自身附加乾坤斗气弹预备状态<br>持续时间：20秒<br>发动条件：红莲极意发动时 | monk 职业资源、变招、威力和效果 |

## 输入录像

- arr/武僧.dat：本人量谱 不适用（旁观），SHA-256 `8aa0d081564c85d6a88540f6270ac6d334ba3f602b99588f9e16f139c027cfa4`。
- 军工要地克吕提俄斯魔导工厂 2026.11.11 13.21.01.dat：本人量谱 已确认，SHA-256 `8f85807f8204352a9e02d2304c576490a529ac166ae25420e664c9f111555e0b`。
