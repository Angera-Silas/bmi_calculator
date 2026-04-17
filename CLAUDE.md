# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app (connected device or emulator required)
flutter run

# Build APK
flutter build apk

# Analyze (lint)
flutter analyze

# Run tests
flutter test
```

## Architecture

Flutter BMI Calculator — offline-first, Play Store production build.
Firebase Auth + Firestore for registered users. SQLite (sqflite) as the local source of truth for all users.

### App flow

1. `/splash` — initialises `SessionService`, routes to `/input` (has session) or `/login`
2. `/login` — email/password auth; **"Continue as Guest"** button for guest mode
3. `/register` — creates Firebase account; navigates directly to `/input` (session started inline)
4. `/reset-password` — sends Firebase password-reset email
5. `/input` (`InputPage`) — 3-tab bottom nav: **Calculate**, **History**, **Insights**; avatar → `/profile`
6. `/results` — `ResultsPage` receives a `CalculatorBrain` instance via `Navigator.push` (not a named route)
7. `/profile` — guest banner / editable profile; account deletion; sign-out

### Session management

`SessionService` (`lib/services/session_service.dart`) is the single source of truth for "who is the current user".

- **Guest** — `userId = 'guest'`, data local-only, no sync
- **Registered** — `userId = Firebase UID`, full offline+sync support

`SessionService.initialize()` is called at app start (in `main()`) and again inside `SplashScreen._checkAuthState()`.

### Offline-first data layer

All writes go to **SQLite** first via `AppDatabase` (`lib/database/app_database.dart`).
`SyncService` (`lib/services/sync_service.dart`) pushes/pulls to Firestore in the background.

**`BmiRecord`** (`lib/models/bmi_record.dart`) — unified model used by both SQLite and Firestore sync:
- `id` — UUID, local primary key
- `userId` — Firebase UID or `'guest'`
- `isSynced` — false until pushed to Firestore
- `isDeleted` — soft-delete flag; propagated on next sync
- `remoteId` — Firestore doc ID, set after first push

**`AppDatabase` key methods:**
- `insertRecord(record)` — new calculation (from Calculate tab)
- `fetchRecords(userId)` — non-deleted records, newest first (History + Insights tabs)
- `softDeleteRecord(id)` — marks deleted locally; `SyncService` propagates deletion
- `fetchUnsynced(userId)` — records pending push
- `migrateGuestRecords(newUserId)` — called on guest → registered upgrade
- `upsertUser(...)` / `getUser(id)` / `updateUser(id, fields)` — user profile cache
- `deleteAllUserData(userId)` — account deletion / sign-out cleanup

**`SyncService` entry points:**
- `sync(userId)` — bidirectional; guarded against concurrent calls; called on reconnect
- `migrateAndSync(userId)` — reassigns guest records then syncs (called after login/register as guest)
- `fullPull(userId)` — pulls ALL remote records; called once on first login on a new device

`ConnectivityService.onlineStream` in `main()` triggers `SyncService.sync()` automatically when the device comes back online.

### Service layer (`lib/services/`)

- `AuthService` — Firebase Auth; returns `String? error` (null = success); calls `SessionService` and `SyncService` internally
  - `loginAsGuest()` — no Firebase; starts local guest session
  - `login(email, password)` — migrates guest records if transitioning from guest
  - `register(...)` — creates account + starts session; migrates guest records
  - `logout()` — Firebase sign-out + clears session
  - `deleteAccount()` — deletes Firebase account + all local data
- `FirestoreService` — user profile CRUD only (screens use `AppDatabase` for history)
- `SessionService` — session state + SharedPreferences persistence
- `ConnectivityService` — wraps `connectivity_plus`; exposes `isOnline` + `onlineStream`
- `SyncService` — offline-first bidirectional Firestore sync

### Core logic (`lib/calculator_brain.dart`)

`CalculatorBrain({height, weight, age, isMale})` — WHO 2004 8-category BMI classification:

| Category | BMI range |
|---|---|
| Severe Thinness | < 16.0 |
| Moderate Thinness | 16.0 – 16.99 |
| Mild Thinness | 17.0 – 18.49 |
| Normal Range | 18.5 – 24.99 |
| Pre-obese | 25.0 – 29.99 |
| Obese Class I | 30.0 – 34.99 |
| Obese Class II | 35.0 – 39.99 |
| Obese Class III | ≥ 40.0 |

Key methods: `getResult()`, `getInterpretation()`, `getResultColor()`, `getIdealWeightRange()`, `calculateBMR()`, `getEstimatedDailyCalories()`, `getWaterIntake()`, `getWeightDelta()`, `getAgeDisclaimer()`, `gaugeProgress`.

### Theme system

- `ThemeMode.system` — light and dark fully supported
- All colors via `DynamicColors.*` helpers or named constants from `lib/constants.dart`
- BMI colors: `kNormalColor`, `kOverweightColor`, `kObeseIColor`, `kObeseIIColor`, `kObeseIIIColor`, `kUnderweightColor`, `kSeverelyUnderweightColor`
- Never hardcode colors — use `DynamicColors.*` or `getBMIColor(bmi)` for BMI-based coloring

### Packages

| Package | Purpose |
|---|---|
| `sqflite` + `path` | Local SQLite database |
| `uuid` | UUID generation for local record PKs |
| `connectivity_plus` | Network state monitoring |
| `shared_preferences` | Session persistence across cold starts |
| `fl_chart` | BMI trend line chart (Insights screen) |
| `intl` | Date formatting |
| `font_awesome_flutter` | Gender icons |
| `firebase_auth` | Authentication |
| `cloud_firestore` | Remote sync |
| `firebase_crashlytics` | Crash reporting |
| `firebase_analytics` | Usage analytics |

### Firebase project

Project ID: `flutterapps-db036`
Config auto-generated in `lib/firebase_options.dart` — do not edit manually.

**Firestore collections:**
- `users/{uid}` — `name`, `email`, `phone`, `userId`, `createdAt`
- `history/{docId}` — `userId`, `localId`, `height`, `weight`, `age`, `isMale`, `bmiResult`, `resultText`, `interpretation`, `timestamp`

**Security rules** (`firestore.rules`): users own their documents; `history` allows create/read/update/delete by owner only; update required by SyncService for re-syncing modified records.

### Android permissions (minimal)

`AndroidManifest.xml` declares only:
- `INTERNET`
- `ACCESS_NETWORK_STATE`

## Android build configuration (AGP 9.0.0)

This project targets **Android Gradle Plugin 9.0.0** with **Gradle 9.3.0** and **Flutter 3.41.x**. Several non-obvious changes were required to make this combination work. Do not revert them.

### Version matrix

| Component | Version | File |
|---|---|---|
| Android Gradle Plugin (AGP) | `9.0.0` | `android/settings.gradle` |
| Gradle wrapper | `9.3.0` | `android/gradle/wrapper/gradle-wrapper.properties` |
| google-services plugin | `4.4.2` | `android/settings.gradle` |

### Why `google-services` must be ≥ 4.4.x

`google-services` ≤ 4.3.x uses the `applicationVariants` API that was removed in AGP 9. Upgrading to `4.4.2` rewrites that internal path and eliminates the error:
```
Could not get unknown property 'applicationVariants' for object of type ApplicationExtensionImpl
```

### Why `kotlin-android` is NOT declared in `app/build.gradle`

`dev.flutter.flutter-gradle-plugin` (Flutter 3.19+) applies `kotlin-android` internally. Declaring it a second time in `plugins {}` causes:
```
Cannot add extension with name 'kotlin', as there is an extension already registered with that name.
```
Do not add `id "kotlin-android"` back to `android/app/build.gradle`.

### Why `kotlinOptions` is NOT in `app/build.gradle`

`kotlinOptions { jvmTarget = "..." }` inside the `android {}` block requires the Kotlin plugin to already be applied. Because `dev.flutter.flutter-gradle-plugin` is declared last (required by Flutter), Kotlin isn't wired up yet when the `android {}` block is evaluated. Removing `kotlinOptions` is safe — Flutter's plugin sets the Kotlin JVM target internally, and `compileOptions` covers the Java side.

### Why `android.newDsl=false` is in `gradle.properties`

AGP 9 enables a new Gradle DSL interface by default. The Flutter Gradle plugin's Groovy-based build scripts still use the old DSL interface, causing a `NullPointerException` at configuration time. Setting `android.newDsl=false` in `android/gradle.properties` tells AGP 9 to keep the old interface available. This is the opt-out path documented by Flutter at:
https://docs.flutter.dev/release/breaking-changes/migrate-to-agp-9

Remove this flag only after Flutter officially migrates its Gradle plugin to the AGP 9 new DSL.
