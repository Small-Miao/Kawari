# 学者（SCH）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 炽天使、慰藉、以太契约缺对应录像；契约连线与独立宠物属性待核验。复活确认服务端已补齐，尚未部署/实机验收。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 166 | 以太超流 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 167 | 能量吸收 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 173 | 复生 | player | 0 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 185 | 鼓舞激励之策 | player | 1 | 297,1918 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 188 | 野战治疗阵 | player | 1 | 1944 | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 189 | 生命活性法 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 190 | 医术 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 3583 | 不屈不挠之策 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 3585 | 展开战术 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 3586 | 应急战术 | player | 1 | 792 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 3587 | 转化 | player | 1 | 791 | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 7434 | 深谋远虑之策 | player | 1 | 1220 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 7436 | 连环计 | player | 1 | 1221,3882 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 7437 | 以太契约 | player | 0 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 7559 | 沉稳咏唱 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Surecast_07559.lua |
| 7561 | 即刻咏唱 | role | 1 | 167 | 共用脚本：resources/scripts/actions/075/Swiftcast_07561.lua |
| 7562 | 醒梦 | role | 1 | 1204 | 共用脚本：resources/scripts/actions/075/LucidDreaming_07562.lua |
| 7568 | 康复 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Esuna_07568.lua |
| 7571 | 营救 | role | 0 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs |
| 16537 | 仙光的低语 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 16538 | 异想的幻光 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 16540 | 蛊毒法 | player | 1 | 1895 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 16542 | 秘策 | player | 1 | 1896 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 16543 | 异想的祥光 | player | 0 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 16545 | 炽天召唤 | player | 0 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 16546 | 慰藉 | player | 0 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 16560 | 沉静 | role | 0 |  | 共用脚本：resources/scripts/actions/165/Repose_16560.lua |
| 17215 | 朝日召唤 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 17870 | 毁坏 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 25865 | 极炎法 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 25866 | 裂阵法 | player | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 25867 | 生命回生法 | player | 1 | 2710 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 25868 | 疾风怒涛之计 | player | 1 | 2711,2712 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 37012 | 埋伏之毒 | player | 1 | 3883 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 37013 | 意气轩昂之策 | player | 2 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 37014 | 炽天附体 | player | 1 | 3884 | 原生：servers/world/src/server/jobs/scholar/actors.rs、servers/world/src/server/jobs/scholar/effects.rs |
| 37015 | 显灵之章 | replacement | 1 | 297 | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 37016 | 降临之章 | replacement | 1 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |
| 37037 | 应急战术 | replacement | 0 |  | 原生：servers/world/src/server/jobs/scholar/effects.rs、servers/world/src/server/jobs/scholar/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 66 | 技能效果提高 / 20 | 自身与召唤兽除自动攻击外的技能造成的伤害提高至基本值的1.1倍，恢复技能的恢复量也提高至基本值的1.1倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 324 | 毒菌精通 / 26 | 毒菌变为猛毒菌 | scholar 职业资源、变招、威力和效果 |
| 69 | 技能效果提高II / 40 | 自身与召唤兽除自动攻击外的技能造成的伤害提高至基本值的1.3倍，恢复技能的恢复量也提高至基本值的1.3倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 214 | 炎法精通 / 54 | 毁灭变为气炎法<br>同时，毁坏的威力提高到160，破阵法的威力提高到165 | scholar 职业资源、变招、威力和效果 |
| 184 | 炎法精通II / 64 | 气炎法变为魔炎法<br>并将毁坏的威力提高到180 | scholar 职业资源、变招、威力和效果 |
| 311 | 毒菌精通II / 72 | 猛毒菌变为蛊毒法 | scholar 职业资源、变招、威力和效果 |
| 312 | 炎法精通III / 72 | 魔炎法变为死炎法<br>并将毁坏的威力提高到200 | scholar 职业资源、变招、威力和效果 |
| 313 | 野战治疗阵效果提高 / 78 | 为野战治疗阵附加区域内的自身和队员体力持续恢复的效果 | scholar 职业资源、变招、威力和效果 |
| 491 | 炎法精通IV / 82 | 死炎法变为极炎法<br>毁坏的威力提高至220 | scholar 职业资源、变招、威力和效果 |
| 492 | 破阵法精通 / 82 | 破阵法变为裂阵法 | scholar 职业资源、变招、威力和效果 |
| 493 | 治疗技能效果提高 / 85 | 部分技能与防护罩的效果提高<br><br>医术的恢复力：450<br>仙光的拥抱的恢复力：180<br>鼓舞激励之策的效果量：抵消相当于治疗量180%的伤害<br>士气高扬之策的效果量：抵消相当于治疗量160%的伤害<br>炽天的幕帘的恢复力：180 | scholar 职业资源、变招、威力和效果 |
| 494 | 展开战术效果提高 / 88 | 展开战术的复唱时间缩短到90秒 | scholar 职业资源、变招、威力和效果 |
| 627 | 连环计效果提高 / 92 | 对自身附加埋伏之毒预备状态<br>持续时间：30秒<br>发动条件：连环计发动时 | scholar 职业资源、变招、威力和效果 |
| 644 | 即刻咏唱效果提高 / 94 | 即刻咏唱的复唱时间缩短到40秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 656 | 技能威力提高 / 94 | 部分技能的威力提高<br><br>蛊毒法持续伤害的威力：85<br>极炎法的威力：320 | scholar 职业资源、变招、威力和效果 |
| 628 | 士气高扬之策精通 / 96 | 士气高扬之策变为意气轩昂之策 | scholar 职业资源、变招、威力和效果 |
| 629 | 秘策效果提高 / 98 | 秘策的复唱时间缩短到60秒 | scholar 职业资源、变招、威力和效果 |

## 输入录像

- arr/学者.dat：本人量谱 已确认，SHA-256 `805d778785dcddea24541de92b2f65a7a47fe080d0388698f128078078ecf4e9`。

## 排除的旧工具误报

ClassJobCategory 不属于该职业，未计入待实现动作：181 溃烂爆发、7560 昏乱、16508 能量吸收、16511 迸裂、25798 宝石兽召唤、25799 守护之光、25800 以太蓄能、25802 红宝石召唤、25803 黄宝石召唤、25804 绿宝石召唤、25880 催眠、25883 宝石耀、25884 宝石辉、172 毁坏、16230 医术。
