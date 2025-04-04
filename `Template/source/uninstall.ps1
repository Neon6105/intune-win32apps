#==================================================
# Software : Template
# Action   : Uninstall
# Method   : Chocolatey, MsiExec, WinGet, etc
# Updated  : 
#==================================================

# Chocolatey
$PackageName = "package"
try {
  Start-Process -FilePath "C:\ProgramData\chocolatey\choco.exe" -ArgumentList "uninstall $PackageName -a -x -y" -Wait -NoNewWindow
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "$PackageName was removed successfully."
Exit 0


# MsiExec
$MsiName = "installer.msi"
try {
  Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $MsiName /qn" -Wait -NoNewWindow
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "$MsiName was removed successfully."
Exit 0


# WinGet
$AppID = "Package.Name"
try {
  $winget = (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" | Sort-Object -Property Path | Select-Object -Last 1)
  Start-Process -FilePath "$winget" -Wait -NoNewWindow `
    -ArgumentList "uninstall --id $AppID --exact --scope machine --source winget --silent --accept-source-agreements --disable-interactivity --purge --force"
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "$AppID was removed successfully."
Exit 0
