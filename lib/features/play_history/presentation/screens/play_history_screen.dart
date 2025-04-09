// lib/features/play_history/presentation/screens/play_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

class PlayHistoryScreen extends ConsumerStatefulWidget {
  const PlayHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlayHistoryScreen> createState() => _PlayHistoryScreenState();
}

class _PlayHistoryScreenState extends ConsumerState<PlayHistoryScreen> {
  String _filterOption = 'All Time';
  String _groupingOption = 'By Date';
  
  // Filter options
  final List<String> _filterOptions = [
    'Last Week',
    'Last Month',
    'Last Year',
    'All Time',
  ];
  
  // Grouping options
  final List<String> _groupingOptions = [
    'By Date',
    'By Artist',
    'By Album',
    'None',
  ];

  @override
  Widget build(BuildContext context) {
    // Get auth state for play history
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Play History',
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter and grouping controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Time filter dropdown
                Expanded(
                  child: _buildFilterDropdown(),
                ),
                
                const SizedBox(width: 16),
                
                // Grouping dropdown
                Expanded(
                  child: _buildGroupingDropdown(),
                ),
              ],
            ),
          ),
          
          // Play history list
          Expanded(
            child: authState.when(
              data: (authData) {
                final playHistory = authData.payload?.playHistory ?? [];
                final releases = authData.payload?.releases ?? [];
                
                if (playHistory.isEmpty) {
                  return const Center(
                    child: Text('No play history found. Start logging plays to see them here.'),
                  );
                }
                
                return _buildPlayHistoryList(playHistory, releases);
              },
              loading: () => const Center(child: CleoLoading()),
              error: (error, _) => Center(
                child: Text('Error loading play history: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      value: _filterOption,
      decoration: InputDecoration(
        labelText: 'Time Period',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _filterOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _filterOption = value;
          });
        }
      },
    );
  }
  
  Widget _buildGroupingDropdown() {
    return DropdownButtonFormField<String>(
      value: _groupingOption,
      decoration: InputDecoration(
        labelText: 'Group By',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _groupingOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _groupingOption = value;
          });
        }
      },
    );
  }
  
  Widget _buildPlayHistoryList(List<PlayHistory> playHistory, List<Release> releases) {
    // Apply time filter
    final filteredHistory = _filterPlayHistory(playHistory);
    
    // Apply grouping
    switch (_groupingOption) {
      case 'By Date':
        return _buildDateGroupedList(filteredHistory, releases);
      case 'By Artist':
        return _buildArtistGroupedList(filteredHistory, releases);
      case 'By Album':
        return _buildAlbumGroupedList(filteredHistory, releases);
      case 'None':
        return _buildNonGroupedList(filteredHistory, releases);
      default:
        return _buildDateGroupedList(filteredHistory, releases);
    }
  }
  
  List<PlayHistory> _filterPlayHistory(List<PlayHistory> playHistory) {
    final now = DateTime.now();
    final filteredList = List<PlayHistory>.from(playHistory);
    
    switch (_filterOption) {
      case 'Last Week':
        final oneWeekAgo = now.subtract(const Duration(days: 7));
        filteredList.retainWhere((play) => play.playedAt.isAfter(oneWeekAgo));
        break;
      case 'Last Month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        filteredList.retainWhere((play) => play.playedAt.isAfter(oneMonthAgo));
        break;
      case 'Last Year':
        final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
        filteredList.retainWhere((play) => play.playedAt.isAfter(oneYearAgo));
        break;
      case 'All Time':
        // No filtering needed
        break;
    }
    
    // Sort by date, most recent first
    filteredList.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    
    return filteredList;
  }
  
  Widget _buildDateGroupedList(List<PlayHistory> playHistory, List<Release> releases) {
    // Group by date
    final groupedPlays = <String, List<PlayHistory>>{};
    
    for (final play in playHistory) {
      final date = DateFormat('yyyy-MM-dd').format(play.playedAt);
      if (!groupedPlays.containsKey(date)) {
        groupedPlays[date] = [];
      }
      groupedPlays[date]!.add(play);
    }
    
    return ListView.builder(
      itemCount: groupedPlays.length,
      itemBuilder: (context, index) {
        final date = groupedPlays.keys.elementAt(index);
        final plays = groupedPlays[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                _formatDateHeader(date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Play items
            ...plays.map((play) => _buildPlayItem(play, releases)).toList(),
            const Divider(),
          ],
        );
      },
    );
  }
  
  Widget _buildArtistGroupedList(List<PlayHistory> playHistory, List<Release> releases) {
    // Group by artist
    final groupedPlays = <String, List<PlayHistory>>{};
    
    for (final play in playHistory) {
      // Find release
      final release = _findRelease(play.releaseId, releases);
      if (release == null) continue;
      
      final artistName = release.artists.isNotEmpty && release.artists.first.artist != null
          ? release.artists.first.artist!.name
          : 'Unknown Artist';
      
      if (!groupedPlays.containsKey(artistName)) {
        groupedPlays[artistName] = [];
      }
      groupedPlays[artistName]!.add(play);
    }
    
    // Sort artist names alphabetically
    final sortedArtists = groupedPlays.keys.toList()..sort();
    
    return ListView.builder(
      itemCount: sortedArtists.length,
      itemBuilder: (context, index) {
        final artist = sortedArtists[index];
        final plays = groupedPlays[artist]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artist header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                artist,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Play items
            ...plays.map((play) => _buildPlayItem(play, releases)).toList(),
            const Divider(),
          ],
        );
      },
    );
  }
  
  Widget _buildAlbumGroupedList(List<PlayHistory> playHistory, List<Release> releases) {
    // Group by album
    final groupedPlays = <int, List<PlayHistory>>{};
    
    for (final play in playHistory) {
      if (!groupedPlays.containsKey(play.releaseId)) {
        groupedPlays[play.releaseId] = [];
      }
      groupedPlays[play.releaseId]!.add(play);
    }
    
    // Convert to list of entries for easier sorting
    final albumEntries = groupedPlays.entries.toList();
    
    // Sort by album title
    albumEntries.sort((a, b) {
      final releaseA = _findRelease(a.key, releases);
      final releaseB = _findRelease(b.key, releases);
      
      if (releaseA == null || releaseB == null) return 0;
      
      return releaseA.title.compareTo(releaseB.title);
    });
    
    return ListView.builder(
      itemCount: albumEntries.length,
      itemBuilder: (context, index) {
        final entry = albumEntries[index];
        final release = _findRelease(entry.key, releases);
        final plays = entry.value;
        
        if (release == null) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                release.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Play items
            ...plays.map((play) => _buildPlayItem(play, releases)).toList(),
            const Divider(),
          ],
        );
      },
    );
  }
  
  Widget _buildNonGroupedList(List<PlayHistory> playHistory, List<Release> releases) {
    return ListView.builder(
      itemCount: playHistory.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final play = playHistory[index];
        return _buildPlayItem(play, releases);
      },
    );
  }
  
  Widget _buildPlayItem(PlayHistory play, List<Release> releases) {
    final release = _findRelease(play.releaseId, releases);
    if (release == null) return const SizedBox.shrink();
    
    final hasArtists = release.artists.isNotEmpty && release.artists.first.artist != null;
    final artistName = hasArtists ? release.artists.first.artist!.name : 'Unknown Artist';
    
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
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
                  errorBuilder: (ctx, error, _) => const Center(
                    child: Icon(Icons.album, size: 24, color: Colors.grey),
                  ),
                ),
              )
            : const Center(
                child: Icon(Icons.album, size: 24, color: Colors.grey),
              ),
      ),
      title: Text(release.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(artistName),
          Text(
            DateFormat('MMM d, yyyy - h:mm a').format(play.playedAt),
            style: const TextStyle(fontSize: 12),
          ),
          if (play.stylus != null)
            Text(
              'Stylus: ${play.stylus!.name}',
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      onTap: () => _showRecordDetail(release),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => _showPlayOptions(play),
      ),
    );
  }
  
  Release? _findRelease(int releaseId, List<Release> releases) {
    try {
      return releases.firstWhere((r) => r.id == releaseId);
    } catch (e) {
      return null;
    }
  }
  
  String _formatDateHeader(String dateStr) {
    final date = DateFormat('yyyy-MM-dd').parse(dateStr);
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMMM d, yyyy').format(date);
    }
  }
  
  void _showRecordDetail(Release release) {
    // Navigate to record detail page
    context.push('/record/${release.id}');
  }
  
  void _showPlayOptions(PlayHistory play) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Play'),
            onTap: () {
              Navigator.pop(context);
              _editPlay(play);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Play', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmDeletePlay(play);
            },
          ),
        ],
      ),
    );
  }
  
  void _editPlay(PlayHistory play) {
    // Placeholder for editing play
    print('Edit play ${play.id}');
    
    // Show dialog for editing play
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Play'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            const Text('Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                // Show date picker
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: play.playedAt,
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
                    Text(DateFormat('MM/dd/yyyy').format(play.playedAt)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(play.stylus?.name ?? 'No stylus selected'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notes field
            const Text('Notes'),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter any notes about this play...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              controller: TextEditingController(text: play.notes),
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
              // Handle updating play
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Play updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDeletePlay(PlayHistory play) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Play?'),
        content: const Text('Are you sure you want to delete this play record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle deleting play
              _deletePlay(play);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _deletePlay(PlayHistory play) {
    // Placeholder for deleting play
    print('Delete play ${play.id}');
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Play deleted successfully')),
    );
  }
}
