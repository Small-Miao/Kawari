using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Util;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class 未来终结结算 : IActionDefinition
    {
        public static int DefinitionId => 1009;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                ActionId = DefinitionId,
                Id = Guid.NewGuid(),
                ActionName = "未来终结",
                ActionCastTime = TimeSpan.FromSeconds(0.5),
                IsDisplayActionOnGame = false,
                GameActionId = 47830,
                OnActionCastBegin = (castInfo, _) => Presentation.Jump(castInfo, 47830, 47832),
                OnActionCastEnd = (castInfo, raidManager) =>
                {
                    castInfo.Execute();
                },
                OnActionCastExecute = (castInfo, raidManager) =>
                {
                    castInfo.Caster.Move = false;
                    castInfo.Caster.MoveSpeed = 5;
                    var hitResult = AoeHelper.MakeCircleAoe(castInfo.TargetPlayer.Position, raidManager.Players, [], 5);
                    foreach (var item in hitResult.HitPlayers)
                    {
                        if (item.HasStatus(9001))
                        {
                            Presentation.Kill(item, 0);
                        }
                        else
                        {
                            item.AddStatus(9001); Presentation.Hit(item, 0, 100000);
                        }
                    }
                }
            };
        }
    }
}
