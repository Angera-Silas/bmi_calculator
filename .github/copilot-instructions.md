# Copilot Instructions - BMI Calculator

This document helps GitHub Copilot and other AI assistants work effectively in this Flutter project.

## Quick Commands

```bash
# Install dependencies
flutter pub get

# Run the app (requires connected device or emulator)
flutter run

# Run a single test
flutter test test/widget_test.dart

# Run all tests
flutter test

# Lint analysis
flutter analyze

# Build for production
flutter build apk
```

## Architecture Overview

**Type**: Flutter mobile app (offline-first, Play Store production-ready)  
**Key Pattern**: Offline-first with cloud sync  
**Data Storage**: SQLite (local) + Firestore (cloud) + SharedPreferences (session)

### Critical User Flows

1. **Auth & Session**:
   - App starts → `SplashScreen` → `SessionService.initialize()` → routes to `/login` or `/input` depending on session state
   - "Continue as Guest" → local-only mode (`userId = 'guest'`)
   - Register/Login → Firebase Auth + session creation + guest record migration (if upgrading from guest)

2. **Data Flow**:
   - User calculates BMI → writes to SQLite via `AppDatabase.insertRecord()`
   - `SyncService` pushes unsynced records to Firestore in background (only for authenticated users)
   - On offline → app continues working with SQLite; syncs when reconnected

3. **Navigation**:
   - `/splash` → `/login` or `/input` (not named routes; uses Navigator.push)
   - `/input` has 3-tab bottom nav (Calculate, History, Insights)
   - Results passed via `CalculatorBrain` instance (not named route)

### Service Layer

**SessionService** — single source of truth for user identity
- `SessionService.userId` — Firebase UID or `'guest'`
- `SessionService.isAuthenticated` — bool flag
- Persists to SharedPreferences; survives cold starts

**AuthService** — Firebase Auth wrapper
- Methods return `String? error` (null = success)
- Handles guest → registered migration via `AppDatabase.migrateGuestRecords()`

**AppDatabase** (`lib/database/app_database.dart`) — SQLite local cache
- **BmiRecord** model: `id`, `userId`, `height`, `weight`, `age`, `isMale`, `bmiResult`, `resultText`, `interpretation`, `timestamp`, `isSynced`, `isDeleted`, `remoteId`
- Key methods: `insertRecord()`, `fetchRecords()`, `softDeleteRecord()`, `fetchUnsynced()`, `migrateGuestRecords()`, `deleteAllUserData()`

**SyncService** — bidirectional Firestore sync
- `sync(userId)` — called on app start and connectivity changes; guarded against concurrent calls
- `migrateAndSync(userId)` — called after guest → registered upgrade
- `fullPull(userId)` — pulls all remote records on first login on new device

**ConnectivityService** — network state monitoring
- Exposes `onlineStream`; used in `main()` to trigger `SyncService.sync()` on reconnect

### BMI Calculation Logic

`CalculatorBrain` class in `lib/calculator_brain.dart`:
- Methods: `getResult()`, `getInterpretation()`, `getResultColor()`, `getIdealWeightRange()`, `calculateBMR()`, `getEstimatedDailyCalories()`, `getWaterIntake()`, `getWeightDelta()`, `getAgeDisclaimer()`
- **8 WHO 2004 BMI Categories**: Severe Thinness (<16.0), Moderate Thinness (16–16.99), Mild Thinness (17–18.49), Normal (18.5–24.99), Pre-obese (25–29.99), Obese I (30–34.99), Obese II (35–39.99), Obese III (≥40.0)

### Firebase Integration

**Project ID**: `flutterapps-db036`  
**Collections**:
- `users/{uid}` — user profile (name, email, phone, createdAt)
- `history/{docId}` — BMI records with userId, height, weight, age, isMale, bmiResult, timestamp

**Security Rules** (`firestore.rules`): users own their documents; `history` allows create/read/update/delete by owner only

**Note**: Do not edit `lib/firebase_options.dart` (auto-generated)

## Key Conventions

### Theme & Colors

- **Never hardcode colors** — use `DynamicColors.*` helpers or named constants
- BMI-specific colors: `kNormalColor`, `kOverweightColor`, `kObeseIColor`, `kObeseIIColor`, `kObeseIIIColor`, `kUnderweightColor`, `kSeverelyUnderweightColor` (from `lib/constants.dart`)
- Use `getBMIColor(bmi)` for dynamic color selection
- Supports light and dark modes (`ThemeMode.system`)

### Widget Structure

- **Screens** in `lib/screens/` — top-level pages
- **Components** in `lib/components/` — reusable UI widgets
- **Models** in `lib/models/` — data classes (BmiRecord, UserProfile, etc.)
- **Services** in `lib/services/` — business logic (auth, sync, session)
- **Database** in `lib/database/` — AppDatabase (SQLite)

### State Management & Error Handling

- Use `StatefulWidget` + `State` for screens; service-level state via singletons (SessionService, AppDatabase)
- `AuthService` methods return `String? error` — null means success; non-null is the error message
- Always call `SessionService.initialize()` at app startup
- Sync errors are logged but not surfaced (background operation); UI shows stale data until next sync succeeds

### Data Consistency

- **All writes go to SQLite first** — never write directly to Firestore
- **Soft deletes**: use `AppDatabase.softDeleteRecord()` (sets `isDeleted = true`); `SyncService` propagates
- **Guest → Registered**: call `AppDatabase.migrateGuestRecords()` before sync (automatically called in `AuthService.login/register`)
- On sign-out or account deletion: `AppDatabase.deleteAllUserData(userId)` clears all local data

### Navigation

- Use named routes for screens in `lib/screens/` (e.g., `/input`, `/login`, `/profile`)
- **Exception**: Results page — pass `CalculatorBrain` via `Navigator.push()`, not named route
- Profile screen reached via avatar button on InputPage; signs out user via `AuthService.logout()`

### Packages

| Package | Purpose | Usage Note |
|---|---|---|
| `sqflite` + `path` | Local SQLite | All data writes go here first |
| `connectivity_plus` | Network monitoring | Drives auto-sync on reconnect |
| `shared_preferences` | Session persistence | SessionService uses internally |
| `uuid` | Record ID generation | Use for new BmiRecord.id |
| `firebase_auth` | Authentication | Wrapped by AuthService |
| `cloud_firestore` | Cloud sync | SyncService pushes/pulls |
| `fl_chart` | Charts | Insights tab (BMI trend) |
| `intl` | Date formatting | Timestamp display |
| `font_awesome_flutter` | Gender icons | Input page gender selector |
| `firebase_analytics` | Analytics | Auto-tracked by Firebase |
| `firebase_crashlytics` | Crash reporting | Configured in main() |

## Testing

- Add tests to `test/` directory
- Test name format: `*_test.dart`
- Run: `flutter test` or `flutter test test/widget_test.dart`

## Android/iOS Specific

**Android Permissions** (`AndroidManifest.xml`):
- `INTERNET` — required for Firebase
- `ACCESS_NETWORK_STATE` — required for connectivity_plus

**iOS**: No custom permissions needed

---

**See also**: `CLAUDE.md` for additional architecture details; `README.md` for feature overview
