@echo off
REM 🚀 HisaabPlus Android Studio Quick Setup Script (Windows)
REM Double-click this file to run setup

echo 🚀 HisaabPlus Android Studio Setup Starting...
echo ================================================

REM Check if Flutter is installed
echo 📱 Checking Flutter installation...
flutter doctor
if %errorlevel% neq 0 (
    echo ❌ Flutter not found!
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter found!

REM Check if we're in the right directory
if exist pubspec.yaml (
    echo ✅ Flutter project detected!
) else (
    echo ❌ Not a Flutter project directory!
    echo Please run this script in your hybrid_app folder
    pause
    exit /b 1
)

REM Clean and get dependencies
echo 🧹 Cleaning project...
flutter clean

echo 📦 Getting dependencies...
flutter pub get

REM Check for connected devices
echo 📱 Checking for devices...
flutter devices

REM Check Android setup
echo 🤖 Checking Android setup...
flutter doctor --android-licenses

echo.
echo 🎉 Setup Complete!
echo ================================================
echo 📋 Next Steps:
echo 1. Open Android Studio
echo 2. File → Open → Select this project folder
echo 3. Wait for indexing to complete
echo 4. Select your device/emulator
echo 5. Click the green play button
echo.
echo 🚀 Happy Coding with HisaabPlus!
echo.
pause