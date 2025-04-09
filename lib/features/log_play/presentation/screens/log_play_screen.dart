// lib/features/log_play/presentation/screens/log_play_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../data/providers/log_play_filter_provider.dart';
import '../widgets/log_play_search_bar.dart';
import '../widgets/log_play_sort_dropdown.dart';
import 'log_play_detail_screen.dart';

class LogPlayScreen extends ConsumerWidget {
  const LogPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get filtered releases
    final filteredReleases = ref.watch(filteredLogPlayReleasesProvider);
    
    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Log Play & Cleaning',
        showBackButton: false,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Collection grid
          Expanded(
            child: _buildCollectionGrid(context, filteredReleases),
          ),
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

// Move this to a separate StatelessWidget so it has its own BuildContext
class ReleaseGridItem extends StatelessWidget {
  final Release release;
  
  const ReleaseGridItem({super.key, required this.release});
  
  @override
  Widget build(BuildContext context) {
    // Get artist name
    final artistName = release.artists.isNotEmpty && release.artists.first.artist != null
        ? release.artists.first.artist!.name
        : 'Unknown Artist';
    
    // Get release year if available
    final releaseYear = release.year?.toString() ?? '';
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetailScreen(context, release),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Expanded(
              child: release.thumb.isNotEmpty
                  ? Image.network(
                      release.thumb,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, _) => _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
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
                    onPressed: () => _navigateToDetailScreen(context, release),
                    color: Colors.green.shade200,
                    icon: Icons.play_arrow,
                  ),
                  _buildActionButton(
                    context: context,
                    onPressed: () => _navigateToDetailScreen(context, release),
                    color: Colors.blue.shade200,
                    icon: Icons.cleaning_services,
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
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
  
  void _navigateToDetailScreen(BuildContext context, Release release) {
    // Navigate to the detail screen using GoRouter
    // We're using context.push instead of context.go to maintain navigation history
    // This way, users can go back to the log play screen after viewing details
    context.push('/log-play-detail/${release.id}');
  }
}
