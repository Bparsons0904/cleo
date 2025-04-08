// lib/features/collection/presentation/widgets/collection_search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cleo/core/theme/theme.dart';
import '../../data/providers/collection_filter_provider.dart';

class CollectionSearchBar extends ConsumerStatefulWidget {
  const CollectionSearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<CollectionSearchBar> createState() => _CollectionSearchBarState();
}

class _CollectionSearchBarState extends ConsumerState<CollectionSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controller with current search query
    final currentQuery = ref.read(collectionFilterProvider).searchQuery;
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
    ref.read(collectionFilterProvider.notifier).setSearchQuery(_searchController.text);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by album or artist...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(collectionFilterProvider.notifier).setSearchQuery('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: CleoSpacing.borderRadius,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        textInputAction: TextInputAction.search,
        autocorrect: false,
        autofocus: false,
      ),
    );
  }
}
