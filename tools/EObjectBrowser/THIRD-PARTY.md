# 来源与依赖

## 渲染器

- XIViewer，MIT，作者 Asriel Camora：https://github.com/WorkingRobot/XIViewer
- 固定提交 `4aabd2e9bc0abd9c68925af13bb7ae86922297ee`（工作区版本 1.9.0）。完整 MIT 声明随附于 `XIViewer-LICENSE.txt`。
- Ironworks 子模块 `a60748b0d29a1ab385505faf2a06559094fbfd46`。
- d3dasm 子模块 `e519da5164b007e588a183b7f87412a53798ef0c`，负责游戏着色器转换。
- ffxiv-downloader 子模块 `d69cf5e526f876bf1df5d960904c224bb4ed547a`；本程序不启动下载器或其服务。
- UI：egui / eframe 0.35.0；GPU：OpenGL、egui_glow 0.35、glow 0.17；数学：glam 0.31。其余依赖锁定在上游 `Cargo.lock`，版本清单见 `DEPENDENCIES.json`。

本地修改：新增独立中文前端、手动时钟和场景入口、内存时间线选择、禁止空 API 地址请求远程索引。原始文件保留上游版权声明。构建脚本使用固定提交和 `--locked`；不会自动跟随上游更新。

1.0.3 另对 eframe / egui_glow **0.35.0** 添加整窗中间缓冲支持，补丁分别保存在 `eframe.patch`、`egui_glow.patch`，新增实现为 `glow_compositor.rs`。MIT / Apache-2.0 许可证随发布包保留。`prepare_gui_deps.py` 校验 crates.io 原始归档 SHA-256 后仅展开到本项目 Engine 缓存，不修改全局 Cargo 注册表；版本未升级，沿用同版本依赖公告检查，并对修改后的窗口呈现路径单独回归。

- eframe 0.35.0 原始归档：`8dc8234e2f681b2afd2b2e8c332fa614de2fddbdcb28d0acf5c420449682ea90`
- egui_glow 0.35.0 原始归档：`52274b9bfb8d8e252cd0f00c9f6214f360d75a0962baa77a2d62ddb002fe99d4`

## 依赖检查范围

已核对 Windows 构建兼容性，并将固定依赖与 RustSec 官方公告数据库逐包匹配。完整匹配记录位于验证目录 `target/eobj-research/advisory-matches.json`；这不是“没有漏洞”的声明。

- lru 0.18.1 匹配 RUSTSEC-2026-0253：要求具有可能 panic 的 Key Drop、自定义 catch_unwind 等条件。本前端没有这些自定义 Key 或恢复路径；仍保留该上游依赖的已知公告。
- serde_yml 0.0.13 / noyalib 0.0.5、zip 8.6.0 以及网络依赖有上游公告；此浏览器不开放 YAML schema 编辑、ZIP 导入、远程 HTTP/TLS 和下载服务入口。普通浏览仅解析选择的本地游戏 SqPack 数据。
- 锁文件包含上游服务器和其他平台模块，它们不都进入 Windows 前端运行路径。依赖版本与功能可达性必须分别核对，不能仅因锁文件命中就声称浏览器暴露同样的远程接口。

官方公告：https://rustsec.org/advisories/ 。后续升级应对 `engine.patch` / `ironworks.patch` 和真实渲染样本重新回归。本次没有为消除无关上游提示而改动整个引擎依赖树。

游戏模型、纹理、音效、特效和着色器属于其各自权利人。发布包只包含程序和目录索引，实际资源在用户本机安装中读取。
