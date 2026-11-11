# 蝰蛇剑士（VPR）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 本人量谱与完整派生链已有回归，实际移动和演出仍待客户端验收。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7542 | 浴血 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Bloodbath_07542.lua |
| 7546 | 真北 | role | 0 |  | 共用脚本：resources/scripts/actions/075/TrueNorth_07546.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7549 | 牵制 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Feint_07549.lua |
| 7863 | 扫腿 | role | 0 |  | 共用脚本：resources/scripts/actions/078/LegSweep_07863.lua |
| 34606 | 咬噬尖齿 | player | 4 | 3772 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34607 | 穿裂尖齿 | player | 4 | 3672 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34608 | 猛袭利齿 | replacement | 4 | 3668 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34609 | 疾速利齿 | replacement | 4 | 3669 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34610 | 侧击獠齿 | replacement | 2 | 3647 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34611 | 侧裂獠齿 | replacement | 2 | 3648 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34612 | 背击獠齿 | replacement | 2 | 3646 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34613 | 背裂獠齿 | replacement | 2 | 3645 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34614 | 咬噬尖牙 | player | 2 | 3772 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34615 | 穿裂尖牙 | player | 2 | 3672 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34616 | 猛袭利牙 | replacement | 2 | 3668 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34617 | 疾速利牙 | replacement | 2 | 3669 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34618 | 乱击獠牙 | replacement | 2 | 3650 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34619 | 乱裂獠牙 | replacement | 2 | 3649 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34620 | 强碎灵蛇 | player | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34621 | 猛袭盘蛇 | player | 3 | 3657,3668 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34622 | 疾速盘蛇 | player | 3 | 3658,3669 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34623 | 强碎灵蝰 | player | 2 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34624 | 猛袭盘蝰 | player | 2 | 3659,3668 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34625 | 疾速盘蝰 | player | 2 | 3660,3669 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34626 | 祖灵降临 | player | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34627 | 祖灵之牙一式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34628 | 祖灵之牙二式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34629 | 祖灵之牙三式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34630 | 祖灵之牙四式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34631 | 祖灵大蛇牙 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34632 | 飞蛇之牙 | player | 1 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34633 | 飞蛇之尾 | player | 5 | 3665 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34634 | 蛇尾击 | replacement | 8 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34635 | 蛇尾闪 | replacement | 4 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34636 | 双牙连击 | replacement | 6 | 3658 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34637 | 双牙乱击 | replacement | 6 | 3657 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34638 | 双牙连闪 | replacement | 4 | 3660 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34639 | 双牙乱闪 | replacement | 4 | 3659 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34640 | 祖灵之蛇一式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34641 | 祖灵之蛇二式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34642 | 祖灵之蛇三式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34643 | 祖灵之蛇四式 | replacement | 3 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34644 | 飞蛇连尾击 | replacement | 5 | 3666 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34645 | 飞蛇乱尾击 | replacement | 5 |  | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 34646 | 蛇行 | player | 2 |  | 原生：servers/world/src/server/jobs/viper/mod.rs |
| 34647 | 蛇灵气 | player | 2 | 3671 | 原生：servers/world/src/server/jobs/viper/effects.rs、servers/world/src/server/jobs/viper/mod.rs |
| 35920 | 蛇尾术 | player | 0 |  | 原生：servers/world/src/server/jobs/viper/mod.rs |
| 35921 | 双牙连术 | player | 0 |  | 原生：servers/world/src/server/jobs/viper/mod.rs |
| 35922 | 双牙乱术 | player | 0 |  | 原生：servers/world/src/server/jobs/viper/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 524 | 齿系技能效果提高 / 55 | 可以发动蛇尾击<br>发动条件：侧击獠齿、侧裂獠齿、背击獠齿、背裂獠齿命中时 | viper 职业资源、变招、威力和效果 |
| 525 | 牙系技能效果提高 / 60 | 可以发动蛇尾闪<br>发动条件：乱击獠牙或乱裂獠牙命中时 | viper 职业资源、变招、威力和效果 |
| 674 | 技能威力提高 / 74 | 部分技能的威力提高<br><br>咬噬尖齿的威力：200<br>穿裂尖齿的威力：200<br>猛袭利齿的威力：300<br>疾速利齿的威力：300 | viper 职业资源、变招、威力和效果 |
| 526 | 蛇系技能效果提高 / 75 | 可以发动双牙连击和双牙乱击<br>发动条件：猛袭盘蛇或疾速盘蛇命中时 | viper 职业资源、变招、威力和效果 |
| 527 | 蝰系技能效果提高 / 80 | 可以发动双牙连闪和双牙乱闪<br>发动条件：猛袭盘蝰或疾速盘蝰命中时 | viper 职业资源、变招、威力和效果 |
| 528 | 飞蛇之魂 / 82 | 对自身附加飞蛇之魂状态<br>发动条件：强碎灵蛇或强碎灵蝰命中时 | viper 职业资源、变招、威力和效果 |
| 529 | 蛇行效果提高 / 84 | 蛇行的积蓄次数增加到3次 | viper + gamedata.rs 充能查询 |
| 675 | 技能威力提高II / 84 | 部分技能的威力提高<br><br>侧击獠齿的威力：340<br>侧裂獠齿的威力：340<br>背击獠齿的威力：340<br>背裂獠齿的威力：340 | viper 职业资源、变招、威力和效果 |
| 530 | 飞蛇之魂效果提高 / 88 | 飞蛇之魂可以积累到3档 | viper 职业资源、变招、威力和效果 |
| 531 | 祖灵之魂 / 90 | 可获得灵力值量值<br>同时，对自身附加祖灵降临预备状态<br>持续时间：30秒<br>发动条件：特定战技命中时或蛇灵气发动时 | viper 职业资源、变招、威力和效果 |
| 532 | 飞蛇之尾效果提高 / 92 | 可以发动飞蛇连尾击和飞蛇乱尾击<br>发动条件：飞蛇之尾命中时 | viper 职业资源、变招、威力和效果 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 533 | 祖灵之魂效果提高 / 96 | 祖灵力可以积累到5档<br>同时，可以发动祖灵大蛇牙<br>发动条件：祖灵降临状态中 | viper 职业资源、变招、威力和效果 |
| 641 | 牵制效果提高 / 98 | 牵制的持续时间延长到15秒 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 534 | 祖灵之牙精通 / 100 | 可以发动祖灵之蛇一式、祖灵之蛇二式、祖灵之蛇三式、祖灵之蛇四式<br>发动条件：分别为祖灵之牙一式、祖灵之牙二式、祖灵之牙三式、祖灵之牙四式命中时 | viper 职业资源、变招、威力和效果 |

## 输入录像

- arr/蝰蛇.dat：本人量谱 不适用（旁观），SHA-256 `e6ed1661acbac5b8570f4abf8d4bb8cd3197038150b89505c9f3b1945b202aac`。
- 军工要地克吕提俄斯魔导工厂 2026.11.11 13.29.09.dat：本人量谱 已确认，SHA-256 `5f77da4e0a9fd7ee78b7fe682a6a69eb0bb331d6132c6c5c7a0c9731112fbb9c`。
