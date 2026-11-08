using Kawari.Encounters;
// 保留原脚本的珊瑚、钥匙、捷径、宝箱、首领与过场交互。
using System.Text.Json;
namespace Script.Definitions.Actions.Sastasha;
public sealed class Dungeon
{
    private static readonly uint[] Corals=[2000213,2000214,2000215];
    private static readonly uint[] Memos=[2000212,2001548,2001549];
    private int color;
    private bool hole,captain,waverider,chopper,seenFinal;
    public int Sequence { get; private set; }
    private static void Hide(EncounterContext c,params uint[] ids){foreach(var id in ids)c.D.Emit("hide_eobj",id);}
    private static void Spawn(EncounterContext c,params uint[] ids){foreach(var id in ids)c.D.Emit("spawn_bnpc",id);}
    public void Setup(EncounterContext c)
    {
        color=c.Random.Next(3);Hide(c,2001504,2001506,2001539,2001508);
        foreach(var id in new[]{97,98,99})c.D.Emit("spawn_treasure",id);
        c.D.Emit("set_data",0,0);Hide(c,2000700,2000216);
        for(var i=0;i<3;i++)if(i!=color)Hide(c,Memos[i]);
        Spawn(c,3637470,3637472,3637475,3637473,3637474,3637476);
    }
    private void Begin(EncounterContext c,int sequence)
    {
        Sequence=sequence;
        if(sequence<=4)c.D.Emit("set_data",0,new[]{0,1,3,7,15}[sequence]);
        switch(sequence)
        {
            case 1:c.D.Emit("log_message",2034,Array.Empty<uint>());Hide(c,Corals);c.D.Emit("show_eobj",2000216);break;
            case 2:Hide(c,2000216,2000217,2001506);c.D.Emit("update_shortcut",11432970);Spawn(c,3981887,3981888);c.D.SetBgm(37);c.D.Emit("spawn_boss",3988325,2001506,2001507,663);break;
            case 3:Hide(c,2000225);Spawn(c,3981878);break;
            case 4:Hide(c,2001539);Spawn(c,3978797,3988324);c.D.Emit("update_shortcut",11432971);c.D.SetBgm(37);c.D.Emit("spawn_boss",4035056,2001539,2001540,670);break;
            case 5:c.D.Emit("update_shortcut",11432972);c.D.Emit("spawn_boss",3978771,2001508,2001509,658);break;
        }
    }
    public void Event(EncounterContext c,JsonElement e)
    {
        var kind=e.GetProperty("kind").GetString();
        if(kind=="gimmick")
        {
            var actor=e.GetProperty("actor").GetUInt32();var id=e.GetProperty("id").GetUInt32();var args=e.GetProperty("params").EnumerateArray().Select(p=>p.GetInt32()).ToArray();
            var interact=(Corals.Contains(id)&&args.FirstOrDefault(-1)==0)||id is 2000256 or 2000250 or 2000255||(id==2000232&&hole)||(id==2000227&&captain)||(id==2000231&&waverider);
            if(id==2000216){if(!chopper){c.D.SetBgm(37);c.D.Emit("spawn_boss",4035011,2001504,2001505,662);}else interact=true;}
            if(interact){c.D.Emit("event_action",24,actor,id);return;}
            if(id==2000139)c.D.Emit("abandon_duty",actor);else if(id==2000700)c.D.Emit("use_shortcut",actor);
            c.D.Emit("finish_gimmick",actor);
        }
        else if(kind=="gimmick_rect"&&e.GetProperty("id").GetUInt32()==4069552&&!seenFinal){c.D.Emit("play_cutscene",175);seenFinal=true;}
        else if(kind=="event_action")
        {
            var actor=e.GetProperty("actor").GetUInt32();var target=e.GetProperty("target").GetUInt32();c.D.Emit("finish_gimmick",actor);
            if(Corals.Contains(target))
            {Hide(c,target);if(target==Corals[color])Begin(c,1);else{c.D.Gain(actor,18,0,120);Spawn(c,target==2000213?4217968u:target==2000214?4217967u:0u);}}
            else switch(target)
            {
                case 2000216:Begin(c,2);break;
                case 2000256:hole=true;Hide(c,target);break;
                case 2000255:waverider=true;Hide(c,target);Begin(c,4);break;
                case 2000250:captain=true;Hide(c,target);break;
                case 2000227:Spawn(c,3282344);Hide(c,target);break;
                case 2000232:case 2000231:Hide(c,target);break;
            }
        }
        else if(kind=="death")
        {
            var id=e.GetProperty("base").GetUInt32();var pos=e.GetProperty("pos").EnumerateArray().Select(v=>v.GetDouble()).ToArray();
            switch(id)
            {
                case 4035011:c.D.Emit("spawn_treasure",94);c.D.SetBgm(0);chopper=true;c.D.Emit("update_shortcut",4033741);break;
                case 3988325:c.D.Emit("spawn_treasure",95);c.D.SetBgm(0);Begin(c,3);c.D.Emit("update_shortcut",4033745);break;
                case 3981878:c.D.Emit("spawn_eobj",2000250,new Position(pos[0],pos[1],pos[2]));break;
                case 3282344:c.D.Emit("spawn_eobj",2000255,new Position(pos[0],pos[1],pos[2]));break;
                case 4035056:c.D.Emit("spawn_treasure",96);c.D.SetBgm(0);Hide(c,2000236);Begin(c,5);c.D.Emit("update_shortcut",4165184);break;
                case 3978771:c.D.Emit("spawn_treasure",93);c.D.SetBgm(0);c.D.Emit("update_shortcut",7372594);c.D.Emit("play_cutscene",176);c.Complete();break;
            }
        }
    }
}
