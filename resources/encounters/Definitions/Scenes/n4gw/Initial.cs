using Kawari.Encounters;
// 入场及重置恢复前阶段场景，再创建静态物件。
using MechanicSim_Server.Manager;
namespace Script.Definitions.n4gw;
public static class InitialScene
{
    public static void Reset()
    {
        RaidManager.Instance.SetupMapEffects(new ushort[] { 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 1);
        RaidManager.Instance.MapEffect(0, 4, 8);
        RaidManager.Instance.MapEffect(2, 4, 8);
        RaidManager.Instance.MapEffect(7, 4, 8);
        RaidManager.Instance.MapEffect(1, 4, 8);
        RaidManager.Instance.MapEffect(15, 4, 1);
        RaidManager.Instance.MapEffect(16, 4, 1);
        RaidManager.Instance.MapEffect(17, 4, 1);
        RaidManager.Instance.MapEffect(18, 4, 1);
        RaidManager.Instance.MapEffect(19, 4, 1);
        RaidManager.Instance.MapEffect(20, 4, 1);
        RaidManager.Instance.MapEffect(9, 4, 8);
        RaidManager.Instance.MapEffect(10, 4, 8);
        RaidManager.Instance.MapEffect(11, 4, 8);
        RaidManager.Instance.MapEffect(12, 4, 8);
        RaidManager.Instance.MapEffect(13, 4, 8);
        RaidManager.Instance.MapEffect(14, 4, 8);
        RaidManager.Instance.MapEffect(22, 4, 1);
        RaidManager.Instance.MapEffect(21, 4, 8);
        RaidManager.Instance.MapEffect(24, 4, 8);
        RaidManager.Instance.MapEffect(25, 4, 8);
        RaidManager.Instance.MapEffect(23, 4, 8);
        RaidManager.Instance.MapEffect(26, 4, 8);
        RaidManager.Instance.MapEffect(27, 4, 8);
        RaidManager.Instance.MapEffect(28, 4, 8);
        RaidManager.Instance.MapEffect(29, 4, 8);
        RaidManager.Instance.MapEffect(30, 4, 8);
        RaidManager.Instance.MapEffect(31, 4, 8);
        RaidManager.Instance.MapEffect(32, 4, 8);
        RaidManager.Instance.MapEffect(33, 4, 8);
        RaidManager.Instance.MapEffect(41, 1, 8);
        RaidManager.Instance.MapEffect(46, 1, 2);
        RaidManager.Instance.MapEffect(44, 4, 1);
        RaidManager.Instance.MapEffect(45, 4, 1);
        RaidManager.Instance.MapEffect(42, 4, 8);
        RaidManager.Instance.MapEffect(43, 4, 8);
        RaidManager.Instance.MapEffect(40, 1, 64);
        RaidManager.Instance.MapEffect(34, 4, 8);
        RaidManager.Instance.MapEffect(35, 4, 8);
        RaidManager.Instance.MapEffect(36, 4, 8);
        RaidManager.Instance.MapEffect(37, 4, 8);
        RaidManager.Instance.MapEffect(38, 4, 8);
        RaidManager.Instance.MapEffect(39, 4, 8);
        RaidManager.Instance.SetWeather(105, 0);
        RaidManager.Instance.PlayBgm(20137);
    }
    public static void SpawnObjects()
    {
    }
}
