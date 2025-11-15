import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../data/services/api_client.dart';
import '../../../../data/repositories/play_history_repository_new.dart';

/// Updated log play screen for Waugzee API
/// Allows users to log a listening session
class LogPlayScreenNew extends ConsumerStatefulWidget {
  const LogPlayScreenNew({super.key});

  @override
  ConsumerState<LogPlayScreenNew> createState() => _LogPlayScreenNewState();
}

class _LogPlayScreenNewState extends ConsumerState<LogPlayScreenNew> {
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String? _selectedReleaseId;
  String? _selectedStylusId;
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Play'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Record
            Text(
              'Select Record',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.album, color: CleoColors.primary),
                title: Text(_selectedReleaseId == null
                    ? 'Tap to select a record'
                    : 'Selected Record'),
                subtitle: _selectedReleaseId == null
                    ? null
                    : const Text('Artist - Release Title'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectRecord,
              ),
            ),

            const SizedBox(height: CleoSpacing.lg),

            // Select Stylus (Optional)
            Text(
              'Stylus Used (Optional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.settings_input_component,
                    color: CleoColors.primary),
                title: Text(_selectedStylusId == null
                    ? 'Tap to select stylus'
                    : 'Selected Stylus'),
                subtitle: _selectedStylusId == null
                    ? null
                    : const Text('Brand - Model'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectStylus,
              ),
            ),

            const SizedBox(height: CleoSpacing.lg),

            // Date and Time
            Text(
              'When Did You Play It?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        DateFormat('MMM d, yyyy').format(_selectedDate),
                      ),
                      onTap: _selectDate,
                    ),
                  ),
                ),
                const SizedBox(width: CleoSpacing.sm),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        _selectedTime.format(context),
                      ),
                      onTap: _selectTime,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: CleoSpacing.lg),

            // Notes
            Text(
              'Notes (Optional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: CleoSpacing.sm),
            TextField(
              controller: _notesController,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'How did it sound? Any thoughts?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: CleoSpacing.xxl),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving || _selectedReleaseId == null
                    ? null
                    : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CleoColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Log Play',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectRecord() {
    // TODO: Show record selection bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record selection coming soon')),
    );
  }

  void _selectStylus() {
    // TODO: Show stylus selection bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stylus selection coming soon')),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _handleSave() async {
    if (_selectedReleaseId == null) return;

    setState(() => _isSaving = true);

    try {
      // Combine date and time
      final playedAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final authService = AuthService();
      final apiClient = ApiClient(authService);
      final playRepo = PlayHistoryRepositoryNew(apiClient);

      await playRepo.createPlay(
        userReleaseId: _selectedReleaseId!,
        playedAt: playedAt,
        userStylusId: _selectedStylusId,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Play logged successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log play: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() => _isSaving = false);
    }
  }
}
