#!/bin/bash

# Patient Tracker iOS - GitHub Setup Script
# Run this script to quickly set up your iOS project on GitHub

echo "🚀 Setting up Patient Tracker iOS on GitHub..."

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📝 Initializing Git repository..."
    git init
else
    echo "✅ Git repository already exists"
fi

# Add iOS native files
echo "📱 Adding iOS native files..."
git add ios_native/
git add setup_ios_github.sh
git add COMPLETE_iOS_BUILD_GUIDE.md

# Create .gitignore for iOS
echo "📋 Creating .gitignore..."
cat > .gitignore << 'EOF'
# iOS
*.xcworkspace/xcuserdata/
*.xcodeproj/xcuserdata/
*.xcodeproj/project.xcworkspace/xcuserdata/
build/
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Xcode
xcuserdata/
*.xcscmblueprint
*.xccheckout

# CocoaPods
Pods/

# Carthage
Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
iOSInjectionProject/

# Provisioning profiles
*.mobileprovision
*.cer
*.p12

# macOS
.DS_Store
EOF

git add .gitignore

# Commit changes
echo "💾 Committing changes..."
git commit -m "Convert Flutter Patient Tracker to native iOS app

Features:
- Complete Swift/UIKit implementation
- Core Data for patient management
- Professional iOS UI design
- Dashboard, Registration, Patient Library screens
- Search, CRUD operations, validation
- 9 physiotherapy assessment scales

Ready for Xcode build and App Store deployment!"

echo ""
echo "✅ Git setup complete!"
echo ""
echo "🔗 Next steps:"
echo "1. Create a repository on GitHub.com"
echo "2. Copy the remote URL"
echo "3. Run: git remote add origin YOUR_GITHUB_URL"
echo "4. Run: git push -u origin main"
echo ""
echo "🎯 Then follow the COMPLETE_iOS_BUILD_GUIDE.md for building!"
echo ""
echo "🚀 Your native iOS Patient Tracker is ready to deploy!"
