import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';

/// Screen that displays analytics and visualizations
class AnalyticsScreen extends ConsumerWidget {
  /// Constructor
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Analytics',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listening Analytics',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24.0),
            _buildPlaceholderCard(
              context,
              'Play Frequency',
              'Chart showing your play frequency over time',
              Icons.show_chart,
            ),
            const SizedBox(height: 16.0),
            _buildPlaceholderCard(
              context,
              'Genre Distribution',
              'Chart showing your genre preferences',
              Icons.pie_chart,
            ),
            const SizedBox(height: 16.0),
            _buildPlaceholderCard(
              context,
              'Top Artists',
              'Your most played artists',
              Icons.people,
            ),
            const SizedBox(height: 16.0),
            _buildPlaceholderCard(
              context,
              'Listening Time',
              'Your total listening time',
              Icons.timer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return CleoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(description),
            ),
          ),
        ],
      ),
    );
  }
}
