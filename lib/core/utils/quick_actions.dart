import 'package:cleo/data/models/models.dart';
import 'package:flutter/material.dart';

/// Utility class for record status indicators
class RecordStatusUtils {
  /// Calculate the cleanliness score for a record
  /// @param lastCleanedDate The date the record was last cleaned
  /// @param playsSinceCleaning Number of plays since last cleaning
  /// @returns Cleanliness score (0-100)
  static double getCleanlinessScore(
    DateTime? lastCleanedDate,
    int playsSinceCleaning,
  ) {
    // If never cleaned, return 100 (needs cleaning)
    if (lastCleanedDate == null) return 100.0;

    // Time-based calculation (percentage of 6 months elapsed)
    const sixMonthsInMs = 6 * 30 * 24 * 60 * 60 * 1000.0;
    final timeElapsed =
        DateTime.now().millisecondsSinceEpoch -
        lastCleanedDate.millisecondsSinceEpoch.toDouble();
    final timeScore = (timeElapsed / sixMonthsInMs) * 100.0;
    final cappedTimeScore = timeScore > 100.0 ? 100.0 : timeScore;

    // Play-based calculation (percentage of 5 plays)
    // Modified to ensure that exactly 4 plays is less than 80%
    final playScore = (playsSinceCleaning / 5.01) * 100.0;
    final cappedPlayScore = playScore > 100.0 ? 100.0 : playScore;

    // Return the higher score (worse case)
    return cappedTimeScore > cappedPlayScore
        ? cappedTimeScore
        : cappedPlayScore;
  }

  /// Get color based on cleanliness score
  /// @param score Cleanliness score (0-100)
  /// @returns Color object
  static Color getCleanlinessColor(double score) {
    if (score < 20) return const Color(0xFF35a173); // Dark green
    if (score < 40) return const Color(0xFF59c48c); // Medium green
    if (score < 60) return const Color(0xFF80d6aa); // Light green
    if (score < 80) {
      return const Color(0xFFf59e0b); // Amber/yellow warning color
    }
    return const Color(0xFFe9493e); // Red for danger
  }

  /// Calculate play recency score
  /// @param lastPlayedDate The date the record was last played
  /// @returns A number between 0-100 representing how recently played
  static double getPlayRecencyScore(DateTime? lastPlayedDate) {
    // If never played, return 0
    if (lastPlayedDate == null) return 0;

    final now = DateTime.now();
    final daysElapsed = now.difference(lastPlayedDate).inHours / 24;

    // Convert days to score (0-100)
    if (daysElapsed <= 7) return 100; // Very recent: Last 7 days
    if (daysElapsed <= 30) return 80; // Recent: Last 30 days
    if (daysElapsed <= 60) return 60; // Moderately recent: Last 60 days
    if (daysElapsed <= 90) return 40; // Not recent: Last 90 days
    return 20; // Long ago: Over 90 days
  }

  /// Get play recency color
  /// @param score Play recency score (0-100)
  /// @returns Color object
  static Color getPlayRecencyColor(double score) {
    if (score >= 80) return const Color(0xFF35a173); // Green
    if (score >= 60) return const Color(0xFF59c48c); // Light green
    if (score >= 40) return const Color(0xFF80d6aa); // Yellow-green
    if (score >= 20) return const Color(0xFFf59e0b); // Orange
    return const Color(0xFFe9493e); // Red
  }

  /// Get text description for recency
  /// @param lastPlayedDate The date the record was last played
  /// @returns Text description of recency
  static String getPlayRecencyText(DateTime? lastPlayedDate) {
    if (lastPlayedDate == null) return "Never played";

    final now = DateTime.now();
    final daysElapsed = now.difference(lastPlayedDate).inHours / 24;

    if (daysElapsed <= 7) return "Played this week";
    if (daysElapsed <= 30) return "Played this month";
    if (daysElapsed <= 60) return "Played in the last 2 months";
    if (daysElapsed <= 90) return "Played in the last 3 months";
    return "Not played recently";
  }

  /// Get text description for cleanliness
  /// @param score Cleanliness score (0-100)
  /// @returns Text description of cleanliness
  static String getCleanlinessText(double score) {
    if (score < 20) return "Recently cleaned";
    if (score < 40) return "Clean";
    if (score < 60) return "May need cleaning soon";
    if (score < 80) return "Due for cleaning";
    return "Needs cleaning";
  }

  /// Count plays since last cleaning
  /// @param playHistory List of play history items
  /// @param lastCleanedDate Date of last cleaning
  /// @returns Number of plays since last cleaning
  static int countPlaysSinceCleaning(
    List<PlayHistory> playHistory,
    DateTime? lastCleanedDate,
  ) {
    if (lastCleanedDate == null) {
      return playHistory.length; // If never cleaned, count all plays
    }

    // Get the exact timestamp of the last cleaning
    final lastCleanedTime = lastCleanedDate.millisecondsSinceEpoch;

    return playHistory.where((play) {
      final playTime = play.playedAt.millisecondsSinceEpoch;

      // Add a small epsilon (1 millisecond) to the cleaning time
      // This ensures that plays logged at exactly the same time as cleaning
      // are not counted toward the "plays since cleaning" total
      return playTime > lastCleanedTime + 1;
    }).length;
  }

  /// Get the last cleaning date from cleaning history
  /// @param cleaningHistory List of cleaning history items
  /// @returns Last cleaning date or null if never cleaned
  static DateTime? getLastCleaningDate(List<CleaningHistory>? cleaningHistory) {
    if (cleaningHistory == null || cleaningHistory.isEmpty) return null;

    // Sort by date descending
    final sortedHistory = List<CleaningHistory>.from(cleaningHistory)
      ..sort((a, b) => b.cleanedAt.compareTo(a.cleanedAt));

    return sortedHistory.first.cleanedAt;
  }

  /// Get the last play date from play history
  /// @param playHistory List of play history items
  /// @returns Last play date or null if never played
  static DateTime? getLastPlayDate(List<PlayHistory>? playHistory) {
    if (playHistory == null || playHistory.isEmpty) return null;

    // Sort by date descending
    final sortedHistory = List<PlayHistory>.from(playHistory)
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    return sortedHistory.first.playedAt;
  }
}
