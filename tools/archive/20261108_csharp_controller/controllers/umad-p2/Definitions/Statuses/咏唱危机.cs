using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Struct;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Statuses.UKFKP2
{
    public class 咏唱危机 : IStatusDefinition
    {
        public static int DefinitionId => 1002;

        public Status Build()
        {
            return new Status()
            {
                StatusId = DefinitionId,
                GameIconId = 218951,
                Duration = TimeSpan.MaxValue,
                StackStep = 1,
                CurrentStack = 4,
                CanStack = true,
                StatusDescription = "身体被植入了多种魔法。魔法会在凯夫卡的魔力波动命中自身时发动，并减少档数。同时，制裁之光对自身造成的伤害大幅提高",
                StatusName = "咏唱危机",
                OnStatusAdd = (_, _) => { },
                OnStatusRemove = (_, _, _) => { },
                OnStatusTick = (_, _) => { }
            };
        }
    }
}