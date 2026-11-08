using Kawari.Encounters;
// 牢狱的动态场景接口；机制直接调用可见的 EObj 动画。
namespace Script.Definitions.d2az;
public static class SceneHooks
{
    private static readonly string[] Prisons=["prison_08","prison_07","prison_06","prison_05","prison_04","prison_03","prison_02","prison_01"];
    public static void Initial(EncounterContext c)=>InitialScene.Reset();
    public static void PrisonPrepare(EncounterContext c){foreach(var key in Prisons)c.Scene.AnimateEObj(key,0x10,0x20);}
    public static void PrisonWarning(EncounterContext c,int index)=>c.Scene.AnimateEObj(Prisons[index],0x400,0x840);
    public static void PrisonClose(EncounterContext c,int index)=>c.Scene.AnimateEObj(Prisons[index],0x1000,0x2000);
}
