using Kawari.Encounters;
// 地火、炎柱、旋风分身和地狱之火保留已有原生技能与判定参数。
namespace Script.Definitions.Actions.IfritHard;
public sealed class Mechanics
{
    private static (Position Pos,double Rotation) Spot(int i,double start=0){var a=start+i*Math.PI/4;return(new(21*Math.Sin(a),0,21*Math.Cos(a)),a+Math.PI);}
    private static ActorRef Boss(EncounterContext c)=>c.D.Find("ifrit.boss")!.Value;
    public void Setup(EncounterContext c)
    {
        c.D.Spawn("ifrit.boss",new(){["base"]=209,["name"]=1185,["hp"]=299314,["level"]=50,["pos"]=new Position(15,0,0),["rotation"]=-Math.PI/2,["boss"]=true,["targetable"]=true});
        c.D.Emit("spawn_omen_pool",12,434,1185,Position.Zero);
        for(var i=0;i<3;i++){var (p,r)=Spot(i);c.D.Spawn($"ifrit.clone.{i}",new(){["base"]=209,["name"]=1185,["hp"]=1,["level"]=50,["pos"]=p,["rotation"]=r,["targetable"]=false,["visible"]=false});}
    }
    public void Cycle(EncounterContext c,int cycle)
    {
        c.Schedule(6,x=>{
            var alive=x.D.Players();if(alive.Length==0)return;var boss=Boss(x);var target=alive[x.Random.Next(alive.Length)];
            x.D.Emit("cast",boss,1355,2.2);x.D.Circle(new(){["source"]=boss,["pos"]=x.D.Position(target),["radius"]=8,["delay"]=3,["action"]=1358,["damage"]=3000,["omen"]=true});
        });
        c.Schedule(14,x=>x.D.Cone(new(){["source"]=Boss(x),["radius"]=15,["angle"]=120,["delay"]=1.43,["action"]=1353,["damage"]=4000}));
        c.Schedule(24,x=>{
            var boss=Boss(x);x.D.Emit("cast",boss,1356,2.2);
            Position[] points=cycle%2==0?[new(8,0,0),new(-8,0,0),new(0,0,8),new(0,0,-8)]:Enumerable.Range(0,8).Select(i=>new Position(20*Math.Sin(i*Math.PI/4),0,20*Math.Cos(i*Math.PI/4))).ToArray();
            foreach(var p in points)x.D.Circle(new(){["source"]=boss,["pos"]=p,["radius"]=8,["delay"]=3,["action"]=1359,["damage"]=3000,["omen"]=true});
        });
        c.Schedule(34,x=>{
            var boss=Boss(x);var start=x.Random.NextDouble()*Math.PI*2;x.D.Targetable(boss,false);x.D.PlayTimeline(boss,0x8C);
            x.Schedule(0.5,y=>{y.D.Visible(boss,false);y.D.Ai(boss,false);});
            for(var i=0;i<3;i++)
            {
                var clone=x.D.Find($"ifrit.clone.{i}")!.Value;var(p,r)=Spot(i,start);x.D.Visible(clone,true);x.D.PlayTimeline(clone,0x8D);x.D.Move(clone,p,r);
                x.Schedule(0.7+i*2,y=>{y.D.Emit("cast",clone,457,2.7,null,Position.Zero);y.D.Rect(new(){["source"]=boss,["pos"]=p,["rotation"]=r,["length"]=43,["width"]=12,["delay"]=2.7,["action"]=0,["damage"]=4000});});
            }
            x.Schedule(9.4,y=>{for(var i=0;i<3;i++)y.D.Visible(y.D.Find($"ifrit.clone.{i}")!.Value,false);y.D.Visible(boss,true);y.D.PlayTimeline(boss,0x8D);y.D.Ai(boss,true);y.Schedule(0.5,z=>z.D.Targetable(boss,true));});
        });
        c.Schedule(44,x=>x.D.Raid(new(){["source"]=Boss(x),["omen"]=Boss(x),["omen_cast"]=2,["delay"]=2,["action"]=1357,["damage"]=2000}));
        c.Schedule(48,x=>Cycle(x,cycle+1));
    }
}
