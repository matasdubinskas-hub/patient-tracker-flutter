# 📱 Launch Patient Tracker for iPhone Access
# This script starts a local server accessible from your iPhone

param(
    [string]$Method = "dev",  # "dev" for development server, "build" for production build
    [int]$Port = 8080
)

# Ensure we're in the correct directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "🚀 Starting Patient Tracker for iPhone Access..." -ForegroundColor Green
Write-Host "Current directory: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Check for pubspec.yaml
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ pubspec.yaml not found in current directory" -ForegroundColor Red
    Write-Host "Please make sure you're running this script from the Flutter project directory" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Get local IP address
$ipInfo = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notmatch "Loopback" -and $_.InterfaceAlias -notmatch "Teredo"}
$localIP = ($ipInfo | Where-Object {$_.IPAddress -match "^192\.168\.|^10\.|^172\.16\."} | Select-Object -First 1).IPAddress

if (-not $localIP) {
    $localIP = ($ipInfo | Select-Object -First 1).IPAddress
}

Write-Host "🖥️  Your Windows IP Address: $localIP" -ForegroundColor Yellow
Write-Host ""

# Check if Flutter is available
if (-not (Test-Path "C:\flutter\bin\flutter.bat")) {
    Write-Host "❌ Flutter not found at C:\flutter\bin\flutter.bat" -ForegroundColor Red
    Write-Host "Please make sure Flutter is installed and try again."
    Read-Host "Press Enter to exit"
    exit 1
}

# Open firewall port
Write-Host "🔥 Configuring Windows Firewall..." -ForegroundColor Yellow
try {
    $ruleName = "Flutter Dev Server iPhone Access"
    $existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if (-not $existingRule) {
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort $Port -Action Allow | Out-Null
        Write-Host "✅ Firewall rule created for port $Port" -ForegroundColor Green
    } else {
        Write-Host "✅ Firewall rule already exists" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Could not configure firewall automatically. You may need to allow port $Port manually." -ForegroundColor Yellow
}

Write-Host ""

if ($Method -eq "dev") {
    Write-Host "🔧 Starting Development Server..." -ForegroundColor Green
    Write-Host "This provides hot reload and debugging features." -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "📱 iPhone Instructions:" -ForegroundColor Cyan
    Write-Host "1. Make sure your iPhone is connected to the same WiFi network" -ForegroundColor White
    Write-Host "2. Open Safari on your iPhone" -ForegroundColor White
    Write-Host "3. Navigate to: http://$localIP`:$Port" -ForegroundColor Yellow
    Write-Host "4. Bookmark or 'Add to Home Screen' for easy access" -ForegroundColor White
    Write-Host ""
    Write-Host "🔗 Direct link: http://$localIP`:$Port" -ForegroundColor Green
    Write-Host ""
    Write-Host "Starting Flutter development server..." -ForegroundColor Gray
    Write-Host "Press Ctrl+C to stop the server when done." -ForegroundColor Gray
    Write-Host ""
    
    # Start Flutter development server
    & "C:\flutter\bin\flutter.bat" run -d web-server --web-hostname 0.0.0.0 --web-port $Port
    
} elseif ($Method -eq "build") {
    Write-Host "🔨 Building Production Version..." -ForegroundColor Green
    Write-Host "This provides optimized performance for testing." -ForegroundColor Gray
    Write-Host ""
    
    # Build the web version
    Write-Host "Building web app..." -ForegroundColor Gray
    & "C:\flutter\bin\flutter.bat" build web --release
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Build successful!" -ForegroundColor Green
        Write-Host ""
        
        # Check for available HTTP server options
        $serverCommand = $null
        $serverArgs = @()
        
        # Check for Python
        if (Get-Command python -ErrorAction SilentlyContinue) {
            $serverCommand = "python"
            $serverArgs = @("-m", "http.server", $Port.ToString(), "--bind", "0.0.0.0")
            Write-Host "🐍 Using Python HTTP server" -ForegroundColor Green
        }
        # Check for Node.js http-server
        elseif (Get-Command http-server -ErrorAction SilentlyContinue) {
            $serverCommand = "http-server"
            $serverArgs = @("-p", $Port.ToString(), "-a", "0.0.0.0")
            Write-Host "🟢 Using Node.js http-server" -ForegroundColor Green
        }
        else {
            Write-Host "⚠️  No HTTP server found. Please install Python or Node.js http-server:" -ForegroundColor Yellow
            Write-Host "   - Install Python: https://python.org" -ForegroundColor Gray
            Write-Host "   - Or install http-server: npm install -g http-server" -ForegroundColor Gray
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        Write-Host ""
        Write-Host "📱 iPhone Instructions:" -ForegroundColor Cyan
        Write-Host "1. Make sure your iPhone is connected to the same WiFi network" -ForegroundColor White
        Write-Host "2. Open Safari on your iPhone" -ForegroundColor White
        Write-Host "3. Navigate to: http://$localIP`:$Port" -ForegroundColor Yellow
        Write-Host "4. Bookmark or 'Add to Home Screen' for easy access" -ForegroundColor White
        Write-Host ""
        Write-Host "🔗 Direct link: http://$localIP`:$Port" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starting HTTP server from build/web directory..." -ForegroundColor Gray
        Write-Host "Press Ctrl+C to stop the server when done." -ForegroundColor Gray
        Write-Host ""
        
        # Change to build/web directory and start server
        Push-Location -Path "build\web"
        try {
            & $serverCommand @serverArgs
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "❌ Build failed. Please check the output above for errors." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""
Write-Host "Server stopped. Thanks for using Patient Tracker!" -ForegroundColor Green
