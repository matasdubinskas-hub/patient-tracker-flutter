# 📱 Run Patient Tracker Locally on iPhone from Windows

## 🎯 **Local Development Server Method**

You can run your Flutter web app locally and access it from your iPhone over your local network!

---

## 🚀 **Method 1: Flutter Web Development Server**

### **Step 1: Start Local Development Server**
```powershell
# In your project directory (C:\Users\Matas\patient_tracker_flutter):
C:\flutter\bin\flutter.bat run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

### **Step 2: Find Your Windows IP Address**
```powershell
# Get your local IP address:
ipconfig | findstr "IPv4"
# Look for something like: IPv4 Address . . . . . . . . . : 192.168.1.100
```

### **Step 3: Access from iPhone**
1. **Make sure iPhone and Windows are on same WiFi network**
2. **Open Safari on iPhone**
3. **Go to**: `http://[YOUR-IP-ADDRESS]:8080`
   - Example: `http://192.168.1.100:8080`
4. **Your Patient Tracker app loads on iPhone!**

---

## ⚡ **Method 2: Simple HTTP Server (Even Easier)**

### **Step 1: Build Web Version**
```powershell
# Build the production web version:
C:\flutter\bin\flutter.bat build web --release
```

### **Step 2: Serve Built Files**

**Option A: Using Python (if installed):**
```powershell
# Navigate to build directory:
cd build\web

# Start simple HTTP server:
python -m http.server 8080 --bind 0.0.0.0
```

**Option B: Using Node.js http-server (if Node.js installed):**
```powershell
# Install http-server globally:
npm install -g http-server

# Navigate to build directory:
cd build\web

# Start server:
http-server -p 8080 -a 0.0.0.0
```

**Option C: Using PowerShell Simple Server:**
```powershell
# I'll create a simple PowerShell server script for you
```

### **Step 3: Access from iPhone**
Same as Method 1 - go to `http://[YOUR-IP]:8080` on iPhone Safari

---

## 🛠️ **Let Me Create a Launch Script for You**

I'll make this super easy with a one-click solution:

### **Option 1: Development Server Script**
```powershell
# This will start Flutter development server accessible from iPhone
```

### **Option 2: Production Build + Local Server**
```powershell
# This will build and serve the production version
```

---

## 🌐 **Testing Steps:**

1. **Start the server** (using one of the methods above)
2. **Check Windows Firewall** - may need to allow the port
3. **Connect iPhone to same WiFi**
4. **Open Safari on iPhone**
5. **Navigate to your Windows IP + port**
6. **Add to Home Screen** for app-like experience

---

## 🔧 **Troubleshooting:**

### **Can't Access from iPhone?**
1. **Check Windows Firewall**:
   ```powershell
   # Allow port through firewall:
   netsh advfirewall firewall add rule name="Flutter Dev Server" dir=in action=allow protocol=TCP localport=8080
   ```

2. **Verify Same Network**: iPhone and Windows on same WiFi
3. **Try Different IP**: Use `ipconfig` to find correct IP address

### **App Not Loading Properly?**
1. **Clear iPhone Safari cache**
2. **Try incognito/private browsing**
3. **Check browser developer tools** (Safari → Settings → Advanced → Web Inspector)

---

## ⚡ **IMMEDIATE SOLUTION: Let's Do This Now!**

Would you like me to:

1. **Create a launch script** that automatically:
   - Finds your IP address
   - Starts the server
   - Shows you the exact URL for your iPhone

2. **Start with Method 1** (development server) for instant testing?

3. **Set up Method 2** (production build) for better performance?

Just let me know, and I'll create the exact commands you need to run!

**This way you can:**
- ✅ Test immediately on your iPhone
- ✅ No internet hosting required  
- ✅ Full app functionality with data persistence
- ✅ Fast development iteration
- ✅ Works over your local WiFi network

Which method would you prefer to start with?
