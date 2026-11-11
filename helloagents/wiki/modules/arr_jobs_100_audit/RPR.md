# 钐镰客（RPR）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 地狱之门固定对象/回退坐标已回归，实际位移和化身演出待验收。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7542 | 浴血 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Bloodbath_07542.lua |
| 7546 | 真北 | role | 0 |  | 共用脚本：resources/scripts/actions/075/TrueNorth_07546.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7549 | 牵制 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Feint_07549.lua |
| 7863 | 扫腿 | role | 0 |  | 共用脚本：resources/scripts/actions/078/LegSweep_07863.lua |
| 24373 | 切割 | player | 2 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24374 | 增盈切割 | player | 2 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24375 | 地狱切割 | player | 3 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24376 | 旋转钐割 | player | 6 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24377 | 噩梦钐割 | player | 5 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24378 | 死亡之影 | player | 2 | 2586 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24379 | 死亡之涡 | player | 2 | 2586 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24380 | 灵魂切割 | player | 6 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24381 | 灵魂钐割 | player | 1 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24382 | 绞决 | player | 2 | 2589 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24383 | 缢杀 | player | 2 | 2588 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24384 | 断首 | player | 3 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24385 | 大丰收 | player | 2 | 3859,3905 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24386 | 勾刃 | player | 2 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24387 | 播魂种 | player | 2 | 2594 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24388 | 收获月 | replacement | 2 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24389 | 隐匿挥割 | player | 0 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24390 | 绞决爪 | replacement | 2 | 2587 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24391 | 缢杀爪 | replacement | 2 | 2587 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24392 | 束缚挥割 | player | 3 | 2587 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24393 | 暴食 | player | 4 | 3858 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24394 | 夜游魂衣 | player | 3 | 3857 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24395 | 虚无收割 | replacement | 6 | 2591 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24396 | 交错收割 | replacement | 6 | 2590 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24397 | 阴冷收割 | replacement | 0 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24398 | 团契 | player | 3 | 3860 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24399 | 夜游魂切割 | replacement | 6 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24400 | 夜游魂钐割 | replacement | 0 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24401 | 地狱入境 | player | 1 | 2595,2845 | 原生：servers/world/src/server/jobs/reaper/actors.rs、servers/world/src/server/jobs/reaper/effects.rs |
| 24402 | 地狱出境 | player | 2 | 2595,2845 | 原生：servers/world/src/server/jobs/reaper/actors.rs、servers/world/src/server/jobs/reaper/effects.rs |
| 24403 | 回退 | replacement | 3 |  | 原生：servers/world/src/server/jobs/reaper/actors.rs、servers/world/src/server/jobs/reaper/effects.rs |
| 24404 | 神秘纹 | player | 3 | 2597 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 24405 | 神秘环 | player | 2 | 2599,2600,2972 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 36969 | 祭牲 | replacement | 3 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 36970 | 绞决处刑 | replacement | 2 | 2589 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 36971 | 缢杀处刑 | replacement | 2 | 2588 | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 36972 | 断首处刑 | replacement | 4 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |
| 36973 | 完人 | replacement | 2 |  | 原生：servers/world/src/server/jobs/reaper/effects.rs、servers/world/src/server/jobs/reaper/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 379 | 灵魂 / 50 | 可获得灵魂量值<br>发动条件：特定战技及魔法命中时或自身附加死亡烙印状态的目标在持续时间内被打倒 | reaper 职业资源、变招、威力和效果 |
| 380 | 技能威力提高 / 60 | 部分技能的威力提高<br><br>切割的威力：300<br>增盈切割的威力：140<br>死亡之影的威力：300<br>勾刃的威力：300<br>旋转钐割的威力：140<br>地狱切割的威力：140<br>死亡之涡的威力：100<br>噩梦钐割的威力：120 | reaper 职业资源、变招、威力和效果 |
| 381 | 化身能力效果提高 / 70 | 对自身附加妖异之镰状态<br>持续时间：30秒<br>发动战技或魔法会导致该效果消失<br>发动条件：隐匿挥割或束缚挥割命中时 | reaper 职业资源、变招、威力和效果 |
| 382 | 地狱之门效果提高 / 74 | 地狱入境或地狱出境发动后在移动前的地点生成地狱之门，并对自身附加回退预备状态<br>持续时间：10秒<br>地狱入境发动后地狱出境变为回退，地狱出境发动后地狱入境变为回退 | reaper 职业资源、变招、威力和效果 |
| 383 | 灵魂技效果提高 / 78 | 灵魂切割与灵魂钐割变为积蓄技能<br>积蓄次数：2 | reaper + gamedata.rs 充能查询 |
| 384 | 魂衣 / 80 | 可获得魂衣量值<br>发动条件：绞决、缢杀、断首命中时 | reaper 职业资源、变招、威力和效果 |
| 385 | 神秘纹效果提高 / 84 | 为自身及周围15米以内的队员附加活性纹状态<br>活性纹效果：持续恢复目标的体力<br>恢复力：50<br>持续时间：15秒<br>发动条件：自身附加的守护纹因吸收到足够的伤害而消失时 | reaper 职业资源、变招、威力和效果 |
| 523 | 技能威力提高II / 84 | 部分技能的威力提高<br><br>切割的威力：320<br>增盈切割的威力：160<br>地狱切割的威力：180 | reaper 职业资源、变招、威力和效果 |
| 386 | 虚无魂 / 86 | 对自身附加虚无魂状态<br>发动条件：虚无收割、交错收割、阴冷收割命中时 | reaper 职业资源、变招、威力和效果 |
| 387 | 神秘环效果提高 / 88 | 为自身及周围队员附加祭祀环状态<br>持续时间：5秒<br>祭祀环：持续时间内受自身祭祀环影响的目标发动战技或魔法攻击命中时，自身获得1档死亡祭品<br>最大档数：8档<br>持续时间：30秒<br>追加效果：死亡祭祀<br>持续时间：6秒<br>死亡祭祀效果：从受到自身祭祀环影响的目标身上获得死亡祭品<br>发动条件：神秘环发动时 | reaper 职业资源、变招、威力和效果 |
| 594 | 夜游魂衣效果提高 / 92 | 对自身附加祭牲预备状态<br>持续时间：30秒<br>发动条件：夜游魂衣发动时 | reaper 职业资源、变招、威力和效果 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 657 | 技能威力提高III / 94 | 部分技能的威力提高<br><br>切割的威力：420<br>增盈切割的威力：260<br>地狱切割的威力：280<br>灵魂切割的威力：520<br>绞决的威力：500<br>缢杀的威力：500<br>绞决爪的威力：440<br>缢杀爪的威力：440<br>虚无收割的威力：580<br>交错收割的威力：580<br>收获月的威力：800<br>夜游魂切割的威力：280 | reaper 职业资源、变招、威力和效果 |
| 596 | 暴食效果提高 / 96 | 对自身附加2档处刑人状态<br>持续时间：30秒<br>无法与妖异之镰效果共存<br>发动战技或魔法会导致该效果消失<br>发动条件：暴食命中时<br>持续时间内，绞决、缢杀、断首分别变为绞决处刑、缢杀处刑、断首处刑 | reaper 职业资源、变招、威力和效果 |
| 641 | 牵制效果提高 / 98 | 牵制的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 597 | 大丰收效果提高 / 100 | 对自身附加补完状态<br>持续时间：30秒<br>补完效果：效果时间内发动团契，该状态变为完人预备<br>进入夜游魂状态时，会解除完人预备状态<br>发动条件：大丰收发动时 | reaper 职业资源、变招、威力和效果 |

## 输入录像

- arr/镰刀.dat：本人量谱 不适用（旁观），SHA-256 `5b9c4ff157500e6918bd3e36743081ee2a0b630d9b8cbf6f5069dbf4e07b25e3`。
- 军工要地克吕提俄斯魔导工厂 2026.11.11 13.27.29.dat：本人量谱 已确认，SHA-256 `f0b8b4b8cfda5c7e02d61c40f817d9f3d2eacb13e256ae6b6b4ab55fe046618c`。
