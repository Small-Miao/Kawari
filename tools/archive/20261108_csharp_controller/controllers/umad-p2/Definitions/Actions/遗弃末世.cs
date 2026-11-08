using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Actions.UKFKP2
{
    public class 遗弃末世 : IActionDefinition
    {
        public static int DefinitionId => 1001;

        public MechanicSim_Server.Struct.Action Build()
        {
            return new MechanicSim_Server.Struct.Action()
            {
                ActionId = DefinitionId,
                Id = Guid.NewGuid(),
                ActionName = "遗弃末世",
                ActionCastTime = TimeSpan.FromSeconds(7),
                IsDisplayActionOnGame = false,
                GameActionId = 47804,
                OnActionCastBegin = (castInfo, _) => {
                    Native.MapEffect(17, 4, 8);
                    Presentation.Begin(castInfo.Caster, 47804, 6.7f);
                },
                OnActionCastEnd = (castInfo, raidManager) =>
                {
                    castInfo.Execute();
                },
                OnActionCastExecute = (castInfo,raidManager) =>
                {
                    Presentation.Finish(castInfo.Caster, 47804);
                    Native.MapEffect(17, 1, 2);
                    foreach (var item in raidManager.Players)
                    {
                        item.AddStatus(1002);

                    }
                }
            };
        }
    }
}
