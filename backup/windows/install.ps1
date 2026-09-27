# Копирует sync.ps1 в папку пользователя, делает первое обновление и ставит ежедневное обновление в 9:30.
$ErrorActionPreference = "Stop"
$home2  = Join-Path $env:LOCALAPPDATA "VyorstkaSync"
New-Item -ItemType Directory -Path $home2 -Force | Out-Null
Copy-Item (Join-Path $PSScriptRoot "sync.ps1") (Join-Path $home2 "sync.ps1") -Force
$script = Join-Path $home2 "sync.ps1"
$action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script`""
$trigger = New-ScheduledTaskTrigger -Daily -At 9:30
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "Утренняя вёрстка — копия с GitHub" -Action $action -Trigger $trigger -Settings $settings -Description "Каждый день обновляет папку Документы\Утренняя вёрстка с GitHub" -Force | Out-Null
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script
$docs = [Environment]::GetFolderPath("MyDocuments")
Write-Host ""
Write-Host "Готово. Папка: $docs\Утренняя вёрстка" -ForegroundColor Green
Write-Host "Она будет обновляться каждый день в 9:30 (или при первом включении компьютера после этого времени)."
Start-Process explorer.exe (Join-Path $docs "Утренняя вёрстка")
Read-Host "Нажмите Enter, чтобы закрыть окно"
