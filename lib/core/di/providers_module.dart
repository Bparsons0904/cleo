// lib/core/di/providers_module.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/collection_repository.dart';
import '../../data/repositories/cleaning_history_repository.dart';
import '../../data/repositories/play_history_repository.dart';
import '../../data/repositories/stylus_repository.dart';
import '../../data/services/api_client.dart';

part 'providers_module.g.dart';

/// Provider for SharedPreferences
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

/// Provider for the API client
@riverpod
ApiClient apiClient(ApiClientRef ref) {
  // Use the no-args constructor since it uses AppConfig internally
  return ApiClient();
}

/// Provider for AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient: apiClient);
}

/// Provider for CollectionRepository
@riverpod
CollectionRepository collectionRepository(CollectionRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CollectionRepository(apiClient: apiClient);
}

/// Provider for StylusRepository
@riverpod
StylusRepository stylusRepository(StylusRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StylusRepository(apiClient: apiClient);
}

/// Provider for PlayHistoryRepository
@riverpod
PlayHistoryRepository playHistoryRepository(PlayHistoryRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PlayHistoryRepository(apiClient: apiClient);
}

/// Provider for CleaningHistoryRepository
@riverpod
CleaningHistoryRepository cleaningHistoryRepository(CleaningHistoryRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CleaningHistoryRepository(apiClient: apiClient);
}
