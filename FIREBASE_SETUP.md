# Firebase Backend & Authentication Connection Guide

This application is architected with dual-mode Firebase integration:
1. **Live Firebase Mode**: Automatically activates when `Firebase.initializeApp()` connects to your Firebase project.
2. **Local Demo Bridge / Fallback Mode**: Active right now out of the box, allowing full testing of Authentication, Registration, Guest login, Donations, Volunteering, Issue reporting, and Upvoting without any missing-credentials crashes.

---

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it (e.g. `civicspark-app`).
3. (Optional) Disable Google Analytics for faster setup, then click **Create Project**.

---

## Step 2: Configure Firebase for Flutter using FlutterFire CLI

The recommended and fastest way to configure Firebase across Android and iOS is using the official **FlutterFire CLI**:

1. Install the Firebase CLI (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```
2. Log in to Firebase:
   ```bash
   firebase login
   ```
3. Activate the FlutterFire CLI globally:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. Run the configuration tool from the project root:
   ```bash
   # Option A:
   flutterfire configure

   # Option B (Recommended if 'flutterfire' is not yet on your Windows PATH):
   dart pub global run flutterfire_cli:flutterfire configure
   ```
   - Select your Firebase project created in Step 1.
   - Choose the platforms you want to support (Android, iOS, Web).
   - This automatically generates `lib/firebase_options.dart` and configures Android/iOS native files (`google-services.json` and `GoogleService-Info.plist`).

---

## Step 3: Enable Authentication in Firebase Console

1. In the Firebase Console, go to **Build > Authentication**.
2. Click **Get Started**.
3. Under the **Sign-in method** tab:
   - Click **Email/Password** -> Toggle **Enable** -> Click **Save**.
   - Click **Anonymous** -> Toggle **Enable** -> Click **Save** (enables the "Continue as Guest" mode).

---

## Step 4: Set Up Cloud Firestore Database

1. In the Firebase Console, navigate to **Build > Firestore Database**.
2. Click **Create Database**.
3. Choose a location close to your users (e.g. `asia-south1` or `us-central1`).
4. Select **Start in test mode** for development, then click **Create**.
5. The collections created by the app are:
   - `campaigns`: `{ id, title, description, raisedAmount, goalAmount, volunteersNeeded, volunteersJoined, isDonation, ... }`
   - `issues`: `{ id, title, description, location, category, urgency, supportCount, createdAt }`
   - `organizations`: `{ id, name, type, description, location, campaignsCount, volunteersCount, isVerified }`
   - `users`: `{ uid, displayName, email, donationsTotal, joinedCampaignsCount, reportedIssuesCount, bookmarkedCampaignIds }`

---

## Step 5: Activate Live Firebase in `lib/main.dart`

Once `flutterfire configure` has created `lib/firebase_options.dart`, update `main()` in `lib/main.dart`:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pass the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CivicSparkApp());
}
```

The app's `AuthService`, `FirestoreService`, and `AppState` will automatically detect the live Firebase connection!
