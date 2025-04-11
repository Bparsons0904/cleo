// lib/features/stylus/presentation/screens/stylus_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../data/providers/stylus_providers.dart';
import '../../../../data/models/models.dart';
import '../widgets/stylus_card.dart';
import '../widgets/add_stylus_form.dart';

/// Screen that displays and manages styluses
class StylusScreen extends ConsumerWidget {
  /// Constructor
  const StylusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stylusesAsync = ref.watch(stylusesNotifierProvider);

    return Scaffold(
      appBar: const CleoAppBar(title: 'Stylus Manager', showBackButton: false),
      body: stylusesAsync.when(
        data: (styluses) => _buildStylusList(context, styluses, ref),
        loading: () => const Center(child: CleoLoading()),
        error:
            (error, stackTrace) =>
                Center(child: Text('Error loading styluses: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStylusDialog(context, ref),
        label: const Text('Add New Stylus'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStylusList(
    BuildContext context,
    List<Stylus> styluses,
    WidgetRef ref,
  ) {
    // Debug print to see what styluses we have
    print('Building stylus list with ${styluses.length} styluses');
    for (var stylus in styluses) {
      print(
        'Stylus: ${stylus.name}, id: ${stylus.id}, '
        'expectedLifespan: ${stylus.expectedLifespan}, '
        'purchaseDate: ${stylus.purchaseDate}',
      );
    }

    // Filter active and inactive styluses (that are owned)
    final activeStyluses = styluses.where((s) => s.active).toList();
    final inactiveStyluses =
        styluses.where((s) => !s.active && s.owned).toList();

    if (styluses.isEmpty) {
      return const Center(
        child: Text('No styluses found. Add your first stylus to get started.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Styluses Section
          const Text(
            'Active Styluses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (activeStyluses.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'No active styluses found. Add a new stylus to get started.',
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeStyluses.length,
              itemBuilder: (context, index) {
                final stylus = activeStyluses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: StylusCard(
                    stylus: stylus,
                    onEdit: () => _showEditStylusDialog(context, ref, stylus),
                    onDelete: () => _confirmDeleteStylus(context, ref, stylus),
                  ),
                );
              },
            ),

          // Inactive Styluses Section (if any)
          if (inactiveStyluses.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Inactive Styluses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inactiveStyluses.length,
              itemBuilder: (context, index) {
                final stylus = inactiveStyluses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: StylusCard(
                    stylus: stylus,
                    onEdit: () => _showEditStylusDialog(context, ref, stylus),
                    onDelete: () => _confirmDeleteStylus(context, ref, stylus),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showAddStylusDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AddStylusForm(
                availableStyluses: ref.read(baseModelStylusesProvider),
                onSubmit: (stylusData) async {
                  try {
                    Navigator.of(context).pop(); // Close the dialog

                    // Create the stylus
                    await ref
                        .read(stylusesNotifierProvider.notifier)
                        .createStylus(
                          name: stylusData.name,
                          manufacturer: stylusData.manufacturer,
                          expectedLifespan: stylusData.expectedLifespan,
                          purchaseDate: stylusData.purchaseDate,
                          active: stylusData.active,
                          primary: stylusData.primary,
                        );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stylus added successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding stylus: $e')),
                      );
                    }
                  }
                },
              ),
            ),
          ),
    );
  }

  void _showEditStylusDialog(
    BuildContext context,
    WidgetRef ref,
    Stylus stylus,
  ) {
    // Debug print before showing edit dialog
    print('Showing edit dialog for stylus: ${stylus.name}');
    print('Expected lifespan: ${stylus.expectedLifespan}');
    print('Purchase date: ${stylus.purchaseDate}');

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AddStylusForm(
                availableStyluses: ref.read(baseModelStylusesProvider),
                initialStylus: stylus,
                onSubmit: (stylusData) async {
                  try {
                    Navigator.of(context).pop(); // Close the dialog

                    // Print the data we're submitting
                    print('Updating stylus with data:');
                    print('name: ${stylusData.name}');
                    print('manufacturer: ${stylusData.manufacturer}');
                    print('expectedLifespan: ${stylusData.expectedLifespan}');
                    print('purchaseDate: ${stylusData.purchaseDate}');
                    print('active: ${stylusData.active}');
                    print('primary: ${stylusData.primary}');

                    // Update the stylus
                    await ref
                        .read(stylusesNotifierProvider.notifier)
                        .updateStylus(
                          id: stylus.id,
                          name: stylusData.name,
                          manufacturer: stylusData.manufacturer,
                          expectedLifespan: stylusData.expectedLifespan,
                          purchaseDate: stylusData.purchaseDate,
                          active: stylusData.active,
                          primary: stylusData.primary,
                        );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stylus updated successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating stylus: $e')),
                      );
                    }
                  }
                },
              ),
            ),
          ),
    );
  }

  void _confirmDeleteStylus(
    BuildContext context,
    WidgetRef ref,
    Stylus stylus,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Stylus'),
            content: Text(
              'Are you sure you want to delete ${stylus.name}? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(stylusesNotifierProvider.notifier)
                        .deleteStylus(stylus.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stylus deleted successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting stylus: $e')),
                      );
                    }
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
