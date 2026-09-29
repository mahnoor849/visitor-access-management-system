$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Write-Host "SecurePass v2.0 - Local Enterprise Demo" -ForegroundColor Cyan
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw "Python was not found. Install Python 3.11+ and reopen PowerShell." }
python -m pip install -r requirements.txt
Write-Host "Starting at http://127.0.0.1:8120" -ForegroundColor Green
Write-Host "Press CTRL+C to stop." -ForegroundColor DarkGray
python -m uvicorn app.main:app --host 127.0.0.1 --port 8120
