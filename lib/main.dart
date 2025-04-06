import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'core/di/providers_module.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';


part 'main.g.dart';  // Change this to match your actual package name
// Remove the part directive since we're not using code generation here
// part 'main.g.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        // Override theme controller provider with shared preferences
        themeControllerProvider.overrideWith(
          (ref) => ThemeController(prefs),
        ),
        // Fix the override for shared preferences
        // Use specific override method based on how the provider is defined
        sharedPreferencesProvider.overrideWith(
          (ref) => Future.value(prefs),
        ),
      ],
      child: const KleioApp(),
    ),
  );
}

/// Main app widget
class KleioApp extends ConsumerWidget {
  /// Default constructor
  const KleioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for theme changes
    final themeMode = ref.watch(themeControllerProvider);
    
    // Get router from provider
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Kleio',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: CleoTheme.lightTheme,
      darkTheme: CleoTheme.darkTheme,
      routerConfig: router,
    );
  }
}

/// Splash screen shown when app launches
class SplashScreen extends StatefulWidget {
  /// Default constructor
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading with a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // The router will handle redirect based on auth state
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 120),
            const SizedBox(height: 24),
            Text(
              'Kleio',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Your Vinyl Collection Manager',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
