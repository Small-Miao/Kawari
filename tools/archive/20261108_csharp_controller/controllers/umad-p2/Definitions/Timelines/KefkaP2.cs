using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Enum;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Struct;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

class KfkP2_1Timeline : ITimeLineDefinition
{
    public string DefinitionId => "KfkTimeline P2 Raid1";

    public TimeLineDef Build()
    {
        var timeline = new TimeLineDef
        {
            TimeLineName = "绝凯夫卡P2 1运",
            TimeLineAuthor = "Small_Miao",
        };


        timeline.OnTimeLineInit = () =>
        {
            RaidManager.Instance.PlayBgm(533);
            Native.ActorDied += id => {
                if (Native.State.Bindings.TryGetValue("ms-3000", out var boss) && id == boss)
                    Native.Complete();
            };
            Native.MapEffect(0, 64, 128);
            Native.MapEffect(17, 1, 2);
            Native.MapEffect(18, 1, 4);
            for (byte index = 1; index <= 8; index++) Native.MapEffect(index, 4, 8);
            timeline.TimeLineVars.Clear();
            timeline.TimeLineVars["BeginTower"] = new Random().Next(0, 8);
            timeline.TimeLineVars["TowerClockWise"] = new Random().Next(0, 2) == 0;
            timeline.TimeLineVars["TowersId"] = new int[] { 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009 };
            timeline.TimeLineVars["TowerRounds"] = 0;
            timeline.TimeLineVars["IsBackOrFront"] = 0; // 0 Front 1 Back
            // TimeLineVars 保存整条时间轴共享的点名池数量；首次点名时扣减，之后同步到 PlayerVar 供塔 Action 使用。
            timeline.TimeLineVars["KfkStackMarkerPool"] = 8;
            timeline.TimeLineVars["KfkCircleMarkerPool"] = 12;
            timeline.TimeLineVars["KfkFanMarkerPool"] = 12;
            timeline.TimeLineVars["KfkInitialMarkerAssigned"] = false;
            timeline.TimeLineVars["KfkRandom"] = new Random();
            new GameObject("凯夫卡", 3000, true, true, new System.Numerics.Vector3(), 0, 5, new System.Numerics.Vector3(3, 3, 3), 5, 2137);
            new GameObject("塔1", 1002, false, false, new System.Numerics.Vector3(0, 0, 8), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔2", 1003, false, false, new System.Numerics.Vector3(5.657f, 0, 5.657f), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔3", 1004, false, false, new System.Numerics.Vector3(8, 0, 0), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔4", 1005, false, false, new System.Numerics.Vector3(5.657f, 0, -5.657f), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔5", 1006, false, false, new System.Numerics.Vector3(0, 0, -8), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔6", 1007, false, false, new System.Numerics.Vector3(-5.657f, 0, -5.657f), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔7", 1008, false, false, new System.Numerics.Vector3(-8, 0, 0), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
            new GameObject("塔8", 1009, false, false, new System.Numerics.Vector3(-5.657f, 0, 5.657f), 0, 0, System.Numerics.Vector3.One, 0, 0x1E0);
        };

        timeline.OnTimeLineReset = () =>
        {

            timeline.TimeLineVars.Clear();
            RaidManager.Instance.ClearAllPlayerStatus();
            RaidManager.Instance.DestoryAllObject();
        };

        timeline.TimeLinePhaseList = new List<TimeLinePhase>()
        {
            new TimeLinePhase()
            {
                PhaseName = "P2 1运",
                TimeLineNodes = new List<TimeLineNode>()
                {
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(3),
                        NodeName = "遗弃末世",
                        OnTimeLineEvent = () =>
                        {


                            var kfk = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            kfk?.TryCast(1001);
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(9),
                        NodeName = "分配BUFF",
                        OnTimeLineEvent = () =>{
                            Console.WriteLine($"[DEBUG] BeginTower:{timeline.TimeLineVars["BeginTower"]} TowerClockwise:{timeline.TimeLineVars["TowerClockWise"]}");
                            if (!(bool)timeline.TimeLineVars["KfkInitialMarkerAssigned"])
                            {
                                timeline.TimeLineVars["KfkInitialMarkerAssigned"] = true;
                                foreach (var player in RaidManager.Instance.Players)
                                {
                                    // 玩家当前点名的唯一存储位置：PlayerVar["KfkMarker"]。
                                    // 读取当前点名时使用：player.PlayerVar["KfkMarker"]，值为 "分摊" / "大圈" / "扇形"。
                                    player.PlayerVar.Remove("KfkMarker");
                                    player.PlayerVar.Remove("KfkLastConsumedMarker");
                                    // KfkCastingTowerRound 是 TimeLineNode 生成塔前写入的“当前生成第几轮塔”，给 2人塔 Action 读取。
                                    player.PlayerVar.Remove("KfkCastingTowerRound");
                                    for (var i = 0; i < 8; i++)
                                    {
                                        // KfkTowerHit_i / Execute_i / MarkerAssigned_i 都是 2人塔 Action 的塔判定中间状态。
                                        player.PlayerVar.Remove($"KfkTowerHit_{i}");
                                        player.PlayerVar.Remove($"KfkTowerExecute_{i}");
                                        player.PlayerVar.Remove($"KfkTowerMarkerConsumed_{i}");
                                        player.PlayerVar.Remove($"KfkConsumedMarker_{i}");
                                        player.PlayerVar.Remove($"KfkTowerMarkerAssigned_{i}");
                                    }
                                }

                                var random = (Random)timeline.TimeLineVars["KfkRandom"];
                                var players = RaidManager.Instance.Players.OrderBy(_ => random.Next()).ToList();
                                var supportPlayers = players.Where(p => p.Role == RoleEnum.TANK || p.Role == RoleEnum.HEALER).OrderBy(_ => random.Next()).ToList();
                                var dpsPlayers = players.Where(p => p.Role == RoleEnum.DPS_MELEE || p.Role == RoleEnum.DPS_RANGE).OrderBy(_ => random.Next()).ToList();
                                Console.WriteLine("T H :");
                                foreach (var item in supportPlayers){
                                    Console.WriteLine(item.PlayerName);
                                }
                                Console.WriteLine("D:");
                                foreach (var item in dpsPlayers){
                                    Console.WriteLine(item.PlayerName);
                                }
                                var assignedClientIds = new HashSet<int>();

                                var supportStack = supportPlayers.FirstOrDefault();
                                if (supportStack == null)
                                {
                                    supportStack = players.FirstOrDefault();
                                }

                                if (supportStack != null)
                                {
                                    assignedClientIds.Add(supportStack.ClientId);
                                    // 首次赋予分摊：直接写入该玩家当前点名。
                                    supportStack.PlayerVar["KfkMarker"] = "分摊";
                                    Presentation.Icon(supportStack, 715);
                                    timeline.TimeLineVars["KfkStackMarkerPool"] = (int)timeline.TimeLineVars["KfkStackMarkerPool"] - 1;
                                }

                                var dpsStack = dpsPlayers.FirstOrDefault(p => !assignedClientIds.Contains(p.ClientId));
                                if (dpsStack == null)
                                {
                                    dpsStack = players.FirstOrDefault(p => !assignedClientIds.Contains(p.ClientId));
                                }

                                if (dpsStack != null)
                                {
                                    assignedClientIds.Add(dpsStack.ClientId);
                                    // 首次赋予分摊：直接写入该玩家当前点名。
                                    dpsStack.PlayerVar["KfkMarker"] = "分摊";
                                    Presentation.Icon(dpsStack, 715);
                                    timeline.TimeLineVars["KfkStackMarkerPool"] = (int)timeline.TimeLineVars["KfkStackMarkerPool"] - 1;
                                }

                                var circleFromSupport = random.Next(0, 2) == 0;
                                var circlePlayers = (circleFromSupport ? supportPlayers : dpsPlayers)
                                    .Where(p => !assignedClientIds.Contains(p.ClientId))
                                    .Take(3)
                                    .ToList();
                                while (circlePlayers.Count < 3)
                                {
                                    var fillPlayer = players.FirstOrDefault(p => !assignedClientIds.Contains(p.ClientId) && !circlePlayers.Any(x => x.ClientId == p.ClientId));
                                    if (fillPlayer == null)
                                    {
                                        break;
                                    }
                                    circlePlayers.Add(fillPlayer);
                                }

                                foreach (var player in circlePlayers)
                                {
                                    assignedClientIds.Add(player.ClientId);
                                    // 首次赋予大圈：直接写入该玩家当前点名。
                                    player.PlayerVar["KfkMarker"] = "大圈";
                                    Presentation.Icon(player, 716);
                                    timeline.TimeLineVars["KfkCircleMarkerPool"] = (int)timeline.TimeLineVars["KfkCircleMarkerPool"] - 1;
                                }

                                var fanPlayers = (circleFromSupport ? dpsPlayers : supportPlayers)
                                    .Where(p => !assignedClientIds.Contains(p.ClientId))
                                    .Take(3)
                                    .ToList();
                                while (fanPlayers.Count < 3)
                                {
                                    var fillPlayer = players.FirstOrDefault(p => !assignedClientIds.Contains(p.ClientId) && !fanPlayers.Any(x => x.ClientId == p.ClientId));
                                    if (fillPlayer == null)
                                    {
                                        break;
                                    }
                                    fanPlayers.Add(fillPlayer);
                                }

                                foreach (var player in fanPlayers)
                                {
                                    assignedClientIds.Add(player.ClientId);
                                    // 首次赋予扇形：直接写入该玩家当前点名。
                                    player.PlayerVar["KfkMarker"] = "扇形";
                                    Presentation.Icon(player, 717);
                                    timeline.TimeLineVars["KfkFanMarkerPool"] = (int)timeline.TimeLineVars["KfkFanMarkerPool"] - 1;
                                }

                                foreach (var player in RaidManager.Instance.Players)
                                {
                                    // 后续点名在 2人塔 Action 中执行；Action 不能直接读取本 timeline 对象，所以把剩余点名池同步到每个玩家的 PlayerVar。
                                    player.PlayerVar["KfkStackMarkerPool"] = timeline.TimeLineVars["KfkStackMarkerPool"];
                                    player.PlayerVar["KfkCircleMarkerPool"] = timeline.TimeLineVars["KfkCircleMarkerPool"];
                                    player.PlayerVar["KfkFanMarkerPool"] = timeline.TimeLineVars["KfkFanMarkerPool"];
                                }

                                Console.WriteLine($"[DEBUG] 初始点名完成 Pool 分摊:{timeline.TimeLineVars["KfkStackMarkerPool"]} 大圈:{timeline.TimeLineVars["KfkCircleMarkerPool"]} 扇形:{timeline.TimeLineVars["KfkFanMarkerPool"]}");
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(1),
                        NodeName = "第一轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 0;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                // 生成塔前写入当前塔轮次。2人塔 Action 的 CastBegin 会读取这个值并绑定到具体塔实体。
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                // 清理本轮旧命中结果，避免重开/重复执行时间轴时残留。
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);

                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(10),
                        NodeName = "第二轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 1;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(3),
                        NodeName = "未来/过去终结",
                        OnTimeLineEvent = () =>
                        {
                            var random = new Random().Next(0,2) == 0;
                            timeline.TimeLineVars["IsBackOrFront"] = random? 1 : 0;
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            if (random)
                            {
                                kafukaMain?.TryCast(1003);
                            }
                            else
                            {
                                kafukaMain?.TryCast(1004);
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(6.7),
                        NodeName = "未来/过去终结结算",
                        OnTimeLineEvent = () =>
                        {
                            new GameObject("凯夫卡",2001,false,true,new System.Numerics.Vector3(),0,0,new System.Numerics.Vector3(3,3,3),5,2137);
                            new GameObject("凯夫卡",2002,false,true,new System.Numerics.Vector3(),0,0,new System.Numerics.Vector3(3,3,3),5,2137);
                            new GameObject("凯夫卡",2003,false,true,new System.Numerics.Vector3(),0,0,new System.Numerics.Vector3(3,3,3),5,2137);
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            var result = RaidManager.Instance.Players
                            .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, kafukaMain.Position))
                            .ToList().Take(4);
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];

                            var proc = 0;
                            foreach (var item in result)
                            {
                                gameObjects[proc].MoveSpeed = 100;
                                gameObjects[proc].TargetPlayer = item;
                                gameObjects[proc].Move = true;
                                 if((int)timeline.TimeLineVars["IsBackOrFront"] == 0){
                                     gameObjects[proc].TryCast(1009,targetPlayer:item);
                                }
                                else
                                {
                                     gameObjects[proc].TryCast(1008,targetPlayer:item);
                                }
                                proc++;
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(0.3),
                        NodeName = "第三轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 2;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        NodeName = "消灭之脚",
                        Duration = TimeSpan.FromSeconds(5),
                        OnTimeLineEvent = () =>
                        {
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];
                            foreach (var item in gameObjects)
                            {
                                var result = RaidManager.Instance.Players
                                .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, item.Position))
                                .ToList().First();
                                float dx = result.Position.X - item.Position.X;
                                float dz = result.Position.Z - item.Position.Z;
                                item.Rotation = (float)Math.Atan2(dx, dz);
                                item.BrocastMove();
                                if((int)timeline.TimeLineVars["IsBackOrFront"] == 0)
                                {
                                    item.TryCast(1006,targetPlayer:result);
                                }
                                else
                                {
                                    item.TryCast(1007,targetPlayer:result);
                                }
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(5),
                        NodeName = "第四轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 3;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(3),
                        NodeName = "未来/过去终结",
                        OnTimeLineEvent = () =>
                        {
                            var random = new Random().Next(0,2) == 0;
                            timeline.TimeLineVars["IsBackOrFront"] = random? 1 : 0;
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            if (random)
                            {
                                kafukaMain?.TryCast(1003);
                            }
                            else
                            {
                                kafukaMain?.TryCast(1004);
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(6.7),
                        NodeName = "未来/过去终结结算",
                        OnTimeLineEvent = () =>
                        {
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            var result = RaidManager.Instance.Players
                            .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, kafukaMain.Position))
                            .ToList().Take(4);
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];

                            var proc = 0;
                            foreach (var item in result)
                            {
                                gameObjects[proc].MoveSpeed = 100;
                                gameObjects[proc].TargetPlayer = item;
                                gameObjects[proc].Move = true;
                                 if((int)timeline.TimeLineVars["IsBackOrFront"] == 0){
                                     gameObjects[proc].TryCast(1009,targetPlayer:item);
                                }
                                else
                                {
                                     gameObjects[proc].TryCast(1008,targetPlayer:item);
                                }
                                proc++;
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(0.3),
                        NodeName = "第五轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 4;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        NodeName = "消灭之脚",
                        Duration = TimeSpan.FromSeconds(5),
                        OnTimeLineEvent = () =>
                        {
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];
                            foreach (var item in gameObjects)
                            {
                                var result = RaidManager.Instance.Players
                                .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, item.Position))
                                .ToList().First();
                                float dx = result.Position.X - item.Position.X;
                                float dz = result.Position.Z - item.Position.Z;
                                item.Rotation = (float)Math.Atan2(dx, dz);
                                item.BrocastMove();
                                if((int)timeline.TimeLineVars["IsBackOrFront"] == 0)
                                {
                                    item.TryCast(1006,targetPlayer:result);
                                }
                                else
                                {
                                    item.TryCast(1007,targetPlayer:result);
                                }
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(5),
                        NodeName = "第六轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 5;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(3),
                        NodeName = "未来/过去终结",
                        OnTimeLineEvent = () =>
                        {
                            var random = new Random().Next(0,2) == 0;
                            timeline.TimeLineVars["IsBackOrFront"] = random? 1 : 0;
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            if (random)
                            {
                                kafukaMain?.TryCast(1003);
                            }
                            else
                            {
                                kafukaMain?.TryCast(1004);
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(6.7),
                        NodeName = "未来/过去终结结算",
                        OnTimeLineEvent = () =>
                        {
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            var result = RaidManager.Instance.Players
                            .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, kafukaMain.Position))
                            .ToList().Take(4);
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];

                            var proc = 0;
                            foreach (var item in result)
                            {
                                gameObjects[proc].MoveSpeed = 100;
                                gameObjects[proc].TargetPlayer = item;
                                gameObjects[proc].Move = true;
                                 if((int)timeline.TimeLineVars["IsBackOrFront"] == 0){
                                     gameObjects[proc].TryCast(1009,targetPlayer:item);
                                }
                                else
                                {
                                     gameObjects[proc].TryCast(1008,targetPlayer:item);
                                }
                                proc++;
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(0.3),
                        NodeName = "第七轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 6;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        NodeName = "消灭之脚",
                        Duration = TimeSpan.FromSeconds(5),
                        OnTimeLineEvent = () =>
                        {
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];
                            foreach (var item in gameObjects)
                            {
                                var result = RaidManager.Instance.Players
                                .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, item.Position))
                                .ToList().First();
                                float dx = result.Position.X - item.Position.X;
                                float dz = result.Position.Z - item.Position.Z;
                                item.Rotation = (float)Math.Atan2(dx, dz);
                                item.BrocastMove();
                                if((int)timeline.TimeLineVars["IsBackOrFront"] == 0)
                                {
                                    item.TryCast(1006,targetPlayer:result);
                                }
                                else
                                {
                                    item.TryCast(1007,targetPlayer:result);
                                }
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(5),
                        NodeName = "第八轮塔",
                        OnTimeLineEvent = () =>
                        {
                            timeline.TimeLineVars["TowerRounds"] = 7;
                            var beginTower = (int)timeline.TimeLineVars["BeginTower"];
                            var clockwise = (bool)timeline.TimeLineVars["TowerClockWise"];
                            var round = (int)timeline.TimeLineVars["TowerRounds"];
                            var towersId = (int[])timeline.TimeLineVars["TowersId"];
                            int towerA = clockwise? (beginTower + round) % 8: (beginTower - round + 8) % 8;
                            int towerB = (towerA + 2) % 8;
                            foreach (var player in RaidManager.Instance.Players)
                            {
                                player.PlayerVar["KfkCastingTowerRound"] = round;
                                player.PlayerVar.Remove($"KfkTowerHit_{round}");
                            }
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerA])?.TryCast(1002);
                            RaidManager.Instance.GetObjectByGameObjectId((ulong)towersId[towerB])?.TryCast(1002);
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(3),
                        NodeName = "未来/过去终结",
                        OnTimeLineEvent = () =>
                        {
                            var random = new Random().Next(0,2) == 0;
                            timeline.TimeLineVars["IsBackOrFront"] = random? 1 : 0;
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            if (random)
                            {
                                kafukaMain?.TryCast(1003);
                            }
                            else
                            {
                                kafukaMain?.TryCast(1004);
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(6.7),
                        NodeName = "未来/过去终结结算",
                        OnTimeLineEvent = () =>
                        {
                            var kafukaMain = RaidManager.Instance.GetObjectByGameObjectId(3000);
                            var result = RaidManager.Instance.Players
                            .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, kafukaMain.Position))
                            .ToList().Take(4);
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];

                            var proc = 0;
                            foreach (var item in result)
                            {
                                gameObjects[proc].MoveSpeed = 100;
                                gameObjects[proc].TargetPlayer = item;
                                gameObjects[proc].Move = true;
                                 if((int)timeline.TimeLineVars["IsBackOrFront"] == 0){
                                     gameObjects[proc].TryCast(1009,targetPlayer:item);
                                }
                                else
                                {
                                     gameObjects[proc].TryCast(1008,targetPlayer:item);
                                }
                                proc++;
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        NodeName = "消灭之脚",
                        Duration = TimeSpan.FromSeconds(6.1),
                        OnTimeLineEvent = () =>
                        {
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(3000),
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];
                            foreach (var item in gameObjects)
                            {
                                var result = RaidManager.Instance.Players
                                .OrderBy(x => System.Numerics.Vector3.Distance(x.Position, item.Position))
                                .ToList().First();
                                float dx = result.Position.X - item.Position.X;
                                float dz = result.Position.Z - item.Position.Z;
                                item.Rotation = (float)Math.Atan2(dx, dz);
                                item.BrocastMove();
                                if((int)timeline.TimeLineVars["IsBackOrFront"] == 0)
                                {
                                    item.TryCast(1006,targetPlayer:result);
                                }
                                else
                                {
                                    item.TryCast(1007,targetPlayer:result);
                                }
                            }
                        }
                    },
                    new TimeLineNode()
                    {
                        Duration = TimeSpan.FromSeconds(10),
                        NodeName = "移除分身",
                        OnTimeLineEvent = () =>
                        {
                            GameObject[] gameObjects = [
                                RaidManager.Instance.GetObjectByGameObjectId(2001),
                                RaidManager.Instance.GetObjectByGameObjectId(2002),
                                RaidManager.Instance.GetObjectByGameObjectId(2003)
                            ];

                            var proc = 0;
                            foreach (var item in gameObjects)
                            {
                                item.Destory();
                            }
                        }
                    },

                }
            },
        };

        return timeline;
    }
}
