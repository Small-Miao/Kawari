using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Manager;
using MechanicSim_Server.Util;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class 消灭之脚_前 : IActionDefinition
    {
        public static int DefinitionId => 1006;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                Id = Guid.NewGuid(),
                ActionId = DefinitionId,
                IsDisplayActionOnGame = false,
                GameActionId = 47836,
                ActionCastTime = TimeSpan.FromSeconds(5),
                ActionName = "消灭之脚",
                OnActionCastBegin = (castInfo, raidManger) =>
                {
                    Presentation.Begin(castInfo.Caster, 47836, 4.7f);
                },
                OnActionCastEnd = (castInfo, _) =>
                {
                    castInfo.Execute();
                },
                OnActionCastExecute = (castInfo,raidManager) =>
                {
                    Presentation.Cleave(castInfo.Caster, 47836, false);
                    var result = AoeHelper.MakeFanAoe(castInfo.Caster.Position, castInfo.Caster.Rotation, raidManager.Players, [], 100, MathF.PI);
                    foreach (var item in result.HitPlayers)
                    {
                        Presentation.Kill(item, 0);

                    }
                }
            };
        }
    }
}
