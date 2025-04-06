import 'package:cleo/features/play_history/data/providers/play_history_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'cleaning_history_providers.g.dart';

/// Provider for cleaning history management
@riverpod
class CleaningHistoryNotifier extends _$CleaningHistoryNotifier {
  @override
  AsyncValue<Map<int, int>> build() {
    // Check if we're authenticated and load cleaning counts if so
    final isAuth = ref.watch(isAuthenticatedProvider);
    
    if (isAuth) {
      _loadCleaningCounts();
    }
    
    return const AsyncValue.loading();
  }

  /// Loads cleaning counts from the API
  Future<void> _loadCleaningCounts() async {
    state = const AsyncValue.loading();
    
    try {
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      final counts = await cleaningRepo.getCleaningCounts();
      
      state = AsyncValue.data(counts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Logs a new cleaning
  Future<void> logCleaning({
    required int releaseId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    try {
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: cleanedAt,
        notes: notes,
      );
      
      // Update the counts in our state if we have data
      if (state.hasValue) {
        final updatedCounts = Map<int, int>.from(state.value!);
        updatedCounts[releaseId] = (updatedCounts[releaseId] ?? 0) + 1;
        state = AsyncValue.data(updatedCounts);
      }
      
      // Reload cleaning counts to ensure we have the latest data
      await _loadCleaningCounts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for record cleanliness status
@riverpod
CleanlinessStatus recordCleanlinessStatus(
  RecordCleanlinessStatusRef ref,
  int releaseId,
) {
  final cleaningCountsAsync = ref.watch(cleaningHistoryNotifierProvider);
  final playHistoryAsync = ref.watch(playHistoryNotifierProvider);
  
  // Default status if data is loading or error
  if (cleaningCountsAsync is AsyncLoading || 
      playHistoryAsync is AsyncLoading) {
    return CleanlinessStatus.clean;
  }
  
  if (cleaningCountsAsync is AsyncError || 
      playHistoryAsync is AsyncError) {
    return CleanlinessStatus.clean;
  }
  
  // Extract data when available
  final cleaningCounts = cleaningCountsAsync.value ?? {};
  final playHistory = playHistoryAsync.value ?? [];
  
  // Get last cleaning date
  DateTime? lastCleaned;
  // This would need to be expanded with actual cleaning history data
  // For now, we just know if it was ever cleaned
  final hasBeenCleaned = cleaningCounts.containsKey(releaseId) && 
                          cleaningCounts[releaseId]! > 0;
  
  // Get plays since last cleaning
  int playsSinceCleaning = 0;
  DateTime? lastPlayed;
  
  // Find plays for this record
  final recordPlays = playHistory.where((play) => play.releaseId == releaseId).toList();
  
  if (recordPlays.isNotEmpty) {
    // Sort by date descending
    recordPlays.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    lastPlayed = recordPlays.first.playedAt;
    
    // Count plays since last cleaning
    // In a real implementation, we'd compare actual dates
    // For now, if it's been cleaned at least once, assume half the plays were before cleaning
    if (hasBeenCleaned) {
      playsSinceCleaning = recordPlays.length ~/ 2;
    } else {
      playsSinceCleaning = recordPlays.length;
    }
  }
  
  // Determine status based on plays since cleaning
  if (!hasBeenCleaned && playsSinceCleaning > 0) {
    return CleanlinessStatus.needsCleaning;
  } else if (playsSinceCleaning >= 10) {
    return CleanlinessStatus.overdue;
  } else if (playsSinceCleaning >= 5) {
    return CleanlinessStatus.needsCleaning;
  } else if (hasBeenCleaned && playsSinceCleaning < 3) {
    return CleanlinessStatus.recentlyCleaned;
  } else {
    return CleanlinessStatus.clean;
  }
}
