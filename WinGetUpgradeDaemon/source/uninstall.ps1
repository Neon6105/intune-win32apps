#==================================================
# Software : WinGet Upgrade Daemon
# Action   : Uninstall
# Method   : File + Task
#==================================================

$TaskName = "WinGet Upgrade Daemon"
$TaskPath = "Neon6105"
$DaemonPath = "C:\ProgramData\$TaskPath\winget-daemon.ps1"
$DaemonDirectory = Split-Path -parent $DaemonPath

If ((Test-Path -Path "$DaemonPath") -and !(.\checkif.ps1 -NewerVersionInstalled -InstalledPath "$DaemonPath" -AvailablePath ".\winget-daemon.ps1")) {
  Write-Output "Removing $DaemonPath"
  Remove-Item -Path "$DaemonPath" -Force
} else {
  Write-Output "Installed version is newer. Uninstall aborted."
  Exit 1
}

If (! (Get-ChildItem -Path "$DaemonDirectory")) {
  Write-Output "Removing $DaemonDirectory"
  Remove-Item $DaemonDirectory -Force -Confirm:$False
}

try {
  Write-Output "Removing scheduled task"
  Unregister-ScheduledTask -TaskName "$TaskName" -TaskPath "\$TaskPath\" -Confirm:$False -ErrorAction SilentlyContinue
} catch { }

Write-Output "Just smile and wave, boys. Smile and wave."
Exit 0
