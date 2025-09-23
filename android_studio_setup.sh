#!/bin/bash

# 🚀 HisaabPlus Android Studio Quick Setup Script
# Run this script in your project directory

echo "🚀 HisaabPlus Android Studio Setup Starting..."
echo "================================================"

# Check if Flutter is installed
echo "📱 Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter found!"
    flutter doctor
else
    echo "❌ Flutter not found!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if we're in the right directory
if [ -f "pubspec.yaml" ]; then
    echo "✅ Flutter project detected!"
else
    echo "❌ Not a Flutter project directory!"
    echo "Please run this script in your hybrid_app folder"
    exit 1
fi

# Clean and get dependencies
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

# Check for connected devices
echo "📱 Checking for devices..."
flutter devices

# Check Android setup
echo "🤖 Checking Android setup..."
flutter doctor --android-licenses

echo ""
echo "🎉 Setup Complete!"
echo "================================================"
echo "📋 Next Steps:"
echo "1. Open Android Studio"
echo "2. File → Open → Select this project folder"
echo "3. Wait for indexing to complete"
echo "4. Select your device/emulator"
echo "5. Click the green play button"
echo ""
echo "🚀 Happy Coding with HisaabPlus!"