using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class 过去终结 : IActionDefinition
    {
        public static int DefinitionId => 1003;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                ActionId = DefinitionId,
                Id = Guid.NewGuid(),
                ActionName = "过去终结",
                ActionCastTime = TimeSpan.FromSeconds(6.4),
                IsDisplayActionOnGame = false,
                GameActionId = 47827,
                OnActionCastBegin = (castInfo, _) => Presentation.Begin(castInfo.Caster, 47827, 6.1f),
                OnActionCastExecute = (castInfo, _) => Presentation.Finish(castInfo.Caster, 47827),
                OnActionCastEnd = (castInfo, raidManager) =>
                {
                    castInfo.Execute();
                },
            };
        }
    }
}
