// 最终阶段共同生命周期：入场前阶段场景、木桩、转场、实际击杀通关。
namespace Kawari.Encounters;
public static class UltimateEncounter
{
    public static TimeLineDef Configure(TimeLineDef definition)
    {
        definition.OnTimeLineInit=c=>{
            var d=c.D;var catalog=c.Definition.Actors!;
            d.ResetOnDeaggro(false);d.Flag(catalog.DirectorFlag);d.LimitBreak(0);
            c.Definition.InitialScene?.Invoke(c);
            foreach(var key in catalog.Initial)c.Actors.Spawn(key,false);
            c.Definition.InitialObjects?.Invoke(c);
            foreach(var key in catalog.Initial)if(catalog.Templates[key].Get<string>("owner") is {} owner)c.Actors.Owner(key,owner);
            var dummy=d.Spawn("trigger",new(){["base"]=11744,["name"]=541,["hp"]=99999999,["level"]=1,["pos"]=Position.Center,["rotation"]=Math.PI,["targetable"]=true,["boss"]=true});
            d.ArmTrigger(dummy);d.Ai(dummy,true);
        };
        definition.OnBattleStart=c=>{if(c.Phase!="waiting")return;c.Phase="transition";c.D.Despawn("trigger");c.Mechanics.Start();};
        definition.OnTick=c=>{if(c.Phase is "transition" or "battle")c.Mechanics.Tick();};
        definition.OnStop=c=>{c.D.DirectorEvent(0x8000001B,1,0,0,0);c.Scene.Clear();c.Definition.InitialScene?.Invoke(c);};
        definition.OnEvent=(c,e)=>{
            var kind=e.GetProperty("kind").GetString();
            if(kind=="death"&&c.Phase is not ("waiting" or "complete"))
            {
                ActorRef actor=e.GetProperty("actor").GetUInt32();var baseId=e.GetProperty("base").GetUInt32();
                var p=e.GetProperty("pos").EnumerateArray().Select(v=>v.GetDouble()).ToArray();
                var dead=c.Get("dead",()=>new HashSet<uint>());if(!dead.Add(actor.Id))return;
                c.Mechanics.ActorDeath(baseId,new(p[0],p[1],p[2]),actor);
                if(c.Boss is {} boss&&c.D.Resolve(boss)==actor.Id&&c.Phase=="battle")c.Complete();
            }
            else if(kind=="gimmick")
            {var player=e.GetProperty("actor").GetUInt32();if(e.GetProperty("id").GetUInt32()==2000139)c.D.Emit("abandon_duty",player);c.D.Emit("finish_gimmick",player);}
        };
        return definition;
    }
}
