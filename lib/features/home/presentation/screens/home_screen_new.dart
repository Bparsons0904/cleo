import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/theme.dart';

/// Updated Home screen with user-focused design
/// Shows daily recommendation, streak, and quick actions
class HomeScreenNew extends ConsumerWidget {
  const HomeScreenNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleo'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(CleoSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CleoColors.primary,
                    CleoColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Text(
                    'Ready to spin some vinyl?',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Listening Streak Card
            Padding(
              padding: const EdgeInsets.all(CleoSpacing.lg),
              child: _buildStreakCard(context),
            ),

            // Daily Recommendation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CleoSpacing.lg),
              child: _buildDailyRecommendation(context),
            ),

            const SizedBox(height: CleoSpacing.lg),

            // Quick Actions Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CleoSpacing.lg),
              child: Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: CleoSpacing.md),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CleoSpacing.lg),
              child: _buildQuickActionsGrid(context),
            ),

            const SizedBox(height: CleoSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Get real streak data from user provider
    const currentStreak = 0;
    const longestStreak = 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade100,
              Colors.deepOrange.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: CleoSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Listening Streak',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Row(
                    children: [
                      Text(
                        '$currentStreak days',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: CleoSpacing.sm),
                      Text(
                        '• Best: $longestStreak',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: CleoColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRecommendation(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Get real recommendation from user provider
    const hasRecommendation = false;

    if (!hasRecommendation) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(CleoSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 40,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: CleoSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Recommendation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: CleoSpacing.xs),
                    Text(
                      'No recommendation yet. Sync your collection to get started!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: CleoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // TODO: Show actual recommendation when available
    return const SizedBox.shrink();
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: CleoSpacing.md,
      mainAxisSpacing: CleoSpacing.md,
      childAspectRatio: 1.1,
      children: [
        _buildQuickActionCard(
          context,
          icon: Icons.play_circle_outline,
          title: 'Log Play',
          color: Colors.blue,
          onTap: () => context.push(AppRoutes.logPlay),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.library_music,
          title: 'Collection',
          color: Colors.purple,
          onTap: () => context.push(AppRoutes.collection),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.history,
          title: 'History',
          color: Colors.green,
          onTap: () => context.push(AppRoutes.playHistory),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.bar_chart,
          title: 'Analytics',
          color: Colors.orange,
          onTap: () => context.push(AppRoutes.analytics),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.settings_input_component,
          title: 'Equipment',
          color: Colors.teal,
          onTap: () => context.push(AppRoutes.stylus),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.sync,
          title: 'Sync',
          color: Colors.indigo,
          onTap: () => _handleSync(context),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(CleoSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: CleoSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: CleoColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSync(BuildContext context) {
    // TODO: Implement sync with SyncRepository
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync functionality coming soon'),
      ),
    );
  }
}
