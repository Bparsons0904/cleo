// lib/features/collection/data/providers/collection_filter_provider.dart

import 'package:cleo/features/folders/data/providers/folder_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cleo/data/models/models.dart';
import 'package:cleo/features/auth/data/providers/auth_providers.dart';
import '../filters/collection_filter_state.dart';
import '../filters/collection_filter_notifier.dart';

part 'collection_filter_provider.g.dart';

// Define the provider
final collectionFilterProvider =
    StateNotifierProvider<CollectionFilterNotifier, CollectionFilterState>((
      ref,
    ) {
      return CollectionFilterNotifier();
    });

// Provider for all available genres in the collection
@riverpod
List<String> availableGenres(Ref ref) {
  final authState = ref.watch(authStateNotifierProvider);

  if (authState is! AsyncData || authState.value?.payload == null) {
    return [];
  }

  final releases = authState.value?.payload!.releases;

  // Extract all genres and remove duplicates
  final Set<String> uniqueGenres = {};

  for (final release in releases ?? []) {
    for (final genre in release.genres) {
      uniqueGenres.add(genre.name);
    }
  }

  // Return sorted list of genres
  final sortedGenres = uniqueGenres.toList()..sort();
  return sortedGenres;
}

// Provider for filtered collection
@riverpod
List<Release> filteredCollection(Ref ref) {
  final filterState = ref.watch(collectionFilterProvider);
  // Use our folder-filtered releases instead of directly from auth state
  var releases = ref.watch(filteredReleasesByFolderProvider);

  // Apply search filter
  if (filterState.searchQuery.isNotEmpty) {
    final query = filterState.searchQuery.toLowerCase();
    releases =
        releases.where((release) {
          final titleMatch = release.title.toLowerCase().contains(query);
          final artistMatch = release.artists.any(
            (artist) =>
                artist.artist?.name.toLowerCase().contains(query) ?? false,
          );
          return titleMatch || artistMatch;
        }).toList();
  }

  // Apply genre filter
  if (filterState.selectedGenres.isNotEmpty) {
    releases =
        releases.where((release) {
          return release.genres.any(
            (genre) => filterState.selectedGenres.contains(genre.name),
          );
        }).toList();
  }

  // Filter by play status
  if (filterState.playStatus != null) {
    releases =
        releases.where((release) {
          // Get recent play dates
          final now = DateTime.now();

          if (release.playHistory.isEmpty) {
            return filterState.playStatus ==
                PlayRecencyStatus.notPlayedRecently;
          }

          // Find the most recent play date
          final mostRecentPlay = release.playHistory
              .map((play) => play.playedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);

          final daysSincePlay = now.difference(mostRecentPlay).inDays;

          switch (filterState.playStatus) {
            case PlayRecencyStatus.recentlyPlayed:
              return daysSincePlay <= 7; // Last week
            case PlayRecencyStatus.playedThisMonth:
              return daysSincePlay <= 30; // Last month
            case PlayRecencyStatus.playedThisYear:
              return daysSincePlay <= 365; // Last year
            case PlayRecencyStatus.notPlayedRecently:
              return daysSincePlay > 365; // More than a year
            default:
              return true;
          }
        }).toList();
  }

  // Filter by cleaning status
  if (filterState.cleaningStatus != null) {
    // Implementation would depend on your cleaning history logic
    // Similar to the play status filter, but for cleanings
  }

  // Apply sorting
  switch (filterState.sortOption) {
    case CollectionSortOption.albumsAZ:
      releases.sort((a, b) => a.title.compareTo(b.title));
      break;
    case CollectionSortOption.albumsZA:
      releases.sort((a, b) => b.title.compareTo(a.title));
      break;
    case CollectionSortOption.artistsAZ:
      releases.sort((a, b) {
        final aArtist =
            a.artists.isNotEmpty ? (a.artists.first.artist?.name ?? '') : '';
        final bArtist =
            b.artists.isNotEmpty ? (b.artists.first.artist?.name ?? '') : '';
        return aArtist.compareTo(bArtist);
      });
      break;
    case CollectionSortOption.artistsZA:
      releases.sort((a, b) {
        final aArtist =
            a.artists.isNotEmpty ? (a.artists.first.artist?.name ?? '') : '';
        final bArtist =
            b.artists.isNotEmpty ? (b.artists.first.artist?.name ?? '') : '';
        return bArtist.compareTo(aArtist);
      });
      break;
    case CollectionSortOption.releaseYear:
      releases.sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));
      break;
    case CollectionSortOption.releaseYearDesc:
      releases.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
      break;
    case CollectionSortOption.recentlyAdded:
      releases.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case CollectionSortOption.recentlyPlayed:
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
    case CollectionSortOption.leastRecentlyPlayed:
      releases.sort((a, b) {
        final aLastPlayed =
            a.playHistory.isNotEmpty
                ? a.playHistory
                    .map((p) => p.playedAt)
                    .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
                : DateTime(2100); // Far future for never played
        final bLastPlayed =
            b.playHistory.isNotEmpty
                ? b.playHistory
                    .map((p) => p.playedAt)
                    .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
                : DateTime(2100); // Far future for never played
        return aLastPlayed.compareTo(bLastPlayed);
      });
      break;
  }

  return releases;
}
