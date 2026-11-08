# 技术设计

比较自行实现 WPF 模型预览与复用 XIViewer：WPF 原生三维易于显示静态网格，但无法直接覆盖游戏着色器、AVFX 和场景时间线。采用开源 XIViewer 离线场景引擎，增加专用中文 EObject 查询入口，读取当前国服 EObj / ExportedSG / EObjName CSV 与本地 SqPack；固定上游提交并保留许可证。

界面必须只使用本地资源后端，不连接游戏进程或游戏服务器。用户查询以 EObj Base ID 为主，显示 SGB 路径，保留资源层级与时间线的真实标识，未支持部分显式标明。

构建先验证引擎在 Windows 原生环境的兼容性，再做查询、渲染和时间线集成；以已有副本 EObj 和包含模型的标准物件做离线真实渲染测试。源码位于 tools/EObjectBrowser，成品位于 target/EObjectBrowser-1.0.0。

已落实的边界：SGB 内置时间线可以查看全部已解析指令，播放 C013 / C018 变换；未知命令不推测执行。AVFX 作为明确标记的手动资源预览，默认每五秒循环。无 ExportedSG 的 ID 提示地图布局绑定 / 逻辑对象，允许直接打开真实 SGB。没有修改游戏文件或服务器。
