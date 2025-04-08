// lib/features/collection/presentation/widgets/filter_sort_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cleo/core/theme/theme.dart';
import '../../data/providers/collection_filter_provider.dart';
import 'filter_sort_button_sheet.dart';

class FilterSortButton extends ConsumerWidget {
  const FilterSortButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(collectionFilterProvider);
    final hasFilters = filterState.hasFilters;
    final activeFilterCount = filterState.activeFilterCount;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showFilterSortBottomSheet(context),
        borderRadius: CleoSpacing.borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasFilters
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            borderRadius: CleoSpacing.borderRadius,
            color: hasFilters
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_list,
                size: 20,
                color: hasFilters
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                'Filter & Sort',
                style: TextStyle(
                  color: hasFilters
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: hasFilters ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (activeFilterCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$activeFilterCount',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  void _showFilterSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes it expandable
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterSortBottomSheet(),
    );
  }
}
