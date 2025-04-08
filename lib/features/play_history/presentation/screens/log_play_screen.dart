// lib/features/play_history/presentation/screens/log_play_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../../../data/models/models.dart';

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
  
  @override
  Widget build(BuildContext context) {
    // Get data from the auth payload
    final authState = ref.watch(authStateNotifierProvider);
    
    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Log Play',
      ),
      body: authState.when(
        data: (data) => _buildForm(context, data),
        loading: () => const Center(child: CleoLoading()),
        error: (error, stack) => Center(
          child: Text('Error loading data: $error'),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AuthStateData authData) {
    final releases = authData.payload?.releases ?? [];
    final styluses = authData.payload?.styluses ?? [];
    
    // Find the primary stylus
    final primaryStylus = styluses.isNotEmpty
        ? styluses.firstWhere(
            (s) => s.primary,
            orElse: () => styluses.first,
          )
        : null;
        
    // Set primary stylus if we haven't selected one yet
    if (_selectedStylus == null && primaryStylus != null) {
      _selectedStylus = primaryStylus;
    }
    
    return SingleChildScrollView(
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
          _buildRecordSelection(context, releases),
          const SizedBox(height: 16.0),
          
          Text(
            'Stylus Used',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          // Stylus selection
          _buildStylusSelection(context, styluses),
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
            onPressed:  _logPlay,
            isLoading: _isLoading,
            isFullWidth: true,
            child: const Text('Log Play'),
          ),
        ],
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
    if (collection.isEmpty) {
      setState(() {
        _errorMessage = 'No records found in your collection';
      });
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Record'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
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
    if (styluses.isEmpty) {
      setState(() {
        _errorMessage = 'No styluses found. Please add a stylus first.';
      });
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Stylus'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
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
      // For now, just show a success message without actual API call
      // We'll implement the actual call later
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Play logged successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
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
}
