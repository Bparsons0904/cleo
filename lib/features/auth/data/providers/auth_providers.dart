import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';

part 'auth_providers.g.dart';

/// Provider for the authentication state
@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AsyncValue<AuthPayload?> build() {
    _loadAuthStatus();
    return const AsyncValue.loading();
  }

  /// Loads the current authentication status
  Future<void> _loadAuthStatus() async {
    state = const AsyncValue.loading();
    
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final authStatus = await authRepository.getAuthStatus();
      
      state = AsyncValue.data(authStatus);
    } catch (error, stackTrace) {
      // If there's an error, the user is likely not authenticated
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
        await _loadAuthStatus();
        return true;
      } else {
        state = AsyncValue.error('Failed to save token', StackTrace.current);
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
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for folders in the collection
@riverpod
List<Folder> folders(FoldersRef ref) {
  final authState = ref.watch(authStateNotifierProvider);
  
  return authState.when(
    data: (payload) => payload?.folders ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for checking if user is authenticated
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authStateNotifierProvider);
  
  return authState.when(
    data: (payload) => payload != null && payload.token.isNotEmpty,
    loading: () => false,
    error: (_, __) => false,
  );
}
