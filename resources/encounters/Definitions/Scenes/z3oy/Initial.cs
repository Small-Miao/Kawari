using Kawari.Encounters;
// 入场及重置恢复前阶段场景，再创建静态物件。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oy;
public static class InitialScene
{
    public static void Reset()
    {
        RaidManager.Instance.SetupMapEffects(new ushort[] { 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 5);
        RaidManager.Instance.MapEffect(17, 1, 2);
        RaidManager.Instance.MapEffect(18, 1, 4);
        RaidManager.Instance.MapEffect(7, 4, 8);
        RaidManager.Instance.MapEffect(8, 4, 8);
        RaidManager.Instance.MapEffect(1, 4, 8);
        RaidManager.Instance.MapEffect(2, 4, 8);
        RaidManager.Instance.MapEffect(5, 4, 8);
        RaidManager.Instance.MapEffect(3, 4, 8);
        RaidManager.Instance.MapEffect(6, 4, 8);
        RaidManager.Instance.MapEffect(4, 4, 8);
        RaidManager.Instance.MapEffect(19, 4, 8);
        RaidManager.Instance.MapEffect(0, 512, 1024);
        RaidManager.Instance.MapEffect(34, 4, 8);
        RaidManager.Instance.SetWeather(174, 0);
        RaidManager.Instance.PlayBgm(20293);
    }
    public static void SpawnObjects()
    {
    }
}
