# 机工士（MCH）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 人偶独立属性和喷射器精确应用延迟待实机标定；低等级车式炮塔不在本次范围。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 2876 | 整备 | player | 1 | 851 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 2878 | 野火 | player | 1 | 861,1946 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 2887 | 武装解除 | player | 1 | 860 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7411 | 热分裂弹 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7412 | 热独头弹 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7413 | 热狙击弹 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7414 | 枪管加热 | player | 1 | 3864,3866 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7418 | 火焰喷射器 | player | 1 | 1205 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7551 | 伤头 | role | 0 |  | 共用脚本：resources/scripts/actions/075/HeadGraze_07551.lua |
| 7553 | 伤足 | role | 0 |  | 共用脚本：resources/scripts/actions/075/FootGraze_07553.lua |
| 7554 | 伤腿 | role | 0 |  | 共用脚本：resources/scripts/actions/075/LegGraze_07554.lua |
| 7557 | 速行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Peloton_07557.lua |
| 16497 | 自动弩 | player | 3 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16498 | 钻头 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16499 | 毒菌冲击 | player | 1 | 1866 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16500 | 空气锚 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16501 | 后式自走人偶 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/effects.rs |
| 16502 | 超档后式人偶 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/effects.rs |
| 16503 | 打桩枪 | pet | 1 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16504 | 铁臂拳 | pet | 2 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16766 | 起爆 | replacement | 0 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 16889 | 策动 | player | 1 | 1951 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 17206 | 滚轮冲 | pet | 1 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 17209 | 超荷 | player | 1 | 2688 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 25786 | 霰弹枪 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 25787 | 王室对撞机 | pet | 1 |  | 原生：servers/world/src/server/jobs/machinist/actors.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 25788 | 回转飞锯 | player | 1 | 3865 | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 36978 | 烈焰弹 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 36979 | 双将 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 36980 | 将死 | player | 2 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 36981 | 掘地飞轮 | replacement | 1 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |
| 36982 | 全金属爆发 | player | 1 |  | 原生：servers/world/src/server/jobs/machinist/effects.rs、servers/world/src/server/jobs/machinist/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 117 | 技能伤害提高 / 20 | 除自动攻击外的技能造成的伤害提高至基本伤害的1.1倍，自身设置的浮空炮塔造成的伤害也提高至基本伤害的1.1倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 119 | 技能伤害提高II / 40 | 除自动攻击外的技能造成的伤害提高至基本伤害的1.2倍，自身设置的浮空炮塔造成的伤害也提高至基本伤害的1.2倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 288 | 分裂弹精通 / 54 | 分裂弹变为热分裂弹 | machinist 职业资源、变招、威力和效果 |
| 289 | 独头弹精通 / 60 | 独头弹变为热独头弹 | machinist 职业资源、变招、威力和效果 |
| 290 | 狙击弹精通 / 64 | 狙击弹变为热狙击弹 | machinist 职业资源、变招、威力和效果 |
| 603 | 热冲击精通 / 68 | 热冲击变为烈焰弹 | machinist 职业资源、变招、威力和效果 |
| 292 | 积蓄技能效果提高 / 74 | 虹吸弹和弹射积蓄次数增加到3次 | machinist + gamedata.rs 充能查询 |
| 291 | 热弹精通 / 76 | 热弹变为空气锚 | machinist 职业资源、变招、威力和效果 |
| 293 | 野火效果提高 / 78 | 野火的“每命中1次战技的威力”提高到240 | machinist 职业资源、变招、威力和效果 |
| 294 | 升变 / 80 | 车式浮空炮塔变为后式自走人偶，超档车式炮塔变为超档后式人偶 | machinist 职业资源、变招、威力和效果 |
| 449 | 散射精通 / 82 | 散射变为霰弹枪 | machinist 职业资源、变招、威力和效果 |
| 450 | 整备效果提高 / 84 | 整备变为积蓄技能<br>积蓄次数：2 | machinist + gamedata.rs 充能查询 |
| 517 | 技能威力提高 / 84 | 部分技能的威力提高<br><br>热分裂弹的威力：200<br>热独头弹的威力：120<br>热狙击弹的威力：120 | machinist 职业资源、变招、威力和效果 |
| 451 | 后翼弃兵 / 86 | 后式自走人偶发动打桩枪后，接着发动王室对撞机后消失 | machinist 职业资源、变招、威力和效果 |
| 452 | 策动效果提高 / 88 | 策动的复唱时间缩短到90秒 | machinist 职业资源、变招、威力和效果 |
| 604 | 积蓄技能精通 / 92 | 虹吸弹变为双将，弹射变为将死 | machinist 职业资源、变招、威力和效果 |
| 605 | 多种武器效果提高 / 94 | 钻头和毒菌冲击变为积蓄技能<br>积蓄次数：2 | machinist + gamedata.rs 充能查询 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 658 | 技能威力提高II / 94 | 部分技能的威力提高<br><br>自动弩的威力：180<br>钻头的威力：660<br>热分裂弹的威力：220<br>热独头弹的威力：140<br>热狙击弹的威力：160<br>烈焰弹的威力：240<br>空气锚的威力：660<br>回转飞锯的威力：660 | machinist 职业资源、变招、威力和效果 |
| 606 | 多种武器效果提高II / 96 | 对自身附加掘地飞轮预备状态<br>持续时间：30秒<br>发动条件：回转飞锯发动时<br>持续时间内，回转飞锯变为掘地飞轮 | machinist 职业资源、变招、威力和效果 |
| 607 | 策动效果提高II / 98 | 策动的效果量提高到15% | machinist 职业资源、变招、威力和效果 |
| 608 | 枪管加热效果提高 / 100 | 对自身附加全金属爆发预备状态<br>持续时间：30秒<br>发动条件：枪管加热发动时 | machinist 职业资源、变招、威力和效果 |

## 输入录像

- arr/机工.dat：本人量谱 已确认，SHA-256 `4984c2fd86c21fd335bfd4a33b1c1ee1721064d40e6c49bc3a8e30f003010baa`。
