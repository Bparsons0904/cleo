// lib/features/play_history/presentation/screens/play_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

/// Screen that displays play history
class PlayHistoryScreen extends ConsumerWidget {
  /// Constructor
  const PlayHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get data directly from the auth payload
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Play History',
        showBackButton: false,
      ),
      body: authState.when(
        data: (data) {
          final playHistory = data.payload?.playHistory ?? [];
          return _buildPlayHistoryList(context, playHistory, data.payload?.releases ?? []);
        },
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading play history: $error'),
        ),
      ),
    );
  }

  Widget _buildPlayHistoryList(
    BuildContext context, 
    List<PlayHistory> playHistory,
    List<Release> releases,
  ) {
    if (playHistory.isEmpty) {
      return const Center(
        child: Text('No play history found. Start logging plays to see them here.'),
      );
    }

    // Sort by date, most recent first
    final sortedHistory = List<PlayHistory>.from(playHistory)
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    // Group by date
    final groupedPlays = <String, List<PlayHistory>>{};
    
    for (final play in sortedHistory) {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                _formatDateHeader(date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...plays.map((play) => _buildPlayItem(context, play, releases)),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildPlayItem(
    BuildContext context, 
    PlayHistory play,
    List<Release> releases,
  ) {
    // Find the release in our collection
    final release = releases.firstWhere(
      (r) => r.id == play.releaseId,
      orElse: () => Release(
        id: play.releaseId,
        instanceId: 0,
        folderId: 0, 
        rating: 0, 
        title: 'Unknown Record',
        resourceUrl: '',
        thumb: '',
        coverImage: '',
        playDurationEstimated: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        artists: [],
        labels: [],
        formats: [],
        genres: [],
        styles: [],
        notes: [],
        playHistory: [],
        cleaningHistory: [],
        tracks: [],
      ),
    );
    
    final hasArtists = release.artists.isNotEmpty && release.artists[0].artist != null;
    final artistName = hasArtists ? release.artists[0].artist!.name : 'Unknown Artist';

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
          if (play.stylus != null)
            Text('Stylus: ${play.stylus!.name}', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      trailing: Text(
        DateFormat('h:mm a').format(play.playedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        context.go('${AppRoutes.recordDetail.replaceAll(':id', '')}${release.id}');
      },
    );
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
}
