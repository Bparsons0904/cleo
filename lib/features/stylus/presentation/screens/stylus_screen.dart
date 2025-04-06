import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../data/providers/stylus_providers.dart';

/// Screen that displays and manages styluses
class StylusScreen extends ConsumerWidget {
  /// Constructor
  const StylusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stylusesAsync = ref.watch(stylusesNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Styluses',
        showBackButton: false,
      ),
      body: stylusesAsync.when(
        data: (styluses) => _buildStylusList(context, styluses, ref),
        loading: () => const Center(child: CleoLoading()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading styluses: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStylusDialog(context, ref),
        tooltip: 'Add Stylus',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStylusList(BuildContext context, List<dynamic> styluses, WidgetRef ref) {
    if (styluses.isEmpty) {
      return const Center(
        child: Text('No styluses found. Add your first stylus to get started.'),
      );
    }

    // This is a placeholder - implement actual stylus list
    return Center(
      child: Text('${styluses.length} styluses available'),
    );
  }

  void _showAddStylusDialog(BuildContext context, WidgetRef ref) {
    // Placeholder for add stylus dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Stylus'),
        content: const Text('Stylus form would appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
