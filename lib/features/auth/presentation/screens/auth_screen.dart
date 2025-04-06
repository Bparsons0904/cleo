import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
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
      final success = await authNotifier.saveToken(_tokenController.text.trim());

      if (success) {
        if (mounted) {
          // Navigate to home screen on success
          context.go(AppRoutes.home);
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to authenticate. Please try again.';
        });
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: CleoSpacing.pagePadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildTokenInput(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorMessage(),
                    ],
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                    _buildHelpText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.album,
          size: 70,
          color: CleoColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to Kleio',
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Your Vinyl Collection Manager',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTokenInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your Discogs API Token',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tokenController,
          decoration: const InputDecoration(
            hintText: 'Paste your token here',
            prefixIcon: Icon(Icons.vpn_key),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your API token';
            }
            return null;
          },
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(CleoSpacing.sm),
      decoration: BoxDecoration(
        color: CleoColors.error.withOpacity(0.1),
        borderRadius: CleoSpacing.borderRadius,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: CleoColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: CleoColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CleoButtons.primary(
      onPressed: _isLoading ? null : _submitToken,
      isLoading: _isLoading,
      isFullWidth: true,
      child: const Text('Connect with Discogs'),
    );
  }

  Widget _buildHelpText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to get your Discogs token:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const Text(
          '1. Log in to your Discogs account',
          style: TextStyle(height: 1.5),
        ),
        const Text(
          '2. Go to Settings > Developer',
          style: TextStyle(height: 1.5),
        ),
        const Text(
          '3. Generate a personal access token',
          style: TextStyle(height: 1.5),
        ),
        const Text(
          '4. Copy and paste it here',
          style: TextStyle(height: 1.5),
        ),
        const SizedBox(height: 16),
        CleoButtons.text(
          onPressed: () {
            // Open Discogs website
            // Implement URL launcher here
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Go to Discogs website'),
              SizedBox(width: 4),
              Icon(Icons.open_in_new, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
