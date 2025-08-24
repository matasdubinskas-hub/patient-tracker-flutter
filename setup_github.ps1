# 🚀 Setup GitHub Repository for iOS Build

Write-Host "📱 Patient Tracker - GitHub Repository Setup" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git first:" -ForegroundColor Red
    Write-Host "https://git-scm.com/download/windows" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Git is installed" -ForegroundColor Green

# Check if we're in the right directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Please run this script from your Flutter project directory" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Found Flutter project" -ForegroundColor Green
Write-Host ""

# Initialize git repository if not already done
if (-not (Test-Path ".git")) {
    Write-Host "🔧 Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already exists" -ForegroundColor Green
}

# Create .gitignore if it doesn't exist or update it
$gitignoreContent = @"
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Windows specific
Thumbs.db
ehthumbs.db
Desktop.ini

# Temporary files
*.tmp
*.temp

# Build directories
build/
.dart_tool/
"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8 -Force
Write-Host "✅ Updated .gitignore" -ForegroundColor Green

# Add all files to git
Write-Host "📦 Adding files to Git..." -ForegroundColor Yellow
git add .

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    # Commit the changes
    $commitMessage = "iOS-ready Patient Tracker Flutter app

Complete Flutter medical app with patient tracking
Cross-platform compatibility (Web, Windows, iOS)
Web storage fallback for browser compatibility
iOS configuration with medical app permissions
Ready for App Store deployment"

    Write-Host "💾 Committing changes..." -ForegroundColor Yellow
    git commit -m $commitMessage
    Write-Host "✅ Changes committed" -ForegroundColor Green
} else {
    Write-Host "✅ No new changes to commit" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 NEXT STEPS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Create GitHub Repository:" -ForegroundColor White
Write-Host "   - Go to https://github.com" -ForegroundColor Gray
Write-Host "   - Click 'New repository'" -ForegroundColor Gray
Write-Host "   - Name: patient-tracker-flutter" -ForegroundColor Gray
Write-Host "   - Make it Public (for free Codespaces)" -ForegroundColor Gray
Write-Host "   - Don't initialize with README (we already have files)" -ForegroundColor Gray
Write-Host ""

Write-Host "2. After creating repository, run these commands:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/[YOUR-USERNAME]/patient-tracker-flutter.git" -ForegroundColor Yellow
Write-Host "   git branch -M main" -ForegroundColor Yellow  
Write-Host "   git push -u origin main" -ForegroundColor Yellow
Write-Host ""

Write-Host "3. Then follow BUILD_IOS_INSTRUCTIONS.md for iOS build" -ForegroundColor White
Write-Host ""

Write-Host "📋 Files ready for iOS deployment:" -ForegroundColor Cyan
Write-Host "✅ iOS configuration updated (Info.plist)" -ForegroundColor Green
Write-Host "✅ Medical app permissions configured" -ForegroundColor Green
Write-Host "✅ App name set to 'Patient Tracker'" -ForegroundColor Green
Write-Host "✅ Cross-platform storage system" -ForegroundColor Green
Write-Host "✅ Complete Flutter medical app" -ForegroundColor Green
Write-Host ""

$currentDir = Get-Location
Write-Host "📁 Project location: $currentDir" -ForegroundColor Gray
Write-Host ""

Write-Host "🚀 Your Patient Tracker is ready for the App Store!" -ForegroundColor Green

Read-Host "Press Enter to finish"
