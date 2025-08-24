Write-Host "========================================" -ForegroundColor Blue
Write-Host "Patient Tracker App Launcher" -ForegroundColor Blue  
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

Write-Host "Current directory: $(Get-Location)" -ForegroundColor Green
Write-Host ""

if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: pubspec.yaml not found!" -ForegroundColor Red
    Write-Host "Make sure you're running this from the project directory." -ForegroundColor Red
    Write-Host "Expected location: C:\Users\Matas\patient_tracker_flutter\" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Flutter project found!" -ForegroundColor Green
Write-Host ""

Write-Host "Choose how to run Patient Tracker:" -ForegroundColor Cyan
Write-Host "[1] Web Browser (Recommended - Works immediately)" -ForegroundColor White
Write-Host "[2] Windows Desktop App (Full features - Needs Developer Mode)" -ForegroundColor White  
Write-Host "[3] Build for Android (APK file)" -ForegroundColor White
Write-Host "[4] Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "Starting Patient Tracker in web browser..." -ForegroundColor Green
        Write-Host "The app will open in Microsoft Edge." -ForegroundColor Yellow
        Write-Host ""
        & "C:\flutter\bin\flutter.bat" run -d edge --release
    }
    "2" {
        Write-Host "Starting Patient Tracker as Windows desktop app..." -ForegroundColor Green
        Write-Host "Note: This requires Developer Mode to be enabled." -ForegroundColor Yellow
        Write-Host ""
        & "C:\flutter\bin\flutter.bat" run -d windows
    }
    "3" {
        Write-Host "Building Android APK..." -ForegroundColor Green
        & "C:\flutter\bin\flutter.bat" build apk --release
        Write-Host ""
        Write-Host "✅ APK built successfully!" -ForegroundColor Green
        Write-Host "Location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Cyan
    }
    "4" {
        Write-Host "Goodbye!" -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Patient Tracker Launch Complete!" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Read-Host "Press Enter to close"
