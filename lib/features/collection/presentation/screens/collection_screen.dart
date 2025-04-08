// lib/features/collection/presentation/screens/collection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

/// Screen that displays the user's vinyl collection
class CollectionScreen extends ConsumerWidget {
  /// Constructor
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get data directly from the auth payload
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Collection',
        showBackButton: false,
      ),
      body: authState.when(
        data: (data) {
          final releases = data.payload?.releases ?? [];
          return _buildCollectionGrid(context, releases);
        },
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading collection: $error'),
        ),
      ),
    );
  }

  Widget _buildCollectionGrid(BuildContext context, List<Release> collection) {
    if (collection.isEmpty) {
      return const Center(
        child: Text('Your collection is empty. Sync with Discogs to get started.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: collection.length,
      itemBuilder: (context, index) {
        final release = collection[index];
        return _buildAlbumCard(context, release);
      },
    );
  }

  Widget _buildAlbumCard(BuildContext context, Release release) {
    final hasArtists = release.artists.isNotEmpty && release.artists[0].artist != null;
    final artistName = hasArtists ? release.artists[0].artist!.name : 'Unknown Artist';
    
    return CleoCard(
      onTap: () {
        context.go('${AppRoutes.recordDetail.replaceAll(':id', '')}${release.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: release.thumb.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        release.thumb,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, _) => const Center(
                          child: Icon(Icons.album, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.album, size: 50, color: Colors.grey),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            release.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          // Artist
          Text(
            artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Year
          if (release.year != null)
            Text(
              release.year.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
