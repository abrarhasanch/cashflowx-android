# 💰 CashFlowX

A modern, cross-platform financial management application built with Flutter. Track cash flows, manage accounts, monitor loans, and generate detailed financial reports with ease.

![Flutter](https://img.shields.io/badge/Flutter-3.10.1-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-Private-red)

## ✨ Features

### 📊 Account Management
- Create and manage multiple accounts with different currencies
- Track cash in and cash out transactions
- Real-time balance calculations
- Multi-member account support with role-based access

### 💸 Transaction Tracking
- Add cash in/out entries with detailed information
- Filter transactions by status (paid/pending)
- Set due dates and payment reminders
- Mark transactions as paid with timestamp tracking
- Attach remarks, categories, and payment modes

### 👥 Contact & Loan Management
- Manage contacts associated with accounts
- Track loan positions (I Owe / They Owe)
- Real-time loan balance calculations
- Contact-specific transaction history

### 📈 Reports & Analytics
- Comprehensive dashboard with summary metrics
- Visual charts for income vs expense trends
- Account breakdown and analysis
- Category-wise transaction reports
- Custom date range filtering

### 📄 PDF Export
- Generate detailed financial reports
- Export account-specific or global reports
- Professional PDF formatting with tables and summaries
- Cross-platform support (Web & Mobile)

### 🎨 Modern UI/UX
- Light and Dark theme support
- Collapsible sidebar navigation
- Responsive design for all screen sizes
- Material 3 design system
- Smooth animations and transitions

### ⏰ Due Date Management
- Unified view of upcoming and overdue transactions
- Color-coded priority indicators
- Quick mark-as-paid functionality
- Account-grouped transaction lists

## 🏗️ Architecture

### Tech Stack
- **Framework:** Flutter 3.10.1
- **State Management:** Riverpod 2.5.1
- **Navigation:** GoRouter 14.2.0
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Charts:** FL Chart 0.69.0
- **PDF Generation:** pdf 3.11.0
- **Fonts:** Google Fonts (Inter)

### Project Structure
```
lib/
├── src/
│   ├── app.dart                    # App entry point
│   ├── auth/                       # Authentication
│   │   ├── controllers/
│   │   ├── repositories/
│   │   └── views/
│   ├── accounts/                   # Account management
│   │   ├── views/
│   │   └── tabs/
│   ├── transactions/               # Transaction handling
│   ├── contacts/                   # Contact management
│   ├── loans/                      # Loan tracking
│   ├── dashboard/                  # Dashboard & overview
│   ├── reports/                    # Analytics & reports
│   ├── settings/                   # App settings
│   ├── due_dates/                  # Due date manager
│   ├── models/                     # Data models
│   ├── providers/                  # Riverpod providers
│   ├── services/                   # Business logic
│   │   ├── firestore_service.dart
│   │   ├── pdf_service.dart
│   │   ├── pdf_service_web.dart   # Web-specific PDF
│   │   └── pdf_service_mobile.dart # Mobile-specific PDF
│   ├── theme/                      # Theme configuration
│   ├── routing/                    # Navigation routes
│   ├── widgets/                    # Reusable widgets
│   └── utils/                      # Utilities
└── main.dart
```

### Data Models
- **Account:** Multi-currency accounts with member management
- **Transaction:** Cash in/out entries with due dates
- **Contact:** Associated parties for transactions
- **Loan:** Loan tracking with net balance calculations
- **Member:** Account members with role-based permissions

### State Management Pattern
```dart
// Provider-based architecture
final accountsProvider = StreamProvider<List<Account>>(...);
final transactionsProvider = StreamProvider.family<List<Transaction>, String>(...);

// Controller pattern for mutations
final accountControllerProvider = StateNotifierProvider<AccountController, AsyncValue<void>>(...);
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK 3.10.1 or higher
- Firebase project setup
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/abrarhasanch/cashflowx-android.git
   cd cashflowx-android
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Enable Storage
   - Download and place configuration files:
     - `google-services.json` in `android/app/`
     - `GoogleService-Info.plist` in `ios/Runner/`
     - Update `lib/firebase_options.dart`

4. **Firestore Security Rules**
   ```bash
   firebase deploy --only firestore
   ```

5. **Run the app**
   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # iOS
   flutter run -d ios
   ```

## 🔧 Configuration

### Currency Settings
The app supports multiple currencies:
- BDT (Bangladesh Taka)
- USD (US Dollar)
- EUR (Euro)
- GBP (British Pound)
- INR (Indian Rupee)
- JPY (Japanese Yen)
- AUD (Australian Dollar)

Currency symbols are automatically displayed based on account settings.

### Theme Customization
Themes are defined in `lib/src/theme/app_theme.dart`:
- Dark theme (default)
- Light theme
- Custom color schemes
- Material 3 design tokens

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Web      | ✅     | Full support with responsive design |
| Android  | ✅     | Android 5.0+ (API 21+) |
| iOS      | ✅     | iOS 12.0+ |
| macOS    | ✅     | macOS 10.14+ |
| Linux    | ✅     | GTK 3.0+ |
| Windows  | ✅     | Windows 10+ |

## 🔒 Security

- Firebase Authentication with secure token management
- Firestore security rules for data protection
- User-scoped data access
- Role-based permissions for multi-member accounts

## 📦 Build & Deploy

### Build for Production

**Android APK**
```bash
flutter build apk --release
```

**Android App Bundle**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

### Firebase Deployment
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage

# Deploy all
firebase deploy
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## 🤝 Contributing

This is a private project. For collaboration inquiries, please contact the repository owner.

## 📄 License

This project is private and proprietary. All rights reserved.

## 👨‍💻 Developer

**Abrar Hasan**
- GitHub: [@abrarhasanch](https://github.com/abrarhasanch)

## 📞 Support

For issues, questions, or feature requests, please contact the development team.

## 🔄 Version History

### v1.0.0 (Current)
- ✅ Multi-account management
- ✅ Transaction tracking with due dates
- ✅ Loan position monitoring
- ✅ Dashboard with analytics
- ✅ PDF report generation
- ✅ Light/Dark theme support
- ✅ Collapsible sidebar navigation
- ✅ Cross-platform support (Web, Android, iOS)
- ✅ Firebase integration
- ✅ Due date manager
- ✅ Member management

---

Built with ❤️ using Flutter
