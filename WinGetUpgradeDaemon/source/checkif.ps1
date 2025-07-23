[CmdletBinding(DefaultParameterSetName="VersionMatch")]
Param(
  # Type of logic check to perform (mutually exclusive)
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionInstalled")]
  [switch]$NewerVersionInstalled,
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionAvailable")]
  [switch]$NewerVersionAvailable,
  [Parameter(Mandatory=$True, ParameterSetName="VersionMatch")]
  [switch]$VersionsMatch,

  # Global Parameters
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionInstalled")]
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionAvailable")]
  [Parameter(Mandatory=$True, ParameterSetName="VersionMatch")]
  [string]$InstalledPath,
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionInstalled")]
  [Parameter(Mandatory=$True, ParameterSetName="NewVersionAvailable")]
  [Parameter(Mandatory=$True, ParameterSetName="VersionMatch")]
  [string]$AvailablePath
);

Set-StrictMode -Version Latest

function ToVersionTable($VersionString) {
  $VersionTable = $VersionString.split(".")
  $VersionTable = [ordered]@{
    Major = If ($VersionTable.length -ge 1) { [int]$VersionTable[0] } else { 0 }
    Minor = If ($VersionTable.length -ge 2) { [int]$VersionTable[1] } else { 0 }
    Patch = If ($VersionTable.length -ge 3) { [int]$VersionTable[2] } else { 0 }
  }
  return $VersionTable
}

# Defaults for -VersionsMatch
$Result1 = $False
$Result2 = $False
$Default = $True
If ($NewerVersionAvailable) { $Result1 = $True;  $Result2 = $False; $Default = $False }
If ($NewerVersionInstalled) { $Result1 = $False; $Result2 = $True;  $Default = $False  }

try { $ThisVersion = (& $AvailablePath -Version) } catch { $ThisVersion = "0.0.0" }
try { $ThatVersion = (& $InstalledPath -Version) } catch { $ThatVersion = "0.0.0" }

$AvailableVersion = ToVersionTable("$ThisVersion")
$InstalledVersion = ToVersionTable("$ThatVersion")
If ($InstalledVersion.Major -lt $AvailableVersion.Major) { return $Result1 } ElseIf ($InstalledVersion.Major -gt $AvailableVersion.Major) { return $Result2 }
If ($InstalledVersion.Minor -lt $AvailableVersion.Minor) { return $Result1 } ElseIf ($InstalledVersion.Minor -gt $AvailableVersion.Minor) { return $Result2 }
If ($InstalledVersion.Patch -lt $AvailableVersion.Patch) { return $Result1 } ElseIf ($InstalledVersion.Patch -gt $AvailableVersion.Patch) { return $Result2 }
return $Default  # aka InstalledVersion == AvailableVersion