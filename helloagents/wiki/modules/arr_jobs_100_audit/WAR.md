# 战士（WAR）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 动作、资源及队伍结算已有回归；全技能视觉尚未实机验收。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 31 | 重劈 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 37 | 凶残裂 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 40 | 战栗 | player | 1 | 87 | 原生：servers/world/src/server/jobs/warrior.rs |
| 41 | 超压斧 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 42 | 暴风斩 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 43 | 死斗 | player | 1 | 409 | 原生：servers/world/src/server/jobs/warrior.rs |
| 45 | 暴风碎 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 46 | 飞斧 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 48 | 守护 | player | 1 | 91 | 原生：servers/world/src/server/jobs/warrior.rs |
| 52 | 战嚎 | player | 1 | 1897 | 原生：servers/world/src/server/jobs/warrior.rs |
| 3549 | 裂石飞环 | player | 1 | 3833 | 原生：servers/world/src/server/jobs/warrior.rs |
| 3550 | 地毁人亡 | player | 1 | 3833 | 原生：servers/world/src/server/jobs/warrior.rs |
| 3552 | 泰然自若 | player | 1 | 2681 | 原生：servers/world/src/server/jobs/warrior.rs |
| 7386 | 猛攻 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7387 | 动乱 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7388 | 摆脱 | player | 1 | 1457,2108 | 原生：servers/world/src/server/jobs/warrior.rs |
| 7389 | 原初的解放 | player | 1 | 1177,2624,2663 | 原生：servers/world/src/server/jobs/warrior.rs |
| 7531 | 铁壁 | role | 1 | 1191 | 原生：servers/world/src/server/jobs/warrior.rs |
| 7533 | 挑衅 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7535 | 雪仇 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7537 | 退避 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7538 | 插言 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7540 | 下踢 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 7548 | 亲疏自行 | role | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 16462 | 秘银暴风 | player | 1 | 2677 | 原生：servers/world/src/server/jobs/warrior.rs |
| 16463 | 混沌旋风 | replacement | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 16464 | 原初的勇猛 | player | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 16465 | 狂魂 | replacement | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 25751 | 原初的血气 | player | 1 | 2678,2679,2680 | 原生：servers/world/src/server/jobs/warrior.rs |
| 25752 | 群山隆起 | player | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 25753 | 蛮荒崩裂 | player | 1 | 3834 | 原生：servers/world/src/server/jobs/warrior.rs |
| 36923 | 戮罪 | player | 1 | 3832 | 原生：servers/world/src/server/jobs/warrior.rs |
| 36924 | 原初的怒震 | replacement | 0 |  | 原生：servers/world/src/server/jobs/warrior.rs |
| 36925 | 尽毁 | replacement | 1 |  | 原生：servers/world/src/server/jobs/warrior.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 318 | 防护精通 / 1 | 将自身所受的伤害减轻20%<br>另外，随耐力提升的最大体力值和随力量提升的伤害量将受到防护职业专属修正的影响 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 249 | 兽魂 / 35 | 可获得兽魂量值<br>发动条件：凶残裂与暴风斩连击成功时 | warrior.rs 职业资源、变招、威力和效果 |
| 265 | 原初之魂精通 / 54 | 原初之魂变为裂石飞环 | warrior.rs 职业资源、变招、威力和效果 |
| 266 | 钢铁旋风精通 / 60 | 钢铁旋风变为地毁人亡 | warrior.rs 职业资源、变招、威力和效果 |
| 157 | 战嚎效果提高 / 66 | 战嚎的复唱时间缩短5秒<br>发动条件：裂石飞环或地毁人亡命中敌人时，部分特定敌人除外 | warrior.rs 职业资源、变招、威力和效果 |
| 218 | 狂暴精通 / 70 | 狂暴变为原初的解放 | warrior.rs 职业资源、变招、威力和效果 |
| 267 | 原初的混沌 / 72 | 对自身附加原初的混沌状态<br>持续时间：30秒<br>原初的混沌效果：获得50点兽魂，地毁人亡变为混沌旋风<br>当学会狂魂后，裂石飞环变为狂魂<br>发动条件：战嚎发动时 | warrior.rs 职业资源、变招、威力和效果 |
| 268 | 兽魂精通 / 74 | 可获得兽魂量值<br>发动条件：秘银暴风连击成功时 | warrior.rs 职业资源、变招、威力和效果 |
| 417 | 摆脱效果提高 / 76 | 发动摆脱后，为目标恢复体力<br>恢复力：300 | warrior.rs 职业资源、变招、威力和效果 |
| 269 | 战栗效果提高 / 78 | 为战栗附加自身所受的体力恢复效果提高20%的效果 | warrior.rs 职业资源、变招、威力和效果 |
| 418 | 原初的直觉精通 / 82 | 原初的直觉变为原初的血气 | warrior.rs 职业资源、变招、威力和效果 |
| 419 | 原初的勇猛效果提高 / 82 | 原初的勇猛与原初的武猛的持续时间延长到8秒<br>同时原初的武猛追加以下效果<br><br>追加效果：为目标附加原初的血潮状态<br>持续时间：4秒<br>原初的血潮效果：令目标受到的伤害减轻10%<br>追加效果：为目标附加能够抵御一定伤害的防护罩原初的血烟<br>该防护罩能够抵消相当于恢复力400的伤害量<br>持续时间：20秒 | warrior.rs 职业资源、变招、威力和效果 |
| 420 | 泰然自若效果提高 / 84 | 发动泰然自若时，持续恢复自身的体力<br>恢复力：200<br>持续时间：15秒 | warrior.rs 职业资源、变招、威力和效果 |
| 505 | 技能威力提高 / 84 | 部分技能的威力提高<br><br>重劈的威力：200<br>凶残裂的威力：150<br>暴风斩的威力：160<br>暴风碎的威力：160 | warrior.rs 职业资源、变招、威力和效果 |
| 421 | 猛攻效果提高 / 88 | 猛攻的积蓄次数增加到3次 | warrior.rs + gamedata.rs 充能查询 |
| 567 | 复仇精通 / 92 | 复仇变为戮罪 | warrior.rs 职业资源、变招、威力和效果 |
| 639 | 铁壁效果提高 / 94 | 增加“自身所受的体力恢复效果提高15%”的效果 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 654 | 技能威力提高II / 94 | 部分技能的威力提高<br><br>重劈的威力：240<br>凶残裂的威力：190<br>暴风斩的威力：220<br>暴风碎的威力：220<br>裂石飞环的威力：580<br>动乱的威力：420 | warrior.rs 职业资源、变招、威力和效果 |
| 568 | 原初的解放效果提高 / 96 | 对自身附加原初的搏动状态<br>最大档数：3档　持续时间：30秒<br>附加3档原初的搏动后，该状态变为原初的怒震预备，原初的解放变为原初的怒震<br>发动条件：原初的解放状态中发动裂石飞环或地毁人亡命中敌人时 | warrior.rs 职业资源、变招、威力和效果 |
| 640 | 雪仇效果提高 / 98 | 雪仇的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 569 | 蛮荒崩裂效果提高 / 100 | 对自身附加尽毁预备状态<br>持续时间：20秒<br>发动条件：蛮荒崩裂发动时 | warrior.rs 职业资源、变招、威力和效果 |

## 输入录像

- arr/战士.dat：本人量谱 已确认，SHA-256 `7dbc0aacee3fedf73e40385d9d10d9cbb91c54670b0a7033b000f01b88351daf`。
