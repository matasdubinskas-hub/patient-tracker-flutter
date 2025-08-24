# Flutter Setup Guide for Windows

## 🚀 Quick Flutter Installation

### Step 1: Download Flutter SDK
1. Go to https://flutter.dev/docs/get-started/install/windows
2. Download the latest stable Flutter SDK (ZIP file)
3. Extract to `C:\flutter` (or your preferred location)

### Step 2: Add Flutter to PATH
1. Open **System Environment Variables**:
   - Press `Win + R`, type `sysdm.cpl`, press Enter
   - Click "Environment Variables" button
   - In "System Variables", find `Path`, click "Edit"
   - Click "New" and add: `C:\flutter\bin`
   - Click "OK" to save

2. **Restart your terminal/PowerShell**

### Step 3: Verify Installation
```powershell
flutter doctor
```

### Step 4: Fix Common Issues
If `flutter doctor` shows issues, run these commands:

```powershell
# Accept Android licenses (if you have Android Studio)
flutter doctor --android-licenses

# Install missing components
flutter doctor
```

## 📱 Alternative: Use Online IDE

If Flutter installation is complex, you can use **DartPad** or **CodePen** for testing:

### DartPad (Recommended)
1. Go to https://dartpad.dev
2. Copy the Flutter code from our app
3. Test the UI components online

### Replit (Full Flutter Environment)
1. Go to https://replit.com
2. Create new "Flutter" repl
3. Copy our entire project
4. Run instantly in browser

## 🏃‍♂️ Quick Start Commands

Once Flutter is installed:

```powershell
# Navigate to project
cd patient_tracker_flutter

# Get dependencies  
flutter pub get

# Run app (web version for testing)
flutter run -d chrome

# Run on connected device
flutter run
```

## 🔧 Troubleshooting "Gets Stuck" Issues

If Flutter gets stuck after "Got dependencies":

### Solution 1: Clear Flutter Cache
```powershell
flutter clean
flutter pub get
flutter pub deps
```

### Solution 2: Check Antivirus
- Add Flutter folder to antivirus exclusions
- Add project folder to exclusions

### Solution 3: Use Verbose Mode
```powershell
flutter run --verbose
```

### Solution 4: Try Web Version First
```powershell
flutter run -d chrome
```

## 🎯 Simplified Testing

To quickly test the Patient Tracker app without full Flutter setup:

### Option A: Web Demo
```powershell
flutter run -d chrome
```

### Option B: Android APK (if you have Android)
```powershell
flutter build apk
# Install the APK file on Android device
```

### Option C: Desktop App (Windows)
```powershell
flutter config --enable-windows-desktop
flutter run -d windows
```

## 📞 Need Help?

If you're still having issues:
1. Check Flutter version: `flutter --version`
2. Run with verbose output: `flutter run --verbose`
3. Check connected devices: `flutter devices`

The Patient Tracker app is ready to run as soon as Flutter is properly installed!
