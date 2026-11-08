using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Enum;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Struct;
using MechanicSim_Server.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class _2人塔 : IActionDefinition
    {
        public static int DefinitionId => 1002;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                ActionId = 1002,
                IsDisplayActionOnGame = false,
                ActionCastTime = TimeSpan.FromSeconds(10),
                Id = Guid.NewGuid(),
                ActionName = "塔",
                GameActionId = 0,
                OnActionCastBegin = (castInfo,raidManager) =>
                {
                    Presentation.Tower(castInfo.Caster.Position);

                    foreach (var player in raidManager.Players)
                    {
                        // TimeLineNode 生成塔前会把当前轮次写到 PlayerVar["KfkCastingTowerRound"]。
                        // 这里在塔开始读条时，把这个轮次绑定到具体塔实体 ID，避免后续其他塔覆盖当前轮次。
                        if (player.PlayerVar.ContainsKey("KfkCastingTowerRound"))
                        {
                            player.PlayerVar[$"KfkTowerRound_{castInfo.Caster.ServerGameObjectId}"] = player.PlayerVar["KfkCastingTowerRound"];
                        }
                    }
                },
                OnActionCastEnd = (castInfo, raidManager) =>
                {
                    castInfo.Execute();


                },
                OnActionCastExecute = (castInfo, raidManager) =>
                {
                    var hitResult = AoeHelper.MakeCircleAoe(castInfo.Caster.Position, raidManager.Players, [], 4);
                    // 塔内人数大于 2 时，随机选 2 人作为本塔实际判定玩家；小于等于 2 人时保持原判定结果。
                    // 后续所有“谁踩了塔”的记录和塔人数是否合法，都只看 towerHitPlayers。
                    var towerPickRandom = new Random();
                    var towerHitPlayers = hitResult.HitPlayers.Count > 2
                        ? hitResult.HitPlayers.OrderBy(_ => towerPickRandom.Next()).Take(2).ToList()
                        : hitResult.HitPlayers.ToList();
                    var towerRound = -1;
                    foreach (var player in raidManager.Players)
                    {
                        // 从塔实体 ID 读取这座塔属于第几轮；这个值在 CastBegin 中绑定。
                        if (player.PlayerVar.ContainsKey($"KfkTowerRound_{castInfo.Caster.ServerGameObjectId}"))
                        {
                            towerRound = (int)player.PlayerVar[$"KfkTowerRound_{castInfo.Caster.ServerGameObjectId}"];
                            break;
                        }
                    }

                    if (towerRound >= 0)
                    {
                        foreach (var player in towerHitPlayers)
                        {
                            // 真正踩塔玩家只从 2人塔 Action 的 hitResult.HitPlayers 获取。
                            // TimeLineNode 不再按位置推断踩塔结果。
                            player.PlayerVar[$"KfkTowerHit_{towerRound}"] = true;
                        }

                        foreach (var player in raidManager.Players)
                        {
                            // 每轮有两座塔，两个塔 Action 都 Execute 后才开始发下一轮点名。
                            var executeKey = $"KfkTowerExecute_{towerRound}";
                            player.PlayerVar[executeKey] = player.PlayerVar.ContainsKey(executeKey) ? (int)player.PlayerVar[executeKey] + 1 : 1;
                        }

                        var firstPlayer = raidManager.Players.FirstOrDefault();
                        if (firstPlayer != null &&
                            (int)firstPlayer.PlayerVar[$"KfkTowerExecute_{towerRound}"] >= 2 &&
                            !firstPlayer.PlayerVar.ContainsKey($"KfkTowerMarkerConsumed_{towerRound}"))
                        {
                            foreach (var player in raidManager.Players)
                            {
                                // 防止同一轮两座塔或重复 Execute 导致重复消费。
                                player.PlayerVar[$"KfkTowerMarkerConsumed_{towerRound}"] = true;
                            }

                            var random = new Random();
                            var towerPlayers = raidManager.Players
                                // 后续点名只赋给本轮实际踩塔玩家；没踩塔玩家不会被覆盖，保留旧 PlayerVar["KfkMarker"]。
                                .Where(p => p.PlayerVar.ContainsKey($"KfkTowerHit_{towerRound}") && (bool)p.PlayerVar[$"KfkTowerHit_{towerRound}"])
                                .OrderBy(_ => random.Next())
                                .ToList();

                            foreach (var player in towerPlayers)
                            {
                                // 消费当前点名的位置：
                                // 这里必须在下面写入下一次 PlayerVar["KfkMarker"] 之前读取。
                                // 如果先赋予新点名，旧点名会被覆盖，后面就无法知道这名玩家本轮实际消费了什么。
                                var currentMarker = player.PlayerVar.ContainsKey("KfkMarker") ? player.PlayerVar["KfkMarker"] as string : string.Empty;
                                player.ReduceStatusStack(1002, 1);
                                switch (currentMarker)
                                {
                                    case "分摊":
                                        // 本轮踩塔前持有的是分摊；先把它记录为已消费，再清掉当前点名。
                                        player.PlayerVar[$"KfkConsumedMarker_{towerRound}"] = "分摊";
                                        player.PlayerVar["KfkLastConsumedMarker"] = "分摊";
                                        var circelAoeResult = AoeHelper.MakeCircleAoe(player.Position, raidManager.Players, [], 5);
                                        Presentation.EffectAt(47808, player.Position, target: unchecked((uint)player.ClientId));
                                        if (circelAoeResult.HitPlayers.Count != 3)
                                        {
                                            foreach (var item in raidManager.Players)
                                            {
                                                Presentation.Kill(item, (uint)castInfo.ActionInfo.GameActionId);
                                            }
                                        }

                                        foreach (var item in circelAoeResult.HitPlayers)
                                        {
                                            if (item.HasStatus(9001))
                                            {
                                                Presentation.Kill(item, (uint)castInfo.ActionInfo.GameActionId);

                                            }
                                            else
                                            {
                                                item.AddStatus(9001); Presentation.Hit(item, (uint)castInfo.ActionInfo.GameActionId, 100000);
                                            }
                                        }
                                        break;
                                    case "大圈":
                                        // 本轮踩塔前持有的是大圈；先把它记录为已消费，再清掉当前点名。
                                        player.PlayerVar[$"KfkConsumedMarker_{towerRound}"] = "大圈";
                                        player.PlayerVar["KfkLastConsumedMarker"] = "大圈";
                                        var circelAoe = AoeHelper.MakeCircleAoe(player.Position, raidManager.Players, [], 5);
                                        Presentation.EffectAt(47809, player.Position, target: unchecked((uint)player.ClientId));
                                        foreach (var item in circelAoe.HitPlayers)
                                        {
                                            if (item.HasStatus(9001))
                                            {
                                                Presentation.Kill(item, (uint)castInfo.ActionInfo.GameActionId);

                                            }
                                            else
                                            {
                                                item.AddStatus(9001); Presentation.Hit(item, (uint)castInfo.ActionInfo.GameActionId, 100000);
                                            }
                                        }
                                        break;
                                    case "扇形":
                                        // 本轮踩塔前持有的是扇形；先把它记录为已消费，再清掉当前点名。
                                        player.PlayerVar[$"KfkConsumedMarker_{towerRound}"] = "扇形";
                                        player.PlayerVar["KfkLastConsumedMarker"] = "扇形";
                                        var result = raidManager.Players
                                            .Where(x => x != player)
                                            .OrderBy(x => System.Numerics.Vector3.DistanceSquared(x.Position, player.Position));
                                        foreach (var item in result)
                                        {
                                            Console.WriteLine($"Fan Target {player} -> {item.PlayerName} ({Vector3.Distance(player.Position,item.Position)})");
                                        }
                                        var target = result.FirstOrDefault();
                                        if (target == null) break;
                                        float dx = target.Position.X - player.Position.X;
                                        float dz = target.Position.Z - player.Position.Z;
                                        var Rotation = (float)Math.Atan2(dx, dz);
                                        Presentation.EffectAt(47810, player.Position, Rotation);
                                        var fanHit = AoeHelper.MakeFanAoe(player.Position, Rotation, raidManager.Players, [], 100, 1.5708f);
                                        foreach (var item in fanHit.HitPlayers)
                                        {
                                            if (item == player) continue;
                                            if (item.HasStatus(9001))
                                            {
                                                Presentation.Kill(item, (uint)castInfo.ActionInfo.GameActionId);

                                            }
                                            else
                                            {
                                                item.AddStatus(9001); Presentation.Hit(item, (uint)castInfo.ActionInfo.GameActionId, 100000);
                                            }
                                        }
                                        break;
                                    default:
                                        // 正常流程里每个玩家都应该有 KfkMarker；这里保留兜底，方便排查异常状态。
                                        player.PlayerVar[$"KfkConsumedMarker_{towerRound}"] = string.Empty;
                                        player.PlayerVar["KfkLastConsumedMarker"] = string.Empty;
                                        break;
                                }

                                // 清掉旧点名，表示它已经被本轮塔消费。
                                // 下面重新分配时，会只给 towerPlayers 中的玩家写入新的 PlayerVar["KfkMarker"]。
                                player.PlayerVar.Remove("KfkMarker");
                            }

                            if (towerRound <= 5 && !firstPlayer.PlayerVar.ContainsKey($"KfkTowerMarkerAssigned_{towerRound}"))
                            {
                                foreach (var player in raidManager.Players)
                                {
                                    // 防止同一轮两座塔或重复 Execute 导致重复赋予。
                                    player.PlayerVar[$"KfkTowerMarkerAssigned_{towerRound}"] = true;
                                }

                                // 文档规则：奇数轮塔后 2 大圈 + 2 扇形；偶数轮塔后 2 分摊 + 1 大圈 + 1 扇形。
                                // towerRound 从 0 开始，所以 0/2/4 对应第 1/3/5 轮塔后。
                                var requestedMarkers = towerRound % 2 == 0
                                    ? new List<string> { "大圈", "大圈", "扇形", "扇形" }
                                    : new List<string> { "分摊", "分摊", "大圈", "扇形" };
                                // 点名池从 PlayerVar 读取；首次点名后由 TimeLine 同步，后续每次 Action 扣减后再同步。
                                var stackMarkerPool = firstPlayer.PlayerVar.ContainsKey("KfkStackMarkerPool") ? (int)firstPlayer.PlayerVar["KfkStackMarkerPool"] : 0;
                                var circleMarkerPool = firstPlayer.PlayerVar.ContainsKey("KfkCircleMarkerPool") ? (int)firstPlayer.PlayerVar["KfkCircleMarkerPool"] : 0;
                                var fanMarkerPool = firstPlayer.PlayerVar.ContainsKey("KfkFanMarkerPool") ? (int)firstPlayer.PlayerVar["KfkFanMarkerPool"] : 0;

                                for (var i = 0; i < towerPlayers.Count && i < requestedMarkers.Count; i++)
                                {
                                    var marker = requestedMarkers[i];
                                    if (marker == "分摊" && stackMarkerPool <= 0 ||
                                        marker == "大圈" && circleMarkerPool <= 0 ||
                                        marker == "扇形" && fanMarkerPool <= 0)
                                    {
                                        // 指定点名池不足时，按 分摊 -> 大圈 -> 扇形 的 fallback 顺序补足。
                                        if (stackMarkerPool > 0)
                                        {
                                            marker = "分摊";
                                        }
                                        else if (circleMarkerPool > 0)
                                        {
                                            marker = "大圈";
                                        }
                                        else if (fanMarkerPool > 0)
                                        {
                                            marker = "扇形";
                                        }
                                        else
                                        {
                                            marker = string.Empty;
                                        }
                                    }

                                    if (!string.IsNullOrEmpty(marker))
                                    {
                                        if (marker == "分摊")
                                        {
                                            stackMarkerPool--;
                                        }
                                        else if (marker == "大圈")
                                        {
                                            circleMarkerPool--;
                                        }
                                        else
                                        {
                                            fanMarkerPool--;
                                        }

                                        towerPlayers[i].PlayerVar["KfkMarker"] = marker;
                                        switch (towerPlayers[i].PlayerVar["KfkMarker"])
                                        {
                                            case "分摊":
                                                Presentation.Icon(towerPlayers[i], 715);
                                                break;
                                            case "大圈":
                                                Presentation.Icon(towerPlayers[i], 716);

                                                break;
                                            case "扇形":
                                                Presentation.Icon(towerPlayers[i], 717);

                                                break;
                                        }
                                        // 当前点名读取位置：
                                        // 任何地方要读取玩家当前点名，都读 towerPlayers[i].PlayerVar["KfkMarker"]。
                                        // 这里覆盖的只有本轮踩塔玩家；未踩塔玩家没有执行到这里，因此保留旧点名。
                                    }
                                }

                                foreach (var player in raidManager.Players)
                                {
                                    // 同步剩余点名池给所有玩家，下一轮塔 Action 继续从 PlayerVar 读取。
                                    player.PlayerVar["KfkStackMarkerPool"] = stackMarkerPool;
                                    player.PlayerVar["KfkCircleMarkerPool"] = circleMarkerPool;
                                    player.PlayerVar["KfkFanMarkerPool"] = fanMarkerPool;
                                }

                                Console.WriteLine($"[DEBUG] 第{towerRound + 1}轮塔后点名完成 Pool 分摊:{stackMarkerPool} 大圈:{circleMarkerPool} 扇形:{fanMarkerPool}");
                            }
                        }
                    }

                    if (towerHitPlayers.Count != 2)
                    {
                        Presentation.EffectAt(47807, castInfo.Caster.Position);

                        raidManager.Players.ForEach(p =>
                        {
                            Presentation.Kill(p, (uint)castInfo.ActionInfo.GameActionId);

                        });
                    }
                    else
                    {
                        Presentation.EffectAt(47806, castInfo.Caster.Position);

                        towerHitPlayers.ForEach(p =>
                        {
                            // 录像中光之波动结算本身为 0 伤害，真实伤害由咏唱危机分支产生。
                        });
                    }
                }
            };
        }
    }
}
