// lib/features/collection/data/providers/collection_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/user_release.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../../user/data/providers/user_providers.dart';

part 'collection_providers.g.dart';

/// Provider for collection data from user releases
@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  AsyncValue<List<UserRelease>> build() {
    // Watch user releases from UserProvider
    final userReleasesAsync = ref.watch(userReleasesProvider);
    return AsyncValue.data(userReleasesAsync);
  }

  /// Syncs the collection with Discogs
  Future<void> syncCollection() async {
    try {
      final syncRepo = ref.read(syncRepositoryProvider);
      await syncRepo.syncCollection();

      // Refresh user data after sync (which includes collection)
      await ref.read(userDataProvider.notifier).refresh();

      print('✅ Collection synced successfully');
    } catch (error) {
      print('⚠️ Error syncing collection: $error');
      rethrow;
    }
  }

  /// Refresh collection data
  Future<void> refresh() async {
    await ref.read(userDataProvider.notifier).refresh();
  }
}

/// Provider for release search and filtering options
@riverpod
class CollectionFilterNotifier extends _$CollectionFilterNotifier {
  @override
  CollectionFilter build() {
    return const CollectionFilter();
  }

  /// Updates search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Updates sort option
  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  /// Updates current folder ID
  void setFolderId(int? folderId) {
    state = state.copyWith(folderId: folderId);
  }

  /// Updates genre filter
  void setGenreFilter(String? genre) {
    state = state.copyWith(genre: genre);
  }

  /// Updates artist filter
  void setArtistFilter(String? artist) {
    state = state.copyWith(artist: artist);
  }

  /// Updates year filter
  void setYearFilter(int? year) {
    state = state.copyWith(year: year);
  }

  /// Resets all filters
  void resetFilters() {
    state = const CollectionFilter();
  }
}

/// Filtered collection based on applied filters
@riverpod
List<UserRelease> filteredCollection(FilteredCollectionRef ref) {
  final collectionAsync = ref.watch(collectionNotifierProvider);
  final filter = ref.watch(collectionFilterNotifierProvider);

  return collectionAsync.when(
    data: (releases) {
      // Make a copy to avoid modifying the original list
      var filteredReleases = List<UserRelease>.from(releases);

      // Apply search query filter if present
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        filteredReleases = filteredReleases.where((userRelease) {
          final release = userRelease.release;
          if (release == null) return false;

          final titleMatch = release.title.toLowerCase().contains(query);
          final artistMatch = release.artists.any(
            (artist) =>
                artist.artist?.name.toLowerCase().contains(query) ?? false,
          );
          return titleMatch || artistMatch;
        }).toList();
      }

      // Apply folder filter if present
      if (filter.folderId != null) {
        filteredReleases = filteredReleases
            .where((userRelease) => userRelease.folderId == filter.folderId)
            .toList();
      }

      // Apply genre filter if present
      if (filter.genre != null && filter.genre!.isNotEmpty) {
        filteredReleases = filteredReleases.where((userRelease) {
          final release = userRelease.release;
          if (release == null) return false;
          return release.genres
              .any((g) => g.name.toLowerCase() == filter.genre!.toLowerCase());
        }).toList();
      }

      // Apply artist filter if present
      if (filter.artist != null && filter.artist!.isNotEmpty) {
        filteredReleases = filteredReleases.where((userRelease) {
          final release = userRelease.release;
          if (release == null) return false;
          return release.artists.any((a) =>
              a.artist?.name
                  .toLowerCase()
                  .contains(filter.artist!.toLowerCase()) ??
              false);
        }).toList();
      }

      // Apply year filter if present
      if (filter.year != null) {
        filteredReleases = filteredReleases.where((userRelease) {
          final release = userRelease.release;
          if (release == null) return false;
          return release.year == filter.year;
        }).toList();
      }

      // Apply sorting
      _applySorting(filteredReleases, filter.sortOption);

      return filteredReleases;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Sort collection based on sort option
void _applySorting(List<UserRelease> releases, SortOption sortOption) {
  switch (sortOption) {
    case SortOption.artistAsc:
      releases.sort((a, b) {
        final aName = a.release?.artists.isNotEmpty == true &&
                a.release?.artists.first.artist != null
            ? a.release!.artists.first.artist!.name
            : '';
        final bName = b.release?.artists.isNotEmpty == true &&
                b.release?.artists.first.artist != null
            ? b.release!.artists.first.artist!.name
            : '';
        return aName.compareTo(bName);
      });
      break;
    case SortOption.artistDesc:
      releases.sort((a, b) {
        final aName = a.release?.artists.isNotEmpty == true &&
                a.release?.artists.first.artist != null
            ? a.release!.artists.first.artist!.name
            : '';
        final bName = b.release?.artists.isNotEmpty == true &&
                b.release?.artists.first.artist != null
            ? b.release!.artists.first.artist!.name
            : '';
        return bName.compareTo(aName);
      });
      break;
    case SortOption.titleAsc:
      releases.sort((a, b) {
        final aTitle = a.release?.title ?? '';
        final bTitle = b.release?.title ?? '';
        return aTitle.compareTo(bTitle);
      });
      break;
    case SortOption.titleDesc:
      releases.sort((a, b) {
        final aTitle = a.release?.title ?? '';
        final bTitle = b.release?.title ?? '';
        return bTitle.compareTo(aTitle);
      });
      break;
    case SortOption.yearAsc:
      releases.sort((a, b) {
        final aYear = a.release?.year ?? 0;
        final bYear = b.release?.year ?? 0;
        return aYear.compareTo(bYear);
      });
      break;
    case SortOption.yearDesc:
      releases.sort((a, b) {
        final aYear = a.release?.year ?? 0;
        final bYear = b.release?.year ?? 0;
        return bYear.compareTo(aYear);
      });
      break;
    case SortOption.recentlyAdded:
      releases.sort((a, b) {
        final aDate = a.release?.createdAt ?? DateTime(1900);
        final bDate = b.release?.createdAt ?? DateTime(1900);
        return bDate.compareTo(aDate);
      });
      break;
    case SortOption.recentlyPlayed:
      releases.sort((a, b) {
        final aLastPlayed = a.playHistory.isNotEmpty
            ? a.playHistory
                .map((p) => p.playedAt)
                .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
            : DateTime(1900);
        final bLastPlayed = b.playHistory.isNotEmpty
            ? b.playHistory
                .map((p) => p.playedAt)
                .reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
            : DateTime(1900);
        return bLastPlayed.compareTo(aLastPlayed);
      });
      break;
  }
}

/// Filter and sort options for collection
class CollectionFilter {
  final String searchQuery;
  final SortOption sortOption;
  final int? folderId;
  final String? genre;
  final String? artist;
  final int? year;

  const CollectionFilter({
    this.searchQuery = '',
    this.sortOption = SortOption.artistAsc,
    this.folderId,
    this.genre,
    this.artist,
    this.year,
  });

  CollectionFilter copyWith({
    String? searchQuery,
    SortOption? sortOption,
    int? folderId,
    String? genre,
    String? artist,
    int? year,
    bool? clearFolderId = false,
    bool? clearGenre = false,
    bool? clearArtist = false,
    bool? clearYear = false,
  }) {
    return CollectionFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      folderId: clearFolderId == true ? null : (folderId ?? this.folderId),
      genre: clearGenre == true ? null : (genre ?? this.genre),
      artist: clearArtist == true ? null : (artist ?? this.artist),
      year: clearYear == true ? null : (year ?? this.year),
    );
  }
}

enum SortOption {
  artistAsc,
  artistDesc,
  titleAsc,
  titleDesc,
  yearAsc,
  yearDesc,
  recentlyAdded,
  recentlyPlayed,
}
