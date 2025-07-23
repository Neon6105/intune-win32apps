#==================================================
# Software : WinGet Upgrade Daemon
# Action   : Detect
# Method   : File + Task + Version
#==================================================

$TaskName = "WinGet Upgrade Daemon"
$TaskPath = "Neon6105"
$DaemonPath = "C:\ProgramData\$TaskPath\winget-daemon.ps1"
$ThisVersion = "0.0.4"

If (! (Test-Path -Path "$DaemonPath" -PathType Leaf)) {
  Write-Output "The winget daemon is not installed!"
  Exit 1
}

try { $InstalledVersion = (& $DaemonPath -Version) } catch { $InstalledVersion = "0.0.0" }
If ($InstalledVersion -ne $ThisVersion) {
  Write-Output "Wrong version installed: expected $ThisVersion"
  Exit 1
}

If (! (Get-ScheduledTask -TaskName "$TaskName" -TaskPath "\$TaskPath\")) {
  Write-Output "The winget daemon is not scheduled!"
  Exit 1
}

Write-Output "The winget daemon $ThisVersion is installed and scheduled."
Exit 0