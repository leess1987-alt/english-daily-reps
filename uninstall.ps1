# English Daily Reps - remove shortcuts (the app folder itself is left in place)
$name = 'English Daily Reps'
foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $p = Join-Path $dir "$name.lnk"
  if (Test-Path $p) { Remove-Item $p -Force; Write-Host "Removed $p" }
}
