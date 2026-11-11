# 暗黑骑士（DRK）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 掠影的独立属性与精确动作时点仍需实机标定。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 3617 | 重斩 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3621 | 释放 | player | 3 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3623 | 吸收斩 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3624 | 伤残 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3629 | 深恶痛绝 | player | 1 | 743 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3632 | 噬魂斩 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3634 | 弃明投暗 | player | 1 | 746 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3638 | 行尸走肉 | player | 1 | 810 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3639 | 腐秽大地 | player | 1 | 749 | 原生：servers/world/src/server/jobs/dark_knight/actors.rs、servers/world/src/server/jobs/dark_knight/effects.rs |
| 3641 | 吸血深渊 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 3643 | 精雕怒斩 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 7390 | 血乱 | player | 1 | 742,3836 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 7391 | 寂灭 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 7392 | 血溅 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 7393 | 至黑之夜 | player | 1 | 1178 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 7531 | 铁壁 | role | 1 | 1191 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7533 | 挑衅 | role | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7535 | 雪仇 | role | 1 | 1193 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7537 | 退避 | role | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7538 | 插言 | role | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7540 | 下踢 | role | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 7548 | 亲疏自行 | role | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs |
| 16468 | 刚魂 | player | 3 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 16469 | 暗影波动 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 16470 | 暗影锋 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 16471 | 暗黑布道 | player | 1 | 1894 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 16472 | 掠影示现 | player | 1 | 3837 | 原生：servers/world/src/server/jobs/dark_knight/actors.rs、servers/world/src/server/jobs/dark_knight/effects.rs |
| 25754 | 献奉 | player | 1 | 2682 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 25755 | 腐秽黑暗 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/actors.rs、servers/world/src/server/jobs/dark_knight/effects.rs |
| 25757 | 暗影使者 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36926 | 暗影步 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36927 | 暗影卫 | player | 1 | 3835,3902 | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36928 | 血红乱 | replacement | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36929 | 报应 | replacement | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36930 | 戮山 | replacement | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36931 | 刺穿 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36932 | 掠影的蔑视 | player | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/effects.rs、servers/world/src/server/jobs/dark_knight/mod.rs |
| 36933 | 掠影的蔑视 | pet | 1 |  | 原生：servers/world/src/server/jobs/dark_knight/actors.rs、servers/world/src/server/jobs/dark_knight/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 319 | 防护精通 / 1 | 将自身所受的伤害减轻20%<br>另外，随耐力提升的最大体力值和随力量提升的伤害量将受到防护职业专属修正的影响 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 158 | 暗血 / 62 | 可获得暗血量值<br>发动条件：特定技能命中时 | dark_knight 职业资源、变招、威力和效果 |
| 159 | 暗血II / 66 | 可获得暗血量值<br>发动条件：嗜血状态中发动战技或魔法命中时 | dark_knight 职业资源、变招、威力和效果 |
| 570 | 嗜血精通 / 68 | 嗜血变为血乱 | dark_knight 职业资源、变招、威力和效果 |
| 271 | 暗黑精通 / 74 | 暗黑波动变为暗影波动，暗黑锋变为暗影锋 | dark_knight 职业资源、变招、威力和效果 |
| 422 | 伤残效果提高 / 84 | 暗影步的复唱时间缩短5秒<br>发动条件：伤残命中敌人时，部分特定敌人除外 | dark_knight 职业资源、变招、威力和效果 |
| 506 | 技能威力提高 / 84 | 部分技能的威力提高<br><br>重斩的威力：180<br>吸收斩的威力：120<br>噬魂斩的威力：140 | dark_knight 职业资源、变招、威力和效果 |
| 511 | 掠影示现效果提高 / 88 | 英雄的掠影发动攻击的威力提高至420 | dark_knight 职业资源、变招、威力和效果 |
| 423 | 掠影示现效果提高II / 90 | 英雄的掠影发动的暗影波动变为暗影使者<br><br>向目标所在方向发出无属性直线范围魔法攻击　威力：570<br>攻击复数敌人时，对目标之外的敌人威力降低25% | dark_knight 职业资源、变招、威力和效果 |
| 571 | 暗影墙精通 / 92 | 暗影墙变为暗影卫 | dark_knight 职业资源、变招、威力和效果 |
| 639 | 铁壁效果提高 / 94 | 增加“自身所受的体力恢复效果提高15%”的效果 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 663 | 技能威力提高II / 94 | 部分技能的威力提高<br><br>重斩的威力：300<br>吸收斩的威力：240<br>噬魂斩的威力：260<br>刚魂的威力：120<br>精雕怒斩的威力：540<br>血溅的威力：600<br>寂灭的威力：240 | dark_knight 职业资源、变招、威力和效果 |
| 572 | 血乱效果提高 / 96 | 血溅变为血红乱，寂灭变为刺穿<br>发动条件：血乱状态中 | dark_knight 职业资源、变招、威力和效果 |
| 640 | 雪仇效果提高 / 98 | 雪仇的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 573 | 掠影示现效果提高III / 100 | 对自身附加掠影的蔑视预备状态<br>持续时间：30秒<br>发动条件：掠影示现发动时<br><br>另外，英雄的掠影发动的精雕怒斩变为掠影的蔑视<br><br>向目标所在方向发出无属性直线范围物理攻击　威力：620<br>攻击复数敌人时，对第一个之外的敌人威力降低25% | dark_knight 职业资源、变招、威力和效果 |

## 输入录像

- arr/暗黑骑士.dat：本人量谱 已确认，SHA-256 `26001edbe9e1be6668d4ab5e0be311ee45a876076262a3faf6cdf90c0a1512f4`。
