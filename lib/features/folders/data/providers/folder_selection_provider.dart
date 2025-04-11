// lib/features/folders/data/providers/folder_selection_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/providers_module.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';

part 'folder_selection_provider.g.dart';

/// Key used to store the selected folder ID in SharedPreferences
const String _selectedFolderIdKey = 'selected_folder_id';

/// Provider for managing folder selection
@Riverpod(keepAlive: true)
class SelectedFolderNotifier extends _$SelectedFolderNotifier {
  @override
  Future<int> build() async {
    // Load the saved folder ID from SharedPreferences
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getInt(_selectedFolderIdKey) ??
        0; // Default to folder ID 0 (All)
  }

  /// Set the selected folder ID and save it to SharedPreferences
  Future<void> setSelectedFolder(int folderId) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(_selectedFolderIdKey, folderId);
    state = AsyncValue.data(folderId);
  }

  /// Get all available folders from the auth payload
  List<Folder> getAvailableFolders() {
    final authState = ref.read(authStateNotifierProvider);
    return authState.value?.payload?.folders ?? [];
  }
}

/// Provider for filtered releases based on the selected folder
@riverpod
List<Release> filteredReleasesByFolder(FilteredReleasesByFolderRef ref) {
  final authState = ref.watch(authStateNotifierProvider);
  final selectedFolderAsync = ref.watch(selectedFolderNotifierProvider);

  if (authState is! AsyncData || authState.value?.payload == null) {
    return [];
  }

  if (selectedFolderAsync is! AsyncData) {
    return authState.value!.payload!.releases;
  }

  final selectedFolderId = selectedFolderAsync.value;
  final allReleases = authState.value!.payload!.releases;

  // If folder ID is 0, return all releases
  if (selectedFolderId == 0) {
    return allReleases;
  }

  // Otherwise, filter by folder ID
  return allReleases
      .where((release) => release.folderId == selectedFolderId)
      .toList();
}

/// Provider for the name of the selected folder
@riverpod
String selectedFolderName(SelectedFolderNameRef ref) {
  final selectedFolderAsync = ref.watch(selectedFolderNotifierProvider);
  final folders = ref.watch(foldersProvider);

  if (selectedFolderAsync is! AsyncData) {
    return 'All Records';
  }

  final selectedFolderId = selectedFolderAsync.value;

  // If folder ID is 0, return "All Records"
  if (selectedFolderId == 0) {
    return 'All Records';
  }

  // Find the folder name by ID
  final folder = folders.firstWhere(
    (folder) => folder.id == selectedFolderId,
    orElse:
        () => Folder(
          id: 0,
          name: 'Unknown Folder',
          count: 0,
          resourceUrl: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
  );

  return folder.name;
}
