// lib/features/log_play/data/providers/log_play_providers.dart
import 'package:flutter/foundation.dart';
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

  /// Logs a play for a release with detailed info
  Future<void> logPlay({
    required int releaseId,
    int? stylusId,
    required DateTime playedAt,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('LogPlay - releaseId: $releaseId, stylusId: $stylusId, playedAt: $playedAt, notes: $notes');
      
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: playedAt,
        notes: notes,
      );
      
      debugPrint('LogPlay - Play logged successfully');
      
      // Instead of doing a full auth refresh, we could:
      // 1. Do a targeted refresh of just the release's play history
      // 2. Or - just skip refreshing and wait until the user navigates away and back
      // For now, we'll do a quiet refresh without triggering navigation
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('LogPlay - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to allow UI to handle the error
    }
  }

  /// Quick logs a play for a release with minimal info (current time, primary stylus)
  Future<void> quickLogPlay(int releaseId) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('QuickLogPlay - releaseId: $releaseId');
      
      // Get the primary stylus
      final authState = ref.read(authStateNotifierProvider);
      final styluses = authState.value?.payload?.styluses ?? [];
      
      int? stylusId;
      if (styluses.isNotEmpty) {
        final primaryStylus = styluses.firstWhere(
          (s) => s.primary, 
          orElse: () => styluses.first
        );
        stylusId = primaryStylus.id;
      }
      
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: DateTime.now(),
        notes: null,
      );
      
      debugPrint('QuickLogPlay - Play logged successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('QuickLogPlay - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to allow UI to handle the error
    }
  }

  /// Logs a cleaning for a release with detailed info
  Future<void> logCleaning({
    required int releaseId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('LogCleaning - releaseId: $releaseId, cleanedAt: $cleanedAt, notes: $notes');
      
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: cleanedAt,
        notes: notes,
      );
      
      debugPrint('LogCleaning - Cleaning logged successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('LogCleaning - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to allow UI to handle the error
    }
  }

  /// Quick logs a cleaning for a release with minimal info (current time)
  Future<void> quickLogCleaning(int releaseId) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('QuickLogCleaning - releaseId: $releaseId');
      
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: DateTime.now(),
        notes: null,
      );
      
      debugPrint('QuickLogCleaning - Cleaning logged successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('QuickLogCleaning - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to allow UI to handle the error
    }
  }
  
  /// Performs a refresh of the auth state without triggering navigation
  Future<void> _quietRefresh() async {
    try {
      // Get the auth repository directly
      final authRepo = ref.read(authRepositoryProvider);
      
      // Get the auth status without going through the notifier
      final authPayload = await authRepo.getAuthStatus();
      
      // Update the auth state without triggering navigation
      ref.read(authStateNotifierProvider.notifier).updatePayloadQuietly(authPayload);
    } catch (e) {
      debugPrint('Error in quiet refresh: $e');
      // Don't throw, just log the error
    }
  }

  Future<void> updatePlay({
    required int playId,
    required int releaseId, // Add this parameter
    required DateTime playedAt,
    int? stylusId,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('UpdatePlay - playId: $playId, releaseId: $releaseId, playedAt: $playedAt, stylusId: $stylusId, notes: $notes');
      
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.updatePlay(
        playId: playId,
        releaseId: releaseId, // Pass this parameter
        playedAt: playedAt,
        stylusId: stylusId,
        notes: notes,
      );
      
      debugPrint('UpdatePlay - Play updated successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('UpdatePlay - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateCleaning({
    required int cleaningId,
    required int releaseId, // Add this parameter
    required DateTime cleanedAt,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('UpdateCleaning - cleaningId: $cleaningId, releaseId: $releaseId, cleanedAt: $cleanedAt, notes: $notes');
      
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.updateCleaning(
        cleaningId: cleaningId,
        releaseId: releaseId, // Pass this parameter
        cleanedAt: cleanedAt,
        notes: notes,
      );
      
      debugPrint('UpdateCleaning - Cleaning updated successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('UpdateCleaning - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Deletes a play record
  Future<void> deletePlay(int playId) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('DeletePlay - playId: $playId');
      
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.deletePlay(playId);
      
      debugPrint('DeletePlay - Play deleted successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('DeletePlay - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Deletes a cleaning record
  Future<void> deleteCleaning(int cleaningId) async {
    state = const AsyncValue.loading();
    
    try {
      debugPrint('DeleteCleaning - cleaningId: $cleaningId');
      
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.deleteCleaning(cleaningId);
      
      debugPrint('DeleteCleaning - Cleaning deleted successfully');
      
      await _quietRefresh();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      debugPrint('DeleteCleaning - Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

}

