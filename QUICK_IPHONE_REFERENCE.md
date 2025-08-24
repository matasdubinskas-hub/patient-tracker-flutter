# 📱 QUICK REFERENCE - Run on Your iPhone

## 🎯 **Super Quick Steps (Personal Use Only)**

### **Cost: ~$5-10 total (vs $119+ for App Store)**
### **Time: 1-2 days (vs weeks for App Store)**

---

## ⚡ **5-Step Process**

### **1. GitHub Setup (5 minutes)**
```bash
bash setup_ios_github.sh
# Follow prompts to push to GitHub
```

### **2. Codespace (10 minutes)**
- GitHub.com → Your repo → Code → Codespaces → Create
- **Choose macOS machine!**

### **3. Install Xcode (60 minutes - automated)**
```bash
# In Codespace terminal
xcode-select --install
brew install mas
mas install 497799835
```

### **4. Create Project (15 minutes)**
- Xcode → New Project → iOS App
- Bundle ID: `com.yourname.patienttracker`
- Team: Your Apple ID (FREE)
- Copy files from `ios_native/PatientTracker/`

### **5. Install on iPhone (5 minutes)**
- Connect iPhone via USB
- Xcode → Select iPhone → Click Play ▶️
- Trust developer on iPhone settings

---

## 🔧 **Key Settings**

### **Xcode Project Setup:**
```
Product Name: Patient Tracker
Bundle ID: com.yourname.patienttracker (unique!)
Team: Personal Team (FREE Apple ID)
Language: Swift
Use Core Data: ✅ YES
Automatically manage signing: ✅ YES
```

### **iPhone Settings:**
```
Settings → Privacy & Security → Developer Mode → ON
Settings → General → VPN & Device Management → Trust your Apple ID
```

---

## ⏰ **Maintenance (Every 7 Days)**

### **Weekly Renewal (2 minutes):**
1. Connect iPhone to Mac/Codespace
2. Open Xcode project
3. Click Play button ▶️
4. App reinstalls with fresh certificate

**Set iPhone reminder: "Renew Patient Tracker app"** 📅

---

## 🆘 **Common Issues & Quick Fixes**

| Issue | Quick Fix |
|-------|-----------|
| "Untrusted Developer" | iPhone Settings → Trust your Apple ID |
| "Failed to code sign" | Change Bundle ID to be unique |
| "Device not found" | Check USB cable, trust computer |
| App won't launch | Check Xcode console for errors |
| Core Data errors | Ensure .xcdatamodeld file is in project |

---

## 💡 **Pro Tips**

- **Use GitHub Codespaces** - cheapest Mac option
- **Set weekly reminder** - for 7-day renewals
- **Keep Xcode project saved** - for easy renewals
- **USB cable required** - for iPhone connection
- **FREE Apple ID works** - no $99 developer account needed

---

## 🚀 **What You Get**

✅ **Native iOS app** on your iPhone  
✅ **All Flutter features** converted to Swift  
✅ **Professional iOS design** with Core Data  
✅ **Perfect for personal use** - physiotherapy practice  
✅ **Cost effective** - under $10 vs $119+  

❌ **Cannot share** with others (personal certificates only)  
❌ **7-day expiry** - needs weekly renewal  

---

## 📞 **Emergency Quick Start**

**If you just want to get started RIGHT NOW:**

1. Run: `bash setup_ios_github.sh`
2. Push to GitHub
3. Create macOS Codespace
4. Install Xcode: `mas install 497799835`
5. Follow Xcode project setup above

**Your Patient Tracker will be running on your iPhone this weekend!** 🎉

---

**📋 All your Swift code is ready in `ios_native/PatientTracker/` - just needs to be built!**
