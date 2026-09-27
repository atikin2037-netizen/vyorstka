# Обновляет папку "Документы\Утренняя вёрстка" свежей копией с GitHub.
$ErrorActionPreference = "Stop"
$docs   = [Environment]::GetFolderPath("MyDocuments")
$target = Join-Path $docs "Утренняя вёрстка"
$tmp    = Join-Path $env:TEMP "vyorstka-sync"
$zip    = Join-Path $tmp "main.zip"
$log    = Join-Path $target "журнал обновлений.txt"
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
New-Item -ItemType Directory -Path $tmp | Out-Null
New-Item -ItemType Directory -Path $target -Force | Out-Null
try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri "https://github.com/atikin2037-netizen/vyorstka/archive/refs/heads/main.zip" -OutFile $zip -UseBasicParsing
  Expand-Archive -Path $zip -DestinationPath $tmp -Force
  $src = Join-Path $tmp "vyorstka-main"
  # Инструкция, тексты задач и история — в корень папки
  Get-ChildItem (Join-Path $src "backup") -Filter *.txt | Copy-Item -Destination $target -Force
  # Сайт, архив новостей и данные проектов — в подпапку
  $site = Join-Path $target "Сайт и данные"
  New-Item -ItemType Directory -Path $site -Force | Out-Null
  Get-ChildItem $src -Force | Where-Object { $_.Name -ne "backup" } | Copy-Item -Destination $site -Recurse -Force
  Add-Content -Path $log -Value ("{0:dd.MM.yyyy HH:mm} — обновлено" -f (Get-Date)) -Encoding UTF8
} catch {
  Add-Content -Path $log -Value ("{0:dd.MM.yyyy HH:mm} — ОШИБКА: {1}" -f (Get-Date), $_.Exception.Message) -Encoding UTF8
} finally {
  if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
