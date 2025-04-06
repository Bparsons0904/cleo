import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'stylus_providers.g.dart';

/// Provider for stylus management
@riverpod
class StylusesNotifier extends _$StylusesNotifier {
  @override
  AsyncValue<List<Stylus>> build() {
    // Check if we're authenticated and load styluses if so
    final isAuth = ref.watch(isAuthenticatedProvider);
    
    if (isAuth) {
      _loadStyluses();
    }
    
    return const AsyncValue.loading();
  }

  /// Loads styluses from the API
  Future<void> _loadStyluses() async {
    state = const AsyncValue.loading();
    
    try {
      final stylusRepo = ref.read(stylusRepositoryProvider);
      final styluses = await stylusRepo.getStyluses();
      
      state = AsyncValue.data(styluses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
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
        'expected_lifespan': expectedLifespan,
        'purchase_date': purchaseDate?.toIso8601String(),
        'active': active,
        'primary': primary,
        'owned': true,
        'base_model': false,
      };
      
      await stylusRepo.createStylus(stylusData);
      
      // Reload styluses after creation
      await _loadStyluses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
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
        'expected_lifespan': expectedLifespan,
        'purchase_date': purchaseDate?.toIso8601String(),
        'active': active,
        'primary': primary,
      };
      
      await stylusRepo.updateStylus(id, stylusData);
      
      // If setting this stylus as primary, we need to update other styluses
      if (primary && state.hasValue) {
        final updatedStyluses = state.value!.map((s) {
          if (s.id != id && s.primary) {
            // Create a copy with primary set to false
            final updatedData = {
              'name': s.name,
              'manufacturer': s.manufacturer,
              'expected_lifespan': s.expectedLifespan,
              'purchase_date': s.purchaseDate?.toIso8601String(),
              'active': s.active,
              'primary': false,
            };
            
            // Update in the background
            stylusRepo.updateStylus(s.id, updatedData);
          }
          return s;
        }).toList();
        
        // Optimistic update
        state = AsyncValue.data(updatedStyluses);
      }
      
      // Reload styluses to ensure we have the latest data
      await _loadStyluses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Deletes a stylus
  Future<void> deleteStylus(int id) async {
    try {
      final stylusRepo = ref.read(stylusRepositoryProvider);
      await stylusRepo.deleteStylus(id);
      
      // Reload styluses after deletion
      await _loadStyluses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the primary stylus
@riverpod
AsyncValue<Stylus?> primaryStylus(PrimaryStylusRef ref) {
  final stylusesAsync = ref.watch(stylusesNotifierProvider);
  
  return stylusesAsync.when(
    data: (styluses) {
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
