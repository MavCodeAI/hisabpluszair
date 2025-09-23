# 🚀 HisaabPlus - Android Studio Setup Guide

## 📱 Complete Setup for Android Studio

### **Prerequisites:**
- ✅ Android Studio installed
- ✅ Flutter SDK installed  
- ✅ Android SDK installed
- ✅ USB debugging enabled on phone

---

## 🔧 **Step-by-Step Setup:**

### **1. Extract Project**
```bash
# Extract the zip file
unzip HisaabPlus_v3_API_KEYS_INTEGRATED.zip
cd hybrid_app
```

### **2. Open in Android Studio**
1. **File → Open**
2. Navigate to `hybrid_app` folder
3. Click **OK**
4. Wait for indexing to complete

### **3. Flutter Doctor Check**
Open terminal in Android Studio:
```bash
flutter doctor
```

**Expected Output:**
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2023.x)
[✓] Connected device (1 available)
```

### **4. Install Dependencies**
```bash
flutter pub get
```

### **5. Configure Android Settings**
File: `android/app/build.gradle`
```gradle
android {
    compileSdkVersion 34
    targetSdkVersion 34
    minSdkVersion 21
}
```

### **6. Setup Device/Emulator**

#### **Physical Device:**
- Enable Developer Options
- Enable USB Debugging  
- Connect via USB
- Trust computer when prompted

#### **Emulator:**
- Tools → AVD Manager
- Create Virtual Device
- Choose Pixel 6 (API 34)
- Download system image if needed

### **7. Run App**
```bash
flutter run
# Or click the green play button in Android Studio
```

---

## 🎯 **Android Studio Specific Features:**

### **🔍 Debugging:**
```bash
# Set breakpoints in code
# Use Debug mode (Debug button)
flutter run --debug
```

### **🚀 Performance:**
```bash
# Profile mode for performance testing
flutter run --profile
```

### **📦 Build APK:**
```bash
# Release APK for distribution
flutter build apk --release
```

### **📱 App Bundle (Google Play):**
```bash
# For Google Play Store
flutter build appbundle --release
```

---

## 🛠️ **Android Studio Tools:**

### **1. Flutter Inspector**
- View → Tool Windows → Flutter Inspector
- Real-time widget tree visualization
- Layout debugging

### **2. Flutter Outline**
- View → Tool Windows → Flutter Outline  
- Quick navigation between widgets
- Code structure overview

### **3. Dart DevTools**
- Run → Flutter → Open DevTools
- Performance monitoring
- Memory analysis

### **4. Hot Reload**
- **Ctrl+S** (Windows) or **Cmd+S** (Mac)
- Instant code changes without restart
- Preserves app state

---

## 📱 **Build & Distribution:**

### **Debug APK (Testing):**
```bash
flutter build apk --debug
# Location: build/app/outputs/flutter-apk/app-debug.apk
```

### **Release APK (Distribution):**
```bash
flutter build apk --release --shrink
# Location: build/app/outputs/flutter-apk/app-release.apk
```

### **App Bundle (Play Store):**
```bash
flutter build appbundle --release
# Location: build/app/outputs/bundle/release/app-release.aab
```

---

## 🔧 **Common Android Studio Commands:**

### **Project Management:**
```bash
flutter clean           # Clean build files
flutter pub get         # Get dependencies  
flutter pub upgrade     # Update dependencies
flutter analyze         # Code analysis
```

### **Device Management:**
```bash
flutter devices         # List connected devices
flutter emulators       # List available emulators
adb devices            # Check ADB connection
```

### **Build Variants:**
```bash
flutter run --debug     # Debug mode
flutter run --profile   # Profile mode  
flutter run --release   # Release mode
```

---

## 🎯 **HisaabPlus Specific Features:**

### **🤖 AI Testing:**
1. Run app on device
2. Open **HisaabBot** section
3. Test queries:
   - "Invoice کیسے بنائیں?"
   - "GST rate in Pakistan"
   - "Business plan kaise banaye?"

### **📄 PDF Testing:**
1. Go to **Reports** section
2. Generate different reports:
   - Invoice PDF
   - Sales Report
   - Tax Report

### **💾 Database Testing:**
1. Add customers, products, expenses
2. Create invoices
3. Check data persistence

---

## 🚀 **Performance Optimization:**

### **Android Studio Settings:**
```
File → Settings → Build → Gradle:
- Use Gradle daemon ✓
- Configure on demand ✓
- Parallel builds ✓
```

### **Flutter Performance:**
```bash
# Enable web rendering for better performance
flutter config --enable-web

# Clear cache if needed
flutter clean
flutter pub cache repair
```

---

## 🔍 **Troubleshooting:**

### **❌ Gradle Build Failed:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### **❌ Plugin Issues:**
```bash
flutter pub deps
flutter pub cache repair
flutter clean
flutter pub get
```

### **❌ Device Not Detected:**
```bash
adb kill-server
adb start-server
adb devices
```

### **❌ Flutter Doctor Issues:**
```bash
flutter doctor --android-licenses
flutter config --android-sdk /path/to/android/sdk
```

---

## 🎉 **Success Checklist:**

- ✅ Android Studio opens project without errors
- ✅ Flutter doctor shows all green checkmarks  
- ✅ Device/emulator appears in device list
- ✅ App runs successfully with `flutter run`
- ✅ Hot reload works with code changes
- ✅ AI features respond correctly
- ✅ PDF generation works
- ✅ APK builds successfully

---

**🚀 Ready for Android Studio Development!**
**Complete Flutter + Android Studio integration for HisaabPlus v3.0**