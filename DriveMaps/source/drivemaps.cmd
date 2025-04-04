@echo off
REM Last updated 2025-03-04

SETLOCAL
set "DOMAIN_NAME=corp.example.com"
set "FILE_SERVER=FILES1.%DOMAIN_NAME%"

REM Ensure that parameter-based variables are not defined
set "debug="
set "verbose="
set "whatif="
for %%p in (%*) do (
  for %%d in (-d, --debug) do ( if %%p==%%d set "debug=1" )
  for %%v in (-v, --verbose) do ( if %%p==%%v set "verbose=1")
  for %%w in (-w, --whatif) do ( if %%p==%%w set "whatif=1")
)
REM setting debug implies verbose
if defined debug set "verbose=1"
if defined debug echo Script called as %0 %*

REM Do not run for local users
if %USERDOMAIN%==%COMPUTERNAME% (
  if defined verbose echo Local users are not allowed. Run this script as a domain or cloud user.
  if defined debug echo %USERDOMAIN%\%USERNAME% same as %COMPUTERNAME%\%USERNAME%
  exit /b
)

:main
  if defined debug echo Arrived at :main %*
  REM call :drive %action% %letter% %sharepath% %label%
  REM Valid actions are listed below. DO NOT INCLUDE A TRAILING SLASH!
  REM  create (map a drive only if it does not exist)
  REM  delete (remove an existing drive)
  REM  replace (always :delete then :create)
  REM  update (only :delete then :create if the remote path has changed)
  call :drive update S \\%FILE_SERVER%\Share "Share"
  call :drive update T \\%FILE_SERVER%\ShareGrp "ShareGroup"
  call :drive update U \\%FILE_SERVER%\Home\%username% "User"
exit /b

REM ## ## ## ## DO NOT EDIT BELOW THIS LINE ## ## ## ##

:drive
  if defined debug echo Arrived at :drive %*
  SETLOCAL enabledelayedexpansion
  REM Set variables...
  set action=%1
  REM Set device as a letter followed by a colon
  set device=%~2
  if not "%device:~-1%"==":" set device=%device%:
  REM Remove trailing \ from sharepath
  set sharepath=%3
  if not defined sharepath set sharepath=\\
  if "%sharepath:~-1%"=="\" set sharepath=%sharepath:~0,-1%
  REM Expand the label and wrap it in quotes
  set label="%~4"
  REM Set regkey from sharepath and remove trailing #
  set regkey=%sharepath:\=#%
  if "%regkey:~-1%"=="#" set regkey=%regkey:~0,-1%
  REM Add the trailing \ AFTER regkey has been set
  if not "%sharepath:~-1%"=="\" set sharepath=%sharepath%\

  REM Debug logging details
  if defined debug (
    echo %device% action=%action%
    echo %device% device=%device%
    echo %device% sharepath=%sharepath%
    echo %device% label=%label%
    echo %device% regkey=%regkey%
  )

  REM Make sure the requested action is valid
  set "valid_action="
  for %%a in (create, delete, replace, update) do ( if %action%==%%a set "valid_action=1" )
  if not defined valid_action (
    if defined verbose echo %device% %action% is not a valid action. Please use create, delete, replace, or update.
    exit /b
  ) else (
    if defined debug echo %device% Success: %action% is a valid action!
  )
  
  REM Convert update to create or replace. Take no action if device is properly mapped.
  if defined debug echo %device% Checking if action=update (%action%)
  if %action%==update (
    if exist %device% (
      set "remotename="
      for /f "tokens=3 delims= " %%a in ('net use %device% ^| findstr "\\"') do ( set "remotename=%%a\" )
      if not "!remotename!"=="%sharepath%" (
        if defined debug echo %device% Action changed from %action% to replace.
        set "action=replace"
      ) else (
        if defined verbose echo %device% Skipped %device% becuase it already points to %sharepath%
        exit /b
      )
    ) else (
      REM The requested drive letter does not exist.
      if defined debug echo %device% Action changed from %action% to create.
      set "action=create"
    )
  )

  REM DELETE, REPLACE
  if defined debug echo %device% Checking if action=delete or action=replace (%action%)
  for %%a in (delete, replace) do ( if %action%==%%a (
    if exist %device% (
      REM The action is delete or replace, and the drive letter already exists.
      if defined debug echo %device% Attempting to remove %device%...
      net use %device% /delete
    )
  ))

  REM CREATE, REPLACE
  if defined debug echo %device% Checking if action=create or action=replace
  for %%a in (create, replace) do ( if %action%==%%a (
    if exist %device% (
      if defined verbose echo %device% Skipped %device% because it already exists for this user.
      exit /b
    ) else (
      REM 'dir' is a reliable method to see if a share is traversable.
      REM 'net view' will only tell you if the top-level share exists.
      dir %sharepath% > nul 2>&1
      if %ERRORLEVEL%==0 (
        if defined verbose echo %device% Mapping %device% to %sharepath% with label %label%
        if not defined whatif (
          net use %device% %sharepath% /persistent:yes > nul
          reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\%regkey% /v _LabelFromReg /t REG_SZ /d %label% /f > nul
        )
      ) else (
        if defined verbose echo %device% Skipped %device% %sharepath% because the path does not exist for this user.
        exit /b
      )
    )
  ))
  ENDLOCAL
exit /b
