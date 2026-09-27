Unregister-ScheduledTask -TaskName "Утренняя вёрстка — копия с GitHub" -Confirm:$false -ErrorAction SilentlyContinue
Write-Host "Ежедневная копия отключена. Папка с файлами осталась на месте."
Read-Host "Нажмите Enter, чтобы закрыть окно"
