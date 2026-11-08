using Kawari.MechanicSim;
using MechanicSim_Server.Definition;
using MechanicSim_Server.Struct;
using System;
using System.Collections.Generic;
using System.Text;

namespace Script.Definitions.Statuses
{
    public class 魔法防御力降低 : IStatusDefinition
    {
        public static int DefinitionId => 9001;

        public Status Build()
        {
            return new Status()
            {
                StatusId = DefinitionId,
                GameIconId = 215057,
                Duration = TimeSpan.FromSeconds(3),
                StatusDescription = "魔法防御力减弱",
                StatusName = "魔法防御力降低",
                CanStack = false,
                CurrentStack = 1,
                OnStatusAdd = (_, _) => { },
                OnStatusRemove = (_, _, _) => { },
                OnStatusTick = (_, _) => { }
            };
        }
    }
}