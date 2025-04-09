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
        onTap: () => _showRecordActions(context, release),
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
                    onPressed: () => _logPlay(context, release),
                    color: Colors.green.shade200,
                    icon: Icons.play_arrow,
                  ),
                  _buildActionButton(
                    context: context,
                    onPressed: () => _logCleaning(context, release),
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
  
  void _showRecordActions(BuildContext context, Release release) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildRecordActionsSheet(context, release),
    );
  }
  
  Widget _buildRecordActionsSheet(BuildContext context, Release release) {
    // Get artist name
    final artistName = release.artists.isNotEmpty && release.artists.first.artist != null
        ? release.artists.first.artist!.name
        : 'Unknown Artist';
        
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with album info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Album art
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: release.thumb.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          release.thumb,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) => const Center(
                            child: Icon(Icons.album, size: 30, color: Colors.grey),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.album, size: 30, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 16),
              // Album info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      release.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      artistName,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (release.year != null)
                      Text(
                        '${release.year}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const Divider(),
        
        // Actions
        ListTile(
          leading: const Icon(Icons.play_arrow, color: Colors.green),
          title: const Text('Log Play'),
          onTap: () {
            Navigator.pop(context);
            _logPlay(context, release);
          },
        ),
        ListTile(
          leading: const Icon(Icons.cleaning_services, color: Colors.blue),
          title: const Text('Log Cleaning'),
          onTap: () {
            Navigator.pop(context);
            _logCleaning(context, release);
          },
        ),
        ListTile(
          leading: const Icon(Icons.all_inclusive),
          title: const Text('Log Play & Cleaning'),
          onTap: () {
            Navigator.pop(context);
            _logBoth(context, release);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('View Record Details'),
          onTap: () {
            Navigator.pop(context);
            _viewRecordDetails(context, release);
          },
        ),
      ],
    );
  }
  
  void _logPlay(BuildContext context, Release release) {
    // Show a dialog with date and stylus selection
    showDialog(
      context: context,
      builder: (context) => _buildLogDialog(context, release, isPlay: true),
    );
  }
  
  void _logCleaning(BuildContext context, Release release) {
    // Show a dialog with date selection
    showDialog(
      context: context,
      builder: (context) => _buildLogDialog(context, release, isPlay: false),
    );
  }
  
  void _logBoth(BuildContext context, Release release) {
    // Show a dialog with options for both play and cleaning
    showDialog(
      context: context,
      builder: (context) => _buildLogBothDialog(context, release),
    );
  }
  
  void _viewRecordDetails(BuildContext context, Release release) {
    // Navigate to record detail screen
    context.push('/record/${release.id}');
  }
  
  Widget _buildLogDialog(BuildContext context, Release release, {required bool isPlay}) {
    final title = isPlay ? 'Log Play' : 'Log Cleaning';
    final actionText = isPlay ? 'Play' : 'Cleaning';
    
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album info
          Text(release.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (release.artists.isNotEmpty && release.artists.first.artist != null)
            Text(release.artists.first.artist!.name),
          const SizedBox(height: 16),
          
          // Date picker field
          const Text('Date'),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              // Show date picker
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              
              if (picked != null) {
                // Handle date selection
                print('Selected date: $picked');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateTime.now().toString().split(' ')[0]),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          
          // Stylus selector (only for plays)
          if (isPlay) ...[
            const SizedBox(height: 16),
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
          ],
          
          // Notes field
          const SizedBox(height: 16),
          const Text('Notes'),
          const SizedBox(height: 8),
          const SizedBox(
            height: 100,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter any notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
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
            // Log the play or cleaning
            print('Logged $actionText for ${release.title}');
            Navigator.pop(context);
            
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$actionText logged successfully')),
            );
          },
          child: Text('Log $actionText'),
        ),
      ],
    );
  }
  
  Widget _buildLogBothDialog(BuildContext context, Release release) {
    return AlertDialog(
      title: const Text('Log Play & Cleaning'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album info
          Text(release.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (release.artists.isNotEmpty && release.artists.first.artist != null)
            Text(release.artists.first.artist!.name),
          const SizedBox(height: 16),
          
          // Date picker field
          const Text('Date'),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              // Show date picker
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              
              if (picked != null) {
                // Handle date selection
                print('Selected date: $picked');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateTime.now().toString().split(' ')[0]),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          
          // Stylus selector
          const SizedBox(height: 16),
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
          
          // Notes field
          const SizedBox(height: 16),
          const Text('Notes'),
          const SizedBox(height: 8),
          const SizedBox(
            height: 100,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter any notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
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
            // Log both play and cleaning
            print('Logged play and cleaning for ${release.title}');
            Navigator.pop(context);
            
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Play and cleaning logged successfully')),
            );
          },
          child: const Text('Log Both'),
        ),
      ],
    );
  }
}
