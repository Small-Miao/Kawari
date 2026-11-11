# 武士（SAM）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 完全被护盾吸收时的天眼触发当前按受到攻击处理，此边界待实机对照。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7478 | 阵风 | player | 2 | 1298 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7479 | 士风 | player | 2 | 1299 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7480 | 雪风 | player | 6 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7481 | 月光 | player | 6 | 1298 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7482 | 花车 | player | 5 | 1299 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7484 | 满月 | player | 4 | 1298 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7485 | 樱花 | player | 4 | 1299 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7486 | 燕飞 | player | 3 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7487 | 纷乱雪月花 | replacement | 1 | 4216 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7488 | 天下五剑 | replacement | 3 | 3852 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7489 | 彼岸花 | replacement | 3 | 1228 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7490 | 必杀剑·震天 | player | 5 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7491 | 必杀剑·九天 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7492 | 必杀剑·晓天 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7493 | 必杀剑·夜天 | player | 2 | 1236 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7495 | 叶隐 | player | 1 |  | 原生：servers/world/src/server/jobs/samurai/mod.rs |
| 7496 | 必杀剑·红莲 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7497 | 默想 | player | 1 | 1231 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7499 | 明镜止水 | player | 4 | 1233,3856 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7542 | 浴血 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Bloodbath_07542.lua |
| 7546 | 真北 | role | 1 | 1250 | 共用脚本：resources/scripts/actions/075/TrueNorth_07546.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7549 | 牵制 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Feint_07549.lua |
| 7863 | 扫腿 | role | 0 |  | 共用脚本：resources/scripts/actions/078/LegSweep_07863.lua |
| 7867 | 居合术 | player | 0 |  | 原生：servers/world/src/server/jobs/samurai/mod.rs |
| 16481 | 必杀剑·闪影 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 16482 | 意气冲天 | player | 2 | 2959,3855 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 16483 | 燕回返 | player | 0 |  | 原生：servers/world/src/server/jobs/samurai/mod.rs |
| 16485 | 回返五剑 | replacement | 3 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 16486 | 回返雪月花 | replacement | 1 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 16487 | 照破 | player | 5 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 25780 | 风光 | player | 5 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 25781 | 奥义斩浪 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 25782 | 回返斩浪 | replacement | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36962 | 天眼通 | player | 3 | 3853 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36963 | 晓风 | player | 8 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36964 | 残心 | player | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36965 | 天道五剑 | replacement | 2 | 4217 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36966 | 天道雪月花 | replacement | 2 | 4218 | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36967 | 天道回返五剑 | replacement | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |
| 36968 | 天道回返雪月花 | replacement | 2 |  | 原生：servers/world/src/server/jobs/samurai/effects.rs、servers/world/src/server/jobs/samurai/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 215 | 剑气精通 / 52 | 可获得剑气量值<br>发动条件：特定战技命中时或发动心眼成功减轻所受的伤害时 | samurai 职业资源、变招、威力和效果 |
| 208 | 剑气精通II / 62 | 可以追加获得剑气量值<br>发动条件：除居合术之外的战技命中时 | samurai 职业资源、变招、威力和效果 |
| 520 | 技能威力提高 / 66 | 部分技能的威力提高<br><br>刃风的威力：200<br>阵风的威力：120<br>士风的威力：120 | samurai 职业资源、变招、威力和效果 |
| 277 | 居合术效果提高 / 74 | 居合术的咏唱时间缩短到1.3秒<br>同时为自身附加燕回返预备状态<br>持续时间：30秒<br>发动条件：彼岸花之外的居合术发动时 | samurai 职业资源、变招、威力和效果 |
| 443 | 明镜止水效果提高 / 76 | 明镜止水变为积蓄技能<br>积蓄次数：2 | samurai + gamedata.rs 充能查询 |
| 278 | 风月风花效果提高 / 78 | 风月与风花效果量提高到13% | samurai 职业资源、变招、威力和效果 |
| 589 | 心眼精通 / 82 | 心眼变为天眼通 | samurai 职业资源、变招、威力和效果 |
| 521 | 技能威力提高II / 84 | 部分技能的威力提高<br><br>月光的威力：110<br>花车的威力：110<br>雪风的威力：110 | samurai 职业资源、变招、威力和效果 |
| 519 | 风雅精通 / 86 | 风雅变为风光 | samurai 职业资源、变招、威力和效果 |
| 514 | 意气冲天效果提高 / 90 | 对自身附加奥义斩浪预备状态<br>持续时间：30秒<br>发动条件：意气冲天发动时 | samurai 职业资源、变招、威力和效果 |
| 590 | 刃风精通 / 92 | 刃风变为晓风 | samurai 职业资源、变招、威力和效果 |
| 591 | 必杀剑效果提高 / 94 | 必杀剑·红莲和必杀剑·闪影的复唱时间缩短到60秒 | samurai 职业资源、变招、威力和效果 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 655 | 技能威力提高III / 94 | 部分技能的威力提高<br><br>阵风的威力：140<br>燕飞效果提高时燕飞的威力：270<br>士风的威力：140<br>月光的威力：160<br>彼岸花持续伤害的威力：50<br>花车的威力：160<br>雪风的威力：160<br>纷乱雪月花的威力：680<br>回返雪月花的威力：680<br>照破的威力：640<br>奥义斩浪的威力：1000<br>回返斩浪的威力：1000 | samurai 职业资源、变招、威力和效果 |
| 592 | 意气冲天效果提高II / 96 | 对自身附加残心预备状态<br>持续时间：30秒<br>发动条件：意气冲天发动时 | samurai 职业资源、变招、威力和效果 |
| 641 | 牵制效果提高 / 98 | 牵制的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 593 | 明镜止水效果提高II / 100 | 对自身附加天道状态<br>持续时间：30秒<br>发动条件：明镜止水发动时<br>持续时间内，天下五剑变为天道五剑，纷乱雪月花变为天道雪月花 | samurai 职业资源、变招、威力和效果 |

## 输入录像

- arr/武士.dat：本人量谱 不适用（旁观），SHA-256 `34adf2fc757ca08dddd1d35e84c10be11df75a562ec4f82e34228190ae9d0b5e`。
- 军工要地克吕提俄斯魔导工厂 2026.11.11 13.31.05.dat：本人量谱 已确认，SHA-256 `8b4a7c2fd131cbc2a642ae9da603b2b6096b114fbe9ecba369ef4644f8b4c023`。
