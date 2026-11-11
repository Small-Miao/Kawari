using Kawari.Encounters;
// 入场及重置恢复前阶段场景，再创建静态物件。
using MechanicSim_Server.Manager;
namespace Script.Definitions.z3oz;
public static class InitialScene
{
    public static void Reset()
    {
        RaidManager.Instance.SetupMapEffects(new ushort[] { 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, 1);
        RaidManager.Instance.MapEffect(9, 4, 8);
        RaidManager.Instance.MapEffect(8, 4, 8);
        RaidManager.Instance.MapEffect(10, 4, 8);
        RaidManager.Instance.MapEffect(11, 4, 2);
        RaidManager.Instance.MapEffect(1, 4, 1024);
        RaidManager.Instance.MapEffect(20, 4, 8);
        RaidManager.Instance.MapEffect(5, 4, 8);
        RaidManager.Instance.SetWeather(174, 0);
        // 先保存非零的恢复曲目，再解除临时覆盖；客户端初始曲目为 0 时顺序不可颠倒。
        RaidManager.Instance.PlayBgm(964);
        RaidManager.Instance.DirectorEvent(0x80000005, 0, 0, 0, 0);
    }
    public static void SpawnObjects()
    {
    }
}
