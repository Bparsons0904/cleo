// lib/features/collection/data/filters/collection_filter_state.dart

import 'package:cleo/data/models/models.dart';

enum CollectionSortOption {
  albumsAZ,        // Albums A-Z
  albumsZA,        // Albums Z-A
  artistsAZ,       // Artists A-Z 
  artistsZA,       // Artists Z-A
  releaseYear,     // Release Year (oldest first)
  releaseYearDesc, // Release Year (newest first)
  recentlyAdded,   // Recently Added
  recentlyPlayed,  // Recently Played
  leastRecentlyPlayed, // Least Recently Played
}

class CollectionFilterState {
  // Search query
  final String searchQuery;
  
  // Selected sort option
  final CollectionSortOption sortOption;
  
  // Selected genres for filtering
  final List<String> selectedGenres;
  
  // Selected folders
  final List<int> selectedFolders;
  
  // Selected years
  final List<int> selectedYears;
  
  // Filter by play status
  final PlayRecencyStatus? playStatus;
  
  // Filter by cleaning status
  final CleanlinessStatus? cleaningStatus;
  
  // Constructor with default values
  CollectionFilterState({
    this.searchQuery = '',
    this.sortOption = CollectionSortOption.albumsAZ, // Default sort
    this.selectedGenres = const [],
    this.selectedFolders = const [],
    this.selectedYears = const [],
    this.playStatus,
    this.cleaningStatus,
  });
  
  // Create a copy with updated fields
  CollectionFilterState copyWith({
    String? searchQuery,
    CollectionSortOption? sortOption,
    List<String>? selectedGenres,
    List<int>? selectedFolders,
    List<int>? selectedYears,
    PlayRecencyStatus? playStatus,
    bool clearPlayStatus = false,
    CleanlinessStatus? cleaningStatus,
    bool clearCleaningStatus = false,
  }) {
    return CollectionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      selectedFolders: selectedFolders ?? this.selectedFolders,
      selectedYears: selectedYears ?? this.selectedYears,
      playStatus: clearPlayStatus ? null : (playStatus ?? this.playStatus),
      cleaningStatus: clearCleaningStatus ? null : (cleaningStatus ?? this.cleaningStatus),
    );
  }
  
  // Check if any filters are applied
  bool get hasFilters => 
    selectedGenres.isNotEmpty || 
    selectedFolders.isNotEmpty || 
    selectedYears.isNotEmpty || 
    playStatus != null || 
    cleaningStatus != null;
    
  // Get the count of active filters
  int get activeFilterCount => 
    (selectedGenres.isNotEmpty ? 1 : 0) +
    (selectedFolders.isNotEmpty ? 1 : 0) +
    (selectedYears.isNotEmpty ? 1 : 0) +
    (playStatus != null ? 1 : 0) +
    (cleaningStatus != null ? 1 : 0);
}
