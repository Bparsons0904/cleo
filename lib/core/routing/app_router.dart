import 'package:cleo/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/collection/presentation/screens/collection_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/play_history/presentation/screens/play_history_screen.dart';
import '../../features/record_detail/presentation/screens/record_detail_screen.dart';
import '../../features/stylus/presentation/screens/stylus_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../widgets/app_scaffold.dart';

part 'app_router.g.dart';

/// Router paths for the app
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String collection = '/collection';
  static const String playHistory = '/play-history';
  static const String logPlay = '/log-play';
  static const String stylus = '/stylus';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String recordDetail = '/record/:id';
}

/// Provider for the GoRouter instance
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Get auth status from preferences
      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.containsKey('auth_token');
      
      // Auth required paths
      final bool isAuthRoute = state.matchedLocation == AppRoutes.auth;
      final bool isSplashRoute = state.matchedLocation == AppRoutes.splash;
      
      // If the user is not logged in and not on auth or splash screen, redirect to auth
      if (!hasToken && !isAuthRoute && !isSplashRoute) {
        return AppRoutes.auth;
      }
      
      // If the user is logged in and on auth or splash screen, redirect to home
      if (hasToken && (isAuthRoute || isSplashRoute)) {
        return AppRoutes.home;
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      // Shell route for main app screens with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.collection,
            builder: (context, state) => const CollectionScreen(),
          ),
          GoRoute(
            path: AppRoutes.playHistory,
            builder: (context, state) => const PlayHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.stylus,
            builder: (context, state) => const StylusScreen(),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => const AnalyticsScreen(),
          ),
        ],
      ),
      // Route for record detail (could be modal or full screen)
      GoRoute(
        path: AppRoutes.recordDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RecordDetailScreen(releaseId: id);
        },
      ),
    ],
  );
}

/// Authentication state provider - this is a placeholder for now
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    // Initial state - not authenticated
    return false;
  }
  
  // Login method
  void login() {
    state = true;
  }
  
  // Logout method
  void logout() {
    state = false;
  }
}
