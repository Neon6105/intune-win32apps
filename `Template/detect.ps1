#==================================================
# Software : Template
# Action   : Detect
# Method   : Chocolatey, MsiID, WinGet, Registry, etc
# Updated  : 
#==================================================

# Chocolatey
$PackageName = "package"
try {
  $installed = (Test-Path -Path "C:\ProgramData\chocolatey\lib\$PackageName" -PathType Container)
  If (! $installed) { throw "Could not find $PackageName"}
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "Found $PackageName"
Exit 0


# MsiExec
$MsiID = "{}"
try {
  $installed = (Get-CimInstance -ClassName Win32_Product | Where-Object { $_.IdentifyingNumber -eq "$MsiID" })
  If (! $installed) { throw "Could not find $MsiID"}
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "Found $MsiID"
Exit 0


# WinGet
$AppID = "Package.Name"
try {
  $winget = (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" | Sort-Object -Property Path | Select-Object -Last 1)
  $installed = (& $winget list --id "$AppID" --exact | findstr "$AppID")
  If (! $installed) { throw "Could not find $AppID" }
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "Found $AppID"
Exit 0


# Registry
$RegistryPath = "HKLM:\Path\To\Key"
$RegistryName = "RegistryItem"
$RegistryValue = 0
try {
  $CurrentValue = Get-ItemPropertyValue -Path $RegistryPath -Name $RegistryName
  If ($CurrentValue -ne $RegistryValue) { throw "$RegistryName is $CurrentValue" }
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}
Write-Output "Found $RegistryName with value $CurrentValue"
Exit 0
