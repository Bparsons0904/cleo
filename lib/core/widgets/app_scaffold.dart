// lib/core/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_router.dart';
import '../theme/theme.dart';

/// A scaffold widget that provides the main layout for the app
/// including navigation controls.
class AppScaffold extends StatefulWidget {
  /// The current child widget to display in the body.
  final Widget child;

  /// Constructor
  const AppScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    if (location.startsWith(AppRoutes.home)) {
      return 0;
    } else if (location.startsWith(AppRoutes.logPlay)) {
      return 1;
    } else if (location.startsWith(AppRoutes.collection)) {
      return 2;
    } else if (location.startsWith(AppRoutes.playHistory)) {
      return 3;
    }
    
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow_outlined),
            activeIcon: Icon(Icons.play_arrow),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.album_outlined),
            activeIcon: Icon(Icons.album),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.logPlay);
        break;
      case 2:
        context.go(AppRoutes.collection);
        break;
      case 3:
        context.go(AppRoutes.playHistory);
        break;
    }
  }
}
