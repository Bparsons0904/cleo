// lib/features/log_play/data/providers/log_play_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/data/providers/auth_providers.dart';
import '../../../../core/di/providers_module.dart';

part 'log_play_providers.g.dart';

/// Provider for play logging functionality
@riverpod
class LogPlayNotifier extends _$LogPlayNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// Quick logs a play for a release with minimal info (current time, primary stylus)
  Future<void> quickLogPlay(int releaseId) async {
    state = const AsyncValue.loading();
    
    try {
      // Get the primary stylus
      final authState = ref.read(authStateNotifierProvider);
      final styluses = authState.value?.payload?.styluses ?? [];
      final primaryStylus = styluses.firstWhere(
        (s) => s.primary, 
        orElse: () => styluses.first
      );
      
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: primaryStylus.id,
        playedAt: DateTime.now(),
        notes: null,
      );
      
      // Refresh auth state to get updated play history
      await ref.read(authStateNotifierProvider.notifier).checkInitialAuthStatus();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Quick logs a cleaning for a release with minimal info (current time)
  Future<void> quickLogCleaning(int releaseId) async {
    state = const AsyncValue.loading();
    
    try {
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: DateTime.now(),
        notes: null,
      );
      
      // Refresh auth state to get updated cleaning history
      await ref.read(authStateNotifierProvider.notifier).checkInitialAuthStatus();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Standard log play implementation (for completeness)
  Future<void> logPlay({
    required int releaseId,
    int? stylusId,
    required DateTime playedAt,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: playedAt,
        notes: notes,
      );
      
      // Refresh auth state to get updated play history
      await ref.read(authStateNotifierProvider.notifier).checkInitialAuthStatus();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Standard log cleaning implementation (for completeness)
  Future<void> logCleaning({
    required int releaseId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: cleanedAt,
        notes: notes,
      );
      
      // Refresh auth state to get updated cleaning history
      await ref.read(authStateNotifierProvider.notifier).checkInitialAuthStatus();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
