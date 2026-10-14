# CivicSpark – Civic Action & Community Impact App

**CivicSpark** is a full-featured cross-platform Flutter application empowering citizens to discover community campaigns, donate funds, volunteer for local causes, and report real-world civic issues.

The application is built with a modern **Sliver scrolling architecture**, a central reactive **AppState** management system, and a **dual-mode Firebase Backend** (runs seamlessly in Local Demo mode out-of-the-box, or switches to live Firebase Authentication & Cloud Firestore with a single command).

---

## 📱 Features Overview

| Feature Area | Key Functionalities | Key Files |
|---|---|---|
| 🟢 **Splash Screen & Navigation** | Orchestrated elastic animations, smooth fade transitions, and nested multi-tab history navigation. | [splash_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/splash_screen.dart), [main_shell.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/main_shell.dart) |
| 🔍 **Home & Live Discovery** | Live search bar (with clear action), interactive category chips (`Education`, `Healthcare`, `Environment`, `Food`), dynamic stats tiles with tab jumping, and notification bell with unread badge counter. | [home_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/home_screen.dart) |
| 🤝 **Campaigns, Donations & Volunteering** | Filter by Donation vs Volunteering drives, progress bars, preset & custom amount donation bottom sheet (₹100–₹5000), 1-tap volunteer registration, bookmarking, and link sharing. | [campaigns_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/campaigns_screen.dart), [campaign_detail_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/campaign_detail_screen.dart) |
| 🏢 **Verified Organizations** | Filter NGOs, Orphanages, and Community groups. View full profiles, active campaigns, direct Contact dialog (phone, email, map), and volunteer partnership requests. | [organizations_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/organizations_screen.dart), [org_detail_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/org_detail_screen.dart) |
| 📢 **Civic Issues & Citizen Action** | Filter issues by Urgency (`High`, `Medium`, `Low`), interactive upvoting/support counters, citizen discussion threads, and a complete "+ Report Issue" modal form. | [issues_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/issues_screen.dart), [report_issue_dialog.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/report_issue_dialog.dart) |
| 👤 **Auth & Impact Profile** | Email/Password login, user registration, anonymous guest login, 1-click Quick Demo Personas, personal impact dashboard (₹ donated, drives joined, issues submitted), and bookmarked campaigns. | [auth_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/auth_screen.dart), [profile_screen.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/profile_screen.dart) |
| 🔔 **In-App Notifications** | Real-time community alert sheet with unread counters and "Mark all read" action. | [notifications_sheet.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/screens/notifications_sheet.dart) |

---

## 🚀 How to Run the Application

The app is **ready to run immediately**. You do not need to configure Firebase before testing the app; it includes a **Local Demo Bridge** that simulates Firebase Auth & database operations with full reactivity.

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.13+ or higher)
- Android Emulator, iOS Simulator, Chrome browser, or connected physical device

### 2. Install Dependencies
Open your terminal in the project directory:
```bash
flutter pub get
```

### 3. Run the App
- **To run on your default connected device / emulator:**
  ```bash
  flutter run
  ```
- **To run in Google Chrome:**
  ```bash
  flutter run -d chrome
  ```
- **To run on a specific Android device/emulator:**
  ```bash
  flutter run -d android
  ```

### 4. Run Automated Test Suite
To verify navigation, state management, search, donations, issue reporting, and authentication:
```bash
flutter test
```
*(All 9 automated test suites pass cleanly).*

---

## 🔥 How to Connect the Backend to Firebase

CivicSpark already has the official Firebase packages (`firebase_core`, `firebase_auth`, `cloud_firestore`) installed and integrated. Follow these simple steps to link your live Firebase project:

### Step 1: Create a Firebase Project
1. Navigate to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it (e.g., `civicspark-app`).
3. Complete the setup wizard (Google Analytics can be disabled for faster setup).

---

### Step 2: Install & Run FlutterFire CLI
The FlutterFire CLI automatically configures Android (`google-services.json`), iOS (`GoogleService-Info.plist`), and generates `lib/firebase_options.dart`.

1. Install the Firebase CLI (requires Node.js):
   ```bash
   npm install -g firebase-tools
   ```
2. Log in with your Google account:
   ```bash
   firebase login
   ```
3. Activate the FlutterFire CLI globally:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. Run the configuration command in your project root:
   ```bash
   # Option A: Standard command
   flutterfire configure

   # Option B (If 'flutterfire' is not recognized on Windows):
   dart pub global run flutterfire_cli:flutterfire configure
   ```
   > **Note for Windows Users**: Dart installs global tools to `C:\Users\<user>\AppData\Local\Pub\Cache\bin`. If `flutterfire` is not recognized, either use **Option B** above or add `$env:LOCALAPPDATA\Pub\Cache\bin` to your Windows PATH.

   - Select your Firebase project from the list.
   - Choose the target platforms (Android, iOS, Web).
   - The CLI will automatically create `lib/firebase_options.dart`.

---

### Step 3: Enable Authentication in Firebase Console
1. In the Firebase Console, go to **Build > Authentication** and click **Get Started**.
2. Under the **Sign-in method** tab:
   - **Email/Password**: Click, toggle **Enable**, and click **Save**.
   - **Anonymous**: Click, toggle **Enable**, and click **Save** (powers "Continue as Guest").

---

### Step 4: Create Cloud Firestore Database
1. In the Firebase Console, go to **Build > Firestore Database** and click **Create Database**.
2. Select your preferred database location (e.g., `asia-south1` or `us-central1`).
3. Choose **Start in test mode** for development, then click **Create**.

#### Collections Schema Used by CivicSpark:
- **`campaigns`**:
  ```json
  {
    "id": "c1",
    "title": "Clean Rivers Initiative",
    "description": "Cleaning river banks...",
    "organizationName": "EcoWarriors NGO",
    "category": "Environment",
    "raisedAmount": 15000,
    "goalAmount": 50000,
    "volunteersNeeded": 20,
    "volunteersJoined": 8,
    "isDonation": true,
    "location": "Pune",
    "date": "Oct 24, 2026"
  }
  ```
- **`issues`**:
  ```json
  {
    "id": "issue_1728900000",
    "title": "Broken Street Lights",
    "description": "Hazardous dark crossing...",
    "location": "MG Road, Pune",
    "category": "Roads & Traffic",
    "urgency": "High",
    "supportCount": 42,
    "createdAt": "2026-10-14T08:00:00.000Z"
  }
  ```
- **`organizations`**:
  ```json
  {
    "id": "o1",
    "name": "Green Earth Foundation",
    "type": "NGO",
    "description": "Tree plantation and clean drives.",
    "location": "Mumbai",
    "campaignsCount": 8,
    "volunteersCount": 350,
    "isVerified": true,
    "phone": "+91 98765 43210",
    "email": "contact@greenearth.org"
  }
  ```

---

### Step 5: Activate Live Firebase in `lib/main.dart`
Once `flutterfire configure` generates `lib/firebase_options.dart`, update the `main()` function in [lib/main.dart](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/main.dart):

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CivicSparkApp());
}
```

The app's [AuthService](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/services/auth_service.dart), [FirestoreService](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/services/firestore_service.dart), and [AppState](file:///c:/Users/bmahi/develop/splashscreen_sliverdemo/lib/services/app_state.dart) will automatically detect the live connection and sync in real time!

---

## 🏛️ Project Directory Structure

```
lib/
├── main.dart                      # App entrypoint & Firebase initialization
├── main_shell.dart                # Bottom Navigation Shell & tab router
├── models/
│   ├── models.dart                # Campaign, Organization, CivicIssue, AppUser, NotificationItem
│   └── mock_data.dart             # Seed data for campaigns, orgs, and issues
├── screens/
│   ├── splash_screen.dart         # Elastic staggered splash animation
│   ├── home_screen.dart           # SliverAppBar, search bar, category chips, stats
│   ├── campaigns_screen.dart      # NestedScrollView, Donate vs Volunteer tabs
│   ├── campaign_detail_screen.dart# Campaign details, donate sheet, volunteer CTA, bookmarks
│   ├── organizations_screen.dart  # Filterable verified orgs list
│   ├── org_detail_screen.dart     # Org profile, contact modal, org campaigns
│   ├── issues_screen.dart         # Civic issues feed, urgency filters, upvotes
│   ├── report_issue_dialog.dart   # Issue reporting modal form
│   ├── auth_screen.dart           # Login, Register, Guest login, Demo profiles
│   ├── profile_screen.dart        # User profile, impact stats, saved campaigns, Firebase guide
│   └── notifications_sheet.dart   # Real-time community notification drawer
├── services/
│   ├── firebase_config.dart       # Safe Firebase initialization & fallback
│   ├── auth_service.dart          # Firebase Auth & Mock Auth engine
│   ├── firestore_service.dart     # Cloud Firestore stream & CRUD operations
│   └── app_state.dart             # Reactive state management (ChangeNotifier)
└── widgets/
    ├── campaign_card.dart         # Reusable campaign card with progress bar
    └── category_chip.dart         # Selectable pill filter widget
```

---

## 🧪 Testing

To run the full suite of unit and widget tests:
```bash
flutter test
```

### Verified Test Cases:
- ✅ **`HomeScreen loads with CivicSpark sliver and campaigns`**
- ✅ **`Push/pop navigation: tabs navigate back to previous selected page, and home pops to splashscreen`**
- ✅ **`Multi-tab history navigation preserves push/pop order`**
- ✅ **`AppState filtering by category works as expected`**
- ✅ **`AppState search query filters campaigns by title and description`**
- ✅ **`Donating to a campaign updates raised amount and records in user profile`**
- ✅ **`Reporting an issue adds it to the issues list and updates user stats`**
- ✅ **`Supporting an issue increments support count and remembers user support`**
- ✅ **`AuthService allows guest and demo login switching`**
