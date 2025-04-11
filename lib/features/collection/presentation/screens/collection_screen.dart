// lib/features/collection/presentation/screens/collection_screen.dart

import 'package:cleo/features/folders/data/providers/folder_selection_provider.dart';
import 'package:cleo/features/home/presentation/widgets/folder_selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../data/filters/collection_filter_state.dart';
import '../../data/providers/collection_filter_provider.dart';
import '../widgets/collection_search_bar.dart';
import '../widgets/filter_sort_button.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredReleases = ref.watch(filteredCollectionProvider);
    final filterState = ref.watch(collectionFilterProvider);

    return Scaffold(
      appBar: CleoAppBar(
        title:
            ref.watch(selectedFolderNameProvider) != null
                ? 'Collection - ${ref.watch(selectedFolderNameProvider)}'
                : 'Collection',
        showBackButton: false,
        actions: const [FolderSelectionMenu()],
      ),
      body: Column(
        children: [
          // Search Bar
          const CollectionSearchBar(),

          // Filter and Sort Controls
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                // Filter button
                const FilterSortButton(),

                const Spacer(),

                // View toggle (for desktop/tablet)
                if (MediaQuery.of(context).size.width >= 600) ...[
                  IconButton(
                    icon: const Icon(Icons.grid_view),
                    onPressed: () {
                      // Toggle to grid view
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.view_list),
                    onPressed: () {
                      // Toggle to list view
                    },
                  ),
                ],
              ],
            ),
          ),

          // Active filters display (optional)
          if (filterState.hasFilters)
            _buildActiveFilters(context, filterState, ref),

          // Collection Grid/List
          Expanded(
            child:
                filteredReleases.isEmpty
                    ? const _EmptyCollectionView()
                    : _buildCollectionGrid(context, filteredReleases),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(
    BuildContext context,
    CollectionFilterState filterState,
    ref,
  ) {
    // Display active filters as pills/chips
    final List<Widget> filterChips = [];

    // Add genre filters
    for (final genre in filterState.selectedGenres) {
      filterChips.add(
        _buildFilterChip(
          context,
          label: genre,
          onRemove: () {
            // Use ref instead of context to access the provider
            ref.read(collectionFilterProvider.notifier).toggleGenre(genre);
          },
        ),
      );
    }

    // Add play status filter if selected
    if (filterState.playStatus != null) {
      String statusLabel;
      switch (filterState.playStatus!) {
        case PlayRecencyStatus.recentlyPlayed:
          statusLabel = 'Recently Played';
          break;
        case PlayRecencyStatus.playedThisMonth:
          statusLabel = 'Played This Month';
          break;
        case PlayRecencyStatus.playedThisYear:
          statusLabel = 'Played This Year';
          break;
        case PlayRecencyStatus.notPlayedRecently:
          statusLabel = 'Not Played Recently';
          break;
      }

      filterChips.add(
        _buildFilterChip(
          context,
          label: statusLabel,
          onRemove: () {
            // Use ref instead of context to access the provider
            ref.read(collectionFilterProvider.notifier).setPlayStatus(null);
          },
        ),
      );
    }

    if (filterChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < filterChips.length; i++) ...[
              filterChips[i],
              if (i < filterChips.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required VoidCallback onRemove,
  }) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      deleteIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  Widget _buildCollectionGrid(BuildContext context, List<Release> releases) {
    // Determine number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth >= 1200
            ? 5
            : (screenWidth >= 800 ? 4 : (screenWidth >= 600 ? 3 : 2));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // Adjust as needed for your album covers
      ),
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return _ReleaseGridItem(release: release);
      },
    );
  }
}

class _ReleaseGridItem extends StatelessWidget {
  final Release release;

  const _ReleaseGridItem({required this.release});

  @override
  Widget build(BuildContext context) {
    // Debug print to understand what's happening
    print('Release: ${release.title}, Image URL: ${release.thumb}');

    return InkWell(
      onTap: () {
        context.go('/record/${release.id}');
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                release.thumb.isNotEmpty
                    ? release.thumb
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.album, size: 48, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),

          // Album title
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              release.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

          // Artist name
          if (release.artists.isNotEmpty &&
              release.artists.first.artist != null)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                release.artists.first.artist!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyCollectionView extends StatelessWidget {
  const _EmptyCollectionView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.album,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No records found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your filters or sync with Discogs',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Trigger sync
            },
            icon: const Icon(Icons.sync),
            label: const Text('Sync Collection'),
          ),
        ],
      ),
    );
  }
}
