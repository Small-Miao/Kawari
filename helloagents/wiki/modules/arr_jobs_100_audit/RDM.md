# 赤魔法师（RDM）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 复活确认服务端已补齐，尚未部署/实机验收；实际位移和全技能演出待验收。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7504 | 回刺 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7506 | 短兵相接 | player | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7510 | 赤火炎 | player | 5 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7511 | 赤飞石 | player | 4 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7512 | 交击斩 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7513 | 划圆斩 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7514 | 赤治疗 | player | 0 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7515 | 移转 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7516 | 连攻 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7517 | 飞刺 | player | 5 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7518 | 促进 | player | 4 | 1238,3877 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7519 | 六分反击 | player | 3 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7520 | 鼓励 | player | 1 | 1239,3876 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7521 | 魔元化 | player | 2 | 1971,3875,3878 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7523 | 赤复活 | player | 0 |  | 原生：servers/world/src/server/jobs/red_mage/mod.rs |
| 7525 | 赤核爆 | replacement | 2 | 1234 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7526 | 赤神圣 | replacement | 2 | 1235 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7527 | 魔回刺 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7528 | 魔交击斩 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7529 | 魔连攻 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7530 | 魔划圆斩·一段 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 7559 | 沉稳咏唱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Surecast_07559.lua |
| 7560 | 昏乱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Addle_007560.lua |
| 7561 | 即刻咏唱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Swiftcast_07561.lua |
| 7562 | 醒梦 | role | 2 | 1204 | 共用脚本：resources/scripts/actions/075/LucidDreaming_07562.lua |
| 16524 | 赤震雷 | player | 9 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16525 | 赤烈风 | player | 9 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16526 | 冲击 | player | 4 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16527 | 交剑 | player | 3 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16528 | 魔续斩 | replacement | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16529 | 续斩 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 16530 | 焦热 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 25855 | 赤暴雷 | player | 5 | 1234 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 25856 | 赤暴风 | player | 6 | 1235 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 25857 | 抗死 | player | 2 | 2707 | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 25858 | 决断 | replacement | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 25880 | 催眠 | role | 0 |  | 共用脚本：resources/scripts/actions/025/Sleep_25880.lua |
| 37002 | 魔划圆斩·二段 | replacement | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 37003 | 魔划圆斩·三段 | replacement | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 37004 | 激荡 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 37005 | 荆棘环绕 | player | 1 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 37006 | 显贵冲击 | replacement | 3 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |
| 37007 | 光芒四射 | player | 2 |  | 原生：servers/world/src/server/jobs/red_mage/effects.rs、servers/world/src/server/jobs/red_mage/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 216 | 连续咏唱 / 1 | 发动有咏唱时间的魔法时，对自身附加连续咏唱状态<br>持续时间：15秒<br>连续咏唱效果：下次咏唱魔法不需要咏唱时间<br>若在持续时间中发动自动攻击或能力之外的技能，会立即解除连续咏唱状态 | red_mage 职业资源、变招、威力和效果 |
| 200 | 技能效果提高 / 20 | 除自动攻击外的技能造成的伤害提高至基本值的1.1倍，恢复技能的恢复量也提高至基本值的1.1倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 201 | 技能效果提高II / 40 | 除自动攻击外的技能造成的伤害提高至基本值的1.3倍，恢复技能的恢复量也提高至基本值的1.3倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 195 | 摇荡效果提高 / 62 | 摇荡变为震荡<br>将赤闪雷和赤疾风的威力提高到360<br>将赤火炎和赤飞石的威力提高到300 | red_mage 职业资源、变招、威力和效果 |
| 303 | 散碎精通 / 66 | 散碎变为冲击 | red_mage 职业资源、变招、威力和效果 |
| 482 | 魔法剑效果提高 / 68 | 对自身附加魔元集状态<br>最大档数：3档<br>当魔元集累积3档时，赤闪雷与赤震雷变为赤核爆<br>当学会赤神圣后，赤疾风与赤烈风变为赤神圣<br>发动条件：魔回刺、魔交击斩、魔连攻、魔划圆斩·一段、魔划圆斩·二段、魔划圆斩·三段命中时 | red_mage 职业资源、变招、威力和效果 |
| 304 | 移转效果提高 / 72 | 移转的威力提高到180 | red_mage 职业资源、变招、威力和效果 |
| 306 | 赤魔法精通 / 74 | 六分反击的复唱时间缩短到35秒<br>另外，部分技能的威力提高<br><br>赤震雷的威力：120<br>赤烈风的威力：120 | red_mage 职业资源、变招、威力和效果 |
| 483 | 赤魔法精通II / 82 | 赤闪雷变为赤暴雷，赤疾风变为赤暴风<br>魔元集累积3档时，赤暴雷变为赤核爆，赤暴风变为赤神圣 | red_mage 职业资源、变招、威力和效果 |
| 484 | 赤魔法精通III / 84 | 震荡变为激荡<br>另外，部分技能的威力提高<br><br>魔回刺的威力：280<br>赤震雷的威力：140<br>赤烈风的威力：140<br>赤火炎的威力：340<br>赤飞石的威力：340<br>魔交击斩的威力：150<br>魔连攻的威力：130<br>冲击的威力：210<br>魔续斩的威力：340 | red_mage 职业资源、变招、威力和效果 |
| 485 | 促进效果提高 / 88 | 促进变为积蓄技能<br>积蓄次数：2 | red_mage + gamedata.rs 充能查询 |
| 620 | 鼓励效果提高 / 92 | 对自身附加荆棘环绕预备状态<br>持续时间：30秒<br>发动条件：鼓励发动时 | red_mage 职业资源、变招、威力和效果 |
| 644 | 即刻咏唱效果提高 / 94 | 即刻咏唱的复唱时间缩短到40秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 652 | 技能威力提高 / 94 | 部分技能的威力提高<br><br>魔回刺的威力：340<br>赤火炎的威力：380<br>赤飞石的威力：380<br>魔交击斩的威力：190<br>飞刺的威力：480<br>魔连攻的威力：190<br>六分反击的威力：420<br>赤核爆的威力：650<br>赤神圣的威力：650<br>魔续斩的威力：420<br>焦热的威力：750<br>赤暴风的威力：440<br>赤暴雷的威力：440<br>决断的威力：850 | red_mage 职业资源、变招、威力和效果 |
| 621 | 促进效果提高II / 96 | 对自身附加显贵冲击预备状态<br>持续时间：30秒<br>发动条件：促进发动时<br>持续时间内，激荡和冲击变为显贵冲击 | red_mage 职业资源、变招、威力和效果 |
| 643 | 昏乱效果提高 / 98 | 昏乱的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 622 | 魔元化效果提高 / 100 | 对自身附加光芒四射预备状态<br>持续时间：30秒<br>发动条件：发动魔元化时<br>持续时间内，魔元化变为光芒四射 | red_mage 职业资源、变招、威力和效果 |

## 输入录像

- arr/赤魔.dat：本人量谱 已确认，SHA-256 `e743be6f86d381f555fcc2b8be3cc42660e53751b72ea8e3b1293b578abe0139`。
