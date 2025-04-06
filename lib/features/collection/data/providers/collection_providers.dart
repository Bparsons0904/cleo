import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'collection_providers.g.dart';

/// Provider for the filtered collection
@riverpod
class CollectionNotifier extends _$CollectionNotifier {
  @override
  AsyncValue<List<Release>> build() {
    // Check if we're authenticated and load collection if so
    final isAuth = ref.watch(isAuthenticatedProvider);
    
    if (isAuth) {
      _loadCollection();
    }
    
    return const AsyncValue.loading();
  }

  /// Loads the vinyl collection from the API
  Future<void> _loadCollection({int? folderId}) async {
    state = const AsyncValue.loading();
    
    try {
      final collectionRepo = ref.read(collectionRepositoryProvider);
      final releases = await collectionRepo.getCollection(folderId: folderId);
      
      state = AsyncValue.data(releases);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Filters collection by folder ID
  Future<void> filterByFolder(int? folderId) async {
    // If we already have data, show loading overlay without losing current data
    if (state.hasValue) {
      state = AsyncValue.data(state.value!);
    } else {
      state = const AsyncValue.loading();
    }
    
    await _loadCollection(folderId: folderId);
  }

  /// Syncs the collection with Discogs
  Future<void> syncCollection() async {
    try {
      final collectionRepo = ref.read(collectionRepositoryProvider);
      await collectionRepo.syncCollection();
      
      // Reload the collection after sync
      await _loadCollection();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
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
AsyncValue<List<Release>> filteredCollection(FilteredCollectionRef ref) {
  final collectionAsync = ref.watch(collectionNotifierProvider);
  final filter = ref.watch(collectionFilterNotifierProvider);
  
  return collectionAsync.when(
    data: (releases) {
      // Make a copy to avoid modifying the original list
      final filteredReleases = List<Release>.from(releases);
      
      // Apply search query filter if present
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        filteredReleases.removeWhere((release) {
          final titleMatch = release.title.toLowerCase().contains(query);
          final artistMatch = release.artists.any(
            (artist) => artist.artist?.name.toLowerCase().contains(query) ?? false
          );
          return !(titleMatch || artistMatch);
        });
      }
      
      // Apply folder filter if present
      if (filter.folderId != null) {
        filteredReleases.removeWhere((release) => release.folderId != filter.folderId);
      }
      
      // Apply genre filter if present
      if (filter.genre != null && filter.genre!.isNotEmpty) {
        filteredReleases.removeWhere((release) => 
          !release.genres.any((g) => g.name.toLowerCase() == filter.genre!.toLowerCase())
        );
      }
      
      // Apply artist filter if present
      if (filter.artist != null && filter.artist!.isNotEmpty) {
        filteredReleases.removeWhere((release) => 
          !release.artists.any((a) => 
            a.artist?.name.toLowerCase().contains(filter.artist!.toLowerCase()) ?? false
          )
        );
      }
      
      // Apply year filter if present
      if (filter.year != null) {
        filteredReleases.removeWhere((release) => release.year != filter.year);
      }
      
      // Apply sorting
      _applySorting(filteredReleases, filter.sortOption);
      
      return AsyncValue.data(filteredReleases);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
}

/// Sort collection based on sort option
void _applySorting(List<Release> releases, SortOption sortOption) {
  switch (sortOption) {
    case SortOption.artistAsc:
      releases.sort((a, b) {
        final aName = a.artists.isNotEmpty && a.artists.first.artist != null
            ? a.artists.first.artist!.name
            : '';
        final bName = b.artists.isNotEmpty && b.artists.first.artist != null
            ? b.artists.first.artist!.name
            : '';
        return aName.compareTo(bName);
      });
      break;
    case SortOption.artistDesc:
      releases.sort((a, b) {
        final aName = a.artists.isNotEmpty && a.artists.first.artist != null
            ? a.artists.first.artist!.name
            : '';
        final bName = b.artists.isNotEmpty && b.artists.first.artist != null
            ? b.artists.first.artist!.name
            : '';
        return bName.compareTo(aName);
      });
      break;
    case SortOption.titleAsc:
      releases.sort((a, b) => a.title.compareTo(b.title));
      break;
    case SortOption.titleDesc:
      releases.sort((a, b) => b.title.compareTo(a.title));
      break;
    case SortOption.yearAsc:
      releases.sort((a, b) {
        final aYear = a.year ?? 0;
        final bYear = b.year ?? 0;
        return aYear.compareTo(bYear);
      });
      break;
    case SortOption.yearDesc:
      releases.sort((a, b) {
        final aYear = a.year ?? 0;
        final bYear = b.year ?? 0;
        return bYear.compareTo(aYear);
      });
      break;
    case SortOption.recentlyAdded:
      releases.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortOption.recentlyPlayed:
      releases.sort((a, b) {
        final aLastPlayed = a.playHistory.isNotEmpty
            ? a.playHistory.map((p) => p.playedAt).reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
            : DateTime(1900);
        final bLastPlayed = b.playHistory.isNotEmpty
            ? b.playHistory.map((p) => p.playedAt).reduce((v1, v2) => v1.isAfter(v2) ? v1 : v2)
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
