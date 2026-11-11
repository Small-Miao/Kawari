param(
    [string]$Root = $PSScriptRoot,
    [switch]$WorldOnly,
    [switch]$CheckOnly,
    [ValidateRange(5, 300)][int]$StartupTimeoutSeconds = 120
)

# 使用项目现有二进制；不编译、不重启已有进程、不修改配置或数据库。
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$Root = (Resolve-Path -LiteralPath "$Root").Path
$binDirectory = Join-Path "$Root" 'target\debug'
$configPath = Join-Path "$Root" 'config.yaml'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$startupLock = $null
$lockHeld = $false
$oldLog = $env:RUST_LOG
$oldBacktrace = $env:RUST_BACKTRACE

function Get-Listeners {
    @(Get-NetTCPConnection -State Listen -ErrorAction Stop)
}

function Wait-ServiceReady($Service, $Process) {
    $deadline = [DateTime]::UtcNow.AddSeconds($StartupTimeoutSeconds)
    do {
        $Process.Refresh()
        if ($Process.HasExited) { throw "$($Service.Name) 已退出，请查看本次启动日志。" }
        $ownedPorts = @(Get-Listeners | Where-Object { $_.OwningProcess -eq $Process.Id } | Select-Object -ExpandProperty LocalPort)
        $missing = @($Service.Ports | Where-Object { $_ -notin $ownedPorts })
        if ($missing.Count -eq 0) {
            if ($Service.Name -ne 'world') { return }
            $healthAddress = $Service.Address
            if ($healthAddress -eq '0.0.0.0') { $healthAddress = '127.0.0.1' }
            if ($healthAddress -eq '::') { $healthAddress = '::1' }
            if ($healthAddress.Contains(':')) { $healthAddress = "[$healthAddress]" }
            try {
                $url = 'http://{0}:{1}/healthcheck' -f $healthAddress, $Service.Ports[1]
                $response = Invoke-WebRequest -Uri "$url" -UseBasicParsing -TimeoutSec 3
                if ($response.StatusCode -eq 200) { return }
            } catch { }
        }
        Start-Sleep -Milliseconds 400
    } while ([DateTime]::UtcNow -lt $deadline)
    throw "$($Service.Name) 在 $StartupTimeoutSeconds 秒内未就绪。请查看日志；脚本不会强制结束进程。"
}

try {
    foreach ($required in @('config.yaml', 'login.db', 'world.db', 'resources')) {
        if (-not (Test-Path -LiteralPath (Join-Path "$Root" "$required"))) {
            throw "项目文件缺失：$required。请在完整服务器目录中运行此脚本。"
        }
    }
    $definitions = [ordered]@{
        login = @(21060); lobby = @(21059); world = @(21063, 21064)
        frontier = @(21058); patch = @(21061); web = @(21062)
        launcher = @(21065); admin = @(21057)
    }

    # 读取现有配置的普通 YAML 标量；省略的端口采用 core/src/config.rs 默认值。
    $settings = @{}
    foreach ($name in $definitions.Keys) { $settings[$name] = @{ listen_address = '0.0.0.0' } }
    $section = ''
    foreach ($line in [IO.File]::ReadAllLines("$configPath", [Text.Encoding]::UTF8)) {
        if ($line -match '^(\w+):\s*(.*)$') {
            $section = $Matches[1]
            if ($settings.ContainsKey($section) -and $Matches[2].Trim() -notmatch '^(#.*)?$') {
                throw "配置段 $section 需要使用普通缩进格式，暂不支持内联 YAML 或别名。"
            }
        } elseif ($settings.ContainsKey($section) -and $line -match '^\s+(port|healthcheck_port|listen_address):\s*(.*?)\s*(?:#.*)?$') {
            $settings[$section][$Matches[1]] = $Matches[2].Trim().Trim([char]39, [char]34)
        }
    }

    $services = @()
    foreach ($name in $definitions.Keys) {
        if ($WorldOnly -and $name -ne 'world') { continue }
        $exe = Join-Path "$binDirectory" "kawari-$name.exe"
        if (-not (Test-Path -LiteralPath "$exe" -PathType Leaf)) { throw "尚未编译或文件缺失：$exe" }
        $ports = @($definitions[$name])
        foreach ($key in @('port', 'healthcheck_port')) {
            if ($settings[$name].ContainsKey($key)) {
                $value = $settings[$name][$key]
                if ($value -notmatch '^\d+$' -or [int]$value -lt 1 -or [int]$value -gt 65535) { throw "$name.$key 不是有效端口。" }
                if ($key -eq 'port') { $ports[0] = [int]$value }
                elseif ($name -eq 'world') { $ports[1] = [int]$value }
            }
        }
        $address = $settings[$name].listen_address
        $null = [Net.IPAddress]::Parse($address)
        $services += [pscustomobject]@{ Name = $name; Exe = $exe; Ports = $ports; Address = $address; Process = $null }
    }

    # 同一个项目避免被两个双击启动入口同时启动。
    if (-not $CheckOnly) {
        $sha = [Security.Cryptography.SHA256]::Create()
        try { $hash = [BitConverter]::ToString($sha.ComputeHash($utf8.GetBytes($Root.ToLowerInvariant()))).Replace('-', '') }
        finally { $sha.Dispose() }
        $startupLock = [Threading.Mutex]::new($false, "Local\KawariStart-$hash")
        try { $lockHeld = $startupLock.WaitOne(0) }
        catch [Threading.AbandonedMutexException] { $lockHeld = $true }
        if (-not $lockHeld) { throw '此目录已有启动或关闭脚本正在执行，请等待其完成。' }
    }

    $duplicatePorts = @($services | ForEach-Object { $_.Ports } | Group-Object | Where-Object { $_.Count -gt 1 })
    if ($duplicatePorts.Count -gt 0) { throw "配置中多个服务使用同一端口：$($duplicatePorts[0].Name)。" }
    $listeners = @(Get-Listeners)
    foreach ($service in $services) {
        $running = @(Get-Process -Name "kawari-$($service.Name)" -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $service.Exe })
        if ($running.Count -gt 1) { throw "$($service.Name) 已有多个同路径进程，请先检查。" }
        if ($running.Count -eq 1) { $service.Process = $running[0] }
        foreach ($port in $service.Ports) {
            $conflict = @($listeners | Where-Object {
                $_.LocalPort -eq $port -and ($null -eq $service.Process -or $_.OwningProcess -ne $service.Process.Id)
            })
            if ($conflict.Count -gt 0) { throw "端口 $port 已被其他进程占用（PID $($conflict[0].OwningProcess)），未启动新服务。" }
        }
        $state = if ($null -eq $service.Process) { '待启动' } else { "已运行，PID $($service.Process.Id)" }
        Write-Host ('{0,-10} {1,-25} 端口 {2}' -f $service.Name, $state, ($service.Ports -join ', '))
    }
    if ($CheckOnly) {
        Write-Host '检查通过。本次没有启动、停止或重启任何服务。'
        return
    }

    $logDirectory = Join-Path "$Root" ('target\runtime\' + (Get-Date -Format 'yyyyMMdd-HHmmss-ffff'))
    $null = New-Item -ItemType Directory -Path "$logDirectory" -Force
    Write-Host "日志目录：$logDirectory"
    if ([string]::IsNullOrWhiteSpace($env:RUST_LOG)) { $env:RUST_LOG = 'info' }
    $env:RUST_BACKTRACE = '1'
    $records = @()
    foreach ($service in $services) {
        $started = $null -eq $service.Process
        if ($started) {
            $service.Process = Start-Process -FilePath "$($service.Exe)" -WorkingDirectory "$Root" -WindowStyle Hidden -PassThru `
                -RedirectStandardOutput (Join-Path "$logDirectory" "$($service.Name).stdout.log") `
                -RedirectStandardError (Join-Path "$logDirectory" "$($service.Name).stderr.log")
        }
        $records += [pscustomobject]@{ Service = $service.Name; Pid = $service.Process.Id; Exe = $service.Exe; StartedNow = $started }
        [IO.File]::WriteAllText((Join-Path "$logDirectory" 'processes.json'), (ConvertTo-Json -InputObject @($records) -Depth 3), $utf8)
        Wait-ServiceReady $service $service.Process
        Write-Host ("已就绪：{0}（PID {1}）" -f $service.Name, $service.Process.Id)
    }
    Write-Host '服务器已就绪。可关闭此窗口，服务会继续在后台运行。'
} catch {
    Write-Host ("启动失败：" + $_.Exception.Message) -ForegroundColor Red
    Write-Host '已运行的服务保持运行，请根据提示检查配置、端口或日志。'
    exit 1
} finally {
    if ($lockHeld) { $startupLock.ReleaseMutex() }
    if ($null -ne $startupLock) { $startupLock.Dispose() }
    $env:RUST_LOG = $oldLog
    $env:RUST_BACKTRACE = $oldBacktrace
}
