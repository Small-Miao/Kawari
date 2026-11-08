using Kawari.Encounters;
// 绝亚原生状态与强制行军角色映射。
namespace Script.Definitions.Statuses;
public static class TEA
{
    public const ushort EnigmaCodex=2146,ProjectionColor=2195,Near=1123,Far=1124,Prison=2165,PhysicalVulnerability=695;
    public static readonly Dictionary<string,ushort> FinalWord=new(){["light_beacon"]=2153,["light_follow"]=2152,["dark_beacon"]=2155,["dark_follow"]=2154};
    public static readonly Dictionary<string,ushort> Ordained=new(){["light_beacon"]=3056,["light_follow"]=3055,["dark_beacon"]=3058,["dark_follow"]=3057};
    public const double MarchDuration=3.2;
}
