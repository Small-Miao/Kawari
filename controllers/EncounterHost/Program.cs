// 本地实例宿主：标准输出仅承载版本化协议，脚本日志写入标准错误。
using System.Text;
using System.Text.Json;
using Kawari.Encounters;

var transport=Console.Out;
Console.SetOut(Console.Error);
Console.InputEncoding=Encoding.UTF8;
var options=new JsonSerializerOptions{PropertyNameCaseInsensitive=false};
try
{
    string Argument(string name,string fallback)
    {var at=Array.IndexOf(args,name);return at>=0&&at+1<args.Length?args[at+1]:fallback;}
    var root=Argument("--definitions","resources/encounters/Definitions");
    using var loader=new DefinitionLoader(root);
    if(args.Contains("--check")) { foreach(var pair in loader.Definitions)Console.Error.WriteLine($"{pair.Key}: {pair.Value.Build().TimeLineName}"); return 0; }
    var id=Argument("--content","");
    if(!loader.Definitions.TryGetValue(id,out var definition))throw new InvalidDataException($"未注册副本 {id}");
    var context=new EncounterContext(definition.Build(),Random.Shared.Next());
    var first=true;ulong previous=0;
    while(true)
    {
        // 限制分配大小，损坏或超长帧不能无限占用内存。
        var buffer=new StringBuilder();
        while(true)
        {
            var next=Console.In.Read();
            if(next<0){if(buffer.Length==0)return 0;throw new EndOfStreamException("不完整请求帧");}
            if(next=='\n')break;
            if(buffer.Length>=1024*1024)throw new InvalidDataException("请求帧过大");
            buffer.Append((char)next);
        }
        var frame=JsonSerializer.Deserialize<InputFrame>(buffer.ToString(),options)??throw new InvalidDataException("空请求");
        if(frame.version!=1||frame.seq<=previous)throw new InvalidDataException("请求版本或序号无效");
        previous=frame.seq;
        if(first){context.Initialize(frame);first=false;}
        else if(frame.events.Any(e=>e.TryGetProperty("kind",out var kind)&&kind.GetString()=="reset"))
        {
            if(context.Definition.PreserveStateOnReset)context.Reset(frame);
            else { context.BeforeReplace(); context=new EncounterContext(definition.Build(),Random.Shared.Next());context.Initialize(frame); }
            context.D.Commands.Insert(0,new Operation("director_event",[0x8000001Bu,new uint[]{1,0,0,0}]));
        }
        else context.Advance(frame);
        if(context.D.Commands.Count>4096)throw new InvalidDataException("单帧原生操作超过上限");
        var line=JsonSerializer.Serialize(new OutputFrame(1,frame.seq,context.D.Commands,context.Report()),options);
        if(Encoding.UTF8.GetByteCount(line)>1024*1024)throw new InvalidDataException("响应帧过大");
        transport.WriteLine(line);transport.Flush();
    }
}
catch(Exception error)
{
    Console.Error.WriteLine(error);
    return 1;
}
