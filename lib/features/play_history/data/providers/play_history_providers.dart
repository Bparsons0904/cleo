import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'play_history_providers.g.dart';

/// Provider for play history management
@riverpod
class PlayHistoryNotifier extends _$PlayHistoryNotifier {
  @override
  AsyncValue<List<PlayHistory>> build() {
    // Check if we're authenticated and load play history if so
    final isAuth = ref.watch(isAuthenticatedProvider);
    
    if (isAuth) {
      _loadPlayHistory();
    }
    
    return const AsyncValue.loading();
  }

  /// Loads play history from the API
  Future<void> _loadPlayHistory() async {
    state = const AsyncValue.loading();
    
    try {
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      final history = await playHistoryRepo.getRecentPlays();
      
      state = AsyncValue.data(history);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Logs a new play
  Future<void> logPlay({
    required int releaseId,
    int? stylusId,
    required DateTime playedAt,
    String? notes,
  }) async {
    try {
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      final newPlay = await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: playedAt,
        notes: notes,
      );
      
      // Optimistic update - add the new play to the list if we have data
      if (state.hasValue) {
        final updatedHistory = [newPlay, ...state.value!];
        state = AsyncValue.data(updatedHistory);
      }
      
      // Reload play history to ensure we have the latest data
      await _loadPlayHistory();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for filtered play history based on time period
@riverpod
class FilteredPlayHistoryNotifier extends _$FilteredPlayHistoryNotifier {
  @override
  AsyncValue<List<PlayHistory>> build() {
    final historyAsync = ref.watch(playHistoryNotifierProvider);
    final timePeriod = PlayTimePeriod.allTime; // Default time period
    
    return _filterByTimePeriod(historyAsync, timePeriod);
  }

  AsyncValue<List<PlayHistory>> _filterByTimePeriod(
    AsyncValue<List<PlayHistory>> historyAsync,
    PlayTimePeriod timePeriod,
  ) {
    return historyAsync.when(
      data: (playHistory) {
        if (playHistory.isEmpty) {
          return AsyncValue.data(const []);
        }
        
        final now = DateTime.now();
        final filteredHistory = playHistory.where((play) {
          switch (timePeriod) {
            case PlayTimePeriod.lastWeek:
              return now.difference(play.playedAt).inDays <= 7;
            case PlayTimePeriod.lastMonth:
              return now.difference(play.playedAt).inDays <= 30;
            case PlayTimePeriod.lastYear:
              return now.difference(play.playedAt).inDays <= 365;
            case PlayTimePeriod.allTime:
              return true;
          }
        }).toList();
        
        return AsyncValue.data(filteredHistory);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    );
  }

  /// Updates time period filter
  void setTimePeriod(PlayTimePeriod period) {
    final historyAsync = ref.watch(playHistoryNotifierProvider);
    state = _filterByTimePeriod(historyAsync, period);
  }
}

/// Provider for grouped play history
@riverpod
AsyncValue<Map<String, List<PlayHistory>>> groupedPlayHistory(
  GroupedPlayHistoryRef ref,
  PlayGrouping grouping,
) {
  final historyAsync = ref.watch(filteredPlayHistoryNotifierProvider);
  
  return historyAsync.when(
    data: (playHistory) {
      final Map<String, List<PlayHistory>> grouped = {};
      
      for (final play in playHistory) {
        String key;
        
        switch (grouping) {
          case PlayGrouping.none:
            // No grouping, use a single key
            key = 'all';
            break;
          case PlayGrouping.byDate:
            // Group by date (yyyy-MM-dd)
            key = play.playedAt.toString().split(' ')[0];
            break;
          case PlayGrouping.byArtist:
            // Group by artist name
            key = play.release?.artists.isNotEmpty == true 
                ? (play.release!.artists.first.artist?.name ?? 'Unknown Artist')
                : 'Unknown Artist';
            break;
          case PlayGrouping.byAlbum:
            // Group by album title
            key = play.release?.title ?? 'Unknown Album';
            break;
        }
        
        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        
        grouped[key]!.add(play);
      }
      
      return AsyncValue.data(grouped);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
}

/// Time period options for filtering play history
enum PlayTimePeriod {
  lastWeek,
  lastMonth,
  lastYear,
  allTime,
}

/// Grouping options for play history
enum PlayGrouping {
  none,
  byDate,
  byArtist,
  byAlbum,
}
