# 📱 Workifies - Enterprise Workforce Management Solution

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white" alt="Material Design" />
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</div>

## 🎯 Overview

**Workifies** is a comprehensive, modern workforce management solution designed to streamline company operations and enhance employee productivity. Built with Flutter for cross-platform compatibility, featuring an intuitive Material Design 3 interface optimized for both managers and employees.

### ✨ Key Highlights
- 🏢 **Complete Enterprise Solution** - Full-featured workforce management
- 📱 **Cross-Platform** - iOS, Android, and Web support
- 🎨 **Modern UI/UX** - Beautiful Material Design 3 interface
- ⚡ **High Performance** - Optimized Flutter architecture
- 🔒 **Secure & Scalable** - Enterprise-ready architecture

## 🚀 Features

### 👨‍💼 **Manager Dashboard**
- **📊 Real-time Analytics** - Company performance metrics and insights
- **👥 Employee Management** - Comprehensive team member profiles and management
- **📅 Attendance Tracking** - Advanced time tracking with visual reports
- **💬 Team Communication** - Built-in messaging system for seamless collaboration
- **⚙️ Company Settings** - Full company configuration and customization

### 👩‍💻 **Employee Dashboard**
- **🏠 Personal Dashboard** - Clean, intuitive home screen with quick actions
- **⏰ Time Tracking** - Easy clock-in/out with detailed hours visualization
- **📈 My Hours** - Comprehensive time reports (daily, weekly, monthly)
- **💬 Chat System** - Direct communication with managers and colleagues
- **👤 Profile Management** - Personal settings, achievements, and preferences

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="screenshots/landing.png" width="200" alt="Landing Screen"/></td>
      <td><img src="screenshots/manager-dashboard.png" width="200" alt="Manager Dashboard"/></td>
      <td><img src="screenshots/employee-dashboard.png" width="200" alt="Employee Dashboard"/></td>
      <td><img src="screenshots/attendance.png" width="200" alt="Attendance Tracking"/></td>
    </tr>
    <tr>
      <td align="center"><b>Landing Screen</b></td>
      <td align="center"><b>Manager Dashboard</b></td>
      <td align="center"><b>Employee Dashboard</b></td>
      <td align="center"><b>Attendance Tracking</b></td>
    </tr>
  </table>
</div>

## 🏗️ Technical Architecture

### **Tech Stack**
- **Frontend**: Flutter 3.x with Material Design 3
- **Language**: Dart 3.x
- **State Management**: StatefulWidget (Bloc/Cubit ready)
- **UI Components**: Custom Material 3 components
- **Typography**: Google Fonts (Inter)
- **Charts**: FL Chart for data visualization
- **Icons**: Material Icons + Custom icons

### **Project Structure**
```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # App-wide theming
├── features/
│   ├── auth/                       # Authentication flow
│   │   └── presentation/screens/
│   ├── dashboard/                  # Main dashboards
│   │   └── presentation/screens/
│   │       ├── manager/           # Manager-specific screens
│   │       └── employee/          # Employee-specific screens
│   ├── company/                   # Company management
│   │   └── presentation/screens/
│   └── employee/                  # Employee onboarding
│       └── presentation/screens/
└── shared/
    └── models/                    # Shared data models
```

## 🛠️ Installation & Setup

### **Prerequisites**
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Xcode (for iOS development on Mac)

### **Quick Start**
```bash
# Clone the repository
git clone https://github.com/yourusername/workifies.git

# Navigate to project directory
cd workifies

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### **Build for Production**
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac with Xcode)
flutter build ios --release

# Web
flutter build web --release
```

## 🎮 Demo & Testing

### **Demo Credentials**
- **Any email/password combination works** (mock authentication)
- **Manager Flow**: Select "I'm a Manager" → Sign In
- **Employee Flow**: Select "I'm an Employee" → Sign In

### **Features to Test**
1. **Authentication Flow** - Landing → Role Selection → Login/Register
2. **Manager Dashboard** - Analytics, Employee Management, Attendance, Chat, Settings
3. **Employee Dashboard** - Clock-in/out, Hours Tracking, Chat, Profile
4. **Navigation** - Bottom navigation, screen transitions
5. **Responsive Design** - Portrait/landscape modes

## 📋 Roadmap

### **Current Version (v1.0)** ✅
- [x] Complete UI/UX implementation
- [x] Authentication flow
- [x] Manager dashboard with all features
- [x] Employee dashboard with all features
- [x] Time tracking interface
- [x] Chat system UI
- [x] Settings and profile management

### **Next Version (v2.0)** 🔄
- [ ] Firebase backend integration
- [ ] Real-time data synchronization
- [ ] Push notifications
- [ ] Offline functionality
- [ ] Advanced analytics

### **Future Versions** 📋
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Admin web portal
- [ ] API integrations
- [ ] Advanced reporting (PDF, Excel export)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Built with ❤️ by [Your Name]**

- 📧 Email: your.email@example.com
- 💼 LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)
- 🌐 Portfolio: [your-portfolio.com](https://your-portfolio.com)

---

<div align="center">
  <p><b>⭐ If you found this project helpful, please give it a star!</b></p>
  <p>📱 Built with Flutter • 🎨 Designed with Material Design 3 • 🚀 Ready for Enterprise</p>
</div>
# workifies
