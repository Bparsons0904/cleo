// Complete updated version of DistributionAnalysis class with all necessary methods

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../data/models/models.dart';
import '../../providers/analytics_providers.dart';

// Enums for distribution widgets
enum DistributionType { byGenre, byArtist, byAlbum }

enum TopLimit { top5, top10, top15, top20, top50 }

// Providers for distribution controls
final distributionTimeProvider = StateProvider<AnalyticsPeriod>((ref) {
  return AnalyticsPeriod.last30Days;
});

final distributionTypeProvider = StateProvider<DistributionType>((ref) {
  return DistributionType.byGenre;
});

final distributionTopLimitProvider = StateProvider<TopLimit>((ref) {
  return TopLimit.top10;
});

class DistributionAnalysis extends ConsumerWidget {
  final List<PlayHistory> playHistory;
  final List<Release> releases;

  const DistributionAnalysis({
    super.key,
    required this.playHistory,
    required this.releases,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the control values
    final timePeriod = ref.watch(distributionTimeProvider);
    final distributionType = ref.watch(distributionTypeProvider);
    final topLimit = ref.watch(distributionTopLimitProvider);

    // Filter by time period
    final filteredPlayHistory = _filterByTimePeriod(playHistory, timePeriod);

    // Calculate distributions
    final Map<String, int> playCountData = _calculateDistribution(
      filteredPlayHistory,
      releases,
      distributionType,
      topLimit,
      countMode: true,
      ref: ref,
    );

    final Map<String, int> playDurationData = _calculateDistribution(
      filteredPlayHistory,
      releases,
      distributionType,
      topLimit,
      countMode: false,
      ref: ref,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribution Analysis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Controls - Now stacked vertically for mobile
        _buildControls(context, ref),

        const SizedBox(height: 24),

        // Pie charts - Now stacked for mobile
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              // Stack charts vertically on mobile with fixed spacing
              return Column(
                children: [
                  // Play count distribution
                  _buildDistributionSection(
                    context,
                    'By Play Count',
                    playCountData,
                    Colors.blue.shade300,
                    ref,
                  ),

                  const SizedBox(height: 48), // Fixed spacing between charts
                  // Play duration distribution
                  _buildDistributionSection(
                    context,
                    'By Listening Time',
                    playDurationData,
                    Colors.pink.shade300,
                    ref,
                  ),
                ],
              );
            } else {
              // Side by side on tablet/desktop
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Play count distribution
                  Expanded(
                    child: _buildDistributionSection(
                      context,
                      'By Play Count',
                      playCountData,
                      Colors.blue.shade300,
                      ref,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Play duration distribution
                  Expanded(
                    child: _buildDistributionSection(
                      context,
                      'By Listening Time',
                      playDurationData,
                      Colors.pink.shade300,
                      ref,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context, WidgetRef ref) {
    final timePeriod = ref.watch(distributionTimeProvider);
    final distributionType = ref.watch(distributionTypeProvider);
    final topLimit = ref.watch(distributionTopLimitProvider);

    // Use LayoutBuilder to adjust based on screen width
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Stack controls vertically on mobile
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period
              const Text('Time Period:'),
              const SizedBox(height: 8),
              _buildDropdown<AnalyticsPeriod>(
                value: timePeriod,
                items:
                    AnalyticsPeriod.values
                        .map(
                          (period) => DropdownMenuItem(
                            value: period,
                            child: Text(_getPeriodLabel(period)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(distributionTimeProvider.notifier).state = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Distribution Type
              const Text('Distribution Type:'),
              const SizedBox(height: 8),
              _buildDropdown<DistributionType>(
                value: distributionType,
                items:
                    DistributionType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(_getDistributionTypeLabel(type)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(distributionTypeProvider.notifier).state = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Show Top
              const Text('Show Top:'),
              const SizedBox(height: 8),
              _buildDropdown<TopLimit>(
                value: topLimit,
                items:
                    TopLimit.values
                        .map(
                          (limit) => DropdownMenuItem(
                            value: limit,
                            child: Text(_getTopLimitLabel(limit)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(distributionTopLimitProvider.notifier).state =
                        value;
                  }
                },
              ),
            ],
          );
        } else {
          // Side by side on tablet/desktop (original layout)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period
              Row(
                children: [
                  const SizedBox(width: 4),
                  const Text('Time Period:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown<AnalyticsPeriod>(
                      value: timePeriod,
                      items:
                          AnalyticsPeriod.values
                              .map(
                                (period) => DropdownMenuItem(
                                  value: period,
                                  child: Text(_getPeriodLabel(period)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(distributionTimeProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Distribution Type & Show Top
              Row(
                children: [
                  // Distribution Type
                  const SizedBox(width: 4),
                  const Text('Distribution Type:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown<DistributionType>(
                      value: distributionType,
                      items:
                          DistributionType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(_getDistributionTypeLabel(type)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(distributionTypeProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 32),

                  // Show Top
                  const Text('Show Top:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown<TopLimit>(
                      value: topLimit,
                      items:
                          TopLimit.values
                              .map(
                                (limit) => DropdownMenuItem(
                                  value: limit,
                                  child: Text(_getTopLimitLabel(limit)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(distributionTopLimitProvider.notifier)
                              .state = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
      ),
    );
  }

  Widget _buildDistributionSection(
    BuildContext context,
    String title,
    Map<String, int> data,
    Color baseColor,
    WidgetRef ref,
  ) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and subtitle
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            data.isNotEmpty
                ? "${data.entries.first.key} Distribution"
                : "Distribution",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 82), // More space before chart
          // Fixed height container for pie chart and legend
          SizedBox(
            height: 300, // Fixed height
            child: _buildPieWithLegend(context, data, baseColor, ref),
          ),
          const SizedBox(height: 32), // More space after chart
        ],
      ),
    );
  }

  Widget _buildPieWithLegend(
    BuildContext context,
    Map<String, int> data,
    Color baseColor,
    WidgetRef ref,
  ) {
    // Use LayoutBuilder to adjust based on screen width
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;

        if (isMobile) {
          // For mobile, use ListView instead of Column to avoid overflow
          return ListView(
            physics:
                const NeverScrollableScrollPhysics(), // Disable scrolling within this ListView
            shrinkWrap: true, // Important!
            children: [
              // Pie chart with fixed height
              SizedBox(
                height: 180,
                child: _buildPieChart(context, data, baseColor, ref),
              ),
              // Legend
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: _buildLegend(context, data, baseColor, ref),
              ),
            ],
          );
        } else {
          // For larger screens - side by side layout using Row
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pie chart - fixed size
              Expanded(
                flex: 7, // 70% of width
                child: SizedBox(
                  height: 260, // Fixed height
                  child: _buildPieChart(context, data, baseColor, ref),
                ),
              ),

              // Legend with shrinkwrap column
              Expanded(
                flex: 3, // 30% of width
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // Prevents bouncing
                  child: _buildLegend(context, data, baseColor, ref),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    Map<String, int> data,
    Color baseColor,
    WidgetRef ref,
  ) {
    // Define colors based on the base color
    final List<Color> colors = _generateColors(baseColor, data.length, ref);

    // Calculate total for percentages
    final int total = data.values.fold(0, (sum, value) => sum + value);

    return PieChart(
      PieChartData(
        sectionsSpace: 3, // Space between sections
        centerSpaceRadius: 50, // Center hole size
        sections:
            data.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value.value;

              // Calculate percentage
              final double percentage = total > 0 ? value / total * 100 : 0;

              return PieChartSectionData(
                color: colors[index % colors.length],
                value: value.toDouble(),
                title: '${percentage.toStringAsFixed(0)}%',
                radius: 110,
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black26,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                titlePositionPercentageOffset: 0.6,
                // Add a border to make sections more distinct
                borderSide: const BorderSide(color: Colors.white, width: 2),
              );
            }).toList(),
        centerSpaceColor: Colors.transparent,
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context,
    Map<String, int> data,
    Color baseColor,
    WidgetRef ref,
  ) {
    // Define colors based on the base color
    final List<Color> colors = _generateColors(baseColor, data.length, ref);

    // Use ListView.builder instead of Column for better layout behavior
    return ListView.builder(
      shrinkWrap: true, // Important!
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling of this inner ListView
      itemCount: data.length,
      itemBuilder: (context, index) {
        final entry = data.entries.elementAt(index);
        final key = entry.key;
        final value = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0), // Reduced padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Color indicator
              Container(
                width: 10, // Made smaller
                height: 10, // Made smaller
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6), // Made smaller
              // Label
              Expanded(
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: 11, // Made smaller
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Value
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 11, // Made smaller
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods - keeping the same implementation
  List<PlayHistory> _filterByTimePeriod(
    List<PlayHistory> playHistory,
    AnalyticsPeriod period,
  ) {
    // Apply time period filter
    final DateTime now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case AnalyticsPeriod.last7Days:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case AnalyticsPeriod.last30Days:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case AnalyticsPeriod.last90Days:
        startDate = now.subtract(const Duration(days: 90));
        break;
      case AnalyticsPeriod.lastYear:
        startDate = now.subtract(const Duration(days: 365));
        break;
      case AnalyticsPeriod.allTime:
        startDate = DateTime(1900); // Far in the past
        break;
    }

    return playHistory
        .where((play) => play.playedAt.isAfter(startDate))
        .toList();
  }

  Map<String, int> _calculateDistribution(
    List<PlayHistory> playHistory,
    List<Release> releases,
    DistributionType type,
    TopLimit limit, {
    bool countMode = true,
    required WidgetRef ref,
  }) {
    // Maps to track distribution
    final Map<String, int> distribution = {};

    // Process each play history item
    for (final play in playHistory) {
      // Find the corresponding release
      final release = releases.firstWhere(
        (r) => r.id == play.releaseId,
        orElse: () => throw Exception('Release not found'),
      );

      // Key for grouping based on distribution type
      String key;

      switch (type) {
        case DistributionType.byGenre:
          key =
              release.genres.isNotEmpty
                  ? release.genres.first.name
                  : 'Uncategorized';
          break;

        case DistributionType.byArtist:
          key =
              release.artists.isNotEmpty && release.artists.first.artist != null
                  ? release.artists.first.artist!.name
                  : 'Unknown Artist';
          break;

        case DistributionType.byAlbum:
          key = release.title;
          break;
      }

      // Get value to track (count or duration)
      int value;

      if (countMode) {
        // Play count mode - each play counts as 1
        value = 1;
      } else {
        // Duration mode - use play duration or estimate
        value =
            release.playDuration ??
            45; // Default to 45 minutes if not specified
      }

      // Update distribution
      distribution[key] = (distribution[key] ?? 0) + value;
    }

    // Sort by value (descending) and limit to top X
    final sortedEntries =
        distribution.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Get limit number
    int topCount;
    switch (limit) {
      case TopLimit.top5:
        topCount = 5;
        break;
      case TopLimit.top10:
        topCount = 10;
        break;
      case TopLimit.top15:
        topCount = 15;
        break;
      case TopLimit.top20:
        topCount = 20;
        break;
      case TopLimit.top50:
        topCount = 50;
        break;
    }

    // Apply limit and group remaining as "Other"
    if (sortedEntries.length > topCount) {
      // Calculate the "Other" value
      int otherValue = 0;
      for (int i = topCount; i < sortedEntries.length; i++) {
        otherValue += sortedEntries[i].value;
      }

      // Return top entries + "Other"
      final topEntries = sortedEntries.sublist(0, topCount);

      if (otherValue > 0) {
        // Only add "Other" if there are values to sum
        return {
          for (var entry in topEntries) entry.key: entry.value,
          'Other': otherValue,
        };
      } else {
        return {for (var entry in topEntries) entry.key: entry.value};
      }
    }

    // Return all entries if less than or equal to limit
    return Map.fromEntries(sortedEntries);
  }

  List<Color> _generateColors(Color baseColor, int count, WidgetRef ref) {
    // Generate a list of colors based on the base color
    final List<Color> colors = [];

    // Primary color
    colors.add(baseColor);

    // For genre, we want to use specific colors that are different
    if (ref.read(distributionTypeProvider) == DistributionType.byGenre) {
      colors.addAll([
        Colors.pink.shade300, // Jazz
        Colors.blue.shade300, // Rock
        Colors.amber.shade300, // Funk/Soul
        Colors.teal.shade300, // Pop
        Colors.purple.shade300, // Electronic
        Colors.green.shade300, // Classical
        Colors.red.shade300, // Hip Hop
        Colors.orange.shade300, // R&B
        Colors.indigo.shade300, // Reggae
        Colors.brown.shade300, // Folk
      ]);
    } else {
      // For other types, create variations of the base color
      colors.addAll([
        baseColor.withOpacity(0.8),
        baseColor.withOpacity(0.6),
        baseColor.withOpacity(0.4),
        baseColor.withRed((baseColor.red + 40) % 255),
        baseColor.withGreen((baseColor.green + 40) % 255),
        baseColor.withBlue((baseColor.blue + 40) % 255),
        baseColor.withRed((baseColor.red + 80) % 255),
        baseColor.withGreen((baseColor.green + 80) % 255),
        baseColor.withBlue((baseColor.blue + 80) % 255),
      ]);
    }

    return colors;
  }

  String _getPeriodLabel(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.last7Days:
        return 'Last 7 Days';
      case AnalyticsPeriod.last30Days:
        return 'Last 30 Days';
      case AnalyticsPeriod.last90Days:
        return 'Last 90 Days';
      case AnalyticsPeriod.lastYear:
        return 'Last Year';
      case AnalyticsPeriod.allTime:
        return 'All Time';
    }
  }

  String _getDistributionTypeLabel(DistributionType type) {
    switch (type) {
      case DistributionType.byGenre:
        return 'By Genre';
      case DistributionType.byArtist:
        return 'By Artist';
      case DistributionType.byAlbum:
        return 'By Album';
    }
  }

  String _getTopLimitLabel(TopLimit limit) {
    switch (limit) {
      case TopLimit.top5:
        return 'Top 5';
      case TopLimit.top10:
        return 'Top 10';
      case TopLimit.top15:
        return 'Top 15';
      case TopLimit.top20:
        return 'Top 20';
      case TopLimit.top50:
        return 'Top 50';
    }
  }
}
