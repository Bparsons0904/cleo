// lib/features/home/presentation/widgets/folder_selection_menu.dart
import 'package:cleo/features/auth/data/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../folders/data/providers/folder_selection_provider.dart';

class FolderSelectionMenu extends ConsumerWidget {
  final VoidCallback? onMenuClosed;

  const FolderSelectionMenu({super.key, this.onMenuClosed});

  @override
  // lib/features/home/presentation/widgets/folder_selection_menu.dart
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(foldersProvider);
    final selectedFolderAsync = ref.watch(selectedFolderNotifierProvider);

    // Debug print
    print('Building folder menu with ${folders.length} folders');
    print('Available folders: ${folders.length}');
    for (var folder in folders) {
      print('Folder: ${folder.id} - ${folder.name} (${folder.count} records)');
    }
    print('Selected folder ID: ${selectedFolderAsync.valueOrNull}');

    return PopupMenuButton<int>(
      tooltip: 'Filter by Folder',
      icon: const Icon(Icons.folder),
      onSelected: (int folderId) {
        print('Selected folder ID: $folderId');
        ref
            .read(selectedFolderNotifierProvider.notifier)
            .setSelectedFolder(folderId);
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<int>> items = [
          // "All Records" option
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: [
                Icon(
                  Icons.folder_open,
                  color:
                      selectedFolderAsync.valueOrNull == 0
                          ? Theme.of(context).colorScheme.primary
                          : null,
                ),
                const SizedBox(width: 12),
                Text(
                  'All Records',
                  style: TextStyle(
                    fontWeight:
                        selectedFolderAsync.valueOrNull == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        selectedFolderAsync.valueOrNull == 0
                            ? Theme.of(context).colorScheme.primary
                            : null,
                  ),
                ),
              ],
            ),
          ),
        ];

        // Only add divider if there are folders
        if (folders.isNotEmpty) {
          items.add(const PopupMenuDivider());
        }

        // Add each folder
        for (final folder in folders) {
          print('Adding folder to menu: ${folder.id} - ${folder.name}');
          final isSelected = selectedFolderAsync.valueOrNull == folder.id;
          items.add(
            PopupMenuItem<int>(
              value: folder.id,
              child: Row(
                children: [
                  Icon(
                    Icons.folder,
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folder.name,
                          style: TextStyle(
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                          ),
                        ),
                        Text(
                          '${folder.count} records',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return items;
      },
    );
  }
}
