// lib/features/log_play/data/providers/log_play_filter_provider.dart
import 'package:cleo/features/folders/data/providers/folder_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/models.dart';
import '../filters/log_play_filter_state.dart';

part 'log_play_filter_provider.g.dart';

/// Provider for log play filter state
final logPlayFilterProvider =
    StateNotifierProvider<LogPlayFilterNotifier, LogPlayFilterState>((ref) {
      return LogPlayFilterNotifier();
    });

/// Notifier for log play filter state
class LogPlayFilterNotifier extends StateNotifier<LogPlayFilterState> {
  LogPlayFilterNotifier() : super(const LogPlayFilterState());

  /// Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Update sort option
  void setSortOption(LogPlaySortOption option) {
    state = state.copyWith(sortOption: option);
  }

  /// Reset all filters
  void resetFilters() {
    state = const LogPlayFilterState();
  }
}

/// Provider for filtered releases based on log play filter
@riverpod
List<Release> filteredLogPlayReleases(Ref ref) {
  final filterState = ref.watch(logPlayFilterProvider);
  // Use our folder-filtered releases instead of directly from auth state
  final releases = ref.watch(filteredReleasesByFolderProvider);

  // Apply search filter (keeping your existing logic)
  List<Release> filteredReleases = _applySearchFilter(
    releases,
    filterState.searchQuery,
  );

  // Apply sorting
  _applySorting(filteredReleases, filterState.sortOption);

  return filteredReleases;
}

List<Release> _applySearchFilter(List<Release> releases, String query) {
  if (query.isEmpty) {
    return List.from(releases);
  }

  final lowerQuery = query.toLowerCase();
  return releases.where((release) {
    final titleMatch = release.title.toLowerCase().contains(lowerQuery);
    final artistMatch = release.artists.any(
      (artist) =>
          artist.artist?.name.toLowerCase().contains(lowerQuery) ?? false,
    );

    return titleMatch || artistMatch;
  }).toList();
}

void _applySorting(List<Release> releases, LogPlaySortOption sortOption) {
  switch (sortOption) {
    case LogPlaySortOption.artistAZ:
      releases.sort((a, b) {
        final aArtist =
            a.artists.isNotEmpty && a.artists.first.artist != null
                ? a.artists.first.artist!.name
                : '';
        final bArtist =
            b.artists.isNotEmpty && b.artists.first.artist != null
                ? b.artists.first.artist!.name
                : '';
        return aArtist.compareTo(bArtist);
      });
      break;
    case LogPlaySortOption.artistZA:
      releases.sort((a, b) {
        final aArtist =
            a.artists.isNotEmpty && a.artists.first.artist != null
                ? a.artists.first.artist!.name
                : '';
        final bArtist =
            b.artists.isNotEmpty && b.artists.first.artist != null
                ? b.artists.first.artist!.name
                : '';
        return bArtist.compareTo(aArtist);
      });
      break;
    case LogPlaySortOption.albumAZ:
      releases.sort((a, b) => a.title.compareTo(b.title));
      break;
    case LogPlaySortOption.albumZA:
      releases.sort((a, b) => b.title.compareTo(a.title));
      break;
    case LogPlaySortOption.genre:
      releases.sort((a, b) {
        final aGenre = a.genres.isNotEmpty ? a.genres.first.name : '';
        final bGenre = b.genres.isNotEmpty ? b.genres.first.name : '';
        return aGenre.compareTo(bGenre);
      });
      break;
    case LogPlaySortOption.lastPlayed:
      releases.sort((a, b) {
        final aLastPlayed =
            a.playHistory.isNotEmpty
                ? a.playHistory
                    .map((p) => p.playedAt)
                    .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
                : DateTime(1900);
        final bLastPlayed =
            b.playHistory.isNotEmpty
                ? b.playHistory
                    .map((p) => p.playedAt)
                    .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
                : DateTime(1900);
        return bLastPlayed.compareTo(aLastPlayed);
      });
      break;
    case LogPlaySortOption.recentlyPlayed:
      releases.sort((a, b) {
        final aRecentlyPlayed = a.playHistory.isNotEmpty;
        final bRecentlyPlayed = b.playHistory.isNotEmpty;
        if (aRecentlyPlayed && !bRecentlyPlayed) return -1;
        if (!aRecentlyPlayed && bRecentlyPlayed) return 1;
        return 0;
      });
      break;
    case LogPlaySortOption.releaseYear:
      releases.sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));
      break;
    case LogPlaySortOption.mostPlayed:
      releases.sort(
        (a, b) => b.playHistory.length.compareTo(a.playHistory.length),
      );
      break;
    case LogPlaySortOption.leastPlayed:
      releases.sort(
        (a, b) => a.playHistory.length.compareTo(b.playHistory.length),
      );
      break;
  }
}
