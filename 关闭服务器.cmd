@echo off
setlocal
chcp 65001 >nul
set "KAWARI_STOP_ROOT=%~dp0"
powershell.exe -ExecutionPolicy Bypass -Command "& ([scriptblock]::Create([IO.File]::ReadAllText((Join-Path $env:KAWARI_STOP_ROOT 'Stop-Servers.ps1'), [Text.Encoding]::UTF8))) -Root $env:KAWARI_STOP_ROOT"
set "KAWARI_STOP_RESULT=%ERRORLEVEL%"
pause
exit /b %KAWARI_STOP_RESULT%
