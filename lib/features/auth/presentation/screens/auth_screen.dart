import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/theme.dart';
import '../../data/providers/auth_providers.dart';

/// Authentication screen for entering Discogs API token
class AuthScreen extends ConsumerStatefulWidget {
  /// Constructor
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaved = false;
  String? _errorMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _submitToken() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authNotifier = ref.read(authStateNotifierProvider.notifier);
      final success = await authNotifier.saveToken(
        _tokenController.text.trim(),
      );

      if (success) {
        setState(() {
          _isSaved = true;
          _isLoading = false;
        });

        // Short delay to show success message before navigating
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          // Navigate to home screen on success
          context.go(AppRoutes.home);
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to authenticate. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _openDiscogsSettings() async {
    const url = 'https://www.discogs.com/settings/developers';
    try {
      print("Attempting to launch URL: $url");
      final canLaunch = await canLaunchUrlString(url);
      print("Can launch URL: $canLaunch");

      if (canLaunch) {
        final result = await launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        );
        print("Launch result: $result");
      } else {
        print("Cannot launch URL");
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Could not open URL')));
        }
      }
    } catch (e) {
      print("Error launching URL: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    'Discogs API Configuration',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                // What is a Discogs Token section
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'What is a Discogs Token?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'A Discogs API token allows this application to securely access your Discogs collection, search the Discogs database, and perform other operations without requiring your full Discogs credentials.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // How to Get Your Token section
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'How to Get Your Token',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Numbered list of instructions
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("1.", style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      const Text("Go to your ", style: TextStyle(fontSize: 14)),
                      GestureDetector(
                        onTap: _openDiscogsSettings,
                        child: Text(
                          "Discogs Developer Settings",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0, left: 16.0),
                  child: Text(
                    "2. Sign in to your Discogs account if you're not already logged in",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0, left: 16.0),
                  child: Text(
                    '3. Under "Developer Resources", find your personal access token or generate a new one',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0, left: 16.0),
                  child: Text(
                    "4. Copy the token and paste it in the field below",
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // Token input section
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Your Discogs API Token',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _tokenController,
                        decoration: InputDecoration(
                          hintText: 'Paste your token here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your API token';
                          }
                          return null;
                        },
                      ),

                      // Error message
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      // Success message
                      if (_isSaved)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Token saved successfully!',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 14,
                            ),
                          ),
                        ),

                      // Save button
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitToken,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.blue[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'Save Token',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer text
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text(
                    'Your token is stored securely and only used to access the Discogs API on your behalf. We never share your token or use it for any other purpose.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
