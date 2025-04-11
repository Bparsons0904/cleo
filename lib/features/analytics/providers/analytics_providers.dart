// lib/features/analytics/providers/analytics_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum for time period filtering
enum AnalyticsPeriod { last7Days, last30Days, last90Days, lastYear, allTime }

// Enum for grouping options
enum AnalyticsGroupBy { daily, weekly, monthly, artist, genre }

// Provider for the selected time period
final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>((ref) {
  return AnalyticsPeriod.last30Days; // Default value
});

// Provider for the selected grouping option
final analyticsGroupByProvider = StateProvider<AnalyticsGroupBy>((ref) {
  return AnalyticsGroupBy.daily; // Default value
});

// Provider for the selected filter (Record/Artist/Genre)
final analyticsFilterProvider = StateProvider<String>((ref) {
  return 'All Records'; // Default value
});

// Provider for analyzed play history data
final playHistoryAnalyticsProvider =
    Provider.family<Map<String, List<dynamic>>, AnalyticsFilters>((
      ref,
      filters,
    ) {
      // This provider would analyze the play history based on selected filters
      // Will be implemented if needed for more complex analytics
      return {};
    });

// Data class to combine all analytics filters
class AnalyticsFilters {
  final AnalyticsPeriod period;
  final AnalyticsGroupBy groupBy;
  final String filterOption;

  AnalyticsFilters({
    required this.period,
    required this.groupBy,
    required this.filterOption,
  });
}
