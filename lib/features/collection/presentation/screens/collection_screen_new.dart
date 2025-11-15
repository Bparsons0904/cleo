import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../data/providers/collection_providers.dart';
import '../../../../data/models/user_release.dart';

/// Updated collection screen for Waugzee API
/// Shows user's vinyl collection with search and filtering
class CollectionScreenNew extends ConsumerStatefulWidget {
  const CollectionScreenNew({super.key});

  @override
  ConsumerState<CollectionScreenNew> createState() => _CollectionScreenNewState();
}

class _CollectionScreenNewState extends ConsumerState<CollectionScreenNew> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get filtered collection from provider
    final filteredReleases = ref.watch(filteredCollectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _handleSync,
            tooltip: 'Sync with Discogs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(CleoSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your collection...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                ref
                    .read(collectionFilterNotifierProvider.notifier)
                    .setSearchQuery(value);
              },
            ),
          ),

          // Collection Stats
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CleoSpacing.md,
              vertical: CleoSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredReleases.length} records',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Show filter dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filters coming soon')),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                ),
              ],
            ),
          ),

          // Collection Grid
          Expanded(
            child: filteredReleases.isEmpty
                ? _buildEmptyState(context)
                : _buildCollectionGrid(filteredReleases),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_music,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: CleoSpacing.lg),
            Text(
              'No Records Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            Text(
              'Sync with Discogs to import your collection',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: CleoColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CleoSpacing.xl),
            ElevatedButton.icon(
              onPressed: _handleSync,
              icon: const Icon(Icons.sync),
              label: const Text('Sync Collection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CleoColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: CleoSpacing.lg,
                  vertical: CleoSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionGrid(List<UserRelease> releases) {
    return GridView.builder(
      padding: const EdgeInsets.all(CleoSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        crossAxisSpacing: CleoSpacing.md,
        mainAxisSpacing: CleoSpacing.md,
        childAspectRatio: 0.7,
      ),
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final userRelease = releases[index];
        return _buildReleaseCard(userRelease);
      },
    );
  }

  Widget _buildReleaseCard(UserRelease userRelease) {
    final release = userRelease.release;
    final title = release?.title ?? 'Unknown Title';
    final artist = release?.artists.isNotEmpty == true &&
            release!.artists.first.artist != null
        ? release.artists.first.artist!.name
        : 'Unknown Artist';
    final imageUrl = release?.coverImage;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (release != null) {
            context.push('${AppRoutes.recordDetail}/${release.id}');
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Art
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.album,
                            size: 48,
                            color: Colors.grey.shade400,
                          );
                        },
                      )
                    : Icon(
                        Icons.album,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
              ),
            ),
            // Release Info
            Padding(
              padding: const EdgeInsets.all(CleoSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: CleoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5;
    if (width > 800) return 4;
    if (width > 600) return 3;
    return 2;
  }

  Future<void> _handleSync() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syncing with Discogs...'),
        ),
      );

      await ref.read(collectionNotifierProvider.notifier).syncCollection();

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sync completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
