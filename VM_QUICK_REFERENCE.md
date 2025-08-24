# 🖥️ VM macOS - Quick Reference Card

## ⚡ **Super Quick Steps for VM**

### **Prerequisites:**
- ✅ macOS VM running (you have this!)
- ✅ 8GB+ RAM allocated to VM
- ✅ 50GB+ free space in VM
- ✅ iPhone + USB cable

---

## 🚀 **5-Step Process**

### **1. Install Xcode in VM (60 minutes)**
```bash
# In macOS VM Terminal
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mas
mas install 497799835
```

### **2. Transfer Code to VM (5 minutes)**
```bash
# Option 1: Shared folder
cp -r /shared/ios_native ~/Desktop/PatientTracker

# Option 2: GitHub clone
git clone https://github.com/yourusername/patient-tracker-ios.git
```

### **3. Create Xcode Project (10 minutes)**
- Xcode → New Project → iOS App
- Bundle ID: `com.yourname.patienttracker`
- Team: Personal Team (FREE)
- Add your .swift files from `ios_native/PatientTracker/`

### **4. Connect iPhone to VM (2 minutes)**
```bash
# VMware: VM → Removable Devices → iPhone
# VirtualBox: Devices → USB → iPhone  
# Parallels: Actions → Configure → Hardware → USB
```

### **5. Build & Install (5 minutes)**
- Xcode → Select iPhone → Click Play ▶️
- Trust developer on iPhone settings

---

## 🔧 **VM-Specific Settings**

### **VMware Workstation:**
```
VM Settings → Hardware → USB Controller → USB 3.1
VM → Removable Devices → Apple iPhone → Connect
```

### **VirtualBox:**
```
Machine → Settings → USB → Enable USB 3.0 Controller
Install Extension Pack for USB 3.0 support
Devices → USB → Your iPhone Name
```

### **Parallels Desktop:**
```
Actions → Configure → Hardware → USB & Bluetooth
Set to "Connect to Mac" for iPhone
```

### **VM Resource Allocation:**
```
RAM: 8GB minimum (12GB+ recommended)
CPU: 2+ cores with virtualization enabled
Storage: 50GB+ free space
Graphics: Enable hardware acceleration
```

---

## 🆘 **Common VM Issues & Quick Fixes**

| Issue | Quick Fix |
|-------|-----------|
| iPhone not detected | Disconnect from Windows, connect to VM USB |
| Slow Xcode performance | Increase VM RAM to 12GB+, close Windows apps |
| Build fails | Clean build folder, check 50GB+ free space |
| USB keeps disconnecting | Use USB 3.0 port, high-quality cable |
| VM crashes during build | Allocate more CPU cores, enable VT-x/AMD-V |
| Xcode won't install | Check macOS version 12.0+, App Store signed in |

---

## 💡 **Performance Optimization**

### **VM Settings:**
```bash
# Allocate maximum safe resources:
RAM: 60-70% of your total system RAM
CPU: Half your physical cores
Storage: SSD if possible
Graphics: 3D acceleration enabled
```

### **Windows Host Optimization:**
```bash
# Before starting VM:
- Close unnecessary Windows applications
- Ensure antivirus excludes VM files
- Use Performance power plan
- Disable Windows search indexing on VM folder
```

---

## 🔄 **Weekly Renewal Process (2 minutes)**

### **Every Sunday:**
```bash
1. Start macOS VM
2. Connect iPhone to VM USB
3. Open Xcode project
4. Click Play button ▶️
5. App reinstalls automatically
```

**Set iPhone reminder: "Renew Patient Tracker - Sunday"** 📅

---

## 📱 **iPhone Connection Checklist**

### **Before Building:**
- ✅ iPhone connected to PC USB (not wireless)
- ✅ iPhone trusted computer
- ✅ USB forwarded to VM (not Windows)
- ✅ Developer Mode enabled on iPhone
- ✅ iPhone unlocked during build

### **After Build:**
- ✅ Trust developer certificate in iPhone Settings
- ✅ App appears on home screen
- ✅ Launches without errors

---

## 🎯 **What Makes This Perfect**

### **Advantages:**
✅ **$0 cost** - Using existing VM  
✅ **No internet needed** - All local  
✅ **Full control** - Your environment  
✅ **Fast builds** - No cloud latency  
✅ **Privacy** - Code stays on your machine  

### **Your iOS App Features:**
- 📊 Native iOS dashboard
- 👤 Patient registration with validation
- 📚 Patient library with search
- 📈 Progress tracking
- 🏥 Assessment scales
- 💾 Core Data database

---

## 🚀 **Emergency Quick Start**

**If something goes wrong, start fresh:**

1. **Reset Xcode project**: Delete and recreate
2. **Reset iPhone trust**: Settings → General → Reset → Reset Location & Privacy
3. **Restart VM**: Fresh USB connections
4. **Check resources**: Ensure 8GB+ RAM, 50GB+ storage

---

## 📋 **File Checklist**

**Make sure these files are in your Xcode project:**
- ✅ `AppDelegate.swift`
- ✅ `DashboardViewController.swift`
- ✅ `PatientRegistrationViewController.swift`
- ✅ `PatientLibraryViewController.swift`
- ✅ `Patient.swift` & `ProgressEntry.swift`
- ✅ `CoreDataManager.swift`
- ✅ `PatientTracker.xcdatamodeld`
- ✅ `Info.plist`

---

**🎉 Your VM setup is perfect for iOS development - $0 cost and full control!**
