// lib/features/log_play/data/providers/log_play_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/models.dart';
import '../../../../data/repositories/play_history_repository.dart';
import '../../../../data/repositories/cleaning_history_repository.dart';
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

  /// Logs a play for a release
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

  /// Logs a cleaning for a release
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

  /// Logs both a play and cleaning for a release
  Future<void> logBoth({
    required int releaseId,
    int? stylusId,
    required DateTime dateTime,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // First log the play
      final playHistoryRepo = ref.read(playHistoryRepositoryProvider);
      await playHistoryRepo.logPlay(
        releaseId: releaseId,
        stylusId: stylusId,
        playedAt: dateTime,
        notes: notes,
      );
      
      // Then log the cleaning
      final cleaningRepo = ref.read(cleaningHistoryRepositoryProvider);
      await cleaningRepo.logCleaning(
        releaseId: releaseId,
        cleanedAt: dateTime,
        notes: notes,
      );
      
      // Refresh auth state to get updated histories
      await ref.read(authStateNotifierProvider.notifier).checkInitialAuthStatus();
      
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for filtering and sorting the collection for the log play screen
@riverpod
List<Release> filteredLogPlayCollection(
  FilteredLogPlayCollectionRef ref,
  String searchQuery,
  String sortOption,
) {
  final authState = ref.watch(authStateNotifierProvider);
  
  if (authState is! AsyncData || authState.value?.payload == null) {
    return [];
  }
  
  final releases = authState.value!.payload!.releases;
  
  // Filter by search query
  final List<Release> filteredReleases = searchQuery.isEmpty
      ? List.from(releases)
      : releases.where((release) {
          final query = searchQuery.toLowerCase();
          final titleMatch = release.title.toLowerCase().contains(query);
          final artistMatch = release.artists.any((artist) => 
            artist.artist?.name.toLowerCase().contains(query) ?? false
          );
          return titleMatch || artistMatch;
        }).toList();
  
  // Apply sorting
  switch (sortOption) {
    case 'Artist (A-Z)':
      filteredReleases.sort((a, b) {
        final aArtist = a.artists.isNotEmpty && a.artists.first.artist != null
            ? a.artists.first.artist!.name
            : '';
        final bArtist = b.artists.isNotEmpty && b.artists.first.artist != null
            ? b.artists.first.artist!.name
            : '';
        return aArtist.compareTo(bArtist);
      });
      break;
    case 'Artist (Z-A)':
      filteredReleases.sort((a, b) {
        final aArtist = a.artists.isNotEmpty && a.artists.first.artist != null
            ? a.artists.first.artist!.name
            : '';
        final bArtist = b.artists.isNotEmpty && b.artists.first.artist != null
            ? b.artists.first.artist!.name
            : '';
        return bArtist.compareTo(aArtist);
      });
      break;
    case 'Album (A-Z)':
      filteredReleases.sort((a, b) => a.title.compareTo(b.title));
      break;
    case 'Album (Z-A)':
      filteredReleases.sort((a, b) => b.title.compareTo(a.title));
      break;
    case 'Release Year':
      filteredReleases.sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));
      break;
    case 'Recently Played':
      filteredReleases.sort((a, b) {
        final aLastPlayed = a.playHistory.isNotEmpty
            ? a.playHistory.map((p) => p.playedAt).reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
            : DateTime(1900);
        final bLastPlayed = b.playHistory.isNotEmpty
            ? b.playHistory.map((p) => p.playedAt).reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
            : DateTime(1900);
        return bLastPlayed.compareTo(aLastPlayed);
      });
      break;
    case 'Most Played':
      filteredReleases.sort((a, b) => b.playHistory.length.compareTo(a.playHistory.length));
      break;
    case 'Least Played':
      filteredReleases.sort((a, b) => a.playHistory.length.compareTo(b.playHistory.length));
      break;
  }
  
  return filteredReleases;
}
