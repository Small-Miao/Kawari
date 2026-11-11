# 舞者（DNC）100 级逐项审计

基准：国服 build 14251465。仅列当前最高等级仍有效的动作；低级替代动作列入导出目录而不重复验收。
源码落点是静态定位，回放次数包含本人及演员动作；它们不表示该条全部效果已由测试或实机覆盖。测试范围及已知缺口见主审计记录。

**待核验：** 队友伶俐使用集中 20% 近似概率，各职业真实概率尚未标定。

## 技能与效果

| ID | 技能 | 类别 | 回放次数 | 录像状态 ID | 实现落点 / 边界 |
|---|---|---|---:|---|---|
| 7541 | 内丹 | role | 0 |  | 共用脚本：resources/scripts/actions/075/SecondWind_07541.lua |
| 7548 | 亲疏自行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/ArmsLength_07548.lua |
| 7551 | 伤头 | role | 0 |  | 共用脚本：resources/scripts/actions/075/HeadGraze_07551.lua |
| 7553 | 伤足 | role | 0 |  | 共用脚本：resources/scripts/actions/075/FootGraze_07553.lua |
| 7554 | 伤腿 | role | 0 |  | 共用脚本：resources/scripts/actions/075/LegGraze_07554.lua |
| 7557 | 速行 | role | 0 |  | 共用脚本：resources/scripts/actions/075/Peloton_07557.lua |
| 15989 | 瀑泻 | player | 7 | 2693 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15990 | 喷泉 | player | 7 | 2694 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15991 | 逆瀑泻 | player | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15992 | 坠喷泉 | player | 3 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15993 | 风车 | player | 2 | 2693 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15994 | 落刃雨 | player | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15995 | 升风车 | player | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15996 | 落血雨 | player | 3 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15997 | 标准舞步 | player | 1 | 1818 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15998 | 技巧舞步 | player | 1 | 1819 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 15999 | 蔷薇曲脚步 | replacement | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16000 | 小鸟交叠跳 | replacement | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16001 | 绿叶小踢腿 | replacement | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16002 | 金冠趾尖转 | replacement | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16003 | 标准舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16004 | 技巧舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16005 | 剑舞 | player | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16006 | 闭式舞姿 | player | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16007 | 扇舞·序 | player | 2 | 1820 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16008 | 扇舞·破 | player | 2 | 1820 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16009 | 扇舞·急 | player | 3 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16010 | 前冲步 | player | 0 |  | 原生：servers/world/src/server/jobs/dancer/mod.rs |
| 16011 | 进攻之探戈 | player | 1 | 1825,2700 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16012 | 防守之桑巴 | player | 1 | 1826 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16013 | 百花争艳 | player | 1 | 1820,2699,3017,3018,3868 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16014 | 即兴表演 | player | 1 | 1827 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16015 | 治疗之华尔兹 | player | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16191 | 单色标准舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16192 | 双色标准舞步结束 | replacement | 1 | 1821,1847,3867 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16193 | 单色技巧舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16194 | 双色技巧舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16195 | 三色技巧舞步结束 | replacement | 0 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 16196 | 四色技巧舞步结束 | replacement | 1 | 2698,3869 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 25789 | 即兴表演结束 | replacement | 1 | 2697 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 25790 | 提拉纳 | replacement | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 25791 | 扇舞·终 | player | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 25792 | 流星舞 | player | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 36983 | 落幕舞 | player | 2 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 36984 | 结束动作 | replacement | 1 | 1821,1847,3867 | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |
| 36985 | 拂晓舞 | replacement | 1 |  | 原生：servers/world/src/server/jobs/dancer/effects.rs、servers/world/src/server/jobs/dancer/mod.rs |

## 职业和职能特性

以下逐条保留本地 Trait 说明，便于继续逐效果复核；落点列表示实现责任，单独测试未覆盖的边界不标为完整验收。

| ID | 特性 / 学习等级 | 当前效果 | 实现责任 |
|---|---|---|---|
| 252 | 幻扇 / 30 | 对自身附加幻扇状态<br>最多可积累到4档<br>发动条件：特定技能命中时 | dancer 职业资源、变招、威力和效果 |
| 251 | 技能伤害提高 / 50 | 除自动攻击外的技能造成的伤害提高至基本伤害的1.1倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 253 | 技能伤害提高II / 60 | 除自动攻击外的技能造成的伤害提高至基本伤害的1.2倍 | zone_connection/stats.rs 属性/伤害与 action.rs 减伤 |
| 254 | 前冲步效果提高 / 68 | 前冲步变为积蓄技能<br>积蓄次数：2 | dancer + gamedata.rs 充能查询 |
| 255 | 伶俐 / 76 | 标准舞步结束及技巧舞步结束成功时，对自身及周围的队员附加伶俐状态<br>对自身附加的伶俐效果：瀑泻、逆瀑泻、喷泉、坠喷泉、风车、升风车、落刃雨、落血雨命中后，获得5点伶俐量值<br>为队员附加的伶俐效果：队员发动战技或魔法命中时，自身获得10点伶俐量值<br>队员的伶俐发动几率会根据各特职产生变化 | dancer 职业资源、变招、威力和效果 |
| 256 | 前冲步效果提高II / 78 | 前冲步最多可积蓄3次 | dancer + gamedata.rs 充能查询 |
| 453 | 技巧舞步结束效果提高 / 82 | 对自身附加提拉纳预备状态<br>持续时间：30秒<br>该效果附加后技巧舞步结束变为提拉纳<br>发动条件：技巧舞步结束成功时 | dancer 职业资源、变招、威力和效果 |
| 454 | 伶俐效果提高 / 84 | 伶俐增加量提高到10<br>发动条件：逆瀑泻、坠喷泉、升风车、落血雨 | dancer 职业资源、变招、威力和效果 |
| 455 | 百花争艳效果提高 / 86 | 对自身附加扇舞·终预备状态<br>持续时间：30秒<br>发动条件：百花争艳发动时 | dancer 职业资源、变招、威力和效果 |
| 456 | 防守之桑巴效果提高 / 88 | 防守之桑巴的复唱时间缩短到90秒 | dancer 职业资源、变招、威力和效果 |
| 457 | 进攻之探戈效果提高 / 90 | 对自身附加流星舞预备状态<br>持续时间：20秒<br>发动条件：进攻之探戈发动时 | dancer 职业资源、变招、威力和效果 |
| 609 | 标准舞步结束效果提高 / 92 | 对自身附加落幕舞预备状态<br>持续时间：30秒<br>发动条件：标准舞步结束成功时 | dancer 职业资源、变招、威力和效果 |
| 642 | 内丹效果提高 / 94 | 内丹的恢复力提高到800 | 共用职能脚本、action.rs、paladin.rs / white_mage.rs |
| 662 | 技能威力提高 / 94 | 部分技能的威力提高<br><br>瀑泻的威力：220<br>喷泉的威力：120<br>双色标准舞步结束的威力：850<br>逆瀑泻的威力：280<br>扇舞·序的威力：180<br>坠喷泉的威力：340<br>扇舞·急的威力：220<br>四色技巧舞步结束的威力：1300<br>剑舞的威力：540<br>扇舞·终的威力：460 | dancer 职业资源、变招、威力和效果 |
| 610 | 百花争艳效果提高II / 96 | 对自身附加结束动作预备状态<br>持续时间：30秒<br>发动条件：百花争艳发动时<br>持续时间内，标准舞步变为结束动作 | dancer 职业资源、变招、威力和效果 |
| 611 | 防守之桑巴效果提高II / 98 | 防守之桑巴的效果量提高到15% | dancer 职业资源、变招、威力和效果 |
| 612 | 技巧舞步结束效果提高II / 100 | 对自身附加拂晓舞预备状态<br>持续时间：30秒<br>发动条件：技巧舞步结束成功时<br>持续时间内且伶俐50点及以上时，剑舞变为拂晓舞 | dancer 职业资源、变招、威力和效果 |

## 输入录像

- arr/舞者.dat：本人量谱 已确认，SHA-256 `82d89e87e5121ab9bdce25cd28584a02285a86dbb25cb119a3e650de1fac9737`。
