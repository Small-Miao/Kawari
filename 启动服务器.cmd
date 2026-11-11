@echo off
setlocal
chcp 65001 >nul
set "KAWARI_START_ROOT=%~dp0"
powershell.exe -ExecutionPolicy Bypass -Command "& ([scriptblock]::Create([IO.File]::ReadAllText((Join-Path $env:KAWARI_START_ROOT 'Start-Servers.ps1'), [Text.Encoding]::UTF8))) -Root $env:KAWARI_START_ROOT"
set "KAWARI_START_RESULT=%ERRORLEVEL%"
pause
exit /b %KAWARI_START_RESULT%
