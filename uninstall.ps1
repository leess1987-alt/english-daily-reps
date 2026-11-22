# English Daily Reps - uninstaller (Windows)
# Removes the Desktop / Start menu shortcuts and the installed app folder.
# The source folder F:\EnglishDailyReps is not touched.
param([string]$Dest = 'F:\Programs\EnglishDailyReps')
$name = 'English Daily Reps'
foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $p = Join-Path $dir "$name.lnk"
  if (Test-Path $p) { Remove-Item $p -Force; Write-Host "Removed $p" }
}
if (Test-Path $Dest) {
  # run from a temp copy if we are inside the folder being removed
  Set-Location $env:TEMP
  Remove-Item $Dest -Recurse -Force
  Write-Host "Removed $Dest"
}
