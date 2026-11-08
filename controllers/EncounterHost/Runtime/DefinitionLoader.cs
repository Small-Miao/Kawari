// 编译可编辑 C# 定义，错误保留文件和行号；每个候选宿主具有独立加载上下文。
using System.Reflection;
using System.Runtime.Loader;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.Text;
using System.Text;
namespace Kawari.Encounters;
public sealed class DefinitionLoader : IDisposable
{
    private readonly AssemblyLoadContext loadContext=new($"Encounter-{Guid.NewGuid():N}",isCollectible:true);
    public IReadOnlyDictionary<string,ITimeLineDefinition> Definitions { get; }
    public DefinitionLoader(string root)
    {
        var files=Directory.GetFiles(Path.GetFullPath(root),"*.cs",SearchOption.AllDirectories).Order(StringComparer.Ordinal).ToArray();
        if(files.Length==0)throw new InvalidDataException("定义目录没有 C# 源文件");
        var trees=files.Select(file=>CSharpSyntaxTree.ParseText(SourceText.From(File.ReadAllText(file),Encoding.UTF8),new CSharpParseOptions(LanguageVersion.Latest),file)).ToArray();
        var paths=((string?)AppContext.GetData("TRUSTED_PLATFORM_ASSEMBLIES")??"").Split(Path.PathSeparator,StringSplitOptions.RemoveEmptyEntries).Append(typeof(ITimeLineDefinition).Assembly.Location).Distinct(StringComparer.OrdinalIgnoreCase);
        var references=paths.Select(p=>MetadataReference.CreateFromFile(p));
        var compilation=CSharpCompilation.Create($"EncounterDefinitions_{Guid.NewGuid():N}",trees,references,new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary,optimizationLevel:OptimizationLevel.Release,nullableContextOptions:NullableContextOptions.Enable));
        using var stream=new MemoryStream();
        var result=compilation.Emit(stream);
        foreach(var diagnostic in result.Diagnostics.Where(d=>d.Severity>=DiagnosticSeverity.Warning))Console.Error.WriteLine(diagnostic);
        if(!result.Success)throw new InvalidDataException("C# 定义编译失败，见上方文件及行号");
        stream.Position=0;var assembly=loadContext.LoadFromStream(stream);
        var types=assembly.GetTypes().Where(t=>!t.IsAbstract).ToArray();
        MechanicSim_Server.Definition.DefinitionRegistry Registry()
        {
            var registry=new MechanicSim_Server.Definition.DefinitionRegistry();
            foreach(var type in types)
            {
                if(type.GetInterfaces().Any(i=>i.FullName=="MechanicSim_Server.Definition.IActionDefinition"))
                {var action=(MechanicSim_Server.Struct.Action)type.GetMethod("Build")!.Invoke(Activator.CreateInstance(type),null)!;registry.Actions.Add(action.ActionId,action);}
                if(type.GetInterfaces().Any(i=>i.FullName=="MechanicSim_Server.Definition.IStatusDefinition"))
                {var status=(MechanicSim_Server.Struct.Status)type.GetMethod("Build")!.Invoke(Activator.CreateInstance(type),null)!;registry.Statuses.Add(status.StatusId,status);}
            }
            return registry;
        }
        var definitions=types.Where(t=>typeof(ITimeLineDefinition).IsAssignableFrom(t)).Select(t=>(ITimeLineDefinition)Activator.CreateInstance(t)!)
            .Concat(types.Where(t=>typeof(MechanicSim_Server.Definition.ITimeLineDefinition).IsAssignableFrom(t)).Select(t=>(ITimeLineDefinition)new TimelineAdapter((MechanicSim_Server.Definition.ITimeLineDefinition)Activator.CreateInstance(t)!,Registry))).ToArray();
        Definitions=definitions.ToDictionary(d=>d.DefinitionId,StringComparer.Ordinal);
        foreach(var definition in definitions)_=new TimelineRunner(definition.Build());
        if(definitions.Length==0)throw new InvalidDataException("没有注册 ITimeLineDefinition");
        Console.Error.WriteLine($"C# 定义加载成功：{files.Length} 个文件，{definitions.Length} 个时间轴。");
    }
    public void Dispose()=>loadContext.Unload();
}
