// 原生快照模拟器：执行生成、移动、状态和死亡反馈，输出真实宿主命令供 Rust 再验证。
using System.Text.Json;
using Kawari.Encounters;
public sealed class Simulation(int playerCount)
{
    public readonly Dictionary<uint,ActorSnapshot> Actors=Enumerable.Range(1,playerCount).ToDictionary(i=>(uint)i,i=>new ActorSnapshot((uint)i,true,1000000,1000000,new byte[]{19,21,24,28,20,22,23,25}[(i-1)%8],[100+(i%4)*2,0,100+(i/4)*2],0,0,[]));
    public readonly Dictionary<string,uint> Bindings=[];
    private readonly Dictionary<(uint,ushort),StatusSnapshot> statuses=[];
    private uint nextId=1000;
    public readonly Dictionary<string,int> Counts=[];
    public InputFrame Frame(ulong seq,double time,bool battle,params JsonElement[] events)=>new(1,seq,time,battle,Actors.Values.ToArray(),new(Bindings),statuses.Values.ToArray(),events);
    private uint Id(JsonElement value)
    {
        if(value.ValueKind==JsonValueKind.Null)return 0;
        if(value.ValueKind==JsonValueKind.Object&&value.TryGetProperty("actor",out var name))return Bindings.TryGetValue(name.GetString()!,out var id)?id:throw new Exception("不存在的演员引用："+name);
        return value.GetUInt32();
    }
    private static double Number(JsonElement p,string key,double fallback=0)=>p.TryGetProperty(key,out var v)&&v.ValueKind!=JsonValueKind.Null?v.GetDouble():fallback;
    private static double[] Position(JsonElement p)=>new[]{p.GetProperty("x").GetDouble(),p.GetProperty("y").GetDouble(),p.GetProperty("z").GetDouble()};
    private void ValidateReferences(JsonElement value)
    {
        if(value.ValueKind==JsonValueKind.Object){if(value.EnumerateObject().Count()==1&&value.TryGetProperty("actor",out _)){_=Id(value);return;}foreach(var p in value.EnumerateObject())ValidateReferences(p.Value);}
        else if(value.ValueKind==JsonValueKind.Array)foreach(var p in value.EnumerateArray())ValidateReferences(p);
    }
    public void Apply(IEnumerable<Operation> commands)
    {
        foreach(var operation in commands)
        {
            Counts[operation.method]=Counts.GetValueOrDefault(operation.method)+1;
            var args=JsonSerializer.SerializeToElement(operation.args);ValidateReferences(args);
            switch(operation.method)
            {
                case "spawn_actor":case "spawn_event_object":
                    var key=args[0].GetString()!;var spec=args[1];var id=++nextId;Bindings[key]=id;
                    Actors[id]=new(id,false,(uint)Number(spec,"hp",1),(uint)Number(spec,"hp",1),0,Position(spec.GetProperty("pos")),Number(spec,"rotation"),1,Actors.Values.Where(a=>a.player).Select(a=>a.id).ToArray());break;
                case "despawn_registered":
                    if(Bindings.Remove(args[0].GetString()!,out var removed))Actors.Remove(removed);break;
                case "move_actor":case "slide_actor":
                    var moved=Id(args[0]);if(Actors.TryGetValue(moved,out var actor))Actors[moved]=actor with{pos=Position(args[1]),rotation=args[2].GetDouble()};break;
                case "set_target":
                    var from=Id(args[0]);if(Actors.TryGetValue(from,out var source))Actors[from]=source with{target=Id(args[1])};break;
                case "gain_effect":
                    var target=Id(args[0]);var status=args[1].GetUInt16();statuses[(target,status)]=new(target,status,args[2].GetUInt16(),args[3].GetDouble(),args.GetArrayLength()>4?Id(args[4]):0);break;
                case "remove_effect":statuses.Remove((Id(args[0]),args[1].GetUInt16()));break;
            }
        }
    }
    public void ClearEncounter(){foreach(var id in Actors.Where(v=>!v.Value.player).Select(v=>v.Key).ToArray())Actors.Remove(id);Bindings.Clear();statuses.Clear();}
}
