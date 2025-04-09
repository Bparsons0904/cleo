// lib/features/log_play/presentation/widgets/log_play_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/log_play_filter_provider.dart';

class LogPlaySearchBar extends ConsumerStatefulWidget {
  const LogPlaySearchBar({super.key});

  @override
  ConsumerState<LogPlaySearchBar> createState() => _LogPlaySearchBarState();
}

class _LogPlaySearchBarState extends ConsumerState<LogPlaySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with current search query
    final currentQuery = ref.read(logPlayFilterProvider).searchQuery;
    _searchController.text = currentQuery;
    
    // Add listener for text changes
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    ref.read(logPlayFilterProvider.notifier).setSearchQuery(_searchController.text);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Search Your Collection'),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by title or artist...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ],
    );
  }
}
