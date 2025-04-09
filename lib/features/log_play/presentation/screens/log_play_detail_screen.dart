// lib/features/log_play/presentation/screens/log_play_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../data/providers/log_play_providers.dart';

/// Screen for logging plays and cleanings for a specific record
class LogPlayDetailScreen extends ConsumerStatefulWidget {
  /// The ID of the release to display
  final int releaseId;

  /// Constructor
  const LogPlayDetailScreen({
    super.key,
    required this.releaseId,
  });

  @override
  ConsumerState<LogPlayDetailScreen> createState() => _LogPlayDetailScreenState();
}

class _LogPlayDetailScreenState extends ConsumerState<LogPlayDetailScreen> {
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedStylusId;
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the release from auth payload
    final authState = ref.watch(authStateNotifierProvider);
    
    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Record Actions',
      ),
      body: authState.when(
        data: (authData) {
          // Find the release in the auth payload
          final release = authData.payload?.releases.firstWhere(
            (r) => r.id == widget.releaseId,
            orElse: () => throw Exception('Release not found'),
          );
          
          if (release == null) {
            return const Center(
              child: Text('Record not found'),
            );
          }
          
          // Get available active styluses only
          final styluses = authData.payload?.styluses
              .where((s) => s.active)
              .toList() ?? [];
          
          // Set default selected stylus if needed
          if (_selectedStylusId == null && styluses.isNotEmpty) {
            // Find primary stylus
            final primaryStylus = styluses.firstWhere(
              (s) => s.primary,
              orElse: () => styluses.first,
            );
            _selectedStylusId = primaryStylus.id.toString();
          }
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Record Info Section
                  _buildRecordInfoSection(release),
                  
                  const SizedBox(height: 24),
                  
                  // Log Play Form Section
                  _buildLogFormSection(context, styluses),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  _buildActionButtons(context, release),
                  
                  const SizedBox(height: 24),
                  
                  // History Section
                  _buildHistorySection(context, release),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CleoLoading()),
        error: (error, _) => Center(
          child: Text('Error loading record: $error'),
        ),
      ),
    );
  }

  Widget _buildRecordInfoSection(Release release) {
    final artistName = release.artists.isNotEmpty && release.artists.first.artist != null
        ? release.artists.first.artist!.name
        : 'Unknown Artist';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Album Cover
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: release.thumb.isNotEmpty
              ? Image.network(
                  release.thumb,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.album, size: 40, color: Colors.grey),
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.album, size: 40, color: Colors.grey),
                  ),
                ),
        ),
        
        const SizedBox(width: 16),
        
        // Album Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                release.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                artistName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              if (release.year != null)
                Text(
                  release.year.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogFormSection(BuildContext context, List<Stylus> styluses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Field
        const Text(
          'Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MM/dd/yyyy').format(_selectedDate),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Stylus Field
        const Text(
          'Stylus Used',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedStylusId,
              items: styluses.map((stylus) {
                return DropdownMenuItem<String>(
                  value: stylus.id.toString(),
                  child: Text(
                    stylus.primary
                        ? '${stylus.name} (Primary)'
                        : stylus.name,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStylusId = value;
                });
              },
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Notes Field
        const Text(
          'Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Enter any notes about this play or cleaning...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Release release) {
    return Row(
      children: [
        // Log Play Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _logPlay(context, release),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Log Play'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3273DC), // Blue color you specified
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Log Both Button
        Expanded(
          child: ElevatedButton(
            onPressed: () => _logBoth(context, release),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C6DFF), // Purple color you specified
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Log Both'),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Log Cleaning Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _logCleaning(context, release),
            icon: const Icon(Icons.cleaning_services),
            label: const Text('Log Cleaning'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981), // Green color you specified
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, Release release) {
    // Combine play and cleaning history
    final allHistory = <HistoryItem>[];
    
    print('Release ID: ${release.id}, Title: ${release.title}');
    print('Play history length: ${release.playHistory.length}');
    print('Cleaning history length: ${release.cleaningHistory.length}');
    
    // Add all play history items
    for (final play in release.playHistory) {
      print('Play: ID=${play.id}, Date=${play.playedAt}, StylesID=${play.stylusId}');
      allHistory.add(HistoryItem(
        type: 'play',
        date: play.playedAt,
        stylus: play.stylus,
        id: play.id,
        notes: play.notes,
      ));
    }
    
    // Add all cleaning history items
    for (final cleaning in release.cleaningHistory) {
      print('Cleaning: ID=${cleaning.id}, Date=${cleaning.cleanedAt}');
      allHistory.add(HistoryItem(
        type: 'cleaning',
        date: cleaning.cleanedAt,
        id: cleaning.id,
        notes: cleaning.notes,
      ));
    }
    
    // Sort by date, most recent first
    allHistory.sort((a, b) => b.date.compareTo(a.date));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Record History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (allHistory.isEmpty)
          const Text('No history recorded yet.'),
        if (allHistory.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allHistory.length,
            itemBuilder: (context, index) {
              final item = allHistory[index];
              return _buildHistoryItem(context, item);
            },
          ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, HistoryItem item) {
    final bool isPlay = item.type == 'play';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isPlay ? const Color(0xFF3273DC) : const Color(0xFF10B981),
            width: 4,
          ),
        ),
        color: isPlay
            ? const Color(0xFF3273DC).withOpacity(0.1)
            : const Color(0xFF10B981).withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Icon(
              isPlay ? Icons.play_arrow : Icons.cleaning_services,
              color: isPlay ? const Color(0xFF3273DC) : const Color(0xFF10B981),
            ),
            const SizedBox(width: 12),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPlay ? 'Played' : 'Cleaned',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isPlay && item.stylus != null)
                    Text('Stylus: ${item.stylus?.name}'),
                  if (item.notes != null && item.notes!.isNotEmpty)
                    Text(
                      'Notes: ${item.notes}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            
            // Date
            Text(
              DateFormat('MMM d, yyyy').format(item.date),
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            
            // Actions
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showHistoryOptions(context, item),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _logPlay(BuildContext context, Release release) async {
    // Show loading indicator
    setState(() {});
    
    try {
      // Get the stylus ID as an integer
      final stylusId = _selectedStylusId != null ? int.parse(_selectedStylusId!) : null;
      
      // Call the actual log play provider method
      await ref.read(logPlayNotifierProvider.notifier).logPlay(
        releaseId: release.id,
        stylusId: stylusId,
        playedAt: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Play logged successfully')),
        );
        
        // Clear notes field after successful log
        _notesController.clear();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log play: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logCleaning(BuildContext context, Release release) async {
    // Show loading indicator
    setState(() {});
    
    try {
      // Call the actual log cleaning provider method
      await ref.read(logPlayNotifierProvider.notifier).logCleaning(
        releaseId: release.id,
        cleanedAt: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cleaning logged successfully')),
        );
        
        // Clear notes field after successful log
        _notesController.clear();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log cleaning: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logBoth(BuildContext context, Release release) async {
    // Show loading indicator
    setState(() {});
    
    try {
      // Get the stylus ID as an integer
      final stylusId = _selectedStylusId != null ? int.parse(_selectedStylusId!) : null;
      
      // Call both log play and log cleaning in sequence
      await ref.read(logPlayNotifierProvider.notifier).logPlay(
        releaseId: release.id,
        stylusId: stylusId,
        playedAt: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      await ref.read(logPlayNotifierProvider.notifier).logCleaning(
        releaseId: release.id,
        cleanedAt: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Play and cleaning logged successfully')),
        );
        
        // Clear notes field after successful log
        _notesController.clear();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log play and cleaning: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showHistoryOptions(BuildContext context, HistoryItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              // Show edit dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, item);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this ${item.type} record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Call the appropriate delete method based on item type
              if (item.type == 'play') {
                _deletePlay(context, item.id);
              } else {
                _deleteCleaning(context, item.id);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Method to delete a play record
  Future<void> _deletePlay(BuildContext context, int playId) async {
    try {
      await ref.read(logPlayNotifierProvider.notifier).deletePlay(playId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Play record deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete play record: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method to delete a cleaning record
  Future<void> _deleteCleaning(BuildContext context, int cleaningId) async {
    try {
      await ref.read(logPlayNotifierProvider.notifier).deleteCleaning(cleaningId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cleaning record deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete cleaning record: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}


/// Helper class to combine play and cleaning history items
class HistoryItem {
  final String type; // 'play' or 'cleaning'
  final DateTime date;
  final Stylus? stylus;
  final int id;
  final String? notes;

  HistoryItem({
    required this.type,
    required this.date,
    this.stylus,
    required this.id,
    this.notes,
  });
}
