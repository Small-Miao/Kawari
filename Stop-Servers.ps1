param(
    [string]$Root = $PSScriptRoot,
    [switch]$WorldOnly,
    [switch]$CheckOnly,
    [switch]$Force,
    [ValidateRange(10, 300)][int]$WaitForLogoutSeconds = 60
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$Root = (Resolve-Path -LiteralPath "$Root").Path
$binDirectory = Join-Path "$Root" 'target\debug'
$utf8 = [Text.UTF8Encoding]::new($false)
$shutdownLock = $null
$lockHeld = $false

function Get-MatchingProcess($Entry) {
    $current = Get-Process -Id $Entry.Pid -ErrorAction SilentlyContinue
    if ($null -eq $current) { return $null }
    # 二次校验路径和启动时间，不能把复用的 PID 当作原进程。
    if ($current.Path -ne $Entry.Exe -or $current.StartTime.ToUniversalTime().Ticks -ne $Entry.StartTicks) {
        throw "PID $($Entry.Pid) 的进程身份已改变，已停止本次关闭操作。"
    }
    return $current
}

function Get-WorldConnectionCount($Entry) {
    if ($null -eq (Get-MatchingProcess $Entry)) { return 0 }
    # 包含游戏及内部 TCP 连接；连接数不是玩家人数。查询失败时不假定无人在线。
    return @(Get-NetTCPConnection -ErrorAction Stop | Where-Object {
        $_.OwningProcess -eq $Entry.Pid -and $_.State -in @('Established', 'CloseWait', 'SynReceived')
    }).Count
}

function Wait-WorldIdle($Entry) {
    $deadline = [DateTime]::UtcNow.AddSeconds($WaitForLogoutSeconds)
    $quietSince = $null
    $announced = $false
    do {
        if ($null -eq (Get-MatchingProcess $Entry)) { return }
        $count = Get-WorldConnectionCount $Entry
        if ($count -eq 0) {
            if ($null -eq $quietSince) { $quietSince = [DateTime]::UtcNow }
            # 给注销后的数据库提交留出静默时间；这不是服务器内置的保存确认接口。
            if (([DateTime]::UtcNow - $quietSince).TotalSeconds -ge 5) { return }
        } else {
            $quietSince = $null
            if (-not $announced) {
                Write-Host "世界服仍有 $count 个活动连接。请先在游戏中退出角色，最多等待 $WaitForLogoutSeconds 秒。"
                $announced = $true
            }
        }
        Start-Sleep -Milliseconds 500
    } while ([DateTime]::UtcNow -lt $deadline)
    throw '世界服仍有连接或尚未静默，已保留世界服。请退出角色后重试；明确接受丢失未保存进度时可使用 -Force。'
}

try {
    # 与启动脚本共用锁，防止一边关闭一边启动。
    if (-not $CheckOnly) {
        $sha = [Security.Cryptography.SHA256]::Create()
        try { $hash = [BitConverter]::ToString($sha.ComputeHash($utf8.GetBytes($Root.ToLowerInvariant()))).Replace('-', '') }
        finally { $sha.Dispose() }
        $shutdownLock = [Threading.Mutex]::new($false, "Local\KawariStart-$hash")
        try { $lockHeld = $shutdownLock.WaitOne(0) }
        catch [Threading.AbandonedMutexException] { $lockHeld = $true }
        if (-not $lockHeld) { throw '此目录已有启动或关闭脚本正在执行，请等待其完成。' }
    }

    # 先停管理入口和登录/大厅，再停世界服；run 是旧版服务集合启动器。
    $names = if ($WorldOnly) { @('world') } else { @('run', 'login', 'lobby', 'world', 'frontier', 'patch', 'web', 'launcher', 'admin') }
    $entries = @()
    foreach ($name in $names) {
        $expectedExe = Join-Path "$binDirectory" "kawari-$name.exe"
        $running = @(Get-Process -Name "kawari-$name" -ErrorAction SilentlyContinue)
        foreach ($process in $running) {
            if ([string]::IsNullOrEmpty($process.Path)) { throw "无法核对 PID $($process.Id) 的路径，请使用有权读取该进程信息的账户运行。" }
            if ($process.Path -ne $expectedExe) { continue }
            $entries += [pscustomobject]@{
                Service = $name; Pid = $process.Id; Exe = $expectedExe
                StartTicks = $process.StartTime.ToUniversalTime().Ticks; State = 'Pending'
            }
        }
    }
    if ($entries.Count -eq 0) {
        Write-Host '此项目的服务器已经全部关闭。'
        return
    }
    foreach ($entry in $entries) {
        Write-Host ("将关闭：{0}（PID {1}）" -f $entry.Service, $entry.Pid)
        if ($entry.Service -eq 'world') { Write-Host ("世界服当前活动 TCP 连接：{0}" -f (Get-WorldConnectionCount $entry)) }
    }
    if ($CheckOnly) {
        Write-Host '只读检查完成，未关闭任何进程。'
        return
    }
    if ($Force) {
        Write-Host '强制模式：将断开在线连接，可能丢失尚未保存的角色进度。' -ForegroundColor Yellow
    } else {
        # 预检查阶段不停止任何服务，在线玩家可正常注销保存。
        foreach ($entry in $entries | Where-Object { $_.Service -eq 'world' }) { Wait-WorldIdle $entry }
    }

    $logDirectory = Join-Path "$Root" ('target\runtime\stop-' + (Get-Date -Format 'yyyyMMdd-HHmmss-ffff'))
    $null = New-Item -ItemType Directory -Path "$logDirectory" -Force
    Write-Host "关闭记录：$logDirectory"
    foreach ($entry in $entries) {
        # 登录入口停止后再次确认世界服无连接，处理预检查之后才到达的连接。
        if ($entry.Service -eq 'world' -and -not $Force) { Wait-WorldIdle $entry }
        $current = Get-MatchingProcess $entry
        if ($null -eq $current) {
            $entry.State = 'AlreadyExited'
        } else {
            # 当前程序没有整体优雅停机接口；仅对已验证身份的本项目进程执行终止。
            Stop-Process -InputObject $current -Force -ErrorAction Stop
            if (-not $current.WaitForExit(10000)) { throw "$($entry.Service) 未在 10 秒内退出。" }
            $entry.State = 'Stopped'
        }
        [IO.File]::WriteAllText((Join-Path "$logDirectory" 'processes.json'), (ConvertTo-Json -InputObject @($entries) -Depth 3), $utf8)
        Write-Host ("已关闭：{0}（PID {1}）" -f $entry.Service, $entry.Pid)
    }
    Write-Host '关闭完成。下次双击“启动服务器.cmd”即可再次启动。'
} catch {
    Write-Host ("关闭未完成：" + $_.Exception.Message) -ForegroundColor Red
    exit 1
} finally {
    if ($lockHeld) { $shutdownLock.ReleaseMutex() }
    if ($null -ne $shutdownLock) { $shutdownLock.Dispose() }
}
