# 📱 Run Patient Tracker on Your iPhone Locally - Simple Guide

## 🎯 **Goal: Get Your App Running on YOUR iPhone Only (No App Store)**

This is **much simpler and cheaper** than App Store deployment! You just need:
- A Mac (cloud or physical) 
- Your iPhone
- **FREE Apple ID** (no $99 developer account needed!)

---

## 💰 **Cost Breakdown - MUCH Cheaper!**

### **Personal Use Setup**:
- **FREE Apple ID**: $0 (just your regular Apple ID)
- **GitHub Codespaces**: ~$5-10 total for setup
- **Total**: ~$5-10 (vs $119+ for App Store)

### **No Apple Developer Account Needed!**
- ✅ FREE personal development signing
- ✅ 7-day app certificates (auto-renewable)
- ✅ Works perfectly for personal use
- ❌ Cannot distribute to others or App Store

---

## 🚀 **STEP 1: Set Up Mac Environment (Cheapest Option)**

### **GitHub Codespaces (Recommended)**

1. **Upload your code to GitHub**:
   ```bash
   # In PowerShell (Windows)
   cd C:\Users\Matas\patient_tracker_flutter
   
   # Run the setup script
   bash setup_ios_github.sh
   
   # Create GitHub repo and push
   # Follow the instructions from the script
   ```

2. **Create GitHub Codespace**:
   - Go to your GitHub repository
   - Click "Code" → "Codespaces" → "Create codespace on main"
   - Choose **macOS** machine type (important!)
   - Wait 5-10 minutes for setup

3. **Cost**: ~$0.18/hour (only pay when building)

---

## 🛠️ **STEP 2: Install Xcode (On Codespace/Mac)**

```bash
# In the Codespace terminal
# Install Xcode Command Line Tools
xcode-select --install

# Install Xcode from Mac App Store (takes 30-60 minutes)
# Or use mas (Mac App Store CLI)
brew install mas
mas install 497799835  # Xcode

# Accept Xcode license
sudo xcodebuild -license accept

# Verify installation
xcode-select -p
```

---

## 📱 **STEP 3: Create Xcode Project**

1. **Open Xcode**:
   ```bash
   open -a Xcode
   ```

2. **Create New Project**:
   - File → New → Project
   - Choose "iOS" → "App"
   - **Product Name**: `Patient Tracker`
   - **Bundle Identifier**: `com.yourname.patienttracker` (use your name)
   - **Team**: Select your Apple ID (FREE personal team)
   - **Language**: Swift
   - **Use Core Data**: ✅ Check this box

3. **Replace Generated Files**:
   - Delete the generated Swift files
   - Copy all files from `ios_native/PatientTracker/` into your Xcode project
   - Drag and drop the files into Xcode

---

## 🔧 **STEP 4: Configure for Personal Development**

### **Set Up FREE Personal Signing**:

1. **In Xcode Project Settings**:
   - Select your project in the navigator
   - Go to "Signing & Capabilities" tab
   - **Team**: Select your personal Apple ID team (should show "Personal Team")
   - **Check**: "Automatically manage signing"
   - **Bundle Identifier**: Make sure it's unique (e.g., `com.matas.patienttracker`)

2. **Xcode will automatically**:
   - Create free development certificates
   - Generate provisional profiles
   - Configure signing (no $99 needed!)

### **Important Note**: 
- Free accounts get 7-day certificates
- Apps need to be re-installed every 7 days
- Perfect for personal use!

---

## 📲 **STEP 5: Build and Install on Your iPhone**

### **Prepare Your iPhone**:
1. **Connect iPhone to Mac** (via USB cable)
2. **Enable Developer Mode**:
   - iPhone Settings → Privacy & Security → Developer Mode → ON
   - You may need to restart iPhone

3. **Trust Computer**:
   - When prompted on iPhone, tap "Trust This Computer"

### **Build and Install**:

1. **In Xcode**:
   - Select your iPhone from the device dropdown (top toolbar)
   - Click the **▶️ Play button**
   - Wait for build and installation (2-5 minutes)

2. **Trust Developer on iPhone**:
   - iPhone Settings → General → VPN & Device Management
   - Find your Apple ID under "Developer App"
   - Tap → "Trust [Your Apple ID]"

3. **Launch App**:
   - Find "Patient Tracker" on your iPhone home screen
   - Tap to launch - **IT WORKS!** 🎉

---

## 🔄 **STEP 6: Maintaining the App (Every 7 Days)**

### **Free Account Limitations**:
- Certificates expire every 7 days
- App will stop working after 7 days
- **Solution**: Simply rebuild and reinstall every week

### **Easy Renewal Process**:
```bash
# Every 7 days, just run:
# 1. Connect iPhone
# 2. Open Xcode project
# 3. Click Play button → App reinstalls with fresh certificate
```

### **Pro Tip**: Set a weekly reminder on your phone! 📅

---

## 🆘 **Troubleshooting Common Issues**

### **1. "Untrusted Developer"**
- **Solution**: iPhone Settings → General → VPN & Device Management → Trust your Apple ID

### **2. "Failed to code sign"**
- **Solution**: Make sure Bundle ID is unique (change `com.yourname.patienttracker` to your actual name)

### **3. "Device not found"**
- **Solution**: Check USB cable, trust computer on iPhone

### **4. "Core Data model not found"**
- **Solution**: Make sure `PatientTracker.xcdatamodeld` is added to Xcode project

### **5. App crashes on launch**
- **Solution**: Check Xcode console for error messages, usually Core Data or missing files

---

## 🚀 **ALTERNATIVE: Use Physical Mac (If You Have One)**

If you have access to a Mac computer:

1. **Skip Codespaces** - use your Mac directly
2. **Install Xcode** from Mac App Store (free)
3. **Follow Steps 3-6** above
4. **Cost**: $0 (just time)

---

## 🎯 **Summary - Your iOS App for $5-10!**

### **What You Get**:
- ✅ Your Patient Tracker running natively on iPhone
- ✅ All features: Dashboard, Registration, Patient Library
- ✅ Core Data database on your phone
- ✅ Professional iOS design and performance
- ✅ Perfect for personal physiotherapy practice

### **What You Don't Get** (vs App Store):
- ❌ Can't share with others
- ❌ No App Store distribution
- ❌ Needs renewal every 7 days
- ❌ Only works on your devices

### **Perfect For**:
- ✅ Personal use
- ✅ Testing and development
- ✅ Private practice use
- ✅ Learning iOS development
- ✅ Saving money vs App Store fees

---

## 📅 **Timeline**:
- **Today**: Set up GitHub and Codespace
- **Tomorrow**: Install Xcode and create project
- **This Weekend**: Your app running on your iPhone!
- **Weekly**: 5-minute renewal process

---

## 🚀 **Ready to Start?**

### **Immediate Next Steps**:
1. **Run the setup script**: `bash setup_ios_github.sh`
2. **Create GitHub repository** and upload your code
3. **Create Codespace** with macOS
4. **Follow this guide** step by step

**Your Flutter app will be running natively on your iPhone within 1-2 days for less than $10!** 🎉

### **Need Help?**
- All your Swift code is ready in `ios_native/PatientTracker/`
- Follow this guide step by step
- Each step is simple and well-documented

**This is MUCH easier than App Store deployment - let's get your iPhone app running!** 📱✨
