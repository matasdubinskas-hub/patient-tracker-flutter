# 📱 QUICK START: Run Patient Tracker on iPhone Locally

## ⚡ **Super Easy - 2 Options:**

### **🚀 Option 1: Double-Click Launch (Easiest)**
1. **Double-click**: `run_for_iphone.bat`
2. **Choose**: Development Server (option 1)
3. **Copy the IP address** shown (like `http://192.168.1.100:8080`)
4. **On iPhone**: Open Safari → Go to that address
5. **Done!** Your app loads on iPhone

### **🔧 Option 2: PowerShell (More Features)**
```powershell
# Right-click and "Run with PowerShell"
.\run_for_iphone.ps1
```

---

## 📱 **iPhone Setup Steps:**

### **1. Connect to Same WiFi**
- Make sure iPhone and Windows PC are on **same WiFi network**

### **2. Open the App**
- **iPhone Safari** → Go to the IP address shown (like `http://192.168.1.100:8080`)
- **Bookmark it** for easy access later

### **3. Make it Feel Like Native App**
- **Safari Share Button** → **"Add to Home Screen"**
- **Choose app name**: "Patient Tracker"
- **Now launches like any iPhone app!**

---

## 🎯 **What You'll Get:**

✅ **Full App Functionality**:
- Register new patients
- Browse patient library  
- Add progress entries
- Search and filter
- Configure assessment scales
- **Data persists** between sessions

✅ **Development Benefits**:
- **Hot reload**: Changes on Windows instantly appear on iPhone
- **Real-time testing**: Test on actual device immediately
- **No App Store needed**: Direct local testing
- **Fast iteration**: Develop and test simultaneously

---

## 🔧 **Troubleshooting:**

### **Can't access from iPhone?**
1. **Check WiFi**: Both devices same network
2. **Try different IP**: Run `ipconfig` in Command Prompt to verify IP
3. **Firewall**: Script should handle this automatically

### **App not loading properly?**
1. **Clear Safari cache**: Settings → Safari → Clear History and Website Data
2. **Try private browsing**: New private tab in Safari
3. **Check URL**: Make sure it's `http://` not `https://`

### **Need to stop the server?**
- **Press Ctrl+C** in the command window

---

## 🎊 **Ready to Go!**

Your Patient Tracker app can now run locally on your iPhone for development and testing. This gives you:

- ✅ **Immediate iPhone testing**
- ✅ **No external hosting required**  
- ✅ **Full app functionality**
- ✅ **Fast development workflow**

**Just double-click `run_for_iphone.bat` and follow the instructions!**

Later, when you're ready for App Store deployment, we can work on the native iOS build using a cloud Mac service. But for now, you have full iPhone access for development and testing! 🚀
