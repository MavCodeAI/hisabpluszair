# Contributing to HisaabPlus

Thank you for your interest in contributing to HisaabPlus! This document provides guidelines and information to help you contribute effectively.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/MavCodeAI/hisabpluszair.git
   cd hisabpluszair
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Development Guidelines

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting (use `flutter format .`)
- Follow Material Design 3 guidelines

### Adding Features
1. Create a new branch for your feature: `git checkout -b feature/your-feature-name`
2. Implement your changes
3. Write tests if applicable
4. Test thoroughly on both Android and iOS if possible
5. Verify all existing features work as expected
6. Commit your changes with a descriptive message
7. Push to your fork and submit a pull request

### Testing
- Run tests before submitting: `flutter test`
- Test on both Android and iOS if possible
- Verify all features work as expected
- Check that the Hybrid AI system functions properly
- Ensure PDF generation works correctly

## Project Structure

```
lib/
├── main.dart              # App entry point
├── config/                # Configuration files
│   └── api_keys.dart      # API keys configuration
├── models/                # Data models
├── providers/             # State management (Provider)
├── screens/               # UI screens
│   ├── home_screen.dart   # Main dashboard
│   ├── invoice/           # Invoice management
│   ├── inventory/         # Product management
│   ├── expense/           # Expense tracking
│   ├── reports/           # Analytics and reports
│   ├── chatbot/           # AI assistant
│   └── settings/          # App settings
├── services/              # Business logic
│   ├── ai_chatbot_service.dart  # Online AI integration
│   ├── offline_ai_service.dart  # Offline AI system
│   └── pdf_service.dart   # PDF generation
└── utils/                 # Helper utilities
```

## Key Components

### Hybrid AI System
The AI assistant has two components:
1. **Offline AI** (`lib/services/offline_ai_service.dart`) - 700+ pre-built responses
2. **Online AI** (`lib/services/ai_chatbot_service.dart`) - Integration with 6 APIs

### Database
- Uses SQLite with sqflite package
- Database helper in `lib/utils/database_helper.dart`
- Models in `lib/models/` directory

### State Management
- Uses Provider package for state management
- Providers in `lib/providers/` directory

## Reporting Issues

When reporting issues, please include:
1. A clear description of the problem
2. Steps to reproduce
3. Expected vs actual behavior
4. Screenshots if applicable
5. Device/emulator information
6. Flutter version

## Feature Requests

We welcome feature requests! Please:
1. Check if the feature already exists or is planned
2. Provide a clear description of the proposed feature
3. Explain how it would benefit users
4. If possible, suggest implementation approaches

## Code of Conduct

Please be respectful and professional in all interactions. We're building something valuable for Pakistani businesses together.

## Questions?

Feel free to open an issue for any questions or suggestions!

---

**Thank you for contributing to HisaabPlus!** 🙏