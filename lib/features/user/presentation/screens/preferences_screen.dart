import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/api_client.dart';
import '../../../core/services/auth_service.dart';

/// Preferences screen
/// Allows users to configure app settings and thresholds
class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final _discogsTokenController = TextEditingController();

  // Preference values
  int _recentlyPlayedDays = 180;
  int _cleaningFrequency = 5;
  int _neglectedDays = 365;

  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // TODO: Load current preferences from user data
  }

  @override
  void dispose() {
    _discogsTokenController.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    try {
      final authService = AuthService();
      final apiClient = ApiClient(authService);
      final userRepo = UserRepository(apiClient);

      // Update preferences
      await userRepo.updatePreferences(
        recentlyPlayedThresholdDays: _recentlyPlayedDays,
        cleaningFrequencyPlays: _cleaningFrequency,
        neglectedRecordsThresholdDays: _neglectedDays,
      );

      // Update Discogs token if provided
      if (_discogsTokenController.text.isNotEmpty) {
        await userRepo.updateDiscogsToken(_discogsTokenController.text);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved successfully'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _hasChanges = false;
        _isSaving = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save preferences: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        elevation: 0,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(CleoSpacing.lg),
        children: [
          // Discogs Integration Section
          _buildSectionHeader('Discogs Integration'),
          const SizedBox(height: CleoSpacing.md),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(CleoSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discogs API Token',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Text(
                    'Enter your Discogs personal access token to sync your collection',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CleoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.md),
                  TextField(
                    controller: _discogsTokenController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter token...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _markChanged(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: CleoSpacing.xl),

          // Listening Preferences Section
          _buildSectionHeader('Listening Preferences'),
          const SizedBox(height: CleoSpacing.md),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(CleoSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recently Played Threshold
                  Text(
                    'Recently Played Threshold',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Text(
                    'Records played within this many days are considered "recently played"',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CleoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _recentlyPlayedDays.toDouble(),
                          min: 1,
                          max: 365,
                          divisions: 364,
                          label: '$_recentlyPlayedDays days',
                          onChanged: (value) {
                            setState(() => _recentlyPlayedDays = value.toInt());
                            _markChanged();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '$_recentlyPlayedDays days',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: CleoSpacing.xl),

                  // Cleaning Frequency
                  Text(
                    'Cleaning Frequency',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Text(
                    'Recommend cleaning after this many plays',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CleoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _cleaningFrequency.toDouble(),
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: '$_cleaningFrequency plays',
                          onChanged: (value) {
                            setState(() => _cleaningFrequency = value.toInt());
                            _markChanged();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '$_cleaningFrequency plays',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: CleoSpacing.xl),

                  // Neglected Records Threshold
                  Text(
                    'Neglected Records Threshold',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.xs),
                  Text(
                    'Records not played within this many days are considered "neglected"',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CleoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: CleoSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _neglectedDays.toDouble(),
                          min: 1,
                          max: 730,
                          divisions: 729,
                          label: '$_neglectedDays days',
                          onChanged: (value) {
                            setState(() => _neglectedDays = value.toInt());
                            _markChanged();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '$_neglectedDays days',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: CleoSpacing.xxl),

          // Save Button (also shown in bottom)
          if (_hasChanges)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _savePreferences,
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
                        'Save Preferences',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: CleoColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}
