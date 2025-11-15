// lib/features/user/data/providers/user_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_me_response.dart';
import '../../../../data/models/user_release.dart';
import '../../../../data/models/play_history_new.dart';
import '../../../../data/models/daily_recommendation.dart';
import '../../../../data/models/streak.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'user_providers.g.dart';

/// Provider for UserMeResponse (complete user data)
@Riverpod(keepAlive: true)
class UserData extends _$UserData {
  @override
  FutureOr<UserMeResponse?> build() async {
    // Only fetch user data if authenticated
    final isAuth = ref.watch(isAuthenticatedProvider);
    if (!isAuth) {
      return null;
    }

    return _fetchUserData();
  }

  /// Fetch user data from the API
  Future<UserMeResponse?> _fetchUserData() async {
    try {
      final userRepo = ref.read(userRepositoryProvider);
      final userData = await userRepo.getMe();
      print('✅ Fetched user data: ${userData.user.fullName}');
      return userData;
    } catch (e) {
      print('⚠️ Error fetching user data: $e');
      rethrow;
    }
  }

  /// Refresh user data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchUserData());
  }

  /// Update user preferences
  Future<void> updatePreferences({
    int? recentlyPlayedThresholdDays,
    int? cleaningFrequencyPlays,
    int? neglectedRecordsThresholdDays,
  }) async {
    try {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updatePreferences(
        recentlyPlayedThresholdDays: recentlyPlayedThresholdDays,
        cleaningFrequencyPlays: cleaningFrequencyPlays,
        neglectedRecordsThresholdDays: neglectedRecordsThresholdDays,
      );

      // Refresh user data after update
      await refresh();
      print('✅ User preferences updated');
    } catch (e) {
      print('⚠️ Error updating preferences: $e');
      rethrow;
    }
  }

  /// Update Discogs token
  Future<void> updateDiscogsToken(String token) async {
    try {
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateDiscogsToken(token);

      // Refresh user data after update
      await refresh();
      print('✅ Discogs token updated');
    } catch (e) {
      print('⚠️ Error updating Discogs token: $e');
      rethrow;
    }
  }
}

/// Provider for the current user
@riverpod
User? currentUser(CurrentUserRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (data) => data?.user,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for user's collection (releases)
@riverpod
List<UserRelease> userReleases(UserReleasesRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (data) => data?.releases ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for user's play history
@riverpod
List<PlayHistoryNew> userPlayHistory(UserPlayHistoryRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (data) => data?.playHistory ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for user's daily recommendation
@riverpod
DailyRecommendation? dailyRecommendation(DailyRecommendationRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (data) => data?.dailyRecommendation,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for user's streak
@riverpod
Streak? userStreak(UserStreakRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (data) => data?.streak,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Provider for checking if user data is loading
@riverpod
bool isUserDataLoading(IsUserDataLoadingRef ref) {
  final userData = ref.watch(userDataProvider);
  return userData.isLoading;
}

/// Provider for user data error
@riverpod
String? userDataError(UserDataErrorRef ref) {
  final userData = ref.watch(userDataProvider);

  return userData.when(
    data: (_) => null,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
}
