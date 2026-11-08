// 独立本地桌面入口；不连接或修改游戏服务器。
namespace ReplayAnalyzer.Desktop;
internal static class Program {
    [STAThread]
    static void Main(string[] args) {
        ApplicationConfiguration.Initialize();
        Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
        Application.ThreadException+=(_,e)=>MessageBox.Show(e.Exception.Message,"录像分析工具",MessageBoxButtons.OK,MessageBoxIcon.Error);
        Application.Run(new MainForm(args));
    }
}
