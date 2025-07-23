#==================================================
# Software : WinGet Upgrade Daemon
# Action   : Install
# Method   : File + Task
#==================================================

$TaskName = "WinGet Upgrade Daemon"
$TaskPath = "Neon6105"
$DaemonPath = "C:\ProgramData\$TaskPath\winget-daemon.ps1"
$DaemonDirectory = Split-Path -parent $DaemonPath

try {
  If (! (Test-Path -Path "$DaemonDirectory")) {
    New-Item -Path "$DaemonDirectory" -ItemType Directory -Force
  }
  If (.\checkif.ps1 -NewerVersionAvailable -InstalledPath "$DaemonPath" -AvailablePath ".\winget-daemon.ps1") {
    Copy-Item -Path (Split-Path -Leaf $DaemonPath) -Destination "$DaemonPath" -Force
  } else {
    Write-Output "Installed versions is same or newer."
    Exit 0
  }
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}

try {
  $SchTaskAction   = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File $DaemonPath" -WorkingDirectory "$DaemonDirectory"
  $SchTaskTrigger  = New-ScheduledTaskTrigger -Daily -At 2am
  $SchTaskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 2) -DontStopIfGoingOnBatteries -StartWhenAvailable

  Register-ScheduledTask -User SYSTEM -RunLevel Highest -Force `
    -Action $SchTaskAction `
    -Trigger $SchTaskTrigger `
    -Settings $SchTaskSettings `
    -TaskPath "$TaskPath" `
    -TaskName "$TaskName" `
    -Description "Unattended upgrade for winget apps"
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1  
}

Write-Output "The winget daemon was successfully installed."
Exit 0