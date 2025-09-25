# HisaabPlus v3.0 - Hybrid AI Business Management App

A professional Flutter-based accounting and billing application with **Hybrid AI Assistant** and **PDF generation** for Pakistani businesses.

## 🌟 Key Features

🧠 **Hybrid AI Assistant** - 700+ offline topics + 6 online APIs  
📄 **PDF Reports** - Professional invoices and reports  
🇵🇰 **Pakistani Optimized** - Sales Tax 17%, PKR currency  
🗣️ **Bilingual** - Urdu + English support  
📱 **Mobile Ready** - Responsive design  
💾 **Offline First** - Works without internet  
🌐 **Online Backup** - Enhanced with 6 free APIs  

## Core Features

### 📊 Dashboard
- Business overview with key metrics
- Sales, expenses, and profit tracking
- Interactive charts and analytics
- Quick action buttons

### 🧾 Invoice Management
- Create professional invoices with automatic numbering
- Customer management with CNIC support
- Sales Tax calculations (17% for Pakistan)
- PDF generation and sharing via WhatsApp
- Payment tracking and reminders

### 📦 Inventory Control
- Product catalog with categories
- Stock tracking with low stock alerts
- Purchase and sale price management
- Barcode scanning support

### 💰 Expense Tracking
- Business expense recording
- Category-wise organization
- Receipt attachments
- Payment method tracking

### 📈 Reports & Analytics
- Sales and profit reports
- Sales Tax compliance reports
- Visual charts and trends
- PDF export for all reports

### 🤖 Hybrid AI Assistant (HisaabBot)
- **Offline AI**: 700+ pre-built responses for instant help
- **Online AI**: 6 free API integrations for complex queries
- Pakistani business context understanding
- Urdu and English support
- Smart fallback system
- Quick action suggestions

### 👥 Customer Management
- Complete customer profiles
- Outstanding payment tracking
- Credit limit management
- Payment history

### 🏢 Supplier Management
- Supplier database
- Purchase order tracking
- Payment terms management

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Database**: SQLite (sqflite)
- **Charts**: FL Chart
- **UI Design**: Material Design 3
- **PDF Generation**: pdf, printing packages
- **AI Integration**: Hybrid offline + online system
- **Platform**: Android, iOS, Web

## Quick Start

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MavCodeAI/hisabpluszair.git
   cd hisabpluszair
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Hybrid AI System

HisaabPlus features a unique **Hybrid AI Assistant** that works both offline and online:

### Offline Mode (Always Available)
- 700+ pre-built responses covering business topics
- No internet required
- Instant responses (0.1-0.5 seconds)
- Complete privacy (data never leaves device)

### Online Mode (Enhanced Capabilities)
6 free API integrations with fallback mechanism:
1. **Groq** - Fastest responses (Llama 3.1 70B)
2. **OpenRouter** - Multiple free models (DeepSeek R1)
3. **Google AI** - High quality (Gemini Pro)
4. **DeepSeek** - Advanced reasoning
5. **Mistral** - European AI model
6. **HuggingFace** - Community models

### How It Works
1. User asks a question
2. Offline AI responds immediately (80%+ of queries)
3. If needed, online APIs provide enhanced responses
4. Smart fallback ensures answer is always provided

## Project Structure

```
lib/
├── main.dart              # App entry point
├── config/                # Configuration files
│   └── api_keys.dart      # API keys configuration
├── models/                # Data models
│   ├── invoice.dart
│   ├── product.dart
│   ├── expense.dart
│   └── customer.dart
├── providers/             # State management
├── screens/               # UI screens
│   ├── home_screen.dart
│   ├── invoice/
│   ├── inventory/
│   ├── expense/
│   ├── reports/
│   ├── chatbot/
│   └── settings/
├── services/              # Business logic
│   ├── ai_chatbot_service.dart
│   ├── offline_ai_service.dart
│   └── pdf_service.dart
└── utils/                 # Helper utilities
```

## Features Status

- ✅ Dashboard with analytics
- ✅ Invoice creation and management
- ✅ Customer management
- ✅ Product/Inventory management
- ✅ Expense tracking
- ✅ Reports and charts
- ✅ Settings and configuration
- ✅ Hybrid AI chatbot assistant
- ✅ PDF generation
- ✅ Pakistani business optimization
- ✅ Urdu + English support
- ✅ Barcode scanning
- ✅ Supplier management
- ✅ Purchase orders
- ✅ Stock movements

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this project helpful, please give it a ⭐ on GitHub!

---

**HisaabPlus v3.0** - Professional Pakistani business management solution with Hybrid AI