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
    } else if (location.startsWith(AppRoutes.collection)) {
      return 1;
    } else if (location.startsWith(AppRoutes.playHistory)) {
      return 2;
    } else if (location.startsWith(AppRoutes.stylus)) {
      return 3;
    } else if (location.startsWith(AppRoutes.analytics)) {
      return 4;
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.album),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_input_component),
            label: 'Styluses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  FloatingActionButton? _buildFloatingActionButton(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    // Show FAB for certain screens
    if (location.startsWith(AppRoutes.collection) || 
        location.startsWith(AppRoutes.home)) {
      return FloatingActionButton(
        onPressed: () {
          // Navigate to log play screen
          context.push(AppRoutes.logPlay);
        },
        tooltip: 'Log Play',
        child: const Icon(Icons.play_arrow),
      );
    }
    
    return null;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.collection);
        break;
      case 2:
        context.go(AppRoutes.playHistory);
        break;
      case 3:
        context.go(AppRoutes.stylus);
        break;
      case 4:
        context.go(AppRoutes.analytics);
        break;
    }
  }
}
