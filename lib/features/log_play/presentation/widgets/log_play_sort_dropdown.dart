// lib/features/log_play/presentation/widgets/log_play_sort_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/filters/log_play_filter_state.dart';
import '../../data/providers/log_play_filter_provider.dart';

class LogPlaySortDropdown extends ConsumerWidget {
  const LogPlaySortDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(logPlayFilterProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort By'),
        const SizedBox(height: 8),
        DropdownButtonFormField<LogPlaySortOption>(
          value: filterState.sortOption,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          isExpanded: true,
          items: LogPlaySortOption.values.map((option) {
            return DropdownMenuItem<LogPlaySortOption>(
              value: option,
              child: Text(_getSortOptionLabel(option)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              ref.read(logPlayFilterProvider.notifier).setSortOption(value);
            }
          },
        ),
      ],
    );
  }
  
  String _getSortOptionLabel(LogPlaySortOption option) {
    switch (option) {
      case LogPlaySortOption.artistAZ:
        return 'Artist (A-Z)';
      case LogPlaySortOption.artistZA:
        return 'Artist (Z-A)';
      case LogPlaySortOption.albumAZ:
        return 'Album (A-Z)';
      case LogPlaySortOption.albumZA:
        return 'Album (Z-A)';
      case LogPlaySortOption.genre:
        return 'Genre';
      case LogPlaySortOption.lastPlayed:
        return 'Last Played';
      case LogPlaySortOption.recentlyPlayed:
        return 'Recently Played';
      case LogPlaySortOption.releaseYear:
        return 'Release Year';
      case LogPlaySortOption.mostPlayed:
        return 'Most Played';
      case LogPlaySortOption.leastPlayed:
        return 'Least Played';
    }
  }
}
