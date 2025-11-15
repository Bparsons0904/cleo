# Cleo → Waugzee Production Refactor Plan

## Overview
This document outlines the comprehensive refactoring plan to migrate the Cleo Flutter app from a proof-of-concept with local backend to a production-ready application integrated with the Waugzee production API.

## Key Changes

### 1. Authentication
- **From:** Discogs personal access token (single-user, server-stored)
- **To:** OAuth 2.0 PKCE flow with Zitadel (multi-user)

### 2. API Integration
- **From:** Local backend (`http://192.168.86.200:38180/api`)
- **To:** Production API (`https://www.waugzee.com/api`)

### 3. Architecture
- **From:** Single-user data model
- **To:** Multi-tenant, user-scoped data with proper isolation

### 4. Real-time Features
- **New:** WebSocket support for live updates and Discogs proxy

---

## Implementation Phases

## Phase 1: Authentication Infrastructure ✅

### 1.1 Dependencies Added
- ✅ `flutter_appauth: ^7.0.0` - OAuth 2.0 and PKCE support
- ✅ `flutter_secure_storage: ^9.0.0` - Secure token storage
- ✅ `web_socket_channel: ^2.4.0` - WebSocket client
- ✅ `app_links: ^6.0.0` - Deep linking for OAuth callback

### 1.2 Environment Configuration
- ✅ Created `lib/core/config/environment.dart`
- Configuration includes:
  - Zitadel issuer: `https://auth.waugze.com`
  - Client ID (from environment variable)
  - Redirect URLs: `cleo://auth/callback`, `cleo://auth/logout`
  - Scopes: `openid`, `profile`, `email`, `offline_access`, `urn:zitadel:iam:org:project:roles`
  - API URLs for local and production environments

### 1.3 OAuth Service Implementation
**File:** `lib/core/services/auth_service.dart`

Features:
- PKCE flow initialization
- Login/logout methods
- Token management (access, refresh, ID tokens)
- Automatic token refresh on expiration
- Secure token storage using `flutter_secure_storage`

### 1.4 Deep Linking Setup
**Platform-specific configuration:**

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cleo" android:host="auth" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):
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

## Phase 2: API Client Modernization

### 2.1 Token Management in API Client
**File:** `lib/data/services/api_client.dart`

Updates needed:
- Add `AuthInterceptor` to inject JWT tokens in `Authorization: Bearer <token>` header
- Handle 401 responses (trigger token refresh, retry request)
- Update base URLs to use `EnvironmentConfig`
- Enhanced error handling for OAuth-related errors

### 2.2 API Client Interface
```dart
class ApiClient {
  late final Dio _dio;
  final AuthService _authService;

  Future<void> _addAuthHeader(RequestOptions options) async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Handle 401 and retry with refreshed token
  Future<void> _handleUnauthorized() async {
    await _authService.refreshToken();
    // Retry logic
  }
}
```

---

## Phase 3: Data Model Updates

### 3.1 New Models to Create

#### User Model
**File:** `lib/data/models/user.dart`
```dart
class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final String fullName;
  final String? displayName;
  final String? email;
  final bool isAdmin;
  final bool isActive;
  final DateTime? lastLoginAt;
  final bool profileVerified;
  final UserConfiguration? configuration;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

#### UserConfiguration Model
**File:** `lib/data/models/user_configuration.dart`
```dart
class UserConfiguration {
  final String id;
  final String userId;
  final String? discogsToken;
  final String? discogsUsername;
  final int? selectedFolderId;
  final int recentlyPlayedThresholdDays;
  final int cleaningFrequencyPlays;
  final int neglectedRecordsThresholdDays;
}
```

#### DailyRecommendation Model
**File:** `lib/data/models/daily_recommendation.dart`
```dart
class DailyRecommendation {
  final String id;
  final String userId;
  final String userReleaseId;
  final UserRelease userRelease;
  final DateTime date;
  final DateTime? listenedAt;
  final String algorithm; // 'smart' or 'random'
}
```

### 3.2 Models to Update

#### Release Model
**Updates needed:**
- Add `UserRelease` association
- Update fields to match API schema
- Add `playHistory` and `cleaningHistory` arrays

#### PlayHistory Model
**Updates needed:**
- Change `userReleaseId` type and structure
- Add `userStylus` association
- Update timestamp format to RFC3339

#### Stylus Models
**Split into two models:**
- `Stylus` - Base stylus templates (global)
- `UserStylus` - User-specific stylus instances

#### CleaningHistory Model
**Updates needed:**
- Add `isDeepClean` field
- Update to match API schema

---

## Phase 4: Repository Refactoring

### 4.1 AuthRepository
**File:** `lib/data/repositories/auth_repository.dart`

**New methods:**
- `login()` - Initiate OAuth flow
- `logout()` - Logout and clear tokens
- `refreshToken()` - Refresh access token
- `getCurrentUser()` - Get user profile
- `isAuthenticated()` - Check auth status

**Remove:**
- Discogs token methods

### 4.2 UserRepository (NEW)
**File:** `lib/data/repositories/user_repository.dart`

**Methods:**
- `getMe()` - GET `/api/users/me` (includes folders, releases, styluses, history, recommendation, streak)
- `updateDiscogsToken(token)` - PUT `/api/users/me/discogs`
- `updateSelectedFolder(folderId)` - PUT `/api/users/me/folder`
- `updatePreferences(config)` - PUT `/api/users/me/preferences`

### 4.3 CollectionRepository
**File:** `lib/data/repositories/collection_repository.dart`

**Updates:**
- All data comes from `GET /api/users/me` (user-scoped)
- Remove separate collection fetch endpoint
- Data is part of user payload

### 4.4 SyncRepository (NEW)
**File:** `lib/data/repositories/sync_repository.dart`

**Methods:**
- `syncCollection()` - POST `/api/sync/syncCollection`

### 4.5 PlayHistoryRepository
**File:** `lib/data/repositories/play_history_repository.dart`

**Updated endpoints:**
- `createPlay(play)` - POST `/api/plays`
- `updatePlay(id, play)` - PUT `/api/plays/:id`
- `deletePlay(id)` - DELETE `/api/plays/:id`

### 4.6 CleaningHistoryRepository
**File:** `lib/data/repositories/cleaning_history_repository.dart`

**Updated endpoints:**
- `createCleaning(cleaning)` - POST `/api/cleanings`
- `updateCleaning(id, cleaning)` - PUT `/api/cleanings/:id`
- `deleteCleaning(id)` - DELETE `/api/cleanings/:id`

### 4.7 CombinedHistoryRepository (NEW)
**File:** `lib/data/repositories/combined_history_repository.dart`

**Methods:**
- `logBoth(play, cleaning)` - POST `/api/logBoth`

### 4.8 StylusRepository
**File:** `lib/data/repositories/stylus_repository.dart`

**Updated endpoints:**
- `getAvailableStyluses()` - GET `/api/styluses/available` (global templates)
- `createCustomStylus(stylus)` - POST `/api/styluses/custom`
- `getUserStyluses()` - GET `/api/styluses`
- `createUserStylus(userStylus)` - POST `/api/styluses`
- `updateUserStylus(id, userStylus)` - PUT `/api/styluses/:id`
- `deleteUserStylus(id)` - DELETE `/api/styluses/:id`

### 4.9 RecommendationRepository (NEW)
**File:** `lib/data/repositories/recommendation_repository.dart`

**Methods:**
- `markAsListened(id)` - POST `/api/recommendations/:id/listen`

---

## Phase 5: WebSocket Integration

### 5.1 WebSocket Service
**File:** `lib/core/services/websocket_service.dart`

**Features:**
- Connect to WebSocket endpoint
- Authenticate with JWT token
- Handle ping/pong for keep-alive
- Subscribe to events (broadcast, user-specific, admin)
- Reconnection logic
- Message parsing and event dispatching

**Authentication Flow:**
1. Connect to `ws://host/ws`
2. Server sends `auth_request`
3. Client responds with `auth_response` containing JWT token
4. Server validates and sends `auth_success`

**Message Types:**
- System: auth, ping/pong
- API: requests, responses, progress, complete, error
- Admin: download progress, processing status
- Broadcast: collection updates, sync status

### 5.2 Event Bus Integration
**File:** `lib/core/services/event_bus.dart`

**Purpose:**
- Distribute WebSocket events to relevant parts of the app
- Trigger UI updates on real-time changes
- Handle Discogs sync status updates

---

## Phase 6: State Management Updates

### 6.1 Auth State Provider
**File:** `lib/features/auth/data/providers/auth_providers.dart`

**Updates:**
- Replace Discogs token state with OAuth state
- Add user profile state
- Handle token expiration
- Manage login/logout flows

### 6.2 User Profile Provider (NEW)
**File:** `lib/features/user/data/providers/user_providers.dart`

**State:**
- Current user data
- User preferences
- Selected folder

### 6.3 Collection Provider
**File:** `lib/features/collection/data/providers/collection_providers.dart`

**Updates:**
- Data comes from user.me endpoint
- User-scoped filtering
- WebSocket updates trigger refresh

### 6.4 WebSocket Provider (NEW)
**File:** `lib/core/providers/websocket_providers.dart`

**State:**
- Connection status
- Incoming messages
- Event subscriptions

---

## Phase 7: UI Updates

### 7.1 Authentication Screens

#### Login Screen (NEW)
**File:** `lib/features/auth/presentation/screens/login_screen.dart`

**Features:**
- "Sign in with Zitadel" button
- OAuth flow initiation
- Loading states
- Error handling

#### Auth Callback Screen (NEW)
**File:** `lib/features/auth/presentation/screens/auth_callback_screen.dart`

**Features:**
- Handle deep link callback
- Process authorization code
- Exchange for tokens
- Navigate to app on success

### 7.2 User Profile Screens (NEW)

#### Profile Screen
**File:** `lib/features/user/presentation/screens/profile_screen.dart`

**Features:**
- Display user info (name, email)
- Logout button
- Edit preferences
- Discogs token management

#### Preferences Screen
**File:** `lib/features/user/presentation/screens/preferences_screen.dart`

**Features:**
- Recently played threshold
- Cleaning frequency
- Neglected records threshold
- Selected folder

### 7.3 Home Screen Updates
**File:** `lib/features/home/presentation/screens/home_screen.dart`

**Updates:**
- Add daily recommendation widget
- Add streak display
- Sync status indicator
- User greeting

### 7.4 Collection Screen Updates
**File:** `lib/features/collection/presentation/screens/collection_screen.dart`

**Updates:**
- User-scoped collection
- WebSocket real-time updates
- Sync trigger button

---

## Phase 8: Platform-Specific Configuration

### 8.1 Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Add inside <activity> tag -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="cleo" android:host="auth" />
</intent-filter>
```

**File:** `android/app/build.gradle`
```gradle
defaultConfig {
    // Add manifestPlaceholders
    manifestPlaceholders = [
        'appAuthRedirectScheme': 'cleo'
    ]
}
```

### 8.2 iOS Configuration

**File:** `ios/Runner/Info.plist`
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

## Phase 9: Testing Plan

### 9.1 Unit Tests
- [ ] OAuth service tests
- [ ] Token refresh logic
- [ ] API client interceptor tests
- [ ] Repository tests with mocked API
- [ ] Data model serialization tests

### 9.2 Integration Tests
- [ ] Full auth flow (login → callback → token storage)
- [ ] API calls with token injection
- [ ] Token refresh on 401
- [ ] WebSocket connection and authentication

### 9.3 E2E Tests
- [ ] Complete user journey: login → view collection → log play → logout
- [ ] Multi-device testing (Android, iOS)
- [ ] Offline behavior
- [ ] Token expiration handling

### 9.4 Manual Testing Checklist
- [ ] OAuth flow on Android
- [ ] OAuth flow on iOS
- [ ] Token refresh after expiration
- [ ] Logout clears all data
- [ ] WebSocket reconnection
- [ ] Real-time sync updates
- [ ] All CRUD operations (plays, cleanings, styluses)
- [ ] Daily recommendation
- [ ] Preferences updates

---

## Implementation Timeline

### Week 1: Foundation
- [x] Set up dependencies
- [x] Environment configuration
- [ ] OAuth service implementation
- [ ] Deep linking setup
- [ ] API client updates

### Week 2: Data Layer
- [ ] Update all data models
- [ ] Refactor all repositories
- [ ] WebSocket service
- [ ] State management updates

### Week 3: UI & Features
- [ ] Authentication screens
- [ ] User profile screens
- [ ] Update existing screens
- [ ] Daily recommendation UI

### Week 4: Polish & Testing
- [ ] Full E2E testing
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] Production deployment

---

## Environment Variables Needed

Create `.env` file (or use build configuration):
```
ZITADEL_CLIENT_ID=your_client_id_here
ENVIRONMENT=local  # or production
```

---

## Deployment Considerations

### Build Flavors
Create separate builds for development and production:
- `cleo.dev` - Development build (local API)
- `cleo` - Production build (production API)

### CI/CD
- Automated builds for dev/prod
- Automated testing
- Code signing for iOS
- Release signing for Android

---

## Migration Notes

### Data Migration
- No automatic migration from POC to production
- Users will start fresh with new accounts
- Old Discogs token approach deprecated

### Discogs Integration
- Users now manage their own Discogs tokens via preferences
- Backend handles Discogs API calls (proxy through WebSocket for rate limiting)
- Collection sync is user-initiated

---

## Open Questions & TODOs

1. **Client ID**: Get actual Zitadel client ID for mobile app
2. **Testing Environment**: Confirm local Waugzee instance URL
3. **WebSocket Priority**: Determine if WebSocket is MVP or can be v2
4. **Rate Limiting**: How to handle rate limits on mobile?
5. **Offline Support**: Strategy for offline data access
6. **Push Notifications**: Future feature for sync completion, recommendations?

---

## Resources

- [Waugzee GitHub](https://github.com/Bparsons0904/waugzee)
- [flutter_appauth Documentation](https://pub.dev/packages/flutter_appauth)
- [Zitadel Documentation](https://zitadel.com/docs)
- [OAuth 2.0 PKCE](https://oauth.net/2/pkce/)

---

## Success Criteria

- ✅ User can log in via Zitadel OAuth
- ✅ User can view their vinyl collection
- ✅ User can log plays and cleanings
- ✅ User can manage styluses
- ✅ User can sync with Discogs
- ✅ User can receive daily recommendations
- ✅ Real-time updates via WebSocket
- ✅ Multi-user data isolation
- ✅ Secure token management
- ✅ Production-ready deployment

---

**Last Updated:** 2025-11-15
