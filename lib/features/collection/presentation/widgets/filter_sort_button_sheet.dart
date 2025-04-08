// lib/features/collection/presentation/widgets/filter_sort_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cleo/core/theme/theme.dart';
import 'package:cleo/data/models/models.dart';
import '../../data/filters/collection_filter_state.dart';
import '../../data/providers/collection_filter_provider.dart';

class FilterSortBottomSheet extends ConsumerStatefulWidget {
  const FilterSortBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends ConsumerState<FilterSortBottomSheet> {
  late CollectionFilterState _tempFilterState;
  
  @override
  void initState() {
    super.initState();
    // Clone the current filter state for temporary modifications
    _tempFilterState = ref.read(collectionFilterProvider);
  }
  
  @override
  Widget build(BuildContext context) {
    final availableGenres = ref.watch(availableGenresProvider);
    
    // Calculate the height based on screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSheetHeight = screenHeight * 0.8; // Use 80% of screen height
    
    return Container(
      height: bottomSheetHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar and header
          _buildHeader(),
          
          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Sort section
                _buildSectionTitle('Sort By'),
                _buildSortOptions(),
                
                const Divider(height: 32),
                
                // Filter section
                _buildSectionTitle('Filter By'),
                
                // Genre filters
                _buildFilterSection(
                  title: 'Genre',
                  itemCount: availableGenres.length,
                  itemBuilder: (context, index) {
                    final genre = availableGenres[index];
                    return _buildGenreFilterItem(genre);
                  },
                ),
                
                // Play status filters
                _buildFilterSection(
                  title: 'Play Status',
                  itemCount: PlayRecencyStatus.values.length,
                  itemBuilder: (context, index) {
                    final status = PlayRecencyStatus.values[index];
                    return _buildPlayStatusFilterItem(status);
                  },
                ),
              ],
            ),
          ),
          
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter & Sort',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSortOptions() {
    return Column(
      children: [
        // Albums
        _buildSortOption(
          title: 'Albums (A-Z)',
          value: CollectionSortOption.albumsAZ,
        ),
        _buildSortOption(
          title: 'Albums (Z-A)',
          value: CollectionSortOption.albumsZA,
        ),
        
        // Artists
        _buildSortOption(
          title: 'Artists (A-Z)',
          value: CollectionSortOption.artistsAZ,
        ),
        _buildSortOption(
          title: 'Artists (Z-A)',
          value: CollectionSortOption.artistsZA,
        ),
        
        // Year
        _buildSortOption(
          title: 'Year (Oldest First)',
          value: CollectionSortOption.releaseYear,
        ),
        _buildSortOption(
          title: 'Year (Newest First)',
          value: CollectionSortOption.releaseYearDesc,
        ),
        
        // Other
        _buildSortOption(
          title: 'Recently Added',
          value: CollectionSortOption.recentlyAdded,
        ),
        _buildSortOption(
          title: 'Recently Played',
          value: CollectionSortOption.recentlyPlayed,
        ),
        _buildSortOption(
          title: 'Least Recently Played',
          value: CollectionSortOption.leastRecentlyPlayed,
        ),
      ],
    );
  }
  
  Widget _buildSortOption({
    required String title,
    required CollectionSortOption value,
  }) {
    return RadioListTile<CollectionSortOption>(
      title: Text(title),
      value: value,
      groupValue: _tempFilterState.sortOption,
      onChanged: (newValue) {
        setState(() {
          _tempFilterState = _tempFilterState.copyWith(
            sortOption: newValue,
          );
        });
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
  
  Widget _buildFilterSection({
    required String title,
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubsectionTitle(title),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildGenreFilterItem(String genre) {
    final isSelected = _tempFilterState.selectedGenres.contains(genre);
    
    return CheckboxListTile(
      title: Text(genre),
      value: isSelected,
      onChanged: (bool? value) {
        setState(() {
          final updatedGenres = List<String>.from(_tempFilterState.selectedGenres);
          
          if (value == true) {
            updatedGenres.add(genre);
          } else {
            updatedGenres.remove(genre);
          }
          
          _tempFilterState = _tempFilterState.copyWith(
            selectedGenres: updatedGenres,
          );
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
  
  Widget _buildPlayStatusFilterItem(PlayRecencyStatus status) {
    final isSelected = _tempFilterState.playStatus == status;
    String title;
    
    switch (status) {
      case PlayRecencyStatus.recentlyPlayed:
        title = 'Recently Played (Last 7 days)';
        break;
      case PlayRecencyStatus.playedThisMonth:
        title = 'Played This Month';
        break;
      case PlayRecencyStatus.playedThisYear:
        title = 'Played This Year';
        break;
      case PlayRecencyStatus.notPlayedRecently:
        title = 'Not Played Recently';
        break;
    }
    
    return RadioListTile<PlayRecencyStatus?>(
      title: Text(title),
      value: status,
      groupValue: _tempFilterState.playStatus,
      onChanged: (newValue) {
        setState(() {
          _tempFilterState = _tempFilterState.copyWith(
            playStatus: newValue,
            clearPlayStatus: newValue == null,
          );
        });
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Reset button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  // Reset filters but keep sort
                  _tempFilterState = _tempFilterState.copyWith(
                    selectedGenres: [],
                    selectedFolders: [],
                    selectedYears: [],
                    clearPlayStatus: true,
                    clearCleaningStatus: true,
                  );
                });
              },
              child: const Text('Reset Filters'),
            ),
          ),
          const SizedBox(width: 16),
          
          // Apply button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Apply the filter state
                final notifier = ref.read(collectionFilterProvider.notifier);
                
                // Update all filter state properties
                notifier.setSortOption(_tempFilterState.sortOption);
                notifier.setSelectedGenres(_tempFilterState.selectedGenres);
                
                // Update other filters as needed
                if (_tempFilterState.playStatus != ref.read(collectionFilterProvider).playStatus) {
                  notifier.setPlayStatus(_tempFilterState.playStatus);
                }
                
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
