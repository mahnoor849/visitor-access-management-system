$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$Port = 8120
$Health = "http://127.0.0.1:$Port/health"
$AppUrl = "http://127.0.0.1:$Port"

Write-Host "" 
Write-Host "========================================" -ForegroundColor DarkBlue
Write-Host "  SecurePass v2.0 - Audited Enterprise Demo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor DarkBlue

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw "Python was not found. Install Python 3.11+ and reopen the terminal."
}

# If our demo is already healthy, just open it instead of starting a duplicate server.
try {
    $existing = Invoke-RestMethod -Uri $Health -TimeoutSec 2
    if ($existing.status -eq "ok") {
        Write-Host "SecurePass is already running." -ForegroundColor Yellow
        Start-Process $AppUrl
        exit 0
    }
} catch {}

# Refuse to steal a port from another application.
$listener = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
if ($listener) {
    throw "Port $Port is already being used by PID $($listener.OwningProcess). Stop that application or use the original run command with another port."
}

Write-Host "Checking Python packages..." -ForegroundColor Gray
python -c "import fastapi,uvicorn,qrcode,tzdata" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing required packages (first run only)..." -ForegroundColor Yellow
    python -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) { throw "Package installation failed." }
}

$stdout = Join-Path $PSScriptRoot "securepass-server.log"
$stderr = Join-Path $PSScriptRoot "securepass-server-error.log"
Remove-Item $stdout,$stderr -Force -ErrorAction SilentlyContinue

Write-Host "Starting local server..." -ForegroundColor Gray
$proc = Start-Process -FilePath "python" `
    -ArgumentList @("-m","uvicorn","app.main:app","--host","127.0.0.1","--port","$Port") `
    -WorkingDirectory $PSScriptRoot `
    -RedirectStandardOutput $stdout `
    -RedirectStandardError $stderr `
    -PassThru
$proc.Id | Set-Content (Join-Path $PSScriptRoot ".securepass.pid")

$ready = $false
for ($i=0; $i -lt 30; $i++) {
    Start-Sleep -Milliseconds 500
    try {
        $h = Invoke-RestMethod -Uri $Health -TimeoutSec 2
        if ($h.status -eq "ok") { $ready = $true; break }
    } catch {}
    if ($proc.HasExited) { break }
}

if (-not $ready) {
    Write-Host "Server did not become ready." -ForegroundColor Red
    if (Test-Path $stderr) { Get-Content $stderr -Tail 30 }
    throw "SecurePass startup failed."
}

Write-Host "READY: $AppUrl" -ForegroundColor Green
Write-Host "Demo login: guard1 / Guard@123" -ForegroundColor Cyan
Write-Host "Use DEMO_STOP.ps1 when finished." -ForegroundColor Gray
Start-Process $AppUrl
