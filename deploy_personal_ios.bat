@echo off
setlocal enabledelayedexpansion
echo.
echo 📱 Personal iPhone App Deployment
echo =================================
echo.
echo This will prepare your Patient Tracker app for personal iPhone installation
echo.

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo ❌ Please run this script from your Flutter project directory
    pause
    exit /b 1
)

echo ✅ Found Patient Tracker Flutter project
echo.

echo 📱 Choose Your Personal Deployment Option:
echo.
echo 1. FREE Option (~$15 total)
echo    - Uses your regular Apple ID (no developer account needed)
echo    - App expires after 7 days, easy to renew
echo    - Perfect for testing and personal use
echo.
echo 2. PAID Option (~$115 total)
echo    - Requires Apple Developer Account ($99/year)
echo    - Apps last 1 year, more stable  
echo    - Better for long-term personal use
echo.

set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" (
    set "deploymentType=FREE"
    set "appleAccount=Regular Apple ID"
    set "duration=7 days (renewable)"
    set "cost=~$15 total"
) else if "%choice%"=="2" (
    set "deploymentType=PAID"
    set "appleAccount=Apple Developer Account ($99/year)"
    set "duration=1 year"
    set "cost=~$115 total"
) else (
    echo ❌ Invalid choice. Please run the script again.
    pause
    exit /b 1
)

echo.
echo 📋 Your Selected Configuration:
echo Deployment Type: !deploymentType!
echo Apple Account: !appleAccount!
echo App Duration: !duration!
echo Total Cost: !cost!
echo.

echo 📝 Personal iOS Deployment Checklist:
echo.

echo Phase 1: Prerequisites
if "!deploymentType!"=="FREE" (
    echo   ✅ Use your regular Apple ID (the one for your iPhone)
    echo      - No developer account signup needed
    echo      - Completely free!
) else (
    echo   🔲 Sign up for Apple Developer Program
    echo      - Go to developer.apple.com
    echo      - Cost: $99/year
)
echo   🔲 Create free GitHub account (if you don't have one)
echo      - Go to github.com
echo.

echo Phase 2: Upload Your Code
echo   🔲 Run: setup_github.ps1
echo      - This script will set up everything automatically
echo.

echo Phase 3: Build iOS App
echo   🔲 Create GitHub Codespace with macOS
echo      - Use your uploaded repository
echo      - Choose macOS environment (important!)
echo   🔲 Install Xcode and Flutter in Codespace
echo      - Automated setup scripts available
echo.

echo Phase 4: Install on iPhone
echo   🔲 Connect iPhone to Mac (wirelessly or USB)
echo   🔲 Open Xcode and click 'Run'
echo   🔲 App installs directly on your iPhone!
echo.

if "!deploymentType!"=="FREE" (
    echo Phase 5: Weekly Renewal (7-day apps)
    echo   🔲 Reconnect iPhone to Codespace weekly
    echo   🔲 Click 'Run' in Xcode (30 seconds)
    echo   🔲 App refreshed for another 7 days
    echo.
)

echo 🎯 Your Next Steps:
echo.
echo STEP 1: Set up prerequisites
if "!deploymentType!"=="FREE" (
    echo         ✅ You already have everything needed (your Apple ID)
) else (
    echo         - Sign up for Apple Developer Program at developer.apple.com
)
echo         - Create GitHub account at github.com (if needed)
echo.

echo STEP 2: Upload your code
echo         - Run: powershell -ExecutionPolicy Bypass -File setup_github.ps1
echo         - Follow the prompts to create repository
echo.

echo STEP 3: Follow detailed guide
echo         - Read: PERSONAL_IOS_DEPLOYMENT.md
echo         - Contains step-by-step instructions
echo.

REM Create summary file
echo # Personal iOS Deployment Summary > PERSONAL_DEPLOYMENT_SUMMARY.txt
echo. >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo ## Your Configuration: >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - Deployment Type: !deploymentType! >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - Apple Account: !appleAccount! >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - App Duration: !duration! >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - Total Cost: !cost! >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo. >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo ## What You Get: >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Native iPhone app (not web browser) >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Home screen icon "Patient Tracker" >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Full functionality (patients, progress, assessment scales) >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Camera integration for patient photos >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Local data storage (HIPAA-friendly) >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Professional appearance >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo - ✅ Completely private (no App Store) >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo. >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo ## Next Steps: >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo 1. Run: setup_github.ps1 >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo 2. Create GitHub Codespace with macOS >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo 3. Build and install on iPhone >> PERSONAL_DEPLOYMENT_SUMMARY.txt
echo 4. Enjoy your personal medical app! >> PERSONAL_DEPLOYMENT_SUMMARY.txt

echo 📄 Created: PERSONAL_DEPLOYMENT_SUMMARY.txt
echo.

echo 🎊 Ready to Deploy Your Personal iPhone App!
echo.
echo Your Patient Tracker app will run natively on your iPhone with:
echo   ✅ Full medical app functionality
echo   ✅ Private local data storage
echo   ✅ Professional iOS interface
echo   ✅ Camera and photo integration
echo   ✅ No App Store complexity
echo.

if "!deploymentType!"=="FREE" (
    echo 💡 Pro Tip: Try the free option first. If you like it and want
    echo    longer-lasting apps, you can always upgrade to paid later!
    echo.
)

echo Ready to start? Run: powershell -ExecutionPolicy Bypass -File setup_github.ps1
echo.

pause
