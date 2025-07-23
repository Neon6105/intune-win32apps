@echo off

set WinAppUtil=C:\Win32ContentPrepTool\IntuneWinAppUtil.exe

%WinAppUtil% -c %~dp0\source -s install.ps1 -o %~dp0 -q

for %%a in ("%~dp0\.") do set "Package=%%~nxa"
if exist %~dp0\%Package%.old.intunewin del %~dp0\%Package%.old.intunewin
if exist %~dp0\%Package%.intunewin ren %~dp0\%Package%.intunewin %Package%.old.intunewin
ren %~dp0\install.intunewin %Package%.intunewin
