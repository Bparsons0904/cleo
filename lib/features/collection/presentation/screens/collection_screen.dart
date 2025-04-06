import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../data/providers/collection_providers.dart';

/// Screen that displays the user's vinyl collection
class CollectionScreen extends ConsumerWidget {
  /// Constructor
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(filteredCollectionProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Collection',
        showBackButton: false,
      ),
      body: collectionAsync.when(
        data: (collection) => _buildCollectionGrid(context, collection),
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading collection: $error'),
        ),
      ),
    );
  }

  Widget _buildCollectionGrid(BuildContext context, List<dynamic> collection) {
    if (collection.isEmpty) {
      return const Center(
        child: Text('Your collection is empty. Sync with Discogs to get started.'),
      );
    }

    // This is a placeholder - implement actual grid display
    return Center(
      child: Text('${collection.length} records in your collection'),
    );
  }
}
