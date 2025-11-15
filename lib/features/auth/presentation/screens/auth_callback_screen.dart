import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Auth callback screen - handles OAuth redirect
/// This screen is shown when the app receives the OAuth callback
/// from Zitadel after successful authentication
class AuthCallbackScreen extends ConsumerStatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  ConsumerState<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    // Wait a moment to show the loading screen
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // The AuthService already handled the token exchange during the login flow
    // flutter_appauth automatically handles the callback and token exchange
    // So we just need to navigate to the home screen
    // The router's redirect logic will check auth status and route accordingly
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Completing sign in...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
