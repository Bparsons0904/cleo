// lib/features/collection/data/filters/collection_filter_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cleo/data/models/models.dart';
import 'collection_filter_state.dart';

class CollectionFilterNotifier extends StateNotifier<CollectionFilterState> {
  CollectionFilterNotifier() : super(CollectionFilterState());
  
  // Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
  
  // Set the sort option
  void setSortOption(CollectionSortOption option) {
    state = state.copyWith(sortOption: option);
  }
  
  // Toggle a genre in the filter
  void toggleGenre(String genre) {
    final List<String> updatedGenres = List.from(state.selectedGenres);
    
    if (updatedGenres.contains(genre)) {
      updatedGenres.remove(genre);
    } else {
      updatedGenres.add(genre);
    }
    
    state = state.copyWith(selectedGenres: updatedGenres);
  }
  
  // Set selected genres (replacing current selection)
  void setSelectedGenres(List<String> genres) {
    state = state.copyWith(selectedGenres: genres);
  }
  
  // Toggle a folder selection
  void toggleFolder(int folderId) {
    final List<int> updatedFolders = List.from(state.selectedFolders);
    
    if (updatedFolders.contains(folderId)) {
      updatedFolders.remove(folderId);
    } else {
      updatedFolders.add(folderId);
    }
    
    state = state.copyWith(selectedFolders: updatedFolders);
  }
  
  // Toggle a year in the filter
  void toggleYear(int year) {
    final List<int> updatedYears = List.from(state.selectedYears);
    
    if (updatedYears.contains(year)) {
      updatedYears.remove(year);
    } else {
      updatedYears.add(year);
    }
    
    state = state.copyWith(selectedYears: updatedYears);
  }
  
  // Set play status filter
  void setPlayStatus(PlayRecencyStatus? status) {
    state = state.copyWith(
      playStatus: status,
      clearPlayStatus: status == null,
    );
  }
  
  // Set cleaning status filter
  void setCleaningStatus(CleanlinessStatus? status) {
    state = state.copyWith(
      cleaningStatus: status,
      clearCleaningStatus: status == null,
    );
  }
  
  // Reset all filters
  void resetFilters() {
    state = state.copyWith(
      selectedGenres: [],
      selectedFolders: [],
      selectedYears: [],
      clearPlayStatus: true,
      clearCleaningStatus: true,
    );
  }
  
  // Reset all filters and search
  void resetAll() {
    state = CollectionFilterState(
      sortOption: state.sortOption, // Preserve sort option
    );
  }
}
