import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../data/providers/play_history_providers.dart';

/// Screen that displays play history
class PlayHistoryScreen extends ConsumerWidget {
  /// Constructor
  const PlayHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playHistoryAsync = ref.watch(playHistoryNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Play History',
        showBackButton: false,
      ),
      body: playHistoryAsync.when(
        data: (playHistory) => _buildPlayHistoryList(context, playHistory),
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading play history: $error'),
        ),
      ),
    );
  }

  Widget _buildPlayHistoryList(BuildContext context, List<dynamic> playHistory) {
    if (playHistory.isEmpty) {
      return const Center(
        child: Text('No play history found. Start logging plays to see them here.'),
      );
    }

    // This is a placeholder - implement actual history display
    return Center(
      child: Text('${playHistory.length} plays in your history'),
    );
  }
}
