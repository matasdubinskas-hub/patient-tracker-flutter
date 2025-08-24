@echo off
echo ========================================
echo Flutter Installation Helper for Windows
echo ========================================
echo.

echo Step 1: Checking if Flutter is already installed...
flutter --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Flutter is already installed!
    flutter --version
    goto :run_app
) else (
    echo ❌ Flutter not found in PATH
)

echo.
echo Step 2: Instructions for Flutter Installation
echo.
echo Please follow these steps:
echo 1. Go to: https://flutter.dev/docs/get-started/install/windows
echo 2. Download the Flutter SDK ZIP file
echo 3. Extract to C:\flutter (or your preferred location)
echo 4. Add C:\flutter\bin to your Windows PATH:
echo    - Press Win + R, type: sysdm.cpl
echo    - Click "Environment Variables"
echo    - Find "Path" in System Variables, click Edit
echo    - Click New, add: C:\flutter\bin
echo    - Click OK to save
echo 5. Restart this terminal/PowerShell
echo 6. Run this script again
echo.
pause
goto :end

:run_app
echo.
echo Step 3: Setting up the Patient Tracker app...
echo.

if not exist pubspec.yaml (
    echo ❌ pubspec.yaml not found. Make sure you're in the project directory.
    pause
    goto :end
)

echo Getting Flutter dependencies...
flutter pub get

echo.
echo Step 4: Choose how to run the app:
echo.
echo [1] Run in Web Browser (Chrome) - Easiest for testing
echo [2] Run on connected Android/iOS device
echo [3] Run as Windows Desktop app
echo [4] Just build the app (don't run)
echo [5] Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Starting web version...
    flutter run -d chrome
) else if "%choice%"=="2" (
    echo Checking for connected devices...
    flutter devices
    echo.
    echo Starting app on connected device...
    flutter run
) else if "%choice%"=="3" (
    echo Enabling Windows desktop support...
    flutter config --enable-windows-desktop
    echo Starting Windows desktop app...
    flutter run -d windows
) else if "%choice%"=="4" (
    echo Building app...
    flutter build apk --release
    echo ✅ Android APK built successfully!
    echo Check: build\app\outputs\flutter-apk\app-release.apk
) else if "%choice%"=="5" (
    goto :end
) else (
    echo Invalid choice. Please run the script again.
)

:end
echo.
echo ========================================
echo Patient Tracker Setup Complete!
echo ========================================
pause
