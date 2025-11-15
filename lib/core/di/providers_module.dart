// lib/core/di/providers_module.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/api_client.dart';
import '../services/auth_service.dart';
import '../services/websocket_service.dart';

// New repositories for Waugzee API
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/sync_repository.dart';
import '../../data/repositories/play_history_repository_new.dart';
import '../../data/repositories/cleaning_history_repository_new.dart';
import '../../data/repositories/stylus_repository_new.dart';
import '../../data/repositories/recommendation_repository.dart';

// Legacy repositories (will be deprecated)
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/collection_repository.dart';
import '../../data/repositories/cleaning_history_repository.dart';
import '../../data/repositories/play_history_repository.dart';
import '../../data/repositories/stylus_repository.dart';

part 'providers_module.g.dart';

/// Provider for SharedPreferences
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

// ============================================================================
// Core Services
// ============================================================================

/// Provider for the AuthService singleton
@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

/// Provider for the API client (with AuthService)
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiClient(authService);
}

/// Provider for the WebSocket service
@Riverpod(keepAlive: true)
WebSocketService webSocketService(WebSocketServiceRef ref) {
  final authService = ref.watch(authServiceProvider);
  return WebSocketService(authService);
}

// ============================================================================
// New Repositories (Waugzee API)
// ============================================================================

/// Provider for UserRepository
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
}

/// Provider for SyncRepository
@riverpod
SyncRepository syncRepository(SyncRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SyncRepository(apiClient);
}

/// Provider for PlayHistoryRepositoryNew
@riverpod
PlayHistoryRepositoryNew playHistoryRepositoryNew(
  PlayHistoryRepositoryNewRef ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return PlayHistoryRepositoryNew(apiClient);
}

/// Provider for CleaningHistoryRepositoryNew
@riverpod
CleaningHistoryRepositoryNew cleaningHistoryRepositoryNew(
  CleaningHistoryRepositoryNewRef ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return CleaningHistoryRepositoryNew(apiClient);
}

/// Provider for StylusRepositoryNew
@riverpod
StylusRepositoryNew stylusRepositoryNew(StylusRepositoryNewRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StylusRepositoryNew(apiClient);
}

/// Provider for RecommendationRepository
@riverpod
RecommendationRepository recommendationRepository(
  RecommendationRepositoryRef ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return RecommendationRepository(apiClient);
}

// ============================================================================
// Legacy Repositories (Deprecated - for backward compatibility)
// ============================================================================

/// Provider for AuthRepository (DEPRECATED - use AuthService instead)
@Deprecated('Use authService provider instead')
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient: apiClient);
}

/// Provider for CollectionRepository (DEPRECATED - use UserRepository instead)
@Deprecated('Use userRepository provider instead')
@riverpod
CollectionRepository collectionRepository(CollectionRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CollectionRepository(apiClient: apiClient);
}

/// Provider for StylusRepository (DEPRECATED - use StylusRepositoryNew instead)
@Deprecated('Use stylusRepositoryNew provider instead')
@riverpod
StylusRepository stylusRepository(StylusRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StylusRepository(apiClient: apiClient);
}

/// Provider for PlayHistoryRepository (DEPRECATED - use PlayHistoryRepositoryNew)
@Deprecated('Use playHistoryRepositoryNew provider instead')
@riverpod
PlayHistoryRepository playHistoryRepository(PlayHistoryRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PlayHistoryRepository(apiClient: apiClient);
}

/// Provider for CleaningHistoryRepository (DEPRECATED - use CleaningHistoryRepositoryNew)
@Deprecated('Use cleaningHistoryRepositoryNew provider instead')
@riverpod
CleaningHistoryRepository cleaningHistoryRepository(
  CleaningHistoryRepositoryRef ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return CleaningHistoryRepository(apiClient: apiClient);
}
