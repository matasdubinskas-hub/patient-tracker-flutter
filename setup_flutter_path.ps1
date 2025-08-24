# PowerShell script to add Flutter to PATH permanently
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Flutter PATH Setup" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  This script needs to be run as Administrator to modify system PATH." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please:" -ForegroundColor White
    Write-Host "1. Right-click on PowerShell" -ForegroundColor White
    Write-Host "2. Select 'Run as Administrator'" -ForegroundColor White
    Write-Host "3. Navigate to this folder and run the script again" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to close"
    exit 1
}

$flutterPath = "C:\flutter\bin"

Write-Host "Checking if Flutter is installed..." -ForegroundColor Cyan

if (Test-Path $flutterPath) {
    Write-Host "✅ Flutter found at: $flutterPath" -ForegroundColor Green
} else {
    Write-Host "❌ Flutter not found at expected location: $flutterPath" -ForegroundColor Red
    Write-Host "Please make sure Flutter is installed in C:\flutter\" -ForegroundColor Yellow
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host ""
Write-Host "Checking current PATH..." -ForegroundColor Cyan

$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")

if ($currentPath -like "*$flutterPath*") {
    Write-Host "✅ Flutter is already in the system PATH!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Testing Flutter command..." -ForegroundColor Cyan
    
    try {
        $flutterVersion = & "$flutterPath\flutter.bat" --version 2>&1
        Write-Host "✅ Flutter is working correctly!" -ForegroundColor Green
        Write-Host $flutterVersion -ForegroundColor White
    } catch {
        Write-Host "❌ Flutter command failed to run" -ForegroundColor Red
    }
} else {
    Write-Host "Adding Flutter to system PATH..." -ForegroundColor Yellow
    
    try {
        $newPath = $currentPath + ";" + $flutterPath
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
        
        Write-Host "✅ Flutter added to PATH successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  Please restart your PowerShell/Command Prompt for changes to take effect." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "After restart, you can use:" -ForegroundColor White
        Write-Host "  flutter --version" -ForegroundColor Cyan
        Write-Host "  flutter run" -ForegroundColor Cyan
        Write-Host "  flutter build apk" -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Failed to add Flutter to PATH: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "PATH Setup Complete!" -ForegroundColor Blue  
Write-Host "========================================" -ForegroundColor Blue
Read-Host "Press Enter to close"
