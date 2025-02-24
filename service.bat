@echo off
setlocal EnableDelayedExpansion

:: Must be run as Administrator
:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script requires administrative privileges.
    echo Please run as Administrator.
    pause
    exit /b 1
)

:: Configuration (modify these as needed)
:: EXE_NAME is the name of your executable in the same directory as this batch file
set "EXE_NAME=main.exe"
:: Get the full path (current directory + executable name)
set "EXE_PATH=%~dp0%EXE_NAME%"
set "SERVICE_NAME=Kristo-Excel-Automation"
set "DISPLAY_NAME=Kristo-Excel-Automation"
set "DESCRIPTION=Kristo-Excel-Automation"
set "START_TYPE=auto"  :: Can be: auto, demand, or disabled

:: Validate executable exists
if not exist "%EXE_PATH%" (
    echo ERROR: Executable not found at: %EXE_PATH%
    echo Make sure %EXE_NAME% exists in the same directory as this batch file.
    pause
    exit /b 1
)

:: Check if service already exists
sc query "%SERVICE_NAME%" >nul 2>&1
if !errorlevel! equ 0 (
    echo WARNING: Service '%SERVICE_NAME%' already exists.
    echo Stopping and removing existing service...
    net stop "%SERVICE_NAME%" >nul 2>&1
    sc delete "%SERVICE_NAME%" >nul 2>&1
    if !errorlevel! neq 0 (
        echo ERROR: Failed to remove existing service.
        pause
        exit /b 1
    )
    :: Wait for service to be removed
    timeout /t 2 /nobreak >nul
)

:: Create the service
echo Creating service: %SERVICE_NAME%...
sc create "%SERVICE_NAME%" binPath= "%EXE_PATH%" DisplayName= "%DISPLAY_NAME%" start= %START_TYPE%
if !errorlevel! neq 0 (
    echo ERROR: Failed to create service.
    pause
    exit /b 1
)

:: Set service description
sc description "%SERVICE_NAME%" "%DESCRIPTION%"
if !errorlevel! neq 0 (
    echo WARNING: Failed to set service description.
)

:: Verify service creation
sc query "%SERVICE_NAME%" >nul 2>&1
if !errorlevel! neq 0 (
    echo ERROR: Service creation verification failed.
    pause
    exit /b 1
)

echo.
echo Service created successfully!
echo Service Name: %SERVICE_NAME%
echo Display Name: %DISPLAY_NAME%
echo Startup Type: %START_TYPE%
echo Executable Path: %EXE_PATH%

:: Ask to start service
set /p START_NOW="Would you like to start the service now? (Y/N): "
if /i "!START_NOW!"=="Y" (
    echo Starting service...
    net start "%SERVICE_NAME%"
    if !errorlevel! neq 0 (
        echo ERROR: Failed to start service.
        pause
        exit /b 1
    )
    echo Service started successfully!
)

echo.
echo Service creation process completed.
echo To manage the service, you can use:
echo - net start %SERVICE_NAME%
echo - net stop %SERVICE_NAME%
echo - sc query %SERVICE_NAME%
echo - To remove: sc delete %SERVICE_NAME%

pause
exit /b 0