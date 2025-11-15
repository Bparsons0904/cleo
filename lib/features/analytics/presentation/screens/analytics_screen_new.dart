import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/theme.dart';

/// Updated analytics screen for Waugzee API
/// Shows listening habits and collection insights
class AnalyticsScreenNew extends ConsumerStatefulWidget {
  const AnalyticsScreenNew({super.key});

  @override
  ConsumerState<AnalyticsScreenNew> createState() => _AnalyticsScreenNewState();
}

class _AnalyticsScreenNewState extends ConsumerState<AnalyticsScreenNew> {
  String _selectedPeriod = '30 days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7 days', child: Text('Last 7 Days')),
              const PopupMenuItem(value: '30 days', child: Text('Last 30 Days')),
              const PopupMenuItem(value: '90 days', child: Text('Last 90 Days')),
              const PopupMenuItem(value: 'year', child: Text('This Year')),
              const PopupMenuItem(value: 'all', child: Text('All Time')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        children: [
          // Overview Stats
          _buildOverviewSection(),

          const SizedBox(height: CleoSpacing.xl),

          // Plays Over Time Chart
          _buildPlaysChartSection(theme),

          const SizedBox(height: CleoSpacing.xl),

          // Top Artists
          _buildTopArtistsSection(theme),

          const SizedBox(height: CleoSpacing.xl),

          // Top Genres
          _buildTopGenresSection(theme),

          const SizedBox(height: CleoSpacing.xl),

          // Most Played Records
          _buildMostPlayedSection(theme),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.play_circle_outline,
            label: 'Total Plays',
            value: '0',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: CleoSpacing.md),
        Expanded(
          child: _buildStatCard(
            icon: Icons.album,
            label: 'Records Played',
            value: '0',
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: CleoSpacing.sm),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: CleoColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaysChartSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listening Activity',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.lg),
            SizedBox(
              height: 200,
              child: _buildPlaysChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaysChart() {
    // TODO: Use real data from analytics provider
    final spots = <FlSpot>[
      const FlSpot(0, 3),
      const FlSpot(1, 1),
      const FlSpot(2, 4),
      const FlSpot(3, 2),
      const FlSpot(4, 5),
      const FlSpot(5, 3),
      const FlSpot(6, 4),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: CleoColors.primary,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: CleoColors.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopArtistsSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Artists',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.md),
            _buildEmptyPlaceholder('No data available yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGenresSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Genres',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.md),
            _buildEmptyPlaceholder('No data available yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildMostPlayedSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Played Records',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.md),
            _buildEmptyPlaceholder('No data available yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String message) {
    return Container(
      padding: const EdgeInsets.all(CleoSpacing.lg),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          color: CleoColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
