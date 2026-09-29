$ErrorActionPreference = "SilentlyContinue"
Set-Location $PSScriptRoot
$PidFile = Join-Path $PSScriptRoot ".securepass.pid"
$stopped = $false
if (Test-Path $PidFile) {
    $serverPid = Get-Content $PidFile | Select-Object -First 1
    if ($serverPid) {
        $p = Get-Process -Id $serverPid -ErrorAction SilentlyContinue
        if ($p) { Stop-Process -Id $serverPid -Force; $stopped = $true }
    }
    Remove-Item $PidFile -Force
}
# Safe fallback: only inspect our dedicated demo port.
$listener = Get-NetTCPConnection -LocalPort 8120 -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
if ($listener) {
    $cmd = (Get-CimInstance Win32_Process -Filter "ProcessId=$($listener.OwningProcess)" -ErrorAction SilentlyContinue).CommandLine
    if ($cmd -like "*uvicorn*app.main:app*8120*") {
        Stop-Process -Id $listener.OwningProcess -Force
        $stopped = $true
    }
}
if ($stopped) { Write-Host "SecurePass stopped." -ForegroundColor Green } else { Write-Host "SecurePass was not running." -ForegroundColor Yellow }
