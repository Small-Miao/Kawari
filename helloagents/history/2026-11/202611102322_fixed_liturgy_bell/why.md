# 礼仪之铃固定落点与模型修复

用户反馈铃应固定在落点，目前却出现普通 NPC。检查发现生成包没有填写模型，拥有 owner 的 NPC 默认进入 Follow；铃也未禁用 AI。

白魔 21:47:29 原始录像在 49.277 秒生成 BNpcBase 13961、BNpcName 10349、Pet 33、ModelChara 3437、DisplayFlag 0x40008。保留正确协议演员类型，修正可见模型及服务器行为。
