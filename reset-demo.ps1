$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if (Test-Path .\securepass.db) { Remove-Item .\securepass.db -Force }
python -c "from app.db import init_db; init_db(force_seed=True); print('Demo database reset successfully.')"
