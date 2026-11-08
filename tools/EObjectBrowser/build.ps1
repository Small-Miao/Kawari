param([switch]$Test, [switch]$RefreshCatalog, [string]$CsvDirectory = "D:\Code\ffxiv-datamining\csv\cn")
$ErrorActionPreference = "Stop"
$sourceRoot = $PSScriptRoot
$engineRoot = Join-Path "$sourceRoot" "Engine"
$revision = "4aabd2e9bc0abd9c68925af13bb7ae86922297ee"
function Invoke-GitChecked {
    param([string[]]$Arguments)
    & git @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Git 执行失败：$Arguments" }
}
if (-not (Test-Path -LiteralPath "$engineRoot/.git")) {
    Invoke-GitChecked -Arguments @("clone", "https://github.com/WorkingRobot/XIViewer.git", "$engineRoot")
    Invoke-GitChecked -Arguments @("-C", "$engineRoot", "checkout", "--detach", "$revision")
    Invoke-GitChecked -Arguments @("-C", "$engineRoot", "submodule", "update", "--init", "--recursive")
}
$actual = (& git -C "$engineRoot" rev-parse HEAD).Trim()
if ($actual -ne $revision) { throw "引擎版本不符：$actual；不会覆盖已有工作目录。" }
function Apply-LocalPatch {
    param([string]$Repository, [string]$Patch, [string]$Subdirectory = "")
    $applyArgs = @("-C", "$Repository", "apply")
    if ($Subdirectory) { $applyArgs += "--directory=$Subdirectory" }
    & git @applyArgs --reverse --check "$Patch" 2>$null
    if ($LASTEXITCODE -eq 0) { return }
    & git @applyArgs --check "$Patch"
    if ($LASTEXITCODE -ne 0) { throw "补丁与现有修改冲突：$Patch" }
    Invoke-GitChecked -Arguments ($applyArgs + "$Patch")
}
& python "$sourceRoot/prepare_gui_deps.py"
if ($LASTEXITCODE -ne 0) { throw "准备 GUI 源码失败" }
Apply-LocalPatch "$engineRoot" (Join-Path "$sourceRoot" "engine.patch")
Apply-LocalPatch "$engineRoot" (Join-Path "$sourceRoot" "eframe.patch") "deps/eobject-eframe"
Apply-LocalPatch "$engineRoot" (Join-Path "$sourceRoot" "egui_glow.patch") "deps/eobject-egui_glow"
Copy-Item -LiteralPath "$sourceRoot/glow_compositor.rs" -Destination "$engineRoot/deps/eobject-egui_glow/src/compositor.rs" -Force
Apply-LocalPatch "$engineRoot/deps/ironworks" (Join-Path "$sourceRoot" "ironworks.patch")
if ($RefreshCatalog) {
    & python "$sourceRoot/export_catalog.py" "$CsvDirectory" "$sourceRoot/Data/catalog.json"
    if ($LASTEXITCODE -ne 0) { throw "生成目录失败" }
}
foreach ($name in @("eobject.rs", "eobject_main.rs", "render_probe.rs")) {
    Copy-Item -LiteralPath "$sourceRoot/$name" -Destination "$engineRoot/viewer/src/$name" -Force
}
New-Item -ItemType Directory -Path "$engineRoot/viewer/examples" -Force | Out-Null
Copy-Item -LiteralPath "$sourceRoot/eobject_probe.rs" -Destination "$engineRoot/viewer/examples/eobject_probe.rs" -Force
if ($Test) {
    & cargo test --manifest-path "$engineRoot/Cargo.toml" -p viewer --lib --release --locked eobject::tests
    if ($LASTEXITCODE -ne 0) { throw "浏览器回归失败" }
    & cargo test --manifest-path "$engineRoot/Cargo.toml" -p ironworks --release --locked file::sgb::test
    if ($LASTEXITCODE -ne 0) { throw "SGB 回归失败" }
}
& cargo build --manifest-path "$engineRoot/Cargo.toml" -p viewer --bin EObjectBrowser --release --locked
if ($LASTEXITCODE -ne 0) { throw "构建失败" }
& python "$sourceRoot/package_licenses.py"
if ($LASTEXITCODE -ne 0) { throw "收集许可证失败" }
$publishRoot = [IO.Path]::GetFullPath((Join-Path "$sourceRoot" "../../target/EObjectBrowser-1.0.3"))
New-Item -ItemType Directory -Path "$publishRoot" -Force | Out-Null
Copy-Item -LiteralPath "$engineRoot/target/release/EObjectBrowser.exe" -Destination "$publishRoot/EObjectBrowser.exe" -Force
foreach ($name in @("README.md", "THIRD-PARTY.md", "XIViewer-LICENSE.txt", "DEPENDENCIES.json")) {
    Copy-Item -LiteralPath "$sourceRoot/$name" -Destination "$publishRoot/$name" -Force
}
Copy-Item -LiteralPath "$sourceRoot/Licenses" -Destination "$publishRoot" -Recurse -Force
Write-Output "已发布：$publishRoot/EObjectBrowser.exe"
