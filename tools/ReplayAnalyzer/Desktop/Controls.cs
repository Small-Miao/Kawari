// 虚拟化表格与可点击时间轴，避免为大量录像事件创建控件。
using ReplayAnalyzer.Core;
using System.ComponentModel;
namespace ReplayAnalyzer.Desktop;

internal sealed class VirtualTable<T>:DataGridView {
    public List<T> RowsData {get;private set;}=[];
    private readonly List<Func<T,object?>> getters=[];
    private int sortedColumn=-1;private bool descending;
    public Action<T>? Selected;
    public VirtualTable() {
        Dock=DockStyle.Fill;VirtualMode=true;ReadOnly=true;AllowUserToAddRows=false;AllowUserToDeleteRows=false;AllowUserToResizeRows=false;MultiSelect=false;SelectionMode=DataGridViewSelectionMode.FullRowSelect;RowHeadersVisible=false;
        BackgroundColor=Color.White;BorderStyle=BorderStyle.None;GridColor=Color.FromArgb(233,237,242);RowTemplate.Height=29;AutoSizeColumnsMode=DataGridViewAutoSizeColumnsMode.None;EnableHeadersVisualStyles=false;
        ColumnHeadersDefaultCellStyle=new(){BackColor=Color.FromArgb(239,243,248),ForeColor=Color.FromArgb(35,49,68),Font=new Font("Microsoft YaHei UI",9,FontStyle.Bold),SelectionBackColor=Color.FromArgb(239,243,248)};
        DefaultCellStyle=new(){BackColor=Color.White,ForeColor=Color.FromArgb(45,55,70),SelectionBackColor=Color.FromArgb(222,235,253),SelectionForeColor=Color.FromArgb(20,52,92),Padding=new Padding(3,0,3,0)};
        AlternatingRowsDefaultCellStyle.BackColor=Color.FromArgb(249,251,253);ColumnHeadersHeight=34;
        CellValueNeeded+=(_,e)=>{if(e.RowIndex>=0&&e.RowIndex<RowsData.Count&&e.ColumnIndex<getters.Count)e.Value=getters[e.ColumnIndex](RowsData[e.RowIndex]);};
        SelectionChanged+=(_,_)=>{if(CurrentCell is {} cell&&cell.RowIndex<RowsData.Count)Selected?.Invoke(RowsData[cell.RowIndex]);};
        ColumnHeaderMouseClick+=(_,e)=>{descending=sortedColumn==e.ColumnIndex&&!descending;sortedColumn=e.ColumnIndex;var get=getters[e.ColumnIndex];RowsData=descending?RowsData.OrderByDescending(get,ObjectComparer.Instance).ToList():RowsData.OrderBy(get,ObjectComparer.Instance).ToList();Invalidate();};
        CellMouseDown+=(_,e)=>{if(e.Button==MouseButtons.Right&&e.RowIndex>=0&&!Rows[e.RowIndex].Selected)CurrentCell=Rows[e.RowIndex].Cells[Math.Max(0,e.ColumnIndex)];};
    }
    public void Column(string title,int width,Func<T,object?> get,bool fill=false) {
        getters.Add(get);Columns.Add(new DataGridViewTextBoxColumn{HeaderText=title,Width=width,SortMode=DataGridViewColumnSortMode.Programmatic,AutoSizeMode=fill?DataGridViewAutoSizeColumnMode.Fill:DataGridViewAutoSizeColumnMode.None,MinimumWidth=60});
    }
    public void SetData(IEnumerable<T> rows){CurrentCell=null;RowCount=0;RowsData=rows.ToList();RowCount=RowsData.Count;Invalidate();}
    public void SelectItem(Predicate<T> match){var i=RowsData.FindIndex(match);if(i<0)return;CurrentCell=Rows[i].Cells[0];FirstDisplayedScrollingRowIndex=i;}
    private sealed class ObjectComparer:IComparer<object?> {
        public static readonly ObjectComparer Instance=new();
        public int Compare(object? x,object? y){if(x is null)return y is null?0:-1;if(y is null)return 1;return x.GetType()==y.GetType()&&x is IComparable c?c.CompareTo(y):string.Compare(x.ToString(),y.ToString(),StringComparison.CurrentCulture);}
    }
}

internal sealed class TimelineView:Control {
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    public IReadOnlyList<ReplayEvent> Items {get;set;}=[];
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    public uint StartMs {get;set;}
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    public uint EndMs {get;set;}=1;
    [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
    public uint? SelectedMs {get;set;}
    public Action<ReplayEvent>? Picked;
    public Func<ReplayEvent,EventRole> RoleOf=e=>e.Roles;
    private readonly ToolTip tooltip=new();
    private static readonly (EventRole Role,string Name,Color Color)[] tracks=[(EventRole.Cast,"读条",Color.FromArgb(47,115,207)),(EventRole.Result,"判定",Color.FromArgb(211,89,78)),(EventRole.Map,"地图",Color.FromArgb(151,104,190)),(EventRole.Visual,"演出",Color.FromArgb(55,154,135)),(EventRole.Object,"物件",Color.FromArgb(197,149,53))];
    public TimelineView(){Height=122;Dock=DockStyle.Top;DoubleBuffered=true;BackColor=Color.FromArgb(249,251,254);Cursor=Cursors.Hand;}
    protected override void OnPaint(PaintEventArgs e) {
        base.OnPaint(e);var g=e.Graphics;var width=Math.Max(1,Width-95);var span=Math.Max(1,(long)EndMs-StartMs);
        using var line=new Pen(Color.FromArgb(222,229,238));using var text=new SolidBrush(Color.FromArgb(90,104,124));
        for(var i=0;i<=6;i++){var x=75+width*i/6;g.DrawLine(line,x,20,x,112);g.DrawString(ReplayEvent.TimeTextOf((StartMs+span*i/6)/1000d),Font,text,x-18,2);}
        for(var i=0;i<tracks.Length;i++){g.DrawString(tracks[i].Name,Font,text,8,24+i*17);using var brush=new SolidBrush(tracks[i].Color);var columns=new HashSet<int>();foreach(var item in Items){if(item.Ms<StartMs||item.Ms>EndMs||!RoleOf(item).HasFlag(tracks[i].Role))continue;var x=75+(int)(((long)item.Ms-StartMs)*width/span);if(columns.Add(x))g.FillRectangle(brush,x,25+i*17,Math.Max(2,item.Kind=="读条"?(int)(item.Duration*1000*width/span):2),10);}}
        if(SelectedMs is {} selected){using var pen=new Pen(Color.FromArgb(15,37,64),2);var x=75+(int)(((long)selected-StartMs)*width/span);g.DrawLine(pen,x,19,x,113);}
    }
    protected override void OnMouseDown(MouseEventArgs e){base.OnMouseDown(e);if(Items.Count==0)return;var fraction=Math.Clamp((e.X-75d)/Math.Max(1,Width-95),0,1);var time=StartMs+fraction*Math.Max(1,(long)EndMs-StartMs);var nearest=Items.MinBy(item=>Math.Abs(item.Ms-time));if(nearest is not null){SelectedMs=nearest.Ms;Invalidate();Picked?.Invoke(nearest);}}
    protected override void OnMouseMove(MouseEventArgs e){base.OnMouseMove(e);var time=StartMs+Math.Clamp((e.X-75d)/Math.Max(1,Width-95),0,1)*Math.Max(1,(long)EndMs-StartMs);tooltip.SetToolTip(this,$"{ReplayEvent.TimeTextOf(time/1000)} · 点击定位最近事件");}
    protected override void Dispose(bool disposing){if(disposing)tooltip.Dispose();base.Dispose(disposing);}
}

internal static class InputDialog {
    public static string? Ask(IWin32Window owner,string title,string label,string initial="") {
        using var dialog=new Form{Text=title,ClientSize=new Size(540,150),StartPosition=FormStartPosition.CenterParent,FormBorderStyle=FormBorderStyle.FixedDialog,MaximizeBox=false,MinimizeBox=false,Font=new Font("Microsoft YaHei UI",9)};
        var text=new TextBox{Left=18,Top=52,Width=500,Text=initial};dialog.Controls.Add(new Label{Text=label,Left=18,Top=18,Width=505,Height=30});dialog.Controls.Add(text);
        var ok=new Button{Text="确定",DialogResult=DialogResult.OK,Left=335,Top=105,Width=85};var cancel=new Button{Text="取消",DialogResult=DialogResult.Cancel,Left=433,Top=105,Width=85};dialog.Controls.Add(ok);dialog.Controls.Add(cancel);dialog.AcceptButton=ok;dialog.CancelButton=cancel;
        return dialog.ShowDialog(owner)==DialogResult.OK?text.Text:null;
    }
}
