import 'package:logger/logger.dart';
import '../services/api_client.dart';
import '../models/user_me_response.dart';
import '../models/user_configuration.dart';

/// Repository for user-related API operations
/// Handles user profile, preferences, and the main /api/users/me endpoint
class UserRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  UserRepository(this._apiClient);

  /// Get current user's complete data including:
  /// - User profile
  /// - Folders
  /// - Releases (collection)
  /// - Styluses
  /// - Play history
  /// - Daily recommendation
  /// - Streak
  ///
  /// This is the primary data endpoint for the app
  Future<UserMeResponse> getMe() async {
    try {
      _logger.i('📥 Fetching user data from /api/users/me');

      final response = await _apiClient.get('/users/me');

      if (response.statusCode == 200 && response.data != null) {
        final userMeResponse = UserMeResponse.fromJson(response.data);
        _logger.i('✅ Successfully fetched user data');
        _logger.d('User: ${userMeResponse.user.fullName}');
        _logger.d('Releases: ${userMeResponse.releases.length}');
        _logger.d('Styluses: ${userMeResponse.styluses.length}');
        _logger.d('Play history: ${userMeResponse.playHistory.length}');

        return userMeResponse;
      }

      throw Exception('Failed to fetch user data: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e('❌ Error fetching user data', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Update user's Discogs token
  ///
  /// [token] - Discogs personal access token
  Future<void> updateDiscogsToken(String token) async {
    try {
      _logger.i('🔑 Updating Discogs token');

      final response = await _apiClient.put(
        '/users/me/discogs',
        data: {'discogsToken': token},
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Successfully updated Discogs token');
        return;
      }

      throw Exception('Failed to update Discogs token: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating Discogs token',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update user's selected folder
  ///
  /// [folderId] - UUID of the folder to set as selected
  Future<void> updateSelectedFolder(String folderId) async {
    try {
      _logger.i('📁 Updating selected folder to: $folderId');

      final response = await _apiClient.put(
        '/users/me/folder',
        data: {'folderId': folderId},
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Successfully updated selected folder');
        return;
      }

      throw Exception('Failed to update selected folder: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating selected folder',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update user preferences
  ///
  /// [recentlyPlayedThresholdDays] - Days to consider a record "recently played" (1-365)
  /// [cleaningFrequencyPlays] - Number of plays before cleaning recommended (1-50)
  /// [neglectedRecordsThresholdDays] - Days before a record is "neglected" (1-730)
  Future<void> updatePreferences({
    int? recentlyPlayedThresholdDays,
    int? cleaningFrequencyPlays,
    int? neglectedRecordsThresholdDays,
  }) async {
    try {
      _logger.i('⚙️ Updating user preferences');

      final data = <String, dynamic>{};
      if (recentlyPlayedThresholdDays != null) {
        data['recentlyPlayedThresholdDays'] = recentlyPlayedThresholdDays;
      }
      if (cleaningFrequencyPlays != null) {
        data['cleaningFrequencyPlays'] = cleaningFrequencyPlays;
      }
      if (neglectedRecordsThresholdDays != null) {
        data['neglectedRecordsThresholdDays'] = neglectedRecordsThresholdDays;
      }

      final response = await _apiClient.put(
        '/users/me/preferences',
        data: data,
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Successfully updated preferences');
        return;
      }

      throw Exception('Failed to update preferences: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating preferences',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
