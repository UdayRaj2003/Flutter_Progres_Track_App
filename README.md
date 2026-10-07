# Parent Progress Tracker App 📚🎓

A modern Flutter application designed for parents to monitor, track, and support their children's academic journey. Built using Clean Architecture and the BLoC pattern, this application features phone OTP authentication, real-time study session logging, subject-wise progress tracking, and AI-driven personalized progress report generation.

---

## 🚀 Features Present

### 🔐 1. Authentication & Security
* **Phone Number Authentication**:
  * Input validation ensuring proper numeric format (10–15 digits).
  * Direct integration with backend API (`/getotp`) to request one-time passcodes.
* **OTP Verification & Rate Limiting**:
  * 6-digit numeric OTP verification via backend (`/verifyotp`).
  * **Automatic Lockout / Countdown Timer**: Locks input after failed attempts with a real-time countdown (`AuthOtpLocked`).
* **Device Telemetry & Secure Storage**:
  * Collects device metadata (Device ID, Name, Model, OS, Client Version) via `device_info_plus` and `package_info_plus`.
  * Persists session tokens securely using `flutter_secure_storage`.
* **Authentication Gate (`AuthGate`)**:
  * Automatic session status check on startup to navigate smoothly between Loading, Login, OTP verification, and Dashboard screens.

---

### 📊 2. Parent Dashboard
* **Student Profile Card**:
  * Quick summary of student identity, grade/class, and progress metrics.
* **Study Time Metrics**:
  * Real-time calculation and display of **Today's Study Time** and **Weekly Study Time** (in minutes).
* **Subject-Wise Progress Visualizer**:
  * Progress bars indicating mastery across subjects (e.g., Mathematics, Science, English, History).

---

### 📝 3. Study Session Logging
* **Add Study Session Form**:
  * **Subject Selection**: Dropdown menu for enrolled subjects.
  * **Duration Logging**: Number field for logging minutes studied with full validation.
  * **Interactive Date Picker**: `showDatePicker` interface defaulting to current date.
  * **Custom Notes**: Optional text area for logging topics covered or parent remarks.
* **Dynamic Real-Time Updates**:
  * Adding a study session instantly updates the daily and weekly totals and dynamically boosts subject progress (+5% increment per session up to 100%).

---

### 🤖 4. AI-Powered Progress Reports
* **OpenRouter AI Integration**:
  * Connected to LLM endpoints via OpenRouter API with customized educational analysis prompts.
  * Enforces **Structured JSON Schema Output** (`response_format`) for strict type safety and structured parsing.
* **Personalized Insights & Actionable Feedback**:
  * **Overall Summary**: Narrative analysis of overall student performance.
  * **Overall Progress Indicator**: Percentage score bar.
  * **Strengths Identification**: Highlights subject areas and positive study patterns.
  * **Areas to Improve**: Identifies weak areas needing attention.
  * **Actionable Recommendations**: Custom advice provided for parents to help guide their child.
  * **Subject Breakdown**: Granular per-subject status, progress percentages, and subject-specific recommendations.

---

### 👤 5. Student Details View
* Dedicated screen displaying complete student profile, overall progress trends, total study hours, and individual subject cards.

---

## 🛠️ Architecture & Tech Stack

* **Framework**: Flutter (Dart SDK ^3.13.2, Material 3 design system)
* **State Management**: `flutter_bloc` (BLoC pattern separating UI, logic, and data flow)
* **Architecture**: Clean Architecture (Presentation, BLoC, Repository, Service, Model, Storage layers)
* **API Integration**: `http` package for REST services & OpenRouter AI API
* **Security & Storage**: `flutter_secure_storage` for token management
* **Telemetry**: `device_info_plus`, `package_info_plus`, `uuid`
* **Logging & Observability**: `AppBlocObserver` with custom `appLogger` (`logger` package)

---

## 📁 Project Structure

```
parent_progress_app/
├── lib/
│   ├── bloc/              # State management (Auth, Student, ProgressReport BLoCs)
│   ├── core/              # Config, app logger, BLoC observers, utilities
│   ├── data/              # Mock/Dummy student data generator
│   ├── device/            # Device information & hardware telemetry providers
│   ├── models/            # Data models (Student, StudySession, ProgressReport, Auth)
│   ├── repositories/      # Data repositories & contracts
│   ├── screens/           # UI Screens (Login, OTP, Dashboard, Add Session, AI Report)
│   ├── services/          # REST API services (AuthService, ProgressReportService)
│   ├── storage/           # Secure local storage wrappers
│   ├── widgets/           # Modular & reusable UI components
│   └── main.dart          # Entry point, Dependency Injection, AuthGate
└── pubspec.yaml           # Dependencies and app configuration
```

---

## 🚦 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.2 or later)
* Android Studio / Xcode / VS Code with Flutter extension

### Installation
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```
