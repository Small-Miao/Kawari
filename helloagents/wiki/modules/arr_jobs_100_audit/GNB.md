# 绝枪战士（GNB）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 伪装的招架减伤已结算，招架结果协议标志尚未完成对照。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7531 | 铁壁 | role | 1 | 1191 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7533 | 挑衅 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7535 | 雪仇 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7537 | 退避 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7538 | 插言 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7540 | 下踢 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 7548 | 亲疏自行 | role | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16137 | 利刃斩 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16138 | 无情 | player | 1 | 1831,3886 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16139 | 残暴弹 | player | 1 | 1898 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16140 | 伪装 | player | 1 | 1832 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16141 | 恶魔切 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16142 | 王室亲卫 | player | 1 | 1833 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16143 | 闪雷弹 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16145 | 迅连斩 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16146 | 烈牙 | player | 1 | 1842 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16147 | 猛兽爪 | replacement | 1 | 1843 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16149 | 恶魔杀 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16150 | 凶禽爪 | replacement | 1 | 1844 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16151 | 极光 | player | 1 | 1835 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16152 | 超火流星 | player | 1 | 1836 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16153 | 音速破 | player | 1 | 1837 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16155 | 续剑 | player | 0 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16156 | 撕喉 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16157 | 裂膛 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16158 | 穿目 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16159 | 弓形冲波 | player | 1 | 1838 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16160 | 光之心 | player | 1 | 1839 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16162 | 爆发击 | player | 1 | 2686 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16163 | 命运之环 | player | 1 | 3839 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16164 | 血壤 | player | 1 | 3840,5051 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 16165 | 爆破领域 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 25758 | 刚玉之心 | player | 1 | 2683,2684,2685 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 25759 | 超高速 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 25760 | 倍攻 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36934 | 弹道 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36935 | 大星云 | player | 1 | 3838 | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36936 | 命运之印 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36937 | 崛起之心 | player | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36938 | 支配之心 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |
| 36939 | 终结之心 | replacement | 1 |  | 原生：servers/world/src/server/jobs/gunbreaker.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 320 | 防护精通 / 1 | 将自身所受的伤害减轻20%<br>另外，随耐力提升的最大体力值和随力量提升的伤害量将受到防护职业专属修正的影响 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 257 | 晶壤装填 / 30 | 对自身附加晶壤状态<br>最多可积累到2档<br>发动条件：迅连斩连击成功时 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 258 | 残暴弹效果提高 / 52 | 对自身附加能够抵御一定伤害的防护罩残暴弹<br>持续时间：30秒<br>发动条件：残暴弹连击成功时 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 666 | 无情效果提高 / 54 | 对自身附加音速破预备状态<br>持续时间：30秒<br>发动条件：无情发动时 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 259 | 危险领域精通 / 80 | 危险领域变为爆破领域 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 424 | 石之心精通 / 82 | 石之心变为刚玉之心 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 425 | 极光效果提高 / 84 | 极光变为积蓄技能<br>积蓄次数：2 | gunbreaker.rs + gamedata.rs 充能查询 |
| 507 | 技能威力提高 / 84 | 部分技能的威力提高<br><br>利刃斩的威力：200<br>残暴弹的威力：160<br>迅连斩的威力：140 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 426 | 续剑效果提高 / 86 | 对自身附加超高速预备状态<br>持续时间：10秒<br>发动条件：爆发击发动时<br>持续时间内，续剑变为超高速 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 427 | 晶壤装填效果提高 / 88 | 晶壤可以积累到3档，<br>血壤状态中可以积累到6档另外，发动血壤可获得3档晶壤 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 574 | 星云精通 / 92 | 星云变为大星云 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 639 | 铁壁效果提高 / 94 | 增加“自身所受的体力恢复效果提高15%”的效果 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 667 | 技能威力提高II / 94 | 部分技能的威力提高<br><br>利刃斩的威力：300<br>残暴弹的威力：240<br>迅连斩的威力：240<br>爆发击的威力：420<br>烈牙的威力：440<br>猛兽爪的威力：500<br>凶禽爪的威力：560<br>撕喉的威力：220<br>裂膛的威力：260<br>穿目的威力：300<br>爆破领域的威力：800<br>超高速的威力：180 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 575 | 续剑效果提高II / 96 | 对自身附加命运之印预备状态<br>持续时间：10秒<br>发动条件：命运之环发动时<br>持续时间内，续剑变为命运之印 | gunbreaker.rs 职业资源、变招、威力和效果 |
| 640 | 雪仇效果提高 / 98 | 雪仇的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 576 | 血壤效果提高 / 100 | 对自身附加心有灵狮状态<br>持续时间：30秒<br>发动条件：血壤发动时 | gunbreaker.rs 职业资源、变招、威力和效果 |

## 输入录像

- arr/绝枪.dat：本人量谱 已确认，SHA-256 `e57f5d15c0f66f254949491dffd0cf44c99181b0e607918a125472ca44583504`。
