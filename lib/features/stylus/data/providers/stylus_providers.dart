// lib/features/stylus/data/providers/stylus_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'stylus_providers.g.dart';

/// Provider for stylus management that uses data from the auth payload
@riverpod
class StylusesNotifier extends _$StylusesNotifier {
  @override
  AsyncValue<List<Stylus>> build() {
    // Get styluses directly from auth payload
    final authState = ref.watch(authStateNotifierProvider);

    return authState.when(
      data: (authData) {
        if (authData.payload?.styluses != null) {
          return AsyncValue.data(authData.payload!.styluses);
        } else {
          return const AsyncValue.data([]);
        }
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    );
  }

  /// Creates a new stylus
  Future<void> createStylus({
    required String name,
    String? manufacturer,
    int? expectedLifespan,
    DateTime? purchaseDate,
    bool active = true,
    bool primary = false,
  }) async {
    try {
      final stylusRepo = ref.read(stylusRepositoryProvider);

      final stylusData = {
        'name': name,
        'manufacturer': manufacturer,
        'expectedLifespan': expectedLifespan, // Using camelCase as in API
        'purchaseDate':
            purchaseDate != null
                ? '${purchaseDate.toIso8601String().split('.')[0]}Z'
                : null, // Format with Z timezone
        'active': active,
        'primary': primary, 'owned': true,
        'baseModel': false, // Using camelCase as in API
      };

      print("Creating stylus with data: $stylusData");

      // Create stylus and get the styluses list from the response
      final styluses = await stylusRepo.createStylus(stylusData);

      // Update our state directly with the new list if it's not empty
      if (styluses.isNotEmpty) {
        state = AsyncValue.data(styluses);
        print("State updated with ${styluses.length} styluses after creation");
      } else {
        // If the response was empty, refresh from auth state
        _refreshFromAuthState();
      }
    } catch (error) {
      print("Error creating stylus: $error");
      rethrow; // Allow UI to handle errors
    }
  }

  /// Updates an existing stylus
  Future<void> updateStylus({
    required int id,
    required String name,
    String? manufacturer,
    int? expectedLifespan,
    DateTime? purchaseDate,
    required bool active,
    required bool primary,
  }) async {
    try {
      final stylusRepo = ref.read(stylusRepositoryProvider);

      final stylusData = {
        'name': name,
        'manufacturer': manufacturer,
        'expectedLifespan': expectedLifespan, // Using camelCase as in API
        'purchaseDate':
            purchaseDate != null
                ? '${purchaseDate.toIso8601String().split('.')[0]}Z'
                : null, // Format with Z timezone
        'active': active,
        'primary': primary,
      };

      print("Updating stylus with ID $id: $stylusData");

      // Update stylus and get the styluses list from the response
      final styluses = await stylusRepo.updateStylus(id, stylusData);

      // Update our state directly with the new list if it's not empty
      if (styluses.isNotEmpty) {
        state = AsyncValue.data(styluses);
        print("State updated with ${styluses.length} styluses after update");
      } else {
        // If the response was empty, refresh from auth state
        _refreshFromAuthState();
      }
    } catch (error) {
      print("Error updating stylus: $error");
      rethrow; // Allow UI to handle errors
    }
  }

  /// Deletes a stylus
  Future<void> deleteStylus(int id) async {
    try {
      final stylusRepo = ref.read(stylusRepositoryProvider);

      print("Deleting stylus with ID $id");

      // Delete stylus and get the styluses list from the response
      final styluses = await stylusRepo.deleteStylus(id);

      // Update our state directly with the new list if it's not empty
      if (styluses.isNotEmpty) {
        state = AsyncValue.data(styluses);
        print("State updated with ${styluses.length} styluses after deletion");
      } else {
        // If the response was empty, refresh from auth state
        _refreshFromAuthState();
      }
    } catch (error) {
      print("Error deleting stylus: $error");
      rethrow; // Allow UI to handle errors
    }
  }

  /// Helper method to refresh state from the auth payload
  Future<void> _refreshFromAuthState() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final authPayload = await authRepo.getAuthStatus();
      if (authPayload.styluses.isNotEmpty) {
        state = AsyncValue.data(authPayload.styluses);
        print(
          "State refreshed from auth with ${authPayload.styluses.length} styluses",
        );
      }
    } catch (e) {
      print("Error refreshing from auth state: $e");
    }
  }
}

/// Provider for the primary stylus
@riverpod
AsyncValue<Stylus?> primaryStylus(PrimaryStylusRef ref) {
  final stylusesAsync = ref.watch(stylusesNotifierProvider);

  return stylusesAsync.when(
    data: (styluses) {
      // Find the primary stylus
      final primaryList = styluses.where((s) => s.primary).toList();
      if (primaryList.isNotEmpty) {
        return AsyncValue.data(primaryList.first);
      } else {
        // If no primary stylus, return the first active one if available
        final activeList = styluses.where((s) => s.active).toList();
        if (activeList.isNotEmpty) {
          return AsyncValue.data(activeList.first);
        } else {
          return const AsyncValue.data(null);
        }
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
}

/// Provider for base model styluses (for the dropdown in the Add form)
@riverpod
List<Stylus> baseModelStyluses(BaseModelStylusesRef ref) {
  final stylusesAsync = ref.watch(stylusesNotifierProvider);

  return stylusesAsync.maybeWhen(
    data: (styluses) => styluses.where((s) => s.baseModel).toList(),
    orElse: () => [],
  );
}

/// Provider for calculating total play time for a stylus
@riverpod
int stylusPlayTime(StylusPlayTimeRef ref, int stylusId) {
  // Get play history from auth payload
  final authState = ref.watch(authStateNotifierProvider);

  return authState.maybeWhen(
    data: (authData) {
      final playHistory = authData.payload?.playHistory ?? [];

      // Count plays for this stylus (assuming each play is 1 hour)
      return playHistory.where((play) => play.stylusId == stylusId).length;
    },
    orElse: () => 0,
  );
}

/// Provider for remaining lifespan of a stylus
@riverpod
int stylusRemainingLifespan(
  StylusRemainingLifespanRef ref,
  int stylusId,
  int? expectedLifespan,
) {
  if (expectedLifespan == null) return 0;

  // Get total play time
  final playTime = ref.watch(stylusPlayTimeProvider(stylusId));

  // Calculate remaining lifespan
  final remaining = expectedLifespan - playTime;

  // Return 0 if negative
  return remaining > 0 ? remaining : 0;
}

/// Provider for remaining percentage of a stylus lifespan
@riverpod
double stylusRemainingPercentage(
  StylusRemainingPercentageRef ref,
  int stylusId,
  int? expectedLifespan,
) {
  if (expectedLifespan == null || expectedLifespan == 0) return 1.0;

  // Get remaining lifespan
  final remaining = ref.watch(
    stylusRemainingLifespanProvider(stylusId, expectedLifespan),
  );

  // Calculate percentage
  final percentage = remaining / expectedLifespan;

  // Clamp between 0 and 1
  if (percentage < 0) return 0.0;
  if (percentage > 1) return 1.0;

  return percentage;
}
