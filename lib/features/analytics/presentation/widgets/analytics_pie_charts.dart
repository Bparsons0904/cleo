// lib/features/analytics/presentation/widgets/analytics_pie_charts.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/models.dart';

/// Widget for the genre distribution pie chart
class GenreDistributionChart extends StatelessWidget {
  final List<PlayHistory> playHistory;
  final List<Release> releases;

  const GenreDistributionChart({
    Key? key,
    required this.playHistory,
    required this.releases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate genre distribution
    final data = _calculateGenreDistribution();

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Genre Distribution',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Pie chart
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: _buildPieSections(data, context),
                  ),
                ),
              ),

              // Legend
              Expanded(flex: 2, child: _buildLegend(data, context)),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections(
    Map<String, int> data,
    BuildContext context,
  ) {
    // Define colors for the pie chart
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
    ];

    // Calculate total plays for percentage
    final totalPlays = data.values.fold<int>(0, (sum, count) => sum + count);

    // Create sections based on data
    final List<PieChartSectionData> sections = [];

    int colorIndex = 0;
    for (final entry in data.entries) {
      final percentage = totalPlays > 0 ? entry.value / totalPlays * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: entry.value.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend(Map<String, int> data, BuildContext context) {
    // Define colors (same as in _buildPieSections)
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final genre = entry.value.key;
            final count = entry.value.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      genre,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, int> _calculateGenreDistribution() {
    final Map<String, int> genreCounts = {};

    // Count play history by genre
    for (final play in playHistory) {
      final release = releases.firstWhere(
        (r) => r.id == play.releaseId,
        orElse: () => throw Exception('Release not found'),
      );

      // Use primary genre if available
      if (release.genres.isNotEmpty) {
        final genre = release.genres.first.name;
        genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      } else {
        // Use "Uncategorized" if no genre is available
        genreCounts['Uncategorized'] = (genreCounts['Uncategorized'] ?? 0) + 1;
      }
    }

    // Sort by count (descending)
    final sortedEntries =
        genreCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 10 and group the rest as "Other"
    if (sortedEntries.length > 10) {
      final top10 = Map.fromEntries(sortedEntries.take(9));
      final otherCount = sortedEntries
          .skip(9)
          .fold<int>(0, (sum, entry) => sum + entry.value);

      return {...top10, 'Other': otherCount};
    }

    return Map.fromEntries(sortedEntries);
  }
}

/// Widget for artist play count pie chart
class ArtistPlayCountChart extends StatelessWidget {
  final List<PlayHistory> playHistory;
  final List<Release> releases;

  const ArtistPlayCountChart({
    Key? key,
    required this.playHistory,
    required this.releases,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate artist distribution
    final data = _calculateArtistDistribution();

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Most Played Artists',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Pie chart
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: _buildPieSections(data, context),
                  ),
                ),
              ),

              // Legend
              Expanded(flex: 2, child: _buildLegend(data, context)),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildPieSections(
    Map<String, int> data,
    BuildContext context,
  ) {
    // Define colors for the pie chart
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
    ];

    // Calculate total plays for percentage
    final totalPlays = data.values.fold<int>(0, (sum, count) => sum + count);

    // Create sections based on data
    final List<PieChartSectionData> sections = [];

    int colorIndex = 0;
    for (final entry in data.entries) {
      final percentage = totalPlays > 0 ? entry.value / totalPlays * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: entry.value.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend(Map<String, int> data, BuildContext context) {
    // Define colors (same as in _buildPieSections)
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final artist = entry.value.key;
            final count = entry.value.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      artist,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, int> _calculateArtistDistribution() {
    final Map<String, int> artistCounts = {};

    // Count play history by artist
    for (final play in playHistory) {
      final release = releases.firstWhere(
        (r) => r.id == play.releaseId,
        orElse: () => throw Exception('Release not found'),
      );

      // Get artist name
      final artistName =
          release.artists.isNotEmpty && release.artists.first.artist != null
              ? release.artists.first.artist!.name
              : 'Unknown Artist';

      artistCounts[artistName] = (artistCounts[artistName] ?? 0) + 1;
    }

    // Sort by count (descending)
    final sortedEntries =
        artistCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 10 and group the rest as "Other"
    if (sortedEntries.length > 10) {
      final top10 = Map.fromEntries(sortedEntries.take(9));
      final otherCount = sortedEntries
          .skip(9)
          .fold<int>(0, (sum, entry) => sum + entry.value);

      return {...top10, 'Other': otherCount};
    }

    return Map.fromEntries(sortedEntries);
  }
}
