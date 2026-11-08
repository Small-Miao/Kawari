using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class 未来终结 : IActionDefinition
    {
        public static int DefinitionId => 1004;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                ActionId = DefinitionId,
                Id = Guid.NewGuid(),
                ActionName = "未来终结",
                ActionCastTime = TimeSpan.FromSeconds(6.4),
                IsDisplayActionOnGame = false,
                GameActionId = 47826,
                OnActionCastBegin = (castInfo, _) => Presentation.Begin(castInfo.Caster, 47826, 6.1f),
                OnActionCastExecute = (castInfo, _) => Presentation.Finish(castInfo.Caster, 47826),
                OnActionCastEnd = (castInfo, raidManager) =>
                {
                    castInfo.Execute();
                },
            };
        }
    }
}
