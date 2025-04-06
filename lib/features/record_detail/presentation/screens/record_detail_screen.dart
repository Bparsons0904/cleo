import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../collection/data/providers/collection_providers.dart';

final releaseProvider = FutureProvider.family<Release?, int>((ref, releaseId) async {
  final collectionAsync = await ref.watch(collectionNotifierProvider.future);
  return collectionAsync.firstWhere(
    (release) => release.id == releaseId,
    orElse: () => throw Exception('Release not found'),
  );
});

/// Screen that displays record details
class RecordDetailScreen extends ConsumerWidget {
  /// The ID of the release to display
  final int releaseId;

  /// Constructor
  const RecordDetailScreen({
    Key? key,
    required this.releaseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final releaseAsync = ref.watch(releaseProvider(releaseId));

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Record Details',
      ),
      body: releaseAsync.when(
        data: (release) => _buildRecordDetail(context, release!, ref),
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading record: $error'),
        ),
      ),
      bottomNavigationBar: releaseAsync.when(
        data: (release) => _buildBottomActions(context, ref),
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildRecordDetail(BuildContext context, Release release, WidgetRef ref) {
    // This is a placeholder - implement actual detail view
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            release.title,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          if (release.artists.isNotEmpty)
            Text(
              'By ${release.artists.map((a) => a.artist?.name ?? '').join(', ')}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const SizedBox(height: 16.0),
          CleoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                _buildDetailItem('Year', release.year?.toString() ?? 'Unknown'),
                _buildDetailItem(
                  'Genres', 
                  release.genres.map((g) => g.name).join(', ')
                ),
                _buildDetailItem(
                  'Styles', 
                  release.styles.map((s) => s.name).join(', ')
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          CleoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Play History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text('${release.playHistory.length} plays recorded'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // Show log play dialog
            },
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Log Play',
          ),
          IconButton(
            onPressed: () {
              // Show clean record dialog
            },
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Log Cleaning',
          ),
          IconButton(
            onPressed: () {
              // Show edit notes dialog
            },
            icon: const Icon(Icons.note_add),
            tooltip: 'Add Note',
          ),
        ],
      ),
    );
  }
}
