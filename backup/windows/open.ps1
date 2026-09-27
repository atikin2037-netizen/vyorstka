& (Join-Path $PSScriptRoot "sync.ps1")
Start-Process explorer.exe (Join-Path ([Environment]::GetFolderPath("MyDocuments")) "Утренняя вёрстка")
