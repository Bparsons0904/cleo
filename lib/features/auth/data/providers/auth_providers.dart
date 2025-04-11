// Updated version of lib/features/auth/data/providers/auth_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';

part 'auth_providers.g.dart';

// Enum to represent the authentication state
enum AuthenticationStatus { initial, authenticated, unauthenticated, error }

// Provider for the combined auth state
@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AsyncValue<AuthStateData> build() {
    checkInitialAuthStatus();
    return const AsyncValue.loading();
  }

  // Initial auth status check
  Future<void> checkInitialAuthStatus() async {
    state = const AsyncValue.loading();

    try {
      // Check auth status with the server
      final authRepository = ref.read(authRepositoryProvider);
      print('📡 Getting initial auth status from server...');

      try {
        // Try to get auth status from server
        final authPayload = await authRepository.getAuthStatus();
        print('🔑 Successfully got auth status from server');

        // Check if the payload indicates authentication
        // We'll consider having releases as a sign of authentication
        if (authPayload.releases.isNotEmpty) {
          // We have data, we're authenticated
          print('🔐 Data found in payload, authenticated');
          state = AsyncValue.data(
            AuthStateData(
              status: AuthenticationStatus.authenticated,
              payload: authPayload,
            ),
          );
        } else {
          // No data in payload, need to authenticate
          print('🔐 No data found in payload, need authentication');
          state = AsyncValue.data(
            const AuthStateData(status: AuthenticationStatus.unauthenticated),
          );
        }
      } catch (error) {
        print('❌ Server error: $error');

        // Server error, set to unauthenticated to show auth screen
        state = AsyncValue.data(
          AuthStateData(
            status: AuthenticationStatus.error,
            error: 'Could not connect to server: $error',
          ),
        );
      }
    } catch (error, stackTrace) {
      print('🔐 Error in auth check process: $error');
      state = AsyncValue.error(error, stackTrace);
    }
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final authPayload = await authRepository.getAuthStatus();

      // Debug the payload
      debugAuthPayload(authPayload);

      state = AsyncValue.data(
        AuthStateData(
          status: AuthenticationStatus.authenticated,
          payload: authPayload,
        ),
      );
    } catch (error, stackTrace) {
      print('Error in auth check: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Saves the Discogs API token and authenticates the user
  Future<bool> saveToken(String token) async {
    state = const AsyncValue.loading();

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final success = await authRepository.saveToken(token);

      if (success) {
        // After saving token, check auth status again to load collections
        await checkInitialAuthStatus();
        return true;
      } else {
        state = AsyncValue.data(
          AuthStateData(
            status: AuthenticationStatus.error,
            error: 'Failed to save token',
          ),
        );
        return false;
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }

  /// Updates the auth payload without changing the authentication status
  /// This prevents navigation side effects when refreshing data
  Future<void> updatePayloadQuietly(AuthPayload authPayload) async {
    // Only update if we're already in an authenticated state to prevent navigation
    if (state is AsyncData &&
        (state as AsyncData<AuthStateData>).value.status ==
            AuthenticationStatus.authenticated) {
      // Create new state that preserves the current status but updates the payload
      state = AsyncValue.data(
        AuthStateData(
          status: AuthenticationStatus.authenticated,
          payload: authPayload,
        ),
      );
      print('🔄 Auth payload updated quietly');
    } else {
      print('⚠️ Cannot update payload quietly when not authenticated');
    }
  }
}

// Rest of the code remains the same
class AuthStateData {
  final AuthenticationStatus status;
  final AuthPayload? payload;
  final String? error;

  const AuthStateData({required this.status, this.payload, this.error});
}

@riverpod
AuthenticationStatus authStatus(AuthStatusRef ref) {
  final authState = ref.watch(authStateNotifierProvider);

  return authState.when(
    data: (data) => data.status,
    loading: () => AuthenticationStatus.initial,
    error: (_, __) => AuthenticationStatus.error,
  );
}

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthenticationStatus.authenticated;
}

@riverpod
List<Folder> folders(FoldersRef ref) {
  final authState = ref.watch(authStateNotifierProvider);

  if (authState is AsyncData && authState.value?.payload != null) {
    final folders = authState.value!.payload!.folders;
    print('Folders from auth payload: ${folders.length}');
    return folders;
  }

  return [];
}

void debugAuthPayload(AuthPayload? payload) {
  if (payload == null) {
    print('Auth payload is null');
    return;
  }

  print('Auth payload:');
  print('- Releases: ${payload.releases.length}');
  print('- Styluses: ${payload.styluses.length}');
  print('- Play History: ${payload.playHistory.length}');
  print('- Folders: ${payload.folders.length}');

  if (payload.folders.isEmpty) {
    print('WARNING: No folders found in payload!');
  } else {
    print('Folders:');
    for (var folder in payload.folders) {
      print(
        '  - ID: ${folder.id}, Name: ${folder.name}, Count: ${folder.count}',
      );
    }
  }
}
