// 中文离线分析工作台：导入、阶段编辑、证据关联、跨录像对照及工程导出。
using System.Diagnostics;
using System.Globalization;
using System.Text;
using System.Text.Json;
using ReplayAnalyzer.Core;
namespace ReplayAnalyzer.Desktop;

internal sealed class MainForm:Form {
    private readonly List<Recording> recordings=[];
    private readonly TreeView tree=new(){Dock=DockStyle.Fill,BorderStyle=BorderStyle.None,HideSelection=false,FullRowSelect=true,ItemHeight=28,BackColor=Color.FromArgb(245,248,252)};
    private readonly ToolStrip toolbar=new(){Dock=DockStyle.Top,GripStyle=ToolStripGripStyle.Hidden,Padding=new Padding(12,6,8,6),BackColor=Color.White,AutoSize=true};
    private readonly ToolStrip filters=new(){Dock=DockStyle.Top,GripStyle=ToolStripGripStyle.Hidden,Padding=new Padding(8,5,8,5),BackColor=Color.FromArgb(246,248,251)};
    private readonly ToolStripTextBox search=new(){AutoSize=false,Width=230,ToolTipText="筛选技能名称、ID、演员、物件、状态、十六进制参数"};
    private readonly ToolStripComboBox category=new(){DropDownStyle=ComboBoxStyle.DropDownList,AutoSize=false,Width=135};
    private readonly ToolStripButton playerFilter=new("显示玩家技能"){CheckOnClick=true,ToolTipText="默认自动过滤玩家及其召唤物的技能，保留 Boss 对玩家施加的状态。"};
    private readonly ToolStripButton movementFilter=new("移动包"){CheckOnClick=true};
    private readonly ToolStripTextBox from=new(){AutoSize=false,Width=68};
    private readonly ToolStripTextBox to=new(){AutoSize=false,Width=68};
    private readonly Label scopeTitle=new(){Dock=DockStyle.Top,Height=67,Padding=new Padding(15,9,12,4),BackColor=Color.White,Font=new Font("Microsoft YaHei UI",10)};
    private readonly TimelineView timeline=new();
    private readonly TabControl tabs=new(){Dock=DockStyle.Fill,Padding=new Point(14,7)};
    private readonly RichTextBox detail=new(){Dock=DockStyle.Fill,ReadOnly=true,WordWrap=false,BorderStyle=BorderStyle.None,BackColor=Color.FromArgb(249,251,253),Font=new Font("Microsoft YaHei UI",9),DetectUrls=false};
    private readonly VirtualTable<ReplayEvent> eventTable=new();
    private readonly VirtualTable<ReplayEvent> mapTable=new();
    private readonly VirtualTable<ReplayEvent> resourceTable=new();
    private readonly VirtualTable<SkillSummary> skillTable=new();
    private readonly VirtualTable<MergedEvent> mergeTable=new();
    private readonly VirtualTable<MechanicGroup> mechanicTable=new();
    private readonly StatusStrip statusBar=new(){SizingGrip=false};
    private readonly ToolStripStatusLabel status=new(){Spring=true,TextAlign=ContentAlignment.MiddleLeft,Text="导入 .dat 录像开始分析；原录像只读。"};
    private readonly ToolStripProgressBar progressBar=new(){Minimum=0,Maximum=100,Width=170,Visible=false};
    private readonly ToolStripButton cancelButton=new("取消分析"){Visible=false};
    private readonly System.Windows.Forms.Timer filterTimer=new(){Interval=250};
    private readonly Label emptyHint=new(){Text="导入录像，整理阶段与机制\n\n支持多选 .dat 或直接拖入文件。\n选择阶段后查看 MapEffect、演出、判定和预兆配置。\n时间邻近关联会标明置信度，所有记录都能回查原始偏移。",Dock=DockStyle.Fill,TextAlign=ContentAlignment.MiddleCenter,Font=new Font("Microsoft YaHei UI",13),ForeColor=Color.FromArgb(100,116,139),BackColor=Color.White};
    private readonly string dataDirectory=Path.Combine(AppContext.BaseDirectory,"Data");
    private readonly string settingsPath=Path.Combine(AppContext.BaseDirectory,"settings.json");
    private ProtocolProfile protocol=new();private GameCatalog catalog=new();private List<PhasePreset> presets=[];
    private Dictionary<string,string> rsv=[];private Dictionary<long,ReplayEvent> byId=[];
    private Recording? current;private PhaseInfo? selectedPhase;private ReplayEvent? selectedEvent;
    private List<ReplayEvent> scope=[];private List<MergedEvent> merged=[];
    private List<MechanicGroup> mechanics=[];private bool mechanicsDirty=true;
    private HashSet<long>? mechanismFocus;private string mechanismFocusName="";
    private string csvDirectory="";private double mergeTolerance=1.5;private CancellationTokenSource? cancellation;private bool updating;private bool dirty;

    public MainForm(string[] args) {
        Text="FFXIV 录像分析工具 1.1";Size=new Size(1510,950);MinimumSize=new Size(1120,730);StartPosition=FormStartPosition.CenterScreen;Font=new Font("Microsoft YaHei UI",9);BackColor=Color.White;AllowDrop=true;
        var banner=new Panel{Dock=DockStyle.Top,Height=78,BackColor=Color.FromArgb(22,37,59)};
        banner.Controls.Add(new Label{Text="录像分析工具",Location=new Point(21,13),AutoSize=true,Font=new Font("Microsoft YaHei UI",20,FontStyle.Bold),ForeColor=Color.White});
        banner.Controls.Add(new Label{Text="FFXIV  /  阶段 · 地图 · 技能 · 演出证据",Location=new Point(23,49),AutoSize=true,ForeColor=Color.FromArgb(170,193,222)});
        AddButton(toolbar,"导入录像…",async()=>await ImportDialog());AddButton(toolbar,"导入文件夹…",async()=>await ImportFolder());toolbar.Items.Add(new ToolStripSeparator());
        AddButton(toolbar,"打开工程…",async()=>await OpenProjectDialog());AddButton(toolbar,"保存工程…",()=>{SaveProjectDialog();return Task.CompletedTask;});
        var export=new ToolStripDropDownButton("导出整理结果");export.DropDownItems.Add("当前筛选事件 CSV",null,async(_,_)=>await Export("events"));export.DropDownItems.Add("合并对照 CSV",null,async(_,_)=>await Export("merged"));export.DropDownItems.Add("完整分析 JSON",null,async(_,_)=>await Export("report"));export.DropDownItems.Add("当前录像 RSV / RSF",null,async(_,_)=>await Export("resources"));toolbar.Items.Add(export);
        export.DropDownItems.Add("当前机制分组 CSV",null,async(_,_)=>await ExportMechanics(false));export.DropDownItems.Add("选中的单独机制 JSON",null,async(_,_)=>await ExportMechanics(true));
        toolbar.Items.Add(new ToolStripSeparator());AddButton(toolbar,"资源表目录…",async()=>await ChooseCatalog());AddButton(toolbar,"使用说明",()=>{ShowHelp();return Task.CompletedTask;});
        filters.Items.Add(new ToolStripLabel("筛选"));filters.Items.Add(search);category.Items.AddRange(new object[]{"全部类别","读条","判定","演出","预兆配置","MapEffect","物件","状态 / 控制","未知"});category.SelectedIndex=0;filters.Items.Add(category);filters.Items.Add(playerFilter);filters.Items.Add(movementFilter);
        filters.Items.Add(new ToolStripSeparator());filters.Items.Add(new ToolStripLabel("绝对秒"));filters.Items.Add(from);filters.Items.Add(new ToolStripLabel("至"));filters.Items.Add(to);
        AddButton(filters,"清除",()=>{updating=true;search.Text="";category.SelectedIndex=0;from.Text="";to.Text="";mechanismFocus=null;updating=false;RefreshScope();return Task.CompletedTask;});
        var edit=new ToolStripDropDownButton("阶段 / 锚点");edit.DropDownItems.Add("从选中事件拆分阶段…",null,(_,_)=>SplitAtSelection());edit.DropDownItems.Add("重命名当前阶段…",null,(_,_)=>RenamePhase());edit.DropDownItems.Add("将选中事件设为阶段时间锚点",null,(_,_)=>SetAnchor());edit.DropDownItems.Add("合并当前阶段到上一阶段",null,(_,_)=>JoinPrevious());edit.DropDownItems.Add("恢复自动分段",null,(_,_)=>ResetPhases());filters.Items.Add(edit);
        AddButton(filters,"合并对照",async()=>await RebuildMerged());
        var navigation=new Panel{Dock=DockStyle.Fill};navigation.Controls.Add(tree);navigation.Controls.Add(new Label{Text="录像与阶段   ·   右键移除录像",Dock=DockStyle.Top,Height=38,Padding=new Padding(12,10,5,2),ForeColor=Color.FromArgb(70,90,116)});
        var split=new SplitContainer{Dock=DockStyle.Fill,Size=new Size(1480,720),SplitterDistance=285,Panel1MinSize=230,Panel2MinSize=600,BackColor=Color.FromArgb(222,228,236)};split.Panel1.Controls.Add(navigation);
        var work=new Panel{Dock=DockStyle.Fill,BackColor=Color.White};
        var lower=new SplitContainer{Dock=DockStyle.Fill,Orientation=Orientation.Horizontal,Size=new Size(1100,600),SplitterDistance=380,Panel1MinSize=180,Panel2MinSize=120,BackColor=Color.FromArgb(222,228,236)};
        lower.Panel1.Controls.Add(tabs);lower.Panel1.Controls.Add(emptyHint);lower.Panel2.Controls.Add(detail);lower.Panel2.Controls.Add(new Label{Text="证据详情  ·  原始包 / 资源配置 / 候选关联分开显示",Dock=DockStyle.Top,Height=29,Padding=new Padding(10,6,2,2),BackColor=Color.FromArgb(235,240,247)});
        work.Controls.Add(lower);work.Controls.Add(timeline);work.Controls.Add(filters);work.Controls.Add(scopeTitle);split.Panel2.Controls.Add(work);
        statusBar.Items.Add(status);statusBar.Items.Add(progressBar);statusBar.Items.Add(cancelButton);
        Controls.Add(split);Controls.Add(toolbar);Controls.Add(banner);Controls.Add(statusBar);
        timeline.RoleOf=e=>current?.Roles(e)??e.Roles;
        SetupTables();SetupMenus();
        tabs.SelectedIndexChanged+=async(_,_)=>{if(tabs.SelectedIndex==5)await RebuildMechanics();};
        filterTimer.Tick+=(_,_)=>{filterTimer.Stop();RefreshScope();};
        search.TextChanged+=(_,_)=>QueueFilter();from.TextChanged+=(_,_)=>QueueFilter();to.TextChanged+=(_,_)=>QueueFilter();category.SelectedIndexChanged+=(_,_)=>QueueFilter();playerFilter.CheckedChanged+=(_,_)=>QueueFilter();movementFilter.CheckedChanged+=(_,_)=>QueueFilter();
        tree.AfterSelect+=(_,e)=>SelectScope(e.Node?.Tag);timeline.Picked=e=>{tabs.SelectedIndex=0;eventTable.SelectItem(x=>x.Id==e.Id);ShowEvent(e);};
        cancelButton.Click+=(_,_)=>cancellation?.Cancel();
        DragEnter+=(_,e)=>{if(e.Data?.GetDataPresent(DataFormats.FileDrop)==true&&cancellation is null)e.Effect=DragDropEffects.Copy;};
        DragDrop+=async(_,e)=>{if(e.Data?.GetData(DataFormats.FileDrop) is string[] files)await ImportFiles(files.Where(f=>Path.GetExtension(f).Equals(".dat",StringComparison.OrdinalIgnoreCase)).ToArray());};
        FormClosing+=(_,e)=>{if(cancellation is not null){cancellation.Cancel();e.Cancel=true;status.Text="正在取消，完成后可关闭窗口。";return;}if(dirty&&MessageBox.Show(this,"人工阶段或标注尚未保存，直接关闭？","未保存整理",MessageBoxButtons.YesNo,MessageBoxIcon.Question)!=DialogResult.Yes)e.Cancel=true;};
        Shown+=async(_,_)=>await Busy(async token=>{
            protocol=ProtocolProfile.Load(Path.Combine(dataDirectory,"protocol.json"));
            presets=JsonSerializer.Deserialize<List<PhasePreset>>(File.ReadAllText(Path.Combine(dataDirectory,"phase-presets.json")))??[];
            if(File.Exists(settingsPath)){try{csvDirectory=JsonDocument.Parse(File.ReadAllText(settingsPath)).RootElement.GetProperty("CsvDirectory").GetString()??"";}catch{csvDirectory="";}}
            catalog=await Task.Run(()=>GameCatalog.Load(csvDirectory,Path.Combine(dataDirectory,"catalog.json")),token);status.Text=$"就绪 · {protocol.Name} · {catalog.Actions.Count:N0} 个动作定义";
            BeginInvoke(async()=>{if(args.Length>0&&File.Exists(args[0])){if(Path.GetExtension(args[0]).Equals(".json",StringComparison.OrdinalIgnoreCase))await LoadProject(args[0]);else await ImportFiles(args.Where(File.Exists).ToArray());}});
        });
        ShowHelp();
    }

    private static void AddButton(ToolStrip strip,string text,Func<Task> action){var b=new ToolStripButton(text){DisplayStyle=ToolStripItemDisplayStyle.Text,Padding=new Padding(5,3,5,3)};b.Click+=async(_,_)=>await action();strip.Items.Add(b);}
    private void AddTab(string name,Control control){var p=new TabPage(name){BackColor=Color.White,Padding=new Padding(0)};p.Controls.Add(control);tabs.TabPages.Add(p);}
    private void SetupTables() {
        eventTable.Column("相对时间",100,e=>RelativeTime(e));eventTable.Column("录像时间",100,e=>e.TimeText);eventTable.Column("事件",110,e=>e.Kind);eventTable.Column("分类",140,e=>Names.Role(current?.Roles(e)??e.Roles));eventTable.Column("技能 / ID",180,e=>e.Action==0?"":$"{catalog.ActionName(e.Action,rsv)} [{e.Action}]");eventTable.Column("演员",200,e=>current?.ActorLabel(e.Actor));eventTable.Column("内容",350,e=>e.Summary,true);eventTable.Selected=ShowEvent;
        skillTable.Column("技能 ID",90,s=>s.Action);skillTable.Column("名称",190,s=>s.Name);skillTable.Column("读条",65,s=>s.Casts);skillTable.Column("效果包",75,s=>s.Effects);skillTable.Column("判定",65,s=>s.Results);skillTable.Column("演出关联",85,s=>s.VisualLinks);skillTable.Column("地图关联",85,s=>s.MapLinks);skillTable.Column("预兆配置",90,s=>s.OmenConfigurations);skillTable.Column("分类结论",310,s=>s.Classification,true);skillTable.Selected=ShowSkill;
        skillTable.CellDoubleClick+=(_,e)=>{if(e.RowIndex>=0){var s=skillTable.RowsData[e.RowIndex];search.Text=s.Action.ToString();tabs.SelectedIndex=0;}};
        mapTable.Column("相对时间",100,e=>RelativeTime(e));mapTable.Column("事件",120,e=>e.Kind);mapTable.Column("索引 / Base",100,e=>e.Value);mapTable.Column("状态 / 参数",250,e=>string.Join(" ",e.Parameters.Select(p=>$"0x{p:X}")));mapTable.Column("演员 / 物件",220,e=>current?.ActorLabel(e.Actor));mapTable.Column("内容",350,e=>e.Summary,true);mapTable.Selected=ShowEvent;
        mergeTable.Column("副本",150,m=>Names.Content(m.Content));mergeTable.Column("阶段",150,m=>m.Phase);mergeTable.Column("锚点相对时间",115,m=>ReplayEvent.TimeTextOf(m.Seconds));mergeTable.Column("事件",100,m=>m.Kind);mergeTable.Column("录像",60,m=>m.SourceCount);mergeTable.Column("尝试",60,m=>m.RunCount);mergeTable.Column("偏差 / 秒",90,m=>m.Spread.ToString("F3"));mergeTable.Column("观察内容",380,m=>m.Observations.FirstOrDefault()?.Summary,true);mergeTable.Selected=ShowMerged;mergeTable.CellDoubleClick+=(_,e)=>{if(e.RowIndex>=0)GoObservation(mergeTable.RowsData[e.RowIndex].Observations[0]);};
        resourceTable.Column("类型",75,e=>e.Kind);resourceTable.Column("时间",100,e=>e.TimeText);resourceTable.Column("键 / 索引",430,e=>e.ResourceKey);resourceTable.Column("值",500,e=>e.ResourceValue,true);resourceTable.Selected=ShowEvent;
        mechanicTable.MultiSelect=true;mechanicTable.Column("机制组",215,g=>g.Name);mechanicTable.Column("阶段",145,g=>g.Phase);mechanicTable.Column("技能 ID",190,g=>string.Join(" / ",g.Actions));mechanicTable.Column("读条",65,g=>g.Casts);mechanicTable.Column("结算",65,g=>g.Results);mechanicTable.Column("演出事件",85,g=>g.Presentations);mechanicTable.Column("录像 / 尝试",100,g=>$"{g.SourceCount} / {g.RunCount}");mechanicTable.Column("全部记录",90,g=>g.Observations.Count,true);mechanicTable.Selected=ShowMechanic;
        mechanicTable.CellDoubleClick+=(_,e)=>{if(e.RowIndex>=0)FocusMechanic(mechanicTable.RowsData[e.RowIndex]);};
        AddTab("事件时间轴",eventTable);AddTab("技能与演出",skillTable);AddTab("地图 / 物件",mapTable);AddTab("阶段合并对照",mergeTable);AddTab("资源字典 · 全录像",resourceTable);
        AddTab("机制分组 · 多录像",mechanicTable);
    }
    private void SetupMenus() {
        var eventsMenu=new ContextMenuStrip();
        foreach(var item in new[]{("标记为演出",EventRole.Visual),("标记为判定 + 演出",EventRole.Result|EventRole.Visual),("标记为预兆",EventRole.Omen|EventRole.Visual),("标记为待核对",EventRole.Unknown)})eventsMenu.Items.Add(item.Item1,null,(_,_)=>Annotate(item.Item2));
        eventsMenu.Items.Add("人工关联技能 ID / 备注…",null,(_,_)=>AnnotateSkill());eventsMenu.Items.Add("清除这条人工标注",null,(_,_)=>{if(current is null||selectedEvent is null)return;current.Annotations.Remove(selectedEvent.Id);dirty=true;mechanicsDirty=true;merged=[];mergeTable.SetData([]);RefreshScope();});eventsMenu.Items.Add("复制事件证据",null,(_,_)=>{if(detail.Text.Length>0)Clipboard.SetText(detail.Text);});eventTable.ContextMenuStrip=eventsMenu;mapTable.ContextMenuStrip=eventsMenu;
        eventsMenu.Items.Insert(0,new ToolStripMenuItem("归入指定机制组…",null,(_,_)=>AssignEventMechanic()));
        var groupMenu=new ContextMenuStrip();groupMenu.Items.Add("合并选中机制 / 重命名…",null,async(_,_)=>await NameMechanics());groupMenu.Items.Add("查看该机制全部事件",null,(_,_)=>{if(mechanicTable.CurrentCell is {} cell)FocusMechanic(mechanicTable.RowsData[cell.RowIndex]);});groupMenu.Items.Add("导出选中机制 JSON…",null,async(_,_)=>await ExportMechanics(true));mechanicTable.ContextMenuStrip=groupMenu;
        var treeMenu=new ContextMenuStrip();treeMenu.Items.Add("移除此录像（不删除原文件）",null,(_,_)=>{if(current is null)return;recordings.Remove(current);current=null;selectedPhase=null;dirty=true;mechanicsDirty=true;merged=[];mergeTable.SetData([]);BuildTree();});tree.ContextMenuStrip=treeMenu;
        tree.NodeMouseClick+=(_,e)=>{if(e.Button==MouseButtons.Right)tree.SelectedNode=e.Node;};
    }
    private void QueueFilter(){if(updating)return;filterTimer.Stop();filterTimer.Start();}
    private string RelativeTime(ReplayEvent e){var p=current?.Phases.FirstOrDefault(p=>p.Id==e.PhaseId);return ReplayEvent.TimeTextOf(((long)e.Ms-(p?.AnchorMs??0))/1000d);}
    private void BuildTree() {
        var wanted=current?.Sha256;var phase=selectedPhase?.Id;tree.BeginUpdate();tree.Nodes.Clear();
        var all=new TreeNode($"全部录像  ({recordings.Count})");tree.Nodes.Add(all);
        foreach(var r in recordings){var node=new TreeNode($"{r.ContentName} · {r.FileName}"){Tag=r,ToolTipText=r.Path};all.Nodes.Add(node);foreach(var p in r.Phases)node.Nodes.Add(new TreeNode(p.Label){Tag=(r,p)});if(r.Sha256==wanted){node.Expand();tree.SelectedNode=phase is null?node:node.Nodes.Cast<TreeNode>().FirstOrDefault(n=>n.Tag is ValueTuple<Recording,PhaseInfo> t&&t.Item2.Id==phase)??node;}}
        all.Expand();tree.ShowNodeToolTips=true;tree.EndUpdate();if(tree.SelectedNode is null&&all.Nodes.Count>0)tree.SelectedNode=all.Nodes[0];emptyHint.Visible=recordings.Count==0;
        if(recordings.Count==0){scopeTitle.Text="尚未导入录像";eventTable.SetData([]);skillTable.SetData([]);mapTable.SetData([]);resourceTable.SetData([]);timeline.Items=[];timeline.Invalidate();}
    }
    private void SelectScope(object? tag) {
        mechanismFocus=null;
        if(tag is Recording r){current=r;selectedPhase=null;}else if(tag is ValueTuple<Recording,PhaseInfo> value){current=value.Item1;selectedPhase=value.Item2;}else{if(merged.Count>0){tabs.SelectedIndex=3;mergeTable.SetData(merged);}return;}
        rsv=catalog.ResourceStrings(current);byId=current.Events.ToDictionary(e=>e.Id);updating=true;from.Text="";to.Text="";updating=false;selectedEvent=null;RefreshScope();ShowPhase();
    }
    private void RefreshScope() {
        if(current is null)return;var r=current;
        scope=r.Events.Where(e=>selectedPhase is null||e.PhaseId==selectedPhase.Id).ToList();
        var text=search.Text.Trim();var roles=new[]{EventRole.None,EventRole.Cast,EventRole.Result,EventRole.Visual,EventRole.Omen,EventRole.Map,EventRole.Object,EventRole.State,EventRole.Unknown};var role=roles[Math.Max(0,category.SelectedIndex)];
        var hasFrom=double.TryParse(from.Text,NumberStyles.Float,CultureInfo.InvariantCulture,out var low);var hasTo=double.TryParse(to.Text,NumberStyles.Float,CultureInfo.InvariantCulture,out var high);
        var associated=new HashSet<long>();
        if(uint.TryParse(text,out var skillId)&&skillId>0)foreach(var e in scope.Where(e=>e.Action==skillId||r.Annotations.GetValueOrDefault(e.Id)?.RelatedAction==skillId)){associated.Add(e.Id);foreach(var link in e.Related)associated.Add(link.EventId);}
        bool Matches(ReplayEvent e)=>text.Length==0||associated.Contains(e.Id)||e.Action.ToString()==text||e.Value.ToString()==text||e.Kind.Contains(text,StringComparison.OrdinalIgnoreCase)||e.Summary.Contains(text,StringComparison.OrdinalIgnoreCase)||r.ActorLabel(e.Actor).Contains(text,StringComparison.OrdinalIgnoreCase)||(e.Action!=0&&catalog.ActionName(e.Action,rsv).Contains(text,StringComparison.OrdinalIgnoreCase))||r.Annotations.GetValueOrDefault(e.Id)?.Note.Contains(text,StringComparison.OrdinalIgnoreCase)==true;
        var filtered=scope.Where(e=>(mechanismFocus is null||mechanismFocus.Contains(e.Id))&&(playerFilter.Checked||!r.IsPlayerSkill(e))&&(movementFilter.Checked||!e.Roles.HasFlag(EventRole.Movement))&&(role==EventRole.None||r.Roles(e).HasFlag(role))&&(!hasFrom||e.Ms>=low*1000)&&(!hasTo||e.Ms<=high*1000)&&Matches(e)).ToList();
        eventTable.SetData(filtered);skillTable.SetData(SkillAnalysis.Summarize(r,filtered,catalog));mapTable.SetData(filtered.Where(e=>(e.Roles&(EventRole.Map|EventRole.Object))!=0||e.Kind=="EObj 动画"));resourceTable.SetData(r.Events.Where(e=>e.Kind is "RSV" or "RSF").Where(e=>text.Length==0||e.ResourceKey.Contains(text,StringComparison.OrdinalIgnoreCase)||e.ResourceValue.Contains(text,StringComparison.OrdinalIgnoreCase)));
        timeline.Items=filtered;timeline.StartMs=hasFrom?(uint)Math.Clamp(low*1000,0,uint.MaxValue):selectedPhase?.StartMs??0;timeline.EndMs=hasTo?(uint)Math.Clamp(high*1000,1,uint.MaxValue):selectedPhase?.EndMs??r.DurationMs;timeline.Invalidate();
        scopeTitle.Text=$"{r.ContentName}  /  {selectedPhase?.Name??"全录像"}     {filtered.Count:N0} 条筛选事件\n{r.FileName}  ·  Build {r.Build}  ·  {r.PacketCount:N0} 个原始包  ·  {(selectedPhase is null?"可选择左侧阶段，或从任一事件手动分段":selectedPhase.Evidence)}";
        if(merged.Count>0)mergeTable.SetData(merged.Where(m=>m.Content==r.Content&&m.Build==r.Build&&(selectedPhase is null||m.Phase==selectedPhase.Name)));
        if(mechanismFocus is not null)scopeTitle.Text+=$" · 单独机制：{mechanismFocusName}（清除按钮退出）";
        FilterMechanics();
    }
    private void ShowPhase() {
        if(current is null)return;var p=selectedPhase;var sb=new StringBuilder();sb.AppendLine(p is null?$"{current.ContentName} / 完整录像":$"{p.Name}\n分段依据：{p.Evidence}\n时间锚点：{ReplayEvent.TimeTextOf(p.AnchorMs/1000d)}");
        sb.AppendLine($"SHA-256：{current.Sha256}\n识别事件：{current.Events.Count:N0} / 原始包：{current.PacketCount:N0}\n未支持包或控制类别合计：{current.UnknownOpcodes.Values.Sum():N0}（保留统计，不伪装为完整协议覆盖）");
        if(p is not null){sb.AppendLine("\n阶段开始之前最后已知的 MapEffect 状态：");foreach(var (index,state) in PhaseAnalysis.MapBaseline(current,p.StartMs))sb.AppendLine($"  [{index}] {state}");}
        foreach(var warning in current.Warnings)sb.AppendLine("注意："+warning);sb.AppendLine("\n说明：阶段候选不等于机制 P1/P2；右上“阶段 / 锚点”可重命名、拆分及对齐。未知效果和低置信度关联需要人工核对。");detail.Text=sb.ToString();
    }
    private void ShowEvent(ReplayEvent e) {
        if(current is null)return;selectedEvent=e;timeline.SelectedMs=e.Ms;timeline.Invalidate();var r=current;var note=r.Annotations.GetValueOrDefault(e.Id);var sb=new StringBuilder();
        sb.AppendLine($"{e.TimeText}  {e.Kind}  {e.Summary}\n来源：{r.FileName}  ·  偏移 0x{e.Offset:X}  ·  Opcode {e.Opcode}  ·  负载 {e.PayloadSize} 字节");
        sb.AppendLine($"原始分类：{Names.Role(e.Roles)}\n证据：{e.Evidence}\n演员：{r.ActorLabel(e.Actor)}  →  {r.ActorLabel(e.Target)}\n位置：{e.Position}   面向：{e.Rotation:F5} 弧度\n参数：{string.Join(", ",e.Parameters.Select(p=>$"{p} / 0x{p:X}"))}");
        if(r.Actors.TryGetValue(e.Actor,out var actor))sb.AppendLine($"演员资料：Base={actor.Base} Name={actor.NameId} Layout={actor.Layout} Bind={actor.BindLayout} Owner=0x{actor.Owner:X}");
        if(note is not null)sb.AppendLine($"人工整理：机制 {note.Mechanic} · {(note.Roles is {} role?Names.Role(role):"保留原分类")} · 技能 {note.RelatedAction}\n备注：{note.Note}");
        if(e.Action!=0){sb.AppendLine($"\n技能：{catalog.ActionName(e.Action,rsv)} [{e.Action}]  · 表现技能：{e.AnimationAction} · 效果序号：{e.Sequence}");foreach(var resource in catalog.Resources(e.AnimationAction==0?e.Action:e.AnimationAction))sb.AppendLine(resource);}
        if(e.Kind is "RSV" or "RSF")sb.AppendLine($"资源键：{e.ResourceKey}\n资源值：{e.ResourceValue}");
        if(e.Kind.StartsWith("状态")&&catalog.StatusNames.TryGetValue(e.Value,out var statusName))sb.AppendLine($"状态名称：{statusName} [{e.Value}]");
        if(e.Effects.Count>0){sb.AppendLine("\n原始目标效果：");foreach(var f in e.Effects)sb.AppendLine($"  {r.ActorLabel(f.Target)} · {f.Meaning} ({f.Type}) · 值 {f.Value} · 参数 {f.Parameter} · {Convert.ToHexString(f.Raw)}");}
        if(e.Related.Count>0){sb.AppendLine("\n关联证据（低 / 中置信度不能视为因果）：");foreach(var relation in e.Related.Take(60))if(byId.TryGetValue(relation.EventId,out var other))sb.AppendLine($"  [{relation.Confidence}] {other.TimeText} {other.Kind} {other.Summary} @0x{other.Offset:X}\n       {relation.Reason}");}
        else sb.AppendLine("\n未建立自动关联；可右键人工关联技能并添加备注。");detail.Text=sb.ToString();
    }
    private void ShowSkill(SkillSummary s) {
        if(current is null)return;var sb=new StringBuilder($"{s.Name} [{s.Action}]\n{s.Classification}\n读条 {s.Casts} / 动作效果 {s.Effects} / 观察判定 {s.Results} / 预兆配置 {s.OmenConfigurations}\n\n");
        foreach(var item in catalog.Resources(s.Action))sb.AppendLine(item);sb.AppendLine("\n本阶段调用与关联的演出 / 地图 / 判定：");
        foreach(var e in s.Events.Take(100)){sb.AppendLine($"{e.TimeText} {e.Kind} · {e.Summary} @0x{e.Offset:X}");foreach(var link in e.Related.Take(8))if(byId.TryGetValue(link.EventId,out var other))sb.AppendLine($"   [{link.Confidence}] {other.Kind} {other.Summary}（{other.TimeText}）— {link.Reason}");}
        if(s.Events.Count>100)sb.AppendLine("仅预览前 100 次；双击该技能筛选完整事件表。");sb.AppendLine("\n双击技能行，可跳转到事件表并按技能 ID 筛选。");detail.Text=sb.ToString();
    }
    private void ShowMerged(MergedEvent m) {var sb=new StringBuilder($"{Names.Content(m.Content)} / {m.Phase} / Build {m.Build}\n{m.Signature}\n对齐时间 {m.Seconds:F3} 秒 · 时间差范围 {m.Spread:F3} 秒 · {m.SourceCount} 份录像 / {m.RunCount} 次尝试\n\n每次观察均保留，不折叠同一尝试中的重复调用：\n");foreach(var o in m.Observations)sb.AppendLine($"{o.FileName}\n  {o.Phase} · 相对 {o.Seconds:F3}s · 偏移 0x{o.Offset:X}\n  {o.Summary} · {o.Actor} · {o.Position}");sb.AppendLine("\n双击跳回首个原始记录。合并按阶段名称与锚点匹配，自动候选分段可能需要人工调整。");detail.Text=sb.ToString();}
    private void GoObservation(Observation o) {var r=recordings.FirstOrDefault(r=>r.Sha256==o.Recording);if(r is null)return;current=r;selectedPhase=r.Phases.FirstOrDefault(p=>p.Id==o.PhaseId);search.Text="";category.SelectedIndex=0;BuildTree();tabs.SelectedIndex=0;eventTable.SelectItem(e=>e.Id==o.EventId);}
    private async Task Busy(Func<CancellationToken,Task> action) {
        if(cancellation is not null)return;cancellation=new();var token=cancellation.Token;toolbar.Enabled=false;filters.Enabled=false;tree.Enabled=false;tabs.Enabled=false;progressBar.Visible=true;cancelButton.Visible=true;progressBar.Value=0;UseWaitCursor=true;
        try{await action(token);}catch(OperationCanceledException){status.Text="已取消；原录像未改变。";}catch(Exception e){status.Text="操作失败："+e.Message;MessageBox.Show(this,e.Message,"录像分析",MessageBoxButtons.OK,MessageBoxIcon.Error);}finally{cancellation.Dispose();cancellation=null;toolbar.Enabled=true;filters.Enabled=true;tree.Enabled=true;tabs.Enabled=true;progressBar.Visible=false;cancelButton.Visible=false;UseWaitCursor=false;}
    }
    private async Task ImportDialog(){using var d=new OpenFileDialog{Filter="FFXIV 录像 (*.dat)|*.dat",Multiselect=true,Title="选择一份或多份录像"};if(d.ShowDialog(this)==DialogResult.OK)await ImportFiles(d.FileNames);}
    private async Task ImportFolder(){using var d=new FolderBrowserDialog{Description="导入所选目录第一层的 .dat 录像",UseDescriptionForTitle=true};if(d.ShowDialog(this)==DialogResult.OK)await ImportFiles(Directory.GetFiles(d.SelectedPath,"*.dat"));}
    private async Task ImportFiles(string[] files) {
        if(files.Length==0)return;
        await Busy(async token=>{
            var imported=new List<Recording>();var errors=new List<string>();var progress=new Progress<(double Fraction,string Text)>(p=>{progressBar.Value=Math.Clamp((int)(p.Fraction*100),0,100);status.Text=p.Text;});
            await Task.Run(()=>{foreach(var file in files){token.ThrowIfCancellationRequested();try{var r=new ReplayReader(protocol).Read(file,progress,token);PhaseAnalysis.Initialize(r,presets);catalog.Enrich(r);Relationships.Build(r,catalog);imported.Add(r);}catch(OperationCanceledException){throw;}catch(Exception e){errors.Add(Path.GetFileName(file)+"："+e.Message);}}},token);
            var duplicates=0;foreach(var r in imported){if(recordings.Any(old=>old.Sha256==r.Sha256)){duplicates++;continue;}recordings.Add(r);}merged=[];mergeTable.SetData([]);current??=recordings.FirstOrDefault();dirty|=imported.Count>0;mechanicsDirty=true;BuildTree();
            status.Text=$"已载入 {recordings.Count} 份录像 · 跳过 {duplicates} 份重复内容 · {errors.Count} 个失败";if(errors.Count>0)MessageBox.Show(this,string.Join("\n",errors),"部分录像未载入",MessageBoxButtons.OK,MessageBoxIcon.Warning);
        });
    }
    private async Task OpenProjectDialog(){using var d=new OpenFileDialog{Filter="分析工程 (*.json)|*.json"};if(d.ShowDialog(this)==DialogResult.OK)await LoadProject(d.FileName);}
    private async Task LoadProject(string path) {
        if(dirty&&MessageBox.Show(this,"打开工程会替换当前未保存整理，继续？","打开工程",MessageBoxButtons.YesNo,MessageBoxIcon.Question)!=DialogResult.Yes)return;
        await Busy(async token=>{
            var project=WorkspaceFiles.ReadProject(path);var next=new List<Recording>();var errors=new List<string>();
            var nextCatalog=await Task.Run(()=>GameCatalog.Load(project.CsvDirectory,Path.Combine(dataDirectory,"catalog.json")),token);
            var progress=new Progress<(double Fraction,string Text)>(p=>{progressBar.Value=Math.Clamp((int)(p.Fraction*100),0,100);status.Text=p.Text;});
            await Task.Run(()=>{foreach(var item in project.Recordings){token.ThrowIfCancellationRequested();try{var r=new ReplayReader(protocol).Read(Path.IsPathRooted(item.Path)?item.Path:Path.Combine(Path.GetDirectoryName(path)!,item.Path),progress,token);WorkspaceFiles.Apply(r,item);nextCatalog.Enrich(r);Relationships.Build(r,nextCatalog);if(next.All(old=>old.Sha256!=r.Sha256))next.Add(r);}catch(OperationCanceledException){throw;}catch(Exception e){errors.Add(item.Path+"："+e.Message);}}},token);
            if(next.Count==0&&project.Recordings.Count>0)throw new InvalidDataException("工程中的录像都无法读取：\n"+string.Join("\n",errors));
            recordings.Clear();recordings.AddRange(next);catalog=nextCatalog;csvDirectory=project.CsvDirectory;mergeTolerance=project.MergeTolerance;current=recordings.FirstOrDefault();selectedPhase=null;mechanicsDirty=true;merged=[];mergeTable.SetData([]);BuildTree();dirty=false;status.Text=$"已打开工程：{next.Count} 份录像，恢复人工阶段与标注。";
            if(errors.Count>0)MessageBox.Show(this,string.Join("\n",errors),"工程中部分录像不可用",MessageBoxButtons.OK,MessageBoxIcon.Warning);
        });
    }
    private void SaveProjectDialog(){if(recordings.Count==0)return;using var d=new SaveFileDialog{Filter="分析工程 (*.json)|*.json",FileName="录像分析工程.json"};if(d.ShowDialog(this)!=DialogResult.OK)return;try{WorkspaceFiles.SaveProject(d.FileName,recordings,csvDirectory,mergeTolerance);dirty=false;status.Text="工程已保存："+d.FileName;}catch(Exception e){MessageBox.Show(this,e.Message);}}
    private async Task Export(string kind) {
        if(recordings.Count==0||current is null)return;var csv=kind is "events" or "merged";using var d=new SaveFileDialog{Filter=csv?"CSV 表格 (*.csv)|*.csv":"JSON 数据 (*.json)|*.json",FileName=kind switch{"events"=>"阶段事件.csv","merged"=>"阶段合并对照.csv","resources"=>"录像资源数据.json",_=>"录像完整分析.json"}};if(d.ShowDialog(this)!=DialogResult.OK)return;
        var r=current;var rows=eventTable.RowsData.ToArray();await Busy(async token=>{await Task.Run(()=>{token.ThrowIfCancellationRequested();switch(kind){case "events":WorkspaceFiles.ExportCsv(d.FileName,r,rows,catalog);break;case "merged":WorkspaceFiles.ExportMergedCsv(d.FileName,Merger.Merge(recordings,mergeTolerance));break;case "resources":WorkspaceFiles.ExportResources(d.FileName,r);break;default:WorkspaceFiles.ExportReport(d.FileName,recordings,catalog,mergeTolerance);break;}},token);status.Text="已导出："+d.FileName;});
    }
    private async Task ChooseCatalog() {
        using var d=new FolderBrowserDialog{Description="选择包含 Action.csv、Omen.csv、BNpcName.csv 等文件的目录",UseDescriptionForTitle=true};if(d.ShowDialog(this)!=DialogResult.OK)return;
        await Busy(async token=>{var c=await Task.Run(()=>GameCatalog.Load(d.SelectedPath),token);if(c.Actions.Count==0)throw new InvalidDataException("该目录没有可读的 Action.csv");catalog=c;mechanicsDirty=true;csvDirectory=d.SelectedPath;await Task.Run(()=>{foreach(var r in recordings){token.ThrowIfCancellationRequested();catalog.Enrich(r);Relationships.Build(r,catalog);}},token);WorkspaceFiles.WriteJson(settingsPath,new{CsvDirectory=csvDirectory});if(current is not null){rsv=catalog.ResourceStrings(current);RefreshScope();}status.Text=$"资源表已更新：{catalog.Actions.Count:N0} 个动作；缺失表 {catalog.Warnings.Count} 项";});
    }
    private void SplitAtSelection(){if(current is null||selectedEvent is null){MessageBox.Show(this,"请先选中一条事件。");return;}var name=InputDialog.Ask(this,"拆分阶段",$"从 {selectedEvent.TimeText} 开始的新阶段名称，例如 P2 一运","P2");if(name is null)return;try{PhaseAnalysis.Split(current,selectedEvent.Ms,name);selectedPhase=current.Phases.First(p=>p.StartMs==selectedEvent.Ms);ChangedPhases();}catch(Exception e){MessageBox.Show(this,e.Message);}}
    private void RenamePhase(){if(selectedPhase is null){MessageBox.Show(this,"请先选择左侧的一个阶段。");return;}var name=InputDialog.Ask(this,"重命名阶段","跨录像使用相同阶段名称，才能按名称合并。",selectedPhase.Name);if(string.IsNullOrWhiteSpace(name))return;selectedPhase.Name=name;selectedPhase.Evidence="人工命名";ChangedPhases();}
    private void SetAnchor(){if(current is null||selectedEvent is null)return;var p=current.Phases.FirstOrDefault(p=>p.Id==selectedEvent.PhaseId);if(p is null)return;p.AnchorMs=selectedEvent.Ms;selectedPhase=p;ChangedPhases();status.Text="已使用该事件作为阶段零点；其他录像需选择对应事件。";}
    private void JoinPrevious(){if(current is null||selectedPhase is null)return;var index=current.Phases.IndexOf(selectedPhase);if(index<=0)return;current.Phases[index-1].EndMs=selectedPhase.EndMs;current.Phases.RemoveAt(index);selectedPhase=current.Phases[index-1];PhaseAnalysis.Assign(current);ChangedPhases();}
    private void ResetPhases(){if(current is null)return;if(MessageBox.Show(this,"恢复自动章节和已知录像预设？人工阶段名称及锚点将被替换，事件标注保留。","恢复分段",MessageBoxButtons.YesNo,MessageBoxIcon.Question)!=DialogResult.Yes)return;PhaseAnalysis.Initialize(current,presets);selectedPhase=null;ChangedPhases();}
    private void ChangedPhases(){if(current is null)return;Relationships.Build(current,catalog);dirty=true;mechanicsDirty=true;merged=[];mergeTable.SetData([]);BuildTree();}
    private void Annotate(EventRole role){if(current is null||selectedEvent is null)return;var note=current.Annotations.GetValueOrDefault(selectedEvent.Id)??new();note.Roles=role;current.Annotations[selectedEvent.Id]=note;dirty=true;mechanicsDirty=true;var selected=selectedEvent;merged=[];mergeTable.SetData([]);RefreshScope();ShowEvent(selected);}
    private void AnnotateSkill(){if(current is null||selectedEvent is null)return;var note=current.Annotations.GetValueOrDefault(selectedEvent.Id)??new();var id=InputDialog.Ask(this,"人工关联技能","输入技能 ID；留空表示仅添加备注。",note.RelatedAction?.ToString()??"");if(id is null)return;if(id.Length>0&&!uint.TryParse(id,out _)){MessageBox.Show(this,"技能 ID 必须是非负整数。");return;}var text=InputDialog.Ask(this,"事件备注","记录判断依据，保留原始分类。",note.Note);if(text is null)return;note.RelatedAction=id.Length>0?uint.Parse(id):null;note.Note=text;current.Annotations[selectedEvent.Id]=note;dirty=true;mechanicsDirty=true;var selected=selectedEvent;merged=[];mergeTable.SetData([]);RefreshScope();ShowEvent(selected);}
    private async Task RebuildMerged(){if(recordings.Count==0)return;var value=InputDialog.Ask(this,"阶段合并","同名阶段按锚点对齐，允许的时间误差（0–30 秒）",mergeTolerance.ToString(CultureInfo.InvariantCulture));if(value is null)return;if(!double.TryParse(value,NumberStyles.Float,CultureInfo.InvariantCulture,out var tolerance)||!double.IsFinite(tolerance)||tolerance<0||tolerance>30){MessageBox.Show(this,"请输入 0 到 30 之间的秒数。");return;}mergeTolerance=tolerance;dirty=true;mechanicsDirty=true;await Busy(async token=>{merged=await Task.Run(()=>Merger.Merge(recordings,tolerance,token),token);RefreshScope();tabs.SelectedIndex=3;status.Text=$"合并完成：{merged.Count:N0} 项，所有原始观察均保留；双击可回查。";});}
    private void FilterMechanics() {
        if(mechanicsDirty||current is null){mechanicTable.SetData([]);return;}
        var text=search.Text.Trim();
        mechanicTable.SetData(mechanics.Where(g=>g.Content==current.Content&&g.Build==current.Build&&(selectedPhase is null||g.Phase==selectedPhase.Name)&&(text.Length==0||g.Name.Contains(text,StringComparison.OrdinalIgnoreCase)||g.Actions.Any(a=>a.ToString()==text))));
    }
    private async Task RebuildMechanics() {
        if(recordings.Count==0||cancellation is not null)return;
        if(!mechanicsDirty)return;
        await Busy(async token=>{mechanics=await Task.Run(()=>MechanicAnalysis.Build(recordings,catalog,token),token);mechanicsDirty=false;FilterMechanics();status.Text=$"已整理 {mechanics.Count:N0} 个机制组；自动过滤玩家及召唤物技能。Ctrl / Shift 多选后右键可合并。";});
    }
    private void ShowMechanic(MechanicGroup group) {
        var sb=new StringBuilder($"{group.Name} / {group.Phase}\n{group.SourceCount} 份录像 / {group.RunCount} 次尝试 · 读条 {group.Casts} · 结算 {group.Results} · 共 {group.Observations.Count} 条记录\n组内技能 ID：{string.Join(", ",group.Actions)}\n\n同名技能自动归组；相关 MapEffect / EObj / 预兆和演出按各自置信度保留，不能据此断言因果。\nCtrl / Shift 多选机制行，右键可以合并到自定义名称；双击定位单独机制的事件。\n");
        foreach(var id in group.Actions.Take(25)){sb.AppendLine($"\n技能 {id}：");foreach(var resource in catalog.Resources(id))sb.AppendLine("  "+resource);}
        sb.AppendLine("\n逐条调用与关联（保留重复，预览前 250 条）：");
        foreach(var o in group.Observations.Take(250))sb.AppendLine($"{o.FileName} · {o.Seconds:F3}s @0x{o.Offset:X}\n  {(o.Primary?"主要事件":"关联候选")} [{o.Confidence}] {o.Kind} · {o.Summary}\n  {o.Reason}");
        detail.Text=sb.ToString();
    }
    private void FocusMechanic(MechanicGroup group) {
        var sample=group.Observations.FirstOrDefault(o=>o.Recording==current?.Sha256)??group.Observations.First();
        current=recordings.First(r=>r.Sha256==sample.Recording);selectedPhase=null;
        updating=true;search.Text="";category.SelectedIndex=0;from.Text="";to.Text="";updating=false;
        BuildTree();mechanismFocus=group.Observations.Where(o=>o.Recording==current.Sha256).Select(o=>o.EventId).ToHashSet();mechanismFocusName=group.Name;
        RefreshScope();tabs.SelectedIndex=0;ShowMechanic(group);
    }
    private List<MechanicGroup> SelectedMechanics()=>mechanicTable.SelectedRows.Cast<DataGridViewRow>().Where(row=>row.Index<mechanicTable.RowsData.Count).Select(row=>mechanicTable.RowsData[row.Index]).ToList();
    private async Task NameMechanics() {
        var selected=SelectedMechanics();if(selected.Count==0)return;
        var name=InputDialog.Ask(this,"合并机制组",$"将选中的 {selected.Count} 个机制整理为同一名称，保留全部调用和关联。",selected[0].Name);
        if(string.IsNullOrWhiteSpace(name))return;MechanicAnalysis.NameGroups(recordings,selected,name);dirty=true;mechanicsDirty=true;await RebuildMechanics();
    }
    private void AssignEventMechanic() {
        if(current is null||selectedEvent is null)return;var selected=selectedEvent;var annotation=current.Annotations.GetValueOrDefault(selected.Id)??new();
        var name=InputDialog.Ask(this,"事件归入机制","输入机制名称；与其他事件使用相同名称即可归组，留空恢复自动。",annotation.Mechanic);if(name is null)return;
        annotation.Mechanic=name.Trim();current.Annotations[selected.Id]=annotation;dirty=true;mechanicsDirty=true;RefreshScope();ShowEvent(selected);
    }
    private async Task ExportMechanics(bool selectedOnly) {
        await RebuildMechanics();var groups=selectedOnly?SelectedMechanics():mechanicTable.RowsData.ToList();
        if(groups.Count==0){MessageBox.Show(this,"请先在“机制分组 · 多录像”页选中要导出的机制。");return;}
        using var dialog=new SaveFileDialog{Filter=selectedOnly?"单独机制 (*.json)|*.json":"机制分组 (*.csv)|*.csv",FileName=selectedOnly?"单独机制.json":"机制分组.csv"};if(dialog.ShowDialog(this)!=DialogResult.OK)return;
        await Busy(async token=>{await Task.Run(()=>{token.ThrowIfCancellationRequested();if(selectedOnly)WorkspaceFiles.ExportMechanics(dialog.FileName,groups);else WorkspaceFiles.ExportMechanicsCsv(dialog.FileName,groups);},token);status.Text=$"已导出 {groups.Count} 个机制组：{dialog.FileName}";});
    }
    private void ShowHelp()=>detail.Text="使用方法\n\n1. 导入一份或多份 .dat；同内容 SHA 的重复文件会自动跳过。\n2. 左侧选择录像/阶段，顶部按技能 ID、名称、物件或参数筛选。默认自动过滤玩家及其召唤物的技能，保留 Boss 对玩家施加的状态；高频移动默认隐藏。\n3. 选择事件后，用“阶段 / 锚点”拆分、重命名阶段，或指定相对零点。跨录像对照时使用相同阶段名称和对应技能锚点。\n4. “技能与演出”显示读条、判定、地图和演出关联；双击技能行定位事件。\n5. 地图页展示当前范围调用，选中阶段时详情会列出进入该阶段之前的 MapEffect 状态。\n6. 事件右键可人工分类、关联技能并写备注；保存工程后可恢复。\n7. “合并对照”保留每次观察和原始偏移，不会丢弃同一次战斗的重复包。\n8. “机制分组 · 多录像”按同名技能整理多个 ID，选择行查看演出和判定；双击只看该机制。Ctrl / Shift 多选后右键可合并不同名称的机制。\n9. 可导出当前筛选 CSV、合并 CSV、完整 JSON、RSV / RSF，或者选中的单独机制 JSON。\n\n证据边界\n• “判定”表示包中观察到伤害、治疗、状态或位移效果；原始录像不能单独还原全部服务端几何与随机规则。\n• 读条、MapEffect、EObj、ActionTimeline 为演出相关事件；同一技能可以同时具有判定和演出。\n• “预兆配置”来自当前资源表，不能保证该次客户端实际显示。\n• 高置信度表示有同源或资源引用证据，中/低置信度关系仍需人工核对。\n• 阶段候选依据录像章节；五个已核对最终阶段只在 SHA 精确匹配时自动标注。\n\n支持版本：FFXIVREPLAY v5，国服 build 14101351。升级客户端后应核对 Data/protocol.json 和资源表；工具不会套用未知版本。\n所有分析在本机进行，不连接游戏服务器、不修改原录像。";
    protected override void Dispose(bool disposing){if(disposing){filterTimer.Dispose();cancellation?.Dispose();}base.Dispose(disposing);}
}
