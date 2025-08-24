@echo off
echo ========================================
echo Patient Tracker App Launcher
echo ========================================
echo.

echo Current directory: %CD%
echo.

if not exist "pubspec.yaml" (
    echo ❌ Error: pubspec.yaml not found!
    echo Make sure you're running this from the project directory.
    echo Expected location: C:\Users\Matas\patient_tracker_flutter\
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter project found!
echo.

echo Checking Windows Developer Mode...
echo.
echo If the app fails to start, you may need to enable Developer Mode:
echo 1. Press Win + I to open Settings
echo 2. Go to Privacy & security > For developers
echo 3. Turn on Developer Mode
echo 4. Restart this script
echo.
echo Alternatively, you can run: start ms-settings:developers
echo.
pause

echo Starting Patient Tracker app...
echo.

echo Choose platform:
echo [1] Windows Desktop App (Full features, requires Developer Mode)
echo [2] Web Browser (Limited database features, works without Developer Mode)
echo [3] Exit
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo Starting Windows desktop app...
    C:\flutter\bin\flutter.bat run -d windows
) else if "%choice%"=="2" (
    echo Starting web browser app...
    C:\flutter\bin\flutter.bat run -d edge
) else if "%choice%"=="3" (
    goto :end
) else (
    echo Invalid choice. Exiting...
    goto :end
)

:end
echo.
echo Thanks for using Patient Tracker!
pause
