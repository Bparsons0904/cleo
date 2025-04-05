import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences for theme storage
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        // Use overrideWith correctly
        themeControllerProvider.overrideWith(
          (ref) => ThemeController(prefs),
        ),
      ],
      child: const CleoApp(),
    ),
  );
}

/// Main app widget
class CleoApp extends ConsumerWidget {
  /// Default constructor
  const CleoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for theme changes
    final themeMode = ref.watch(themeControllerProvider);
    
    return MaterialApp(
      title: 'Kleio',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: CleoTheme.lightTheme,
      darkTheme: CleoTheme.darkTheme,
      home: const SplashScreen(),
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
    // Simulate loading with a delay, then navigate to home screen
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { // Add this check
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
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
