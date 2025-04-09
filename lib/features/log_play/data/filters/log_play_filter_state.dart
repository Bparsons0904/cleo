// lib/features/log_play/data/filters/log_play_filter_state.dart
import 'package:flutter/material.dart';

enum LogPlaySortOption {
  artistAZ,
  artistZA,
  albumAZ,
  albumZA,
  genre,
  lastPlayed,
  recentlyPlayed, 
  releaseYear,
  mostPlayed,
  leastPlayed,
}

class LogPlayFilterState {
  final String searchQuery;
  final LogPlaySortOption sortOption;
  
  const LogPlayFilterState({
    this.searchQuery = '',
    this.sortOption = LogPlaySortOption.artistAZ,
  });
  
  LogPlayFilterState copyWith({
    String? searchQuery,
    LogPlaySortOption? sortOption,
  }) {
    return LogPlayFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
