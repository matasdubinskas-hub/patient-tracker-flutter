# 📱 Personal iOS Deployment - Automated Script
# This script sets up everything for personal iPhone app deployment

Write-Host "🚀 Personal iPhone App Deployment" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""
Write-Host "This will prepare your Patient Tracker app for personal iPhone installation" -ForegroundColor Gray
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Please run this script from your Flutter project directory" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Found Patient Tracker Flutter project" -ForegroundColor Green
Write-Host ""

# Show deployment options
Write-Host "📱 Choose Your Personal Deployment Option:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. FREE Option (~$15 total)" -ForegroundColor White
Write-Host "   - Uses your regular Apple ID (no developer account needed)" -ForegroundColor Gray
Write-Host "   - App expires after 7 days, easy to renew" -ForegroundColor Gray
Write-Host "   - Perfect for testing and personal use" -ForegroundColor Gray
Write-Host ""
Write-Host "2. PAID Option (~`$115 total)" -ForegroundColor White  
Write-Host "   - Requires Apple Developer Account (`$99/year)" -ForegroundColor Gray
Write-Host "   - Apps last 1 year, more stable" -ForegroundColor Gray
Write-Host "   - Better for long-term personal use" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host 'Enter your choice (1 or 2)'

if ($choice -eq "1") {
    $deploymentType = "FREE"
    $appleAccount = "Regular Apple ID"
    $duration = "7 days (renewable)"
    $cost = "~$15 total"
} elseif ($choice -eq "2") {
    $deploymentType = "PAID" 
    $appleAccount = "Apple Developer Account (`$99/year)"
    $duration = "1 year"
    $cost = "~`$115 total"
} else {
    Write-Host "❌ Invalid choice. Please run the script again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "📋 Your Selected Configuration:" -ForegroundColor Cyan
Write-Host "Deployment Type: $deploymentType" -ForegroundColor Yellow
Write-Host "Apple Account: $appleAccount" -ForegroundColor Yellow  
Write-Host "App Duration: $duration" -ForegroundColor Yellow
Write-Host "Total Cost: $cost" -ForegroundColor Yellow
Write-Host ""

# Create deployment checklist
Write-Host "📝 Personal iOS Deployment Checklist:" -ForegroundColor Cyan
Write-Host ""

Write-Host "Phase 1: Prerequisites" -ForegroundColor White
if ($deploymentType -eq "FREE") {
    Write-Host "  ✅ Use your regular Apple ID (the one for your iPhone)" -ForegroundColor Green
    Write-Host "     - No developer account signup needed" -ForegroundColor Gray
    Write-Host "     - Completely free!" -ForegroundColor Gray
} else {
    Write-Host "  🔲 Sign up for Apple Developer Program" -ForegroundColor Yellow
    Write-Host "     - Go to developer.apple.com" -ForegroundColor Gray
    Write-Host "     - Cost: $99/year" -ForegroundColor Gray
}
Write-Host "  🔲 Create free GitHub account (if you don't have one)" -ForegroundColor Yellow
Write-Host "     - Go to github.com" -ForegroundColor Gray
Write-Host ""

Write-Host "Phase 2: Upload Your Code" -ForegroundColor White
Write-Host "  🔲 Run: .\setup_github.ps1" -ForegroundColor Yellow
Write-Host "     - This script will set up everything automatically" -ForegroundColor Gray
Write-Host ""

Write-Host "Phase 3: Build iOS App" -ForegroundColor White
Write-Host "  🔲 Create GitHub Codespace with macOS" -ForegroundColor Yellow
Write-Host "     - Use your uploaded repository" -ForegroundColor Gray
Write-Host "     - Choose macOS environment (important!)" -ForegroundColor Gray
Write-Host "  🔲 Install Xcode and Flutter in Codespace" -ForegroundColor Yellow
Write-Host "     - Automated setup scripts available" -ForegroundColor Gray
Write-Host ""

Write-Host "Phase 4: Install on iPhone" -ForegroundColor White
Write-Host "  🔲 Connect iPhone to Mac (wirelessly or USB)" -ForegroundColor Yellow
Write-Host "  🔲 Open Xcode and click 'Run'" -ForegroundColor Yellow
Write-Host "  🔲 App installs directly on your iPhone!" -ForegroundColor Yellow
Write-Host ""

if ($deploymentType -eq "FREE") {
    Write-Host "Phase 5: Weekly Renewal (7-day apps)" -ForegroundColor White
    Write-Host "  🔲 Reconnect iPhone to Codespace weekly" -ForegroundColor Yellow
    Write-Host "  🔲 Click 'Run' in Xcode (30 seconds)" -ForegroundColor Yellow
    Write-Host "  🔲 App refreshed for another 7 days" -ForegroundColor Yellow
    Write-Host ""
}

# Generate next steps
Write-Host "🎯 Your Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "STEP 1: Set up prerequisites" -ForegroundColor White
if ($deploymentType -eq "FREE") {
    Write-Host "        ✅ You already have everything needed (your Apple ID)" -ForegroundColor Green
} else {
    Write-Host "        - Sign up for Apple Developer Program at developer.apple.com" -ForegroundColor Gray
}
Write-Host "        - Create GitHub account at github.com (if needed)" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 2: Upload your code" -ForegroundColor White  
Write-Host "        - Run: .\setup_github.ps1" -ForegroundColor Yellow
Write-Host "        - Follow the prompts to create repository" -ForegroundColor Gray
Write-Host ""

Write-Host "STEP 3: Follow detailed guide" -ForegroundColor White
Write-Host "        - Read: PERSONAL_IOS_DEPLOYMENT.md" -ForegroundColor Yellow
Write-Host "        - Contains step-by-step instructions" -ForegroundColor Gray
Write-Host ""

# Create summary file for user
$summaryContent = @"
# Personal iOS Deployment Summary

## Your Configuration:
- Deployment Type: $deploymentType
- Apple Account: $appleAccount  
- App Duration: $duration
- Total Cost: $cost

## What You Get:
- ✅ Native iPhone app (not web browser)
- ✅ Home screen icon "Patient Tracker"
- ✅ Full functionality (patients, progress, assessment scales)
- ✅ Camera integration for patient photos
- ✅ Local data storage (HIPAA-friendly)
- ✅ Professional appearance
- ✅ Completely private (no App Store)

## Next Steps:
1. Run: .\setup_github.ps1
2. Create GitHub Codespace with macOS
3. Build and install on iPhone
4. Enjoy your personal medical app!

Generated: $(Get-Date)
"@

$summaryContent | Out-File -FilePath "PERSONAL_DEPLOYMENT_SUMMARY.txt" -Encoding UTF8 -Force

Write-Host "📄 Created: PERSONAL_DEPLOYMENT_SUMMARY.txt" -ForegroundColor Green
Write-Host ""

Write-Host "🎊 Ready to Deploy Your Personal iPhone App!" -ForegroundColor Green
Write-Host ""
Write-Host "Your Patient Tracker app will run natively on your iPhone with:" -ForegroundColor White
Write-Host "  ✅ Full medical app functionality" -ForegroundColor Green
Write-Host "  ✅ Private local data storage" -ForegroundColor Green
Write-Host "  ✅ Professional iOS interface" -ForegroundColor Green
Write-Host "  ✅ Camera and photo integration" -ForegroundColor Green
Write-Host "  ✅ No App Store complexity" -ForegroundColor Green
Write-Host ""

if ($deploymentType -eq "FREE") {
    Write-Host "💡 Pro Tip: Try the free option first. If you like it and want" -ForegroundColor Yellow
    Write-Host "   longer-lasting apps, you can always upgrade to paid later!" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Ready to start? Run: .\setup_github.ps1" -ForegroundColor Cyan

Read-Host "Press Enter to finish"
