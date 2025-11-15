# Next Steps for Cleo Production Integration

## 🎯 Current Progress

### ✅ Phase 1: Foundation (COMPLETED)
- [x] Comprehensive refactor plan created (`REFACTOR_PLAN.md`)
- [x] Dependencies added (OAuth, WebSocket, secure storage, freezed)
- [x] Environment configuration (`lib/core/config/environment.dart`)
- [x] OAuth/PKCE authentication service (`lib/core/services/auth_service.dart`)
- [x] API client with JWT token management (`lib/data/services/api_client.dart`)

### ✅ Phase 2: Data Layer (COMPLETED)
- [x] All data models created with freezed:
  - User & UserConfiguration
  - UserRelease, DailyRecommendation, Streak
  - StylusBase & UserStylus
  - PlayHistoryNew & CleaningHistoryNew
  - FolderNew, UserMeResponse
- [x] All repositories created:
  - UserRepository (primary `/api/users/me` endpoint)
  - SyncRepository (Discogs sync)
  - PlayHistoryRepositoryNew, CleaningHistoryRepositoryNew
  - StylusRepositoryNew, RecommendationRepository
- [x] WebSocket client with authentication (`lib/core/services/websocket_service.dart`)

---

## 🚧 Phase 3: Next Steps (TO DO)

### 1. Generate Freezed Code (REQUIRED FIRST)

Before the app can compile, you need to generate freezed code for all models:

```bash
# Install dependencies
flutter pub get

# Generate freezed and JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Or for watch mode (auto-generates on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

This will generate `.freezed.dart` and `.g.dart` files for all models.

---

### 2. Platform Configuration

#### A. Android Deep Linking

**File:** `android/app/src/main/AndroidManifest.xml`

Add inside the `<activity android:name=".MainActivity">` tag:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cleo" android:host="auth" />
</intent-filter>
```

**File:** `android/app/build.gradle`

Add inside `defaultConfig`:

```gradle
defaultConfig {
    // ... existing config

    manifestPlaceholders = [
        'appAuthRedirectScheme': 'cleo'
    ]
}
```

#### B. iOS Deep Linking

**File:** `ios/Runner/Info.plist`

Add inside the `<dict>` tag:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.cleo.auth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>cleo</string>
        </array>
    </dict>
</array>
```

---

### 3. Zitadel Client Configuration

You need to configure the mobile app as an OAuth client in Zitadel:

1. **Create OAuth Client** in Zitadel console
2. **Client Type:** Native (PKCE)
3. **Redirect URIs:**
   ```
   cleo://auth/callback
   ```
4. **Post Logout Redirect URIs:**
   ```
   cleo://auth/logout
   ```
5. **Scopes:**
   - openid
   - profile
   - email
   - offline_access
   - urn:zitadel:iam:org:project:roles

#### Update Environment Config

**File:** `lib/core/config/environment.dart`

Replace `YOUR_CLIENT_ID_HERE` with your actual client ID:

```dart
static const String clientId = String.fromEnvironment(
  'ZITADEL_CLIENT_ID',
  defaultValue: 'YOUR_ACTUAL_CLIENT_ID', // Replace this
);
```

**Or** use build arguments (recommended):

```bash
flutter run --dart-define=ZITADEL_CLIENT_ID=your_client_id_here
```

---

### 4. State Management Providers

The next phase requires creating/updating Riverpod providers:

#### A. Auth Provider (Update)

**File:** `lib/features/auth/data/providers/auth_providers.dart`

Update to use new `AuthService` and `UserRepository`:
- Replace Discogs token logic with OAuth
- Handle login/logout flows
- Manage user session state

#### B. User Provider (New)

**File:** `lib/features/user/data/providers/user_providers.dart`

Create provider for current user data:
- User profile state
- User preferences
- Selected folder

#### C. WebSocket Provider (New)

**File:** `lib/core/providers/websocket_providers.dart`

Create provider for WebSocket:
- Connection state
- Message streams
- Auto-connect on auth

#### D. Collection Provider (Update)

**File:** `lib/features/collection/data/providers/collection_providers.dart`

Update to use `UserRepository.getMe()` instead of separate collection endpoint.

---

### 5. Authentication UI

#### A. Login Screen (New)

**File:** `lib/features/auth/presentation/screens/login_screen.dart`

Create OAuth login screen:
- "Sign in with Zitadel" button
- Initiates OAuth flow via `AuthService.login()`
- Handle loading and error states

#### B. Auth Callback Handler (New)

**File:** `lib/features/auth/presentation/screens/auth_callback_screen.dart`

Handle deep link callback:
- Process authorization code
- Exchange for tokens
- Navigate to home on success

#### C. Update Routing (Update)

**File:** `lib/core/routing/`

Update GoRouter:
- Add `/login` route
- Add `/auth/callback` route
- Auth guard redirects
- Handle deep link routing

---

### 6. User Profile UI (New)

#### A. Profile Screen

**File:** `lib/features/user/presentation/screens/profile_screen.dart`

Create user profile screen:
- Display user info (name, email)
- Logout button
- Link to preferences
- Discogs token management

#### B. Preferences Screen

**File:** `lib/features/user/presentation/screens/preferences_screen.dart`

Create preferences screen:
- Recently played threshold (slider 1-365 days)
- Cleaning frequency (slider 1-50 plays)
- Neglected records threshold (slider 1-730 days)
- Selected folder dropdown
- Save button

---

### 7. Update Existing Screens

#### A. Home Screen

**File:** `lib/features/home/presentation/screens/home_screen.dart`

Add:
- User greeting (from `User.fullName`)
- Daily recommendation widget
- Listening streak display
- Sync status indicator

#### B. Collection Screen

**File:** `lib/features/collection/presentation/screens/collection_screen.dart`

Update:
- Use `UserRelease` instead of `Release`
- Add sync trigger button
- Show sync status from WebSocket
- Real-time updates

#### C. Log Play Screen

**File:** `lib/features/log_play/`

Update:
- Use `PlayHistoryRepositoryNew`
- Use `userReleaseId` and `userStylusId` (UUIDs)
- Support new `UserStylus` structure

#### D. Stylus Management

**File:** `lib/features/stylus/`

Major update:
- Show available stylus templates (`StylusBase`)
- Create custom templates
- Manage user instances (`UserStylus`)
- Track hours used, purchase/install dates

---

### 8. Testing Checklist

Before production deployment:

#### Authentication Flow
- [ ] User can log in via Zitadel OAuth
- [ ] Deep link callback works (Android)
- [ ] Deep link callback works (iOS)
- [ ] Token refresh works automatically
- [ ] User can log out
- [ ] Auth state persists across app restarts

#### Data Operations
- [ ] User data loads from `/api/users/me`
- [ ] Collection displays correctly
- [ ] Can log plays (new API structure)
- [ ] Can log cleanings (new API structure)
- [ ] Can manage styluses (templates + instances)
- [ ] Daily recommendation displays
- [ ] Streak displays correctly

#### WebSocket
- [ ] WebSocket connects after auth
- [ ] Receives real-time updates
- [ ] Ping/pong keep-alive works
- [ ] Reconnects after disconnect
- [ ] Handles sync progress updates

#### User Preferences
- [ ] Can update Discogs token
- [ ] Can select folder
- [ ] Can update thresholds
- [ ] Preferences persist

---

## 🔧 Environment Setup

### Local Development

```bash
# Start local Waugzee instance
# (from waugzee repository)
cd path/to/waugzee
# ... start local server on http://localhost:8288

# Run Cleo in local mode
flutter run --dart-define=ENVIRONMENT=local --dart-define=ZITADEL_CLIENT_ID=your_client_id
```

### Production

```bash
# Run Cleo in production mode
flutter run --dart-define=ENVIRONMENT=production --dart-define=ZITADEL_CLIENT_ID=your_client_id
```

---

## 📋 Migration Considerations

### Data Migration

**Important:** The new multi-user architecture is incompatible with the old single-user POC.

**Options:**
1. **Fresh Start:** Users create new accounts and re-sync from Discogs
2. **Server-Side Migration:** Create migration endpoint to import old data (requires backend work)

**Recommendation:** Start fresh - it's cleaner and the Discogs sync will populate the collection anyway.

### Old Code Cleanup

After migration is complete and tested, clean up old files:

**Remove:**
- `lib/data/repositories/auth_repository.dart` (old Discogs token version)
- `lib/data/repositories/collection_repository.dart` (if replaced)
- `lib/data/models/auth_payload.dart` (old structure)
- `lib/data/models/play_history.dart` (replaced by play_history_new.dart)
- `lib/data/models/cleaning_history.dart` (replaced)
- `lib/data/models/stylus.dart` (replaced by stylus_base.dart + user_stylus.dart)

**Rename:**
- `*_new.dart` files to remove the `_new` suffix after confirming they work

---

## 🚨 Important Notes

### 1. Freezed Code Generation

**This is CRITICAL and MUST be done first:**
- The app will NOT compile without generated freezed files
- Run `flutter pub run build_runner build --delete-conflicting-outputs`
- Commit the generated `.freezed.dart` and `.g.dart` files

### 2. Client ID Security

**Do NOT commit the actual client ID to git:**
- Use `--dart-define` for local development
- Use CI/CD environment variables for builds
- Or use a `.env` file (add to `.gitignore`)

### 3. WebSocket Rate Limiting

The WebSocket is essential for multi-user Discogs proxy:
- Each user's app proxies their own Discogs API calls
- This prevents server rate limiting
- WebSocket must be connected for sync to work properly

### 4. Testing with Local Instance

**Highly recommended:**
- Test against local Waugzee instance first
- Verify all endpoints work correctly
- Check data structure matches
- Then switch to production

---

## 📚 Resources

- [REFACTOR_PLAN.md](./REFACTOR_PLAN.md) - Complete refactoring strategy
- [Waugzee Server](https://github.com/Bparsons0904/waugzee) - Backend repository
- [flutter_appauth](https://pub.dev/packages/flutter_appauth) - OAuth library docs
- [freezed](https://pub.dev/packages/freezed) - Code generation docs
- [Zitadel Docs](https://zitadel.com/docs) - OAuth configuration

---

## 🎯 Priority Order

1. **FIRST:** Generate freezed code (`flutter pub run build_runner build`)
2. **SECOND:** Setup platform deep linking (Android + iOS)
3. **THIRD:** Configure Zitadel client and update client ID
4. **FOURTH:** Update auth provider and create login UI
5. **FIFTH:** Update existing screens to use new data models
6. **SIXTH:** Test with local Waugzee instance
7. **SEVENTH:** Production deployment

---

## ✅ Success Criteria

The migration is complete when:
- ✅ User can authenticate via Zitadel OAuth
- ✅ User data loads from `/api/users/me`
- ✅ All CRUD operations work (plays, cleanings, styluses)
- ✅ WebSocket connects and receives updates
- ✅ Collection syncs with Discogs
- ✅ Daily recommendations work
- ✅ Multi-user data isolation verified
- ✅ App tested on both Android and iOS

---

**Questions or issues?** Refer to `REFACTOR_PLAN.md` for detailed technical specs, or check the Waugzee server repository for API documentation.

Good luck! 🚀
