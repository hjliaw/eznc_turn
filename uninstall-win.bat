@echo off
rem eznc_turn uninstaller for Windows 10. Removes everything
rem install-win.bat created: the venv, the Desktop shortcut, and the
rem Startup shortcut (if /autostart was used).
rem
rem Run from anywhere (double-click works):
rem     uninstall-win.bat            uninstall, keep saved settings
rem     uninstall-win.bat /purge     also delete saved op parameters
rem                                  (registry key HKCU\Software\eznc_turn)

setlocal
set "APPDIR=%LOCALAPPDATA%\eznc_turn"

echo ==^> Removing shortcuts
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Remove-Item ([Environment]::GetFolderPath('Desktop') + '\eznc_turn.lnk') -ErrorAction SilentlyContinue;" ^
  "Remove-Item ([Environment]::GetFolderPath('Startup') + '\eznc_turn.lnk') -ErrorAction SilentlyContinue"

if exist "%APPDIR%" (
    echo ==^> Removing %APPDIR%
    rmdir /s /q "%APPDIR%"
)
if exist "%APPDIR%" (
    echo Could not remove %APPDIR% — is the app still running?
    echo Close it and rerun this script.
    goto :fail
)

if /i "%~1"=="/purge" (
    echo ==^> Removing saved settings
    reg delete HKCU\Software\eznc_turn /f >nul 2>nul
)

echo.
echo Done. eznc_turn is uninstalled.
if /i not "%~1"=="/purge" echo (Saved op parameters kept; rerun with /purge to remove them.)
pause
exit /b 0

:fail
pause
exit /b 1
