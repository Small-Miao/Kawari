# 贤者（SGE）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 复活确认服务端已补齐，尚未部署/实机验收；幸福当前按状态治疗包下发，独立 Action 37036 未见于两份录像。非副本初始蛇刺待核验。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7559 | 沉稳咏唱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Surecast_07559.lua |
| 7561 | 即刻咏唱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Swiftcast_07561.lua |
| 7562 | 醒梦 | role | 0 |  | 共用脚本：resources/scripts/actions/075/LucidDreaming_07562.lua |
| 7568 | 康复 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Esuna_07568.lua |
| 7571 | 营救 | role | 0 |  | 原生：servers/world/src/server/jobs/sage/effects.rs |
| 16560 | 沉静 | role | 0 |  | 共用脚本：resources/scripts/actions/165/Repose_16560.lua |
| 24284 | 诊断 | player | 1 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24285 | 心关 | player | 4 | 2604,2605 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24286 | 预后 | player | 1 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24287 | 复苏 | player | 0 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24290 | 均衡 | player | 8 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24291 | 均衡诊断 | replacement | 2 | 2607,2608 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24294 | 拯救 | player | 2 | 2610 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24295 | 神翼 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/mod.rs |
| 24296 | 灵橡清汁 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24298 | 坚角清汁 | player | 2 | 2618,2938 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24299 | 寄生清汁 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24300 | 活化 | player | 2 | 2611 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24301 | 消化 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24302 | 自生II | player | 2 | 2620,2621 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24303 | 白牛清汁 | player | 2 | 2619 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24305 | 输血 | player | 2 | 2612,2642 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24309 | 根素 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24310 | 整体论 | player | 2 | 3003,3365 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24311 | 泛输血 | player | 2 | 2613,2643 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24312 | 注药III | player | 3 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24313 | 发炎III | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24314 | 均衡注药III | replacement | 2 | 2616 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24315 | 失衡II | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24316 | 箭毒II | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24317 | 混合 | player | 2 | 2622 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 24318 | 魂灵风息 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 37032 | 均衡失衡 | replacement | 2 | 3897 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 37033 | 心神风息 | player | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 37034 | 均衡预后II | replacement | 2 |  | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 37035 | 智慧之爱 | player | 2 | 3898,3899 | 原生：servers/world/src/server/jobs/sage/effects.rs、servers/world/src/server/jobs/sage/mod.rs |
| 37036 | 幸福 | replacement | 0 |  | 状态 3899 治疗路径；未使用独立动作，演出待核验 |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 368 | 技能效果提高 / 20 | 除自动攻击外的技能造成的伤害提高至基本值的1.1倍，恢复技能的恢复量也提高至基本值的1.1倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 369 | 技能效果提高II / 40 | 除自动攻击外的技能造成的伤害提高至基本值的1.3倍，恢复技能的恢复量也提高至基本值的1.3倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 370 | 蛇胆 / 45 | 对自身附加蛇胆状态<br>最大档数：3档<br>每隔20秒获得一档蛇胆<br>陷入无法战斗状态不影响获得蛇胆 | sage 职业资源、变招、威力和效果 |
| 371 | 贤学誓词 / 54 | 部分技能的威力提高<br><br>注药的威力：250<br>发炎的威力：330<br>均衡注药的威力：35 | sage 职业资源、变招、威力和效果 |
| 510 | 自生精通 / 60 | 自生变为自生II | sage 职业资源、变招、威力和效果 |
| 372 | 贤学誓词II / 64 | 部分技能的威力提高<br><br>注药的威力：300<br>发炎的威力：400<br>均衡注药的威力：40 | sage 职业资源、变招、威力和效果 |
| 373 | 蛇刺 / 66 | 对自身附加蛇刺状态<br>最大档数：3档<br>发动条件：均衡诊断或对自身附加的均衡预后因吸收到足够的伤害而消失时 | sage 职业资源、变招、威力和效果 |
| 374 | 攻击魔法精通 / 72 | 注药变为注药II<br>发炎变为发炎II<br>均衡注药变为均衡注药II<br>同时，箭毒的威力提高到300 | sage 职业资源、变招、威力和效果 |
| 375 | 坚角清汁效果提高 / 78 | 坚角清汁追加持续恢复效果 | sage 职业资源、变招、威力和效果 |
| 376 | 攻击魔法精通II / 82 | 注药II变为注药III<br>发炎II变为发炎III<br>均衡注药II变为均衡注药III<br>失衡变为失衡II<br>箭毒变为箭毒II | sage 职业资源、变招、威力和效果 |
| 377 | 治疗技能效果提高 / 85 | 部分技能与防护罩的效果提高<br><br>诊断的恢复力：450<br>心关的恢复力：170<br>均衡诊断的效果量：抵消相当于治疗量180%的伤害<br>均衡预后的效果量：抵消相当于治疗量320%的伤害 | sage 职业资源、变招、威力和效果 |
| 378 | 活化效果提高 / 88 | 活化的复唱时间缩短到90秒 | sage 职业资源、变招、威力和效果 |
| 636 | 拯救效果提高 / 94 | 拯救的复唱时间缩短到60秒 | sage 职业资源、变招、威力和效果 |
| 644 | 即刻咏唱效果提高 / 94 | 即刻咏唱的复唱时间缩短到40秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 669 | 技能威力提高 / 94 | 部分技能的威力提高<br><br>注药III的威力：380<br>均衡注药III的威力：90<br>箭毒II的威力：380<br>魂灵风息的威力：380 | sage 职业资源、变招、威力和效果 |
| 637 | 均衡预后精通 / 96 | 均衡预后变为均衡预后II | sage 职业资源、变招、威力和效果 |
| 638 | 自生II效果提高 / 98 | “令目标所受的体力恢复效果提高10%”的持续时间延长到15秒 | sage 职业资源、变招、威力和效果 |

## 输入录像

- arr/贤者.dat：本人量谱 已确认，SHA-256 `caa7dbcad37be824de2c194d106b9765b9e835690928465af993c860fe6adbd4`。
- arr/贤者2.dat：本人量谱 已确认，SHA-256 `625ec3a99d70586a47cb4d99b46613a652a684416000d19b0ea01589f50ec836`。
