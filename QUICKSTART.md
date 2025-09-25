# Quick Start Guide - HisaabPlus v3.0

## Run Online (No Installation Required)

### Option 1: Project IDX (Recommended)
1. Go to [idx.dev](https://idx.dev)
2. Sign in with Google account
3. Click "Import from GitHub"
4. Enter repository URL: `https://github.com/MavCodeAI/hisabpluszair.git`
5. Select "Flutter" template
6. Wait for setup to complete
7. Run `flutter pub get` in terminal
8. Click "Run" to start web preview

### Option 2: FlutLab
1. Go to [flutlab.io](https://flutlab.io)
2. Create account and new project
3. Upload all project files
4. Click "Run" to build and test

### Option 3: Zapp.run
1. Go to [zapp.run](https://zapp.run)
2. Import project from GitHub
3. Instant preview available

## Local Development

### Prerequisites
- Flutter SDK 3.0+
- Android Studio or VS Code
- Git

### Steps
```bash
# Clone repository
git clone https://github.com/MavCodeAI/hisabpluszair.git
cd hisabpluszair

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Run on web
flutter run -d chrome
```

## Hybrid AI Assistant Setup (Optional)

HisaabPlus works 100% offline by default with 700+ pre-built responses. To enable enhanced online AI features:

1. Get free API keys from:
   - [Groq](https://console.groq.com/) - Fastest responses
   - [OpenRouter](https://openrouter.ai/) - Multiple free models
   - [Google AI](https://makersuite.google.com/app/apikey) - High quality
   - [DeepSeek](https://platform.deepseek.com/) - Advanced reasoning
   - [Mistral](https://console.mistral.ai/) - European model
   - [HuggingFace](https://huggingface.co/settings/tokens) - Community models

2. Update API keys in `lib/config/api_keys.dart`:
   ```dart
   static const String groqApiKey = 'your_actual_groq_key_here';
   static const String openRouterApiKey = 'your_actual_openrouter_key_here';
   // ... update other keys as needed
   ```

3. Rebuild the app:
   ```bash
   flutter build apk  # for Android
   # or
   flutter build ios  # for iOS
   ```

## Project Features

✅ **Dashboard**: Business overview with analytics  
✅ **Invoices**: Create and manage customer invoices  
✅ **Inventory**: Product management and stock tracking  
✅ **Expenses**: Track business expenses  
✅ **Reports**: Visual charts and analytics  
✅ **Customers**: Complete customer management  
✅ **Suppliers**: Supplier database and tracking  
✅ **Hybrid AI**: 700+ offline topics + 6 online APIs  
✅ **PDF Generation**: Professional invoice reports  
✅ **Bilingual**: Urdu and English support  
✅ **Offline First**: Works without internet  

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Database**: SQLite (sqflite)
- **Charts**: FL Chart
- **UI**: Material Design 3
- **PDF**: pdf, printing packages
- **AI**: Hybrid offline + online system

## Screenshots

Dashboard Screen:
![Dashboard](assets/images/dashboard.png)

Invoice Screen:
![Invoice](assets/images/invoice.png)

AI Assistant:
![AI Assistant](assets/images/ai_assistant.png)

*Note: Screenshots will be added after testing*

## Contributing

Feel free to open issues and pull requests!

---

**Happy Business Management!** 🚀