// 地图和 EObj 的显式脚本接口；命名物件按实例注册并在重置时清理。
namespace Kawari.Encounters;
public sealed class SceneController(EncounterContext context)
{
    private readonly HashSet<string> objects=[];
    public void MapEffect(byte index,ushort state,ushort timeline) => context.D.MapEffect(index,state,timeline);
    public void SpawnEObj(string key,Params spec)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(key);
        if(context.D.Find(key) is not null) context.D.Despawn(key);
        var id=context.D.SpawnEObj(key,spec); objects.Add(key);
        if(spec.Get<uint[]>("animation") is {} a) context.D.ObjectAnimation(id,a[0],a[1]);
    }
    public void AnimateEObj(string key,uint state,uint timeline) => context.D.ObjectAnimation(context.D.Find(key)??throw new InvalidOperationException($"场景物件不存在：{key}"),state,timeline);
    public void RemoveEObj(string key) { context.D.Despawn(key); objects.Remove(key); }
    public void Clear() { foreach(var key in objects) context.D.Despawn(key); objects.Clear(); }
}
