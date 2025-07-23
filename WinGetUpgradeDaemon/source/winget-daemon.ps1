[CmdletBinding()]
Param([switch]$Version);

Set-StrictMode -Version Latest

# Manual verson check for funsies
If ($Version) {
  Write-Output "0.0.4"
  Exit 0
}

# App versions that end with a '.' will be converted to wildcards (e.g. '1.2.' is '1.2.*')
$PinnedApps = @{
  "AppProvider1.AppID1" = "1.2."
  "AppProvider2.AppID2" = "9.8.7"
}

# Verify that the 'winget' command is available
If (Get-Command -Name "winget" -ErrorAction SilentlyContinue) {
  $winget = (Get-Command -Name "winget").source
} else {
  try {
    $winget = (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" | Sort-Object -Property Path | Select-Object -Last 1)
  } catch {
    $ErrorMsg = $_.Exception.Message
    Write-Error $ErrorMsg
    Exit 1
  }
}
If (!(Test-Path -Path "$winget" -PathType Leaf)) {
  Write-Error "Unable to locate winget command."
  Exit 1
} else {
  Write-Verbose "Using $winget"
}

# Loop through pins
ForEach ($App in $PinnedApps.getEnumerator()) {
  $AppID = $App.Key
  $AppVersion = $App.Value
  Write-Verbose "Processing pin for $AppID $AppVersion"
  # If the pin does not exist...
  If (!(& $winget pin list --id $AppID | Select-String "$AppVersion")) {
    Write-Verbose "-> winget pin add --id $AppID --exact --version $AppVersion --force"
    If ($AppVersion[-1] -eq ".") { $AppVersion = "$AppVersion*" }  # Append * to versions ending with '.'
    # Create pin; exit on failure
    try {
      & $winget pin add --id $AppID --exact --version $AppVersion --force
    } catch {
      Write-Error "Unable to add pin for $AppID $AppVersion!"
      Exit 1
    }
  } else {
    # winget pin already exists
    Write-Verbose "-> pin exists for $AppID $AppVersion"
  }
}

# Upgrade
try {
  & $winget upgrade --all --silent --disable-interactivity --accept-package-agreements --accept-source-agreements --include-unknown
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}