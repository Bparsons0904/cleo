// lib/features/stylus/presentation/widgets/stylus_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../data/models/models.dart';
import '../../data/providers/stylus_providers.dart';

/// Card widget that displays a stylus with its details and action buttons
class StylusCard extends ConsumerWidget {
  /// The stylus to display
  final Stylus stylus;

  /// Callback when edit button is pressed
  final VoidCallback onEdit;

  /// Callback when delete button is pressed
  final VoidCallback onDelete;

  /// Constructor
  const StylusCard({
    Key? key,
    required this.stylus,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get play time from the provider
    final totalPlayTime = ref.watch(stylusPlayTimeProvider(stylus.id));

    // Calculate remaining lifespan and percentage
    final remainingHours = ref.watch(
      stylusRemainingLifespanProvider(stylus.id, stylus.expectedLifespan),
    );

    final remainingPercentage = ref.watch(
      stylusRemainingPercentageProvider(stylus.id, stylus.expectedLifespan),
    );

    // Format the percentage for display
    final percentDisplay = (remainingPercentage * 100).toInt();

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias, // Ensure the left border is sharp
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: stylus.primary ? CleoColors.primary : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stylus name and primary indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      stylus.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (stylus.primary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CleoColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRIMARY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: CleoColors.primary,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Manufacturer
              if (stylus.manufacturer != null &&
                  stylus.manufacturer!.isNotEmpty)
                _buildInfoRow('Manufacturer:', stylus.manufacturer!),

              // Expected lifespan
              if (stylus.expectedLifespan != null)
                _buildInfoRow(
                  'Expected Lifespan:',
                  '${stylus.expectedLifespan} hours',
                ),

              // Total play time from provider
              _buildInfoRow('Total Play Time:', '$totalPlayTime hours'),

              // Remaining lifespan if available
              if (stylus.expectedLifespan != null)
                _buildInfoRow(
                  'Remaining Lifespan:',
                  '$remainingHours hours ($percentDisplay%)',
                ),

              // Progress bar for remaining lifespan
              if (stylus.expectedLifespan != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: remainingPercentage,
                  backgroundColor: Colors.grey.shade200,
                  color: _getProgressColor(remainingPercentage),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],

              // Purchase date
              if (stylus.purchaseDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildInfoRow(
                    'Purchase Date:',
                    DateFormat('MMM d, yyyy').format(stylus.purchaseDate!),
                  ),
                ),

              // Action buttons
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 0.2) {
      return Colors.red;
    } else if (percentage < 0.5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
