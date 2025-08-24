@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
echo.
echo 📱 Patient Tracker - iPhone Access Launcher
echo ==========================================
echo.
echo Current directory: %CD%

REM Get IP address
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /c:"IPv4 Address" ^| findstr /v "127.0.0.1"') do (
    set "ip=%%i"
    set "ip=!ip: =!"
    if not "!ip!"=="" goto :found_ip
)

:found_ip
echo 🖥️  Your Windows IP: !ip!
echo.

echo Choose your preferred method:
echo.
echo 1) Development Server (recommended for testing)
echo    - Hot reload and debugging
echo    - Faster startup
echo.
echo 2) Production Build (better performance)
echo    - Optimized for production
echo    - Requires build step
echo.

set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" (
    echo.
    echo 📱 iPhone Instructions:
    echo 1. Connect iPhone to same WiFi network as this computer
    echo 2. Open Safari on iPhone
    echo 3. Go to: http://!ip!:8080
    echo 4. Add to Home Screen for app-like experience
    echo.
    echo 🔗 Direct link: http://!ip!:8080
    echo.
    echo Starting development server...
    echo Press Ctrl+C to stop when done.
    echo.
    
    C:\flutter\bin\flutter.bat run -d web-server --web-hostname 0.0.0.0 --web-port 8080
    
) else if "%choice%"=="2" (
    echo.
    echo Starting PowerShell script for production build...
    powershell -ExecutionPolicy Bypass -File "run_for_iphone.ps1" -Method build
) else (
    echo Invalid choice. Please run again and choose 1 or 2.
    pause
    exit /b 1
)

echo.
echo Server stopped. Thanks for using Patient Tracker!
pause
