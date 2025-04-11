import 'package:cleo/features/folders/data/providers/folder_selection_provider.dart';
import 'package:cleo/features/home/presentation/widgets/folder_selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
// import '../../../../core/widgets/widgets.dart';
// import '../../../../core/theme/theme.dart';
import '../../../collection/data/providers/collection_providers.dart';

/// Home screen for the Kleio app.
class HomeScreen extends ConsumerWidget {
  /// Constructor
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(selectedFolderNameProvider) != null
              ? 'Kleio - ${ref.watch(selectedFolderNameProvider)}'
              : 'Kleio',
        ),
        centerTitle: true,
        actions: [const FolderSelectionMenu()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              width: double.infinity,
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.2),
              child: Column(
                children: [
                  Text(
                    'Welcome to Kleio',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your personal vinyl collection tracker',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildActionCardsList(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptions(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.settings_input_component),
            title: const Text('Styluses'),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.stylus);
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.analytics);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings when implemented
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings - Coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCardsList(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildActionCardMobile(
          context,
          'Log Play',
          'Record when you play a record from your collection.',
          'Log Now',
          () => context.push(AppRoutes.logPlay),
        ),
        _buildActionCardMobile(
          context,
          'View Play Time',
          'See statistics about your listening habits.',
          'View Stats',
          () => context.push(AppRoutes.playHistory),
        ),
        _buildActionCardMobile(
          context,
          'View Collection',
          'Browse and search through your vinyl collection.',
          'View Collection',
          () => context.push(AppRoutes.collection),
        ),
        _buildActionCardMobile(
          context,
          'View Equipment',
          'View, Edit and add equipment to your profile.',
          'View Equipment',
          () => context.push(AppRoutes.stylus),
        ),
        _buildActionCardMobile(
          context,
          'Refresh Collection',
          'Sync your Kleio collection with your Discogs library.',
          'Sync Now',
          () => _syncCollection(context, ref),
        ),
        _buildActionCardMobile(
          context,
          'View Analytics',
          'Explore insights about your collection and listening habits.',
          'View Insights',
          () => context.push(AppRoutes.analytics),
        ),
      ],
    );
  }

  Widget _buildActionCardMobile(
    BuildContext context,
    String title,
    String description,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Description column (left side)
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                // Button column (right side)
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(buttonText),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _syncCollection(BuildContext context, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing your collection...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Actually trigger the sync using the provider
    final collectionNotifier = ref.read(collectionNotifierProvider.notifier);
    collectionNotifier
        .syncCollection()
        .then((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Collection synced successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        })
        .catchError((error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sync failed: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
