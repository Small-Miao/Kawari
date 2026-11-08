using Kawari.Encounters;
// α/β 投影和预演分配均为实例状态，禁止跨副本共享。
namespace Script.Definitions.Actions.TEA;
public sealed class CalibrationState
{
    public string Phase="";
    public ActorRef[] Players=[];
    public Dictionary<string,ActorRef> Owners=[];
    public HashSet<string> Spawned=[];
    public int Count,AssaultIndex;
    public List<ActorRef> Assault=[];
    public Dictionary<ActorRef,ushort> Colors=[];
    public Dictionary<ushort,ActorRef> Beacons=[];
    public ActorRef[] Near=[],Far=[];
    public Dictionary<string,Position> Jumps=[];
    public ActorRef? Defamation,Shared;
    public bool LinksResolved;
    public static CalibrationState? Find(EncounterContext c)=>c.Find<CalibrationState>("calibration");
    public ActorRef? Owner(string? key)=>key is not null&&Owners.TryGetValue(key,out var actor)?actor:(ActorRef?)null;
}
