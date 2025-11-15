import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';

/// Updated play history screen for Waugzee API
/// Shows all logged play sessions
class PlayHistoryScreenNew extends ConsumerStatefulWidget {
  const PlayHistoryScreenNew({super.key});

  @override
  ConsumerState<PlayHistoryScreenNew> createState() => _PlayHistoryScreenNewState();
}

class _PlayHistoryScreenNewState extends ConsumerState<PlayHistoryScreenNew> {
  final _dateFormat = DateFormat('MMM d, yyyy');
  final _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Get actual play history from UserRepository via provider
    final playHistory = <dynamic>[]; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play History'),
        elevation: 0,
      ),
      body: playHistory.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                // Stats Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(CleoSpacing.lg),
                  decoration: BoxDecoration(
                    color: CleoColors.primary.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.play_circle_outline,
                        label: 'Total Plays',
                        value: '${playHistory.length}',
                      ),
                      _buildStatItem(
                        icon: Icons.calendar_today,
                        label: 'This Month',
                        value: '0', // TODO: Calculate
                      ),
                      _buildStatItem(
                        icon: Icons.trending_up,
                        label: 'This Week',
                        value: '0', // TODO: Calculate
                      ),
                    ],
                  ),
                ),

                // Play History List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(CleoSpacing.md),
                    itemCount: playHistory.length,
                    itemBuilder: (context, index) {
                      final play = playHistory[index];
                      return _buildPlayCard(play);
                    },
                  ),
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
              Icons.history,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: CleoSpacing.lg),
            Text(
              'No Play History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            Text(
              'Start logging your listening sessions to see them here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: CleoColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: CleoColors.primary, size: 28),
        const SizedBox(height: CleoSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: CleoColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayCard(dynamic play) {
    // TODO: Use actual PlayHistoryNew model
    final playedAt = DateTime.now(); // Placeholder

    return Card(
      margin: const EdgeInsets.only(bottom: CleoSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(CleoSpacing.md),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.album,
            color: Colors.grey.shade400,
          ),
        ),
        title: const Text(
          'Release Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text('Artist Name'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: CleoColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${_dateFormat.format(playedAt)} at ${_timeFormat.format(playedAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: CleoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _handleDeletePlay(play);
            }
          },
        ),
      ),
    );
  }

  void _handleDeletePlay(dynamic play) {
    // TODO: Implement delete with PlayHistoryRepositoryNew
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Play'),
        content: const Text('Are you sure you want to delete this play session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Play deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
