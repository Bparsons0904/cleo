// lib/features/auth/data/providers/auth_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/auth_service.dart';

part 'auth_providers.g.dart';

/// Enum to represent the authentication state
enum AuthenticationStatus {
  initial,      // Loading initial auth state
  authenticated, // User is authenticated with valid token
  unauthenticated, // User is not authenticated
  error,        // Error during authentication
}

/// Data class for authentication state
class AuthStateData {
  final AuthenticationStatus status;
  final String? error;

  const AuthStateData({
    required this.status,
    this.error,
  });

  AuthStateData copyWith({
    AuthenticationStatus? status,
    String? error,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

/// Provider for the AuthService singleton
@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Provider for the authentication state
@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  FutureOr<AuthStateData> build() async {
    // Check initial authentication status
    return _checkAuthStatus();
  }

  /// Check current authentication status
  Future<AuthStateData> _checkAuthStatus() async {
    try {
      final authService = ref.read(authServiceProvider);
      final isAuthenticated = await authService.isAuthenticated();

      if (isAuthenticated) {
        print('✅ User is authenticated');
        return const AuthStateData(status: AuthenticationStatus.authenticated);
      } else {
        print('❌ User is not authenticated');
        return const AuthStateData(status: AuthenticationStatus.unauthenticated);
      }
    } catch (e) {
      print('⚠️ Error checking auth status: $e');
      return AuthStateData(
        status: AuthenticationStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Perform OAuth login
  Future<bool> login() async {
    try {
      state = const AsyncValue.loading();

      final authService = ref.read(authServiceProvider);
      final success = await authService.login();

      if (success) {
        print('✅ Login successful');
        state = const AsyncValue.data(
          AuthStateData(status: AuthenticationStatus.authenticated),
        );
        return true;
      } else {
        print('❌ Login failed');
        state = const AsyncValue.data(
          AuthStateData(
            status: AuthenticationStatus.unauthenticated,
            error: 'Login cancelled or failed',
          ),
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('⚠️ Login error: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Perform logout
  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();

      final authService = ref.read(authServiceProvider);
      await authService.logout();

      print('✅ Logout successful');
      state = const AsyncValue.data(
        AuthStateData(status: AuthenticationStatus.unauthenticated),
      );
    } catch (e, stackTrace) {
      print('⚠️ Logout error: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Refresh authentication status
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _checkAuthStatus());
  }
}

/// Provider that returns the current authentication status
@riverpod
AuthenticationStatus authStatus(AuthStatusRef ref) {
  final authState = ref.watch(authStateNotifierProvider);

  return authState.when(
    data: (data) => data.status,
    loading: () => AuthenticationStatus.initial,
    error: (_, __) => AuthenticationStatus.error,
  );
}

/// Provider that returns whether the user is authenticated
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthenticationStatus.authenticated;
}

/// Provider that returns the current error message if any
@riverpod
String? authError(AuthErrorRef ref) {
  final authState = ref.watch(authStateNotifierProvider);

  return authState.when(
    data: (data) => data.error,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
}
