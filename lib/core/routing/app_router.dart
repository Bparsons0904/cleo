// lib/core/routing/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/collection/presentation/screens/collection_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/play_history/presentation/screens/play_history_screen.dart';
import '../../features/record_detail/presentation/screens/record_detail_screen.dart';
import '../../features/stylus/presentation/screens/stylus_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/log_play/presentation/screens/log_play_screen.dart';
import '../../features/log_play/presentation/screens/log_play_detail_screen.dart';
import '../../main.dart';
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
  static const String logPlayDetail = '/log-play-detail/:id';
  static const String stylus = '/stylus';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String recordDetail = '/record/:id';
}

/// Provider for the previous auth status
final previousAuthStatusProvider = StateProvider<AuthenticationStatus?>((ref) => null);

/// Provider for the GoRouter instance
@riverpod
GoRouter appRouter(Ref ref) {
  final authStatus = ref.watch(authStatusProvider);
  final previousAuthStatus = ref.watch(previousAuthStatusProvider);
  
  // Update the previous auth status when the current status changes
  if (authStatus != previousAuthStatus && previousAuthStatus != null) {
    // We need to defer the update to avoid changing state during build
    Future.microtask(() {
      ref.read(previousAuthStatusProvider.notifier).state = authStatus;
    });
  } else if (previousAuthStatus == null) {
    // Initialize on first run
    Future.microtask(() {
      ref.read(previousAuthStatusProvider.notifier).state = authStatus;
    });
  }

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Skip redirects for record detail and log play detail
      // This ensures we stay on these screens when logging plays/cleanings
      if (state.matchedLocation.startsWith('/record/') || 
          state.matchedLocation.startsWith('/log-play-detail/')) {
        return null;
      }
      
      // Simplified redirect logic based on auth status
      final bool isAuthRoute = state.matchedLocation == AppRoutes.auth;
      final bool isSplashRoute = state.matchedLocation == AppRoutes.splash;
      
      // If not authenticated and not on auth or splash screen, go to auth
      if (authStatus == AuthenticationStatus.unauthenticated && 
          !isAuthRoute && 
          !isSplashRoute) {
        return AppRoutes.auth;
      }
      
      // If authenticated and on auth or splash screen, go to home
      if (authStatus == AuthenticationStatus.authenticated && 
          (isAuthRoute || isSplashRoute)) {
        return AppRoutes.home;
      }
      
      // If there's an error with auth, go to auth screen
      if (authStatus == AuthenticationStatus.error && !isAuthRoute) {
        return AppRoutes.auth;
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
            path: AppRoutes.logPlay,
            builder: (context, state) => const LogPlayScreen(),
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
      GoRoute(
        path: AppRoutes.recordDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RecordDetailScreen(releaseId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.logPlayDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LogPlayDetailScreen(releaseId: id);
        },
      ),
    ],
  );
}
