// lib/features/log_play/presentation/screens/log_play_screen.dart
import 'package:cleo/core/utils/quick_actions.dart';
import 'package:cleo/features/folders/data/providers/folder_selection_provider.dart';
import 'package:cleo/features/home/presentation/widgets/folder_selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../data/providers/log_play_filter_provider.dart';
import '../../data/providers/log_play_providers.dart';
import '../widgets/log_play_search_bar.dart';
import '../widgets/log_play_sort_dropdown.dart';

class LogPlayScreen extends ConsumerWidget {
  const LogPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get filtered releases
    final filteredReleases = ref.watch(filteredLogPlayReleasesProvider);

    return Scaffold(
      appBar: CleoAppBar(
        title:
            ref.watch(selectedFolderNameProvider) != null
                ? 'Log Play - ${ref.watch(selectedFolderNameProvider)}'
                : 'Log Play',
        showBackButton: false,
        actions: const [FolderSelectionMenu()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header description
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Record when you play or clean records from your collection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Search bar
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LogPlaySearchBar(),
          ),

          // Sort dropdown
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: LogPlaySortDropdown(),
          ),

          // Collection grid
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Your Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // Collection grid
          Expanded(child: _buildCollectionGrid(context, filteredReleases)),
        ],
      ),
    );
  }

  Widget _buildCollectionGrid(BuildContext context, List<Release> releases) {
    if (releases.isEmpty) {
      return const Center(
        child: Text('No records found. Try a different search term.'),
      );
    }

    // Determine number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: releases.length,
      itemBuilder: (context, index) {
        final release = releases[index];
        return ReleaseGridItem(release: release);
      },
    );
  }
}

class ReleaseGridItem extends ConsumerWidget {
  final Release release;

  const ReleaseGridItem({super.key, required this.release});

  // Update the ReleaseGridItem build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get artist name
    final artistName =
        release.artists.isNotEmpty && release.artists.first.artist != null
            ? release.artists.first.artist!.name
            : 'Unknown Artist';

    // Get release year if available
    final releaseYear = release.year?.toString() ?? '';

    // Watch log play state to handle loading
    final logPlayState = ref.watch(logPlayNotifierProvider);
    final isLoading = logPlayState is AsyncLoading;

    // Calculate play recency score and color
    final lastPlayedDate = RecordStatusUtils.getLastPlayDate(
      release.playHistory,
    );
    final playRecencyScore = RecordStatusUtils.getPlayRecencyScore(
      lastPlayedDate,
    );
    final playColor = RecordStatusUtils.getPlayRecencyColor(playRecencyScore);

    // Calculate cleanliness score and color
    final lastCleanedDate = RecordStatusUtils.getLastCleaningDate(
      release.cleaningHistory,
    );
    final playsSinceCleaning = RecordStatusUtils.countPlaysSinceCleaning(
      release.playHistory,
      lastCleanedDate,
    );
    final cleanlinessScore = RecordStatusUtils.getCleanlinessScore(
      lastCleanedDate,
      playsSinceCleaning,
    );
    final cleanColor = RecordStatusUtils.getCleanlinessColor(cleanlinessScore);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetailScreen(context, release),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  release.thumb.isNotEmpty
                      ? Image.network(
                        release.thumb,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder:
                            (context, error, _) => _buildPlaceholderImage(),
                      )
                      : _buildPlaceholderImage(),
                  // Show loading indicator if an action is in progress
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),

            // Title and artist
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    release.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    artistName,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (releaseYear.isNotEmpty)
                    Text(
                      releaseYear,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    context: context,
                    onPressed: () => _handleQuickPlay(context, ref),
                    icon: Icons.play_arrow,
                    tooltip: RecordStatusUtils.getPlayRecencyText(
                      lastPlayedDate,
                    ),
                    color: playColor,
                  ),
                  _buildActionButton(
                    context: context,
                    onPressed: () => _handleQuickCleaning(context, ref),
                    icon: Icons.cleaning_services,
                    tooltip: RecordStatusUtils.getCleanlinessText(
                      cleanlinessScore,
                    ),
                    color: cleanColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.album, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
    required Color color,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }

  void _navigateToDetailScreen(BuildContext context, Release release) {
    context.push('/log-play-detail/${release.id}');
  }

  void _handleQuickPlay(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(logPlayNotifierProvider.notifier).quickLogPlay(release.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged play for "${release.title}"')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log play: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleQuickCleaning(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(logPlayNotifierProvider.notifier)
          .quickLogCleaning(release.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged cleaning for "${release.title}"')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log cleaning: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
