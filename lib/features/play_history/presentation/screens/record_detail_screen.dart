// lib/features/record_detail/presentation/screens/record_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

/// Provider to get a release by ID from the auth payload
final releaseByIdProvider = Provider.family<Release?, int>((ref, releaseId) {
  final authState = ref.watch(authStateNotifierProvider);
  
  if (authState is AsyncData) {
    final releases = authState.value?.payload?.releases ?? [];
    try {
      return releases.firstWhere(
        (release) => release.id == releaseId,
        orElse: () => throw Exception('Release not found'),
      );
    } catch (e) {
      return null;
    }
  }
  
  return null;
});

class RecordDetailScreen extends ConsumerWidget {
  final int releaseId;

  const RecordDetailScreen({
    super.key,
    required this.releaseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final release = ref.watch(releaseByIdProvider(releaseId));
    final authState = ref.watch(authStateNotifierProvider);
    
    return Scaffold(
      appBar: CleoAppBar(
        title: release?.title ?? 'Record Details',
      ),
      body: authState.when(
        data: (_) {
          if (release == null) {
            return const Center(
              child: Text('Record not found'),
            );
          }
          return _buildRecordDetail(context, release);
        },
        loading: () => const Center(child: CleoLoading()),
        error: (error, _) => Center(
          child: Text('Error loading record: $error'),
        ),
      ),
    );
  }

  Widget _buildRecordDetail(BuildContext context, Release release) {
    // Get artists as comma-separated string
    final artists = release.artists.isEmpty
        ? 'Unknown Artist'
        : release.artists
            .map((a) => a.artist?.name ?? 'Unknown Artist')
            .join(', ');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      // bottomNavigationBar: _buildBottomActions(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album cover
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: release.coverImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          release.coverImage,
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
              const SizedBox(width: 16),
              
              // Basic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      release.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      artists,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (release.year != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Year: ${release.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (release.labels.isNotEmpty &&
                        release.labels[0].label != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Label: ${release.labels[0].label!.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Genres and styles
          if (release.genres.isNotEmpty || release.styles.isNotEmpty) ...[
            CleoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Genres & Styles',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...release.genres.map((genre) => _buildChip(context, genre.name)),
                      ...release.styles.map((style) => _buildChip(context, style.name, isStyle: true)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Play history
          CleoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Play History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (release.playHistory.isEmpty)
                  const Text('No plays recorded yet.'),
                if (release.playHistory.isNotEmpty) ...[
                  Text('${release.playHistory.length} plays recorded'),
                  const SizedBox(height: 8),
                  _buildRecentPlays(context, release.playHistory),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tracks
          if (release.tracks.isNotEmpty) ...[
            CleoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: release.tracks.length,
                    itemBuilder: (context, index) {
                      final track = release.tracks[index];
                      return ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                        leading: Text(
                          track.position,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(track.title),
                        trailing: Text(
                          track.durationText,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Notes
          if (release.notes.isNotEmpty) ...[
            CleoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...release.notes.map((note) => Text(note.value)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, {bool isStyle = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isStyle
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isStyle
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isStyle
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildRecentPlays(BuildContext context, List<PlayHistory> playHistory) {
    // Take the most recent 3 plays
    final recentPlays = List<PlayHistory>.from(playHistory)
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt))
      ..take(3);
    
    return Column(
      children: recentPlays.map((play) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(play.playedAt),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (play.stylus != null)
                Text(
                  play.stylus!.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => _logPlay(context),
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Log Play',
          ),
          IconButton(
            onPressed: () => _logCleaning(context),
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Log Cleaning',
          ),
          IconButton(
            onPressed: () => _addNote(context),
            icon: const Icon(Icons.note_add),
            tooltip: 'Add Note',
          ),
        ],
      ),
    );
  }

  void _logPlay(BuildContext context) {
    // Show dialog for logging play
    showDialog(
      context: context,
      builder: (context) => _buildLogPlayDialog(context),
    );
  }

  void _logCleaning(BuildContext context) {
    // Show dialog for logging cleaning
    showDialog(
      context: context,
      builder: (context) => _buildLogCleaningDialog(context),
    );
  }

  void _addNote(BuildContext context) {
    // Show dialog for adding note
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter your note here...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle adding note
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogPlayDialog(BuildContext context) {
    final now = DateTime.now();
    
    return AlertDialog(
      title: const Text('Log Play'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          const Text('Date'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MM/dd/yyyy').format(now)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Stylus selector
          const Text('Stylus Used'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MP-110 (Primary)'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Notes field
          const Text('Notes'),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter any notes about this play...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle logging play
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Play logged successfully')),
            );
          },
          child: const Text('Log Play'),
        ),
      ],
    );
  }

  Widget _buildLogCleaningDialog(BuildContext context) {
    final now = DateTime.now();
    
    return AlertDialog(
      title: const Text('Log Cleaning'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          const Text('Date'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MM/dd/yyyy').format(now)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Notes field
          const Text('Notes'),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter any notes about this cleaning...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle logging cleaning
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cleaning logged successfully')),
            );
          },
          child: const Text('Log Cleaning'),
        ),
      ],
    );
  }
}
