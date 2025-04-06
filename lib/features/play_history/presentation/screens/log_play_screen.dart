import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';
import '../../../collection/data/providers/collection_providers.dart';
import '../../../stylus/data/providers/stylus_providers.dart';
import '../../data/providers/play_history_providers.dart';

/// Screen for logging a new play
class LogPlayScreen extends ConsumerStatefulWidget {
  /// Constructor
  const LogPlayScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LogPlayScreen> createState() => _LogPlayScreenState();
}

class _LogPlayScreenState extends ConsumerState<LogPlayScreen> {
  Release? _selectedRelease;
  Stylus? _selectedStylus;
  DateTime _playedAt = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _logPlay() async {
    if (_selectedRelease == null) {
      setState(() {
        _errorMessage = 'Please select a record';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final playHistoryNotifier = ref.read(playHistoryNotifierProvider.notifier);
      await playHistoryNotifier.logPlay(
        releaseId: _selectedRelease!.id,
        stylusId: _selectedStylus?.id,
        playedAt: _playedAt,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (mounted) {
        // Navigate back on success
        context.pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionAsync = ref.watch(filteredCollectionProvider);
    final stylusesAsync = ref.watch(stylusesNotifierProvider);
    final primaryStylusAsync = ref.watch(primaryStylusProvider);

    // Set the primary stylus as the default if we haven't selected one yet
    if (_selectedStylus == null) {
      primaryStylusAsync.whenData((primaryStylus) {
        if (primaryStylus != null && mounted) {
          setState(() {
            _selectedStylus = primaryStylus;
          });
        }
      });
    }

    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Log Play',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Record Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            // Record selection
            collectionAsync.when(
              data: (collection) => _buildRecordSelection(context, collection),
              loading: () => const CleoLoading(),
              error: (error, _) => Text('Error loading collection: $error'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Stylus Used',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            // Stylus selection
            stylusesAsync.when(
              data: (styluses) => _buildStylusSelection(context, styluses),
              loading: () => const CleoLoading(),
              error: (error, _) => Text('Error loading styluses: $error'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Play Date',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            // Date selection
            _buildDateSelection(context),
            const SizedBox(height: 16.0),
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            // Notes field
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Any notes about this play (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
            const SizedBox(height: 24.0),
            CleoButtons.primary(
              onPressed: _isLoading ? null : _logPlay,
              isLoading: _isLoading,
              isFullWidth: true,
              child: const Text('Log Play'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordSelection(BuildContext context, List<Release> collection) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(_selectedRelease?.title ?? 'Select a record'),
        subtitle: _selectedRelease != null && _selectedRelease!.artists.isNotEmpty
            ? Text(_getArtistNames(_selectedRelease!))
            : null,
        trailing: const Icon(Icons.search),
        onTap: () => _showRecordSelectionDialog(context, collection),
      ),
    );
  }

  Widget _buildStylusSelection(BuildContext context, List<Stylus> styluses) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(_selectedStylus?.name ?? 'Select a stylus'),
        subtitle: _selectedStylus != null
            ? Text(_selectedStylus!.manufacturer ?? '')
            : null,
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () => _showStylusSelectionDialog(context, styluses),
      ),
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(_formatDate(_playedAt)),
        trailing: const Icon(Icons.calendar_today),
        onTap: () => _selectDate(context),
      ),
    );
  }

  void _showRecordSelectionDialog(BuildContext context, List<Release> collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Record'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: collection.length,
            itemBuilder: (context, index) {
              final release = collection[index];
              return ListTile(
                title: Text(release.title),
                subtitle: Text(_getArtistNames(release)),
                onTap: () {
                  setState(() {
                    _selectedRelease = release;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showStylusSelectionDialog(BuildContext context, List<Stylus> styluses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Stylus'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: styluses.length,
            itemBuilder: (context, index) {
              final stylus = styluses[index];
              return ListTile(
                title: Text(stylus.name),
                subtitle: Text(stylus.manufacturer ?? ''),
                trailing: stylus.primary ? const Icon(Icons.star) : null,
                onTap: () {
                  setState(() {
                    _selectedStylus = stylus;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _playedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _playedAt) {
      setState(() {
        _playedAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _playedAt.hour,
          _playedAt.minute,
        );
      });
    }
  }

  String _getArtistNames(Release release) {
    if (release.artists.isEmpty) {
      return 'Unknown Artist';
    }
    return release.artists
        .map((artist) => artist.artist?.name ?? 'Unknown')
        .join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
