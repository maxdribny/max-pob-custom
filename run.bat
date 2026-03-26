@echo off
pushd "%~dp0runtime" || (
    echo Failed to enter runtime folder.
    pause
    exit /b 1
)

if not exist "Path{space}of{space}Building.exe" (
    echo Could not find Path of Building.exe in:
    echo %cd%
    echo.
    echo Files in this folder:
    dir /b
    pause
    popd
    exit /b 1
)

start "" /d "%cd%" "Path{space}of{space}Building.exe"
popd