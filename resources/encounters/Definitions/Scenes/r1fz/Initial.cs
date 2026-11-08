using Kawari.Encounters;
// 入场及重置恢复前阶段场景，再创建静态物件。
using MechanicSim_Server.Manager;
namespace Script.Definitions.r1fz;
public static class InitialScene
{
    public static void Reset()
    {
        RaidManager.Instance.SetupMapEffects(new ushort[] { 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 1);
        RaidManager.Instance.MapEffect(8, 4, 8);
        RaidManager.Instance.MapEffect(0, 32, 64);
        RaidManager.Instance.SetWeather(3, 0);
        RaidManager.Instance.PlayBgm(926);
    }
    public static void SpawnObjects()
    {
    }
}
