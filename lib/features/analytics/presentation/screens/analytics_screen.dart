// lib/features/analytics/presentation/screens/analytics_screen.dart
import 'package:cleo/features/analytics/presentation/widgets/analytics_distrubution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../providers/analytics_providers.dart';
import '../widgets/records_played_chart.dart';
import '../widgets/listening_time_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load data from providers
    final timePeriod = ref.watch(analyticsPeriodProvider);
    final groupByOption = ref.watch(analyticsGroupByProvider);
    final filterOption = ref.watch(analyticsFilterProvider);

    // Get the play history data
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(title: 'Analytics', showBackButton: false),
      body: authState.when(
        data: (authData) {
          if (authData.payload == null ||
              authData.payload!.playHistory.isEmpty) {
            return const Center(
              child: Text(
                'No play history available. Start playing records to see analytics.',
              ),
            );
          }

          // Get data from auth payload
          final playHistory = authData.payload!.playHistory;
          final releases = authData.payload!.releases;

          return _buildAnalyticsContent(
            context,
            ref,
            playHistory,
            releases,
            timePeriod,
            groupByOption,
            filterOption,
          );
        },
        loading: () => const Center(child: CleoLoading()),
        error: (error, _) => Center(child: Text('Error loading data: $error')),
      ),
    );
  }

  Widget _buildAnalyticsContent(
    BuildContext context,
    WidgetRef ref,
    List<PlayHistory> playHistory,
    List<Release> releases,
    AnalyticsPeriod timePeriod,
    AnalyticsGroupBy groupByOption,
    String filterOption,
  ) {
    // Apply filtering, grouping, and time period
    final filteredData = _filterPlayHistory(
      playHistory,
      releases,
      timePeriod,
      filterOption,
    );
    final groupedData = _groupPlayHistory(
      filteredData,
      releases,
      groupByOption,
    );

    // Filtered and prepared data for charts
    final playCountData = _preparePlayCountData(groupedData);
    final playDurationData = _preparePlayDurationData(groupedData);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Controls - Now stacked vertically on mobile
            _buildFilterControls(
              context,
              ref,
              timePeriod,
              groupByOption,
              filterOption,
              releases,
            ),

            const SizedBox(height: 24),

            // Records Played Over Time Chart
            _buildAnalyticsSection(
              context,
              'Records Played Over Time',
              RecordsPlayedChart(data: playCountData),
            ),

            const SizedBox(height: 24),

            // Listening Time Over Time Chart
            _buildAnalyticsSection(
              context,
              'Listening Time Over Time',
              ListeningTimeChart(data: playDurationData),
            ),

            const SizedBox(height: 24),

            // Distribution Analysis with Side-by-Side Pie Charts
            Container(
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
              child: DistributionAnalysis(
                playHistory: filteredData,
                releases: releases,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterControls(
    BuildContext context,
    WidgetRef ref,
    AnalyticsPeriod timePeriod,
    AnalyticsGroupBy groupByOption,
    String filterOption,
    List<Release> releases,
  ) {
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
                    ref.read(analyticsPeriodProvider.notifier).state = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Group By
              const Text('Group By:'),
              const SizedBox(height: 8),
              _buildDropdown<AnalyticsGroupBy>(
                value: groupByOption,
                items:
                    AnalyticsGroupBy.values
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(_getGroupByLabel(option)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(analyticsGroupByProvider.notifier).state = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Filter by Record/Artist/Genre
              const Text('Filter by Record/Artist/Genre:'),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: filterOption,
                items:
                    _getFilterOptions(releases)
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(analyticsFilterProvider.notifier).state = value;
                  }
                },
              ),
            ],
          );
        } else {
          // Row layout for tablet/desktop
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          ref.read(analyticsPeriodProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Group By Filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Group By:'),
                    const SizedBox(height: 8),
                    _buildDropdown<AnalyticsGroupBy>(
                      value: groupByOption,
                      items:
                          AnalyticsGroupBy.values
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(_getGroupByLabel(option)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(analyticsGroupByProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Record/Artist/Genre Filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter by Record/Artist/Genre:'),
                    const SizedBox(height: 8),
                    _buildDropdown<String>(
                      value: filterOption,
                      items:
                          _getFilterOptions(releases)
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(analyticsFilterProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ],
                ),
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

  Widget _buildAnalyticsSection(
    BuildContext context,
    String title,
    Widget chart,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24), // Increased from 16 to 24
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // Increased from 8 to 12
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08), // More subtle shadow
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24), // Increased from 16 to 24
          child: chart,
        ),
        const SizedBox(
          height: 40,
        ), // Increased from 24 to 40 for more space between sections
      ],
    );
  }

  // Helper methods for filtering and data processing
  List<PlayHistory> _filterPlayHistory(
    List<PlayHistory> playHistory,
    List<Release> releases,
    AnalyticsPeriod period,
    String filterOption,
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

    var filtered =
        playHistory.where((play) => play.playedAt.isAfter(startDate)).toList();

    // Apply record/artist/genre filter if not "All Records"
    if (filterOption != 'All Records') {
      filtered =
          filtered.where((play) {
            final release = releases.firstWhere(
              (r) => r.id == play.releaseId,
              orElse: () => throw Exception('Release not found'),
            );

            // Check if this matches our filter
            // Could be an artist name, album title, or genre
            if (release.artists.isNotEmpty) {
              // Check artist
              final artistName =
                  release.artists.isNotEmpty &&
                          release.artists.first.artist != null
                      ? release.artists.first.artist!.name
                      : 'Unknown Artist';
              if (artistName == filterOption) {
                return true;
              }
            }

            // Check album title
            if (release.title == filterOption) {
              return true;
            }

            // Check genres
            for (final genre in release.genres) {
              if (genre.name == filterOption) {
                return true;
              }
            }

            return false;
          }).toList();
    }

    return filtered;
  }

  Map<String, List<PlayHistory>> _groupPlayHistory(
    List<PlayHistory> playHistory,
    List<Release> releases,
    AnalyticsGroupBy groupBy,
  ) {
    final Map<String, List<PlayHistory>> grouped = {};

    switch (groupBy) {
      case AnalyticsGroupBy.daily:
        // Group by day
        for (final play in playHistory) {
          final day = DateFormat('MMM d').format(play.playedAt);
          if (!grouped.containsKey(day)) {
            grouped[day] = [];
          }
          grouped[day]!.add(play);
        }
        break;

      case AnalyticsGroupBy.weekly:
        // Group by week
        for (final play in playHistory) {
          // Find the start of the week (Monday)
          final startOfWeek = play.playedAt.subtract(
            Duration(days: play.playedAt.weekday - 1),
          );
          final week = DateFormat('MMM d').format(startOfWeek);
          if (!grouped.containsKey(week)) {
            grouped[week] = [];
          }
          grouped[week]!.add(play);
        }
        break;

      case AnalyticsGroupBy.monthly:
        // Group by month
        for (final play in playHistory) {
          final month = DateFormat('MMM yyyy').format(play.playedAt);
          if (!grouped.containsKey(month)) {
            grouped[month] = [];
          }
          grouped[month]!.add(play);
        }
        break;

      case AnalyticsGroupBy.artist:
        // Group by artist
        for (final play in playHistory) {
          final release = releases.firstWhere(
            (r) => r.id == play.releaseId,
            orElse: () => throw Exception('Release not found'),
          );

          final artistName =
              release.artists.isNotEmpty && release.artists.first.artist != null
                  ? release.artists.first.artist!.name
                  : 'Unknown Artist';

          if (!grouped.containsKey(artistName)) {
            grouped[artistName] = [];
          }
          grouped[artistName]!.add(play);
        }
        break;

      case AnalyticsGroupBy.genre:
        // Group by primary genre
        for (final play in playHistory) {
          final release = releases.firstWhere(
            (r) => r.id == play.releaseId,
            orElse: () => throw Exception('Release not found'),
          );

          final genreName =
              release.genres.isNotEmpty
                  ? release.genres.first.name
                  : 'Uncategorized';

          if (!grouped.containsKey(genreName)) {
            grouped[genreName] = [];
          }
          grouped[genreName]!.add(play);
        }
        break;
    }

    return grouped;
  }

  List<ChartData> _preparePlayCountData(
    Map<String, List<PlayHistory>> groupedData,
  ) {
    final sortedKeys = _getSortedKeys(groupedData);

    return sortedKeys.map((key) {
      final plays = groupedData[key]!;
      return ChartData(
        label: key,
        count: plays.length,
        duration: 0, // Not used for play count
      );
    }).toList();
  }

  List<ChartData> _preparePlayDurationData(
    Map<String, List<PlayHistory>> groupedData,
  ) {
    final sortedKeys = _getSortedKeys(groupedData);

    return sortedKeys.map((key) {
      final plays = groupedData[key]!;

      // Calculate total duration in minutes
      // Each play has a duration, or we estimate 45 minutes per play if not available
      int totalMinutes = 0;

      for (final play in plays) {
        // Try to get duration from the release
        final release = play.release;
        final hasKnownDuration = release?.playDuration != null;

        if (hasKnownDuration) {
          totalMinutes += release!.playDuration!;
        } else {
          // Estimate 45 minutes per play if not available
          totalMinutes += 45;
        }
      }

      return ChartData(
        label: key,
        count: 0, // Not used for duration
        duration: totalMinutes,
      );
    }).toList();
  }

  List<String> _getSortedKeys(Map<String, List<PlayHistory>> groupedData) {
    final keys = groupedData.keys.toList();

    // Sort keys based on type
    if (keys.isNotEmpty) {
      final firstKey = keys.first;

      // Check if we're dealing with dates
      final isDate = firstKey.contains(' ');

      if (isDate) {
        // If it's a date format, sort chronologically
        keys.sort((a, b) {
          // Parse dates - this is a simplified approach
          try {
            // Handle different date formats
            DateTime dateA, dateB;

            if (a.contains('yyyy')) {
              // Monthly format
              dateA = DateFormat('MMM yyyy').parse(a);
              dateB = DateFormat('MMM yyyy').parse(b);
            } else {
              // Daily or weekly format
              dateA = DateFormat('MMM d').parse(a);
              dateB = DateFormat('MMM d').parse(b);

              // Handle year wrapping (e.g., Dec 31 vs Jan 1)
              final now = DateTime.now();

              dateA = DateTime(
                dateA.month > now.month ? now.year - 1 : now.year,
                dateA.month,
                dateA.day,
              );

              dateB = DateTime(
                dateB.month > now.month ? now.year - 1 : now.year,
                dateB.month,
                dateB.day,
              );
            }

            return dateA.compareTo(dateB);
          } catch (e) {
            // Fallback to string comparison
            return a.compareTo(b);
          }
        });
      } else {
        // For non-dates (artists, genres), sort alphabetically
        keys.sort();
      }
    }

    return keys;
  }

  List<String> _getFilterOptions(List<Release> releases) {
    final Set<String> options = {'All Records'};

    // Add all artists
    for (final release in releases) {
      if (release.artists.isNotEmpty && release.artists.first.artist != null) {
        options.add(release.artists.first.artist!.name);
      }
    }

    // Add all albums
    for (final release in releases) {
      options.add(release.title);
    }

    // Add all genres
    for (final release in releases) {
      for (final genre in release.genres) {
        options.add(genre.name);
      }
    }

    // Convert to sorted list
    final sortedOptions = options.toList()..sort();
    return sortedOptions;
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

  String _getGroupByLabel(AnalyticsGroupBy groupBy) {
    switch (groupBy) {
      case AnalyticsGroupBy.daily:
        return 'Daily';
      case AnalyticsGroupBy.weekly:
        return 'Weekly';
      case AnalyticsGroupBy.monthly:
        return 'Monthly';
      case AnalyticsGroupBy.artist:
        return 'By Artist';
      case AnalyticsGroupBy.genre:
        return 'By Genre';
    }
  }
}

// Data model for chart
class ChartData {
  final String label;
  final int count;
  final int duration; // In minutes

  ChartData({required this.label, required this.count, required this.duration});
}
