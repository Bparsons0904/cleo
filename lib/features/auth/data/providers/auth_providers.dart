// lib/features/auth/data/providers/auth_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';

part 'auth_providers.g.dart';

// Enum to represent the authentication state
enum AuthenticationStatus {
  initial,
  authenticated,
  unauthenticated,
  error,
}

// Provider for the combined auth state
@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AsyncValue<AuthStateData> build() {
    // _checkInitialAuthStatus();
    // Start with loading state

    checkInitialAuthStatus();
    return const AsyncValue.loading();
  }

  // Initial auth status check
  Future<void> checkInitialAuthStatus() async {
    state = const AsyncValue.loading();
    
    try {
      // Always check auth status with the server regardless of token
      final authRepository = ref.read(authRepositoryProvider);
      print('📡 Getting initial auth status from server...');
      
      try {
        // Try to get auth status from server
        final authPayload = await authRepository.getAuthStatus();
        print('🔑 Successfully got auth status from server');
        
        // If we reach here, we're authenticated
        state = AsyncValue.data(
          AuthStateData(
            status: AuthenticationStatus.authenticated,
            payload: authPayload,
          ),
        );
      } catch (error) {
        print('❌ Server error: $error');
        
        // Check local token as fallback
        final hasToken = await authRepository.hasToken();
        print('🔐 Fallback check - Has token: $hasToken');
        
        if (hasToken) {
          // We have a token, but couldn't connect to server
          state = AsyncValue.data(
            AuthStateData(
              status: AuthenticationStatus.error,
              error: 'Could not connect to server: $error',
            ),
          );
        } else {
          // No token, definitely unauthenticated
          state = AsyncValue.data(
            const AuthStateData(
              status: AuthenticationStatus.unauthenticated,
            ),
          );
        }
      }
    } catch (error, stackTrace) {
      print('🔐 Error in auth check process: $error');
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

  /// Logs the user out
  Future<void> logout() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
      
      state = AsyncValue.data(
        const AuthStateData(
          status: AuthenticationStatus.unauthenticated,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Updates the auth payload without changing the authentication status
  /// This prevents navigation side effects when refreshing data
  Future<void> updatePayloadQuietly(AuthPayload authPayload) async {
    // Only update if we're already in an authenticated state to prevent navigation
    if (state is AsyncData && (state as AsyncData<AuthStateData>).value.status == AuthenticationStatus.authenticated) {
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

// Data class to hold auth state
class AuthStateData {
  final AuthenticationStatus status;
  final AuthPayload? payload;
  final String? error;
  
  const AuthStateData({
    required this.status,
    this.payload,
    this.error,
  });
}

// Provider specifically for auth status enum
@riverpod
AuthenticationStatus authStatus(AuthStatusRef ref) {
  final authState = ref.watch(authStateNotifierProvider);
  
  return authState.when(
    data: (data) => data.status,
    loading: () => AuthenticationStatus.initial,
    error: (_, __) => AuthenticationStatus.error,
  );
}

// Keep the original isAuthenticated provider, but adapt it
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthenticationStatus.authenticated;
}

// Provider for folders in the collection
@riverpod
List<Folder> folders(FoldersRef ref) {
  final authState = ref.watch(authStateNotifierProvider);
  
  return authState.when(
    data: (data) => data.payload?.folders ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}
