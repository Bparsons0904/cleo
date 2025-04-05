import 'package:flutter/material.dart';

/// Animation constants for the Cleo application.
/// Provides consistent animation durations and curves.
class CleoAnimations {
  // Standard duration for animations
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);

  // Reusable curve for smooth animations
  static const Curve curve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.easeOutBack;
  
  // Page transitions
  static PageRouteBuilder pageTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: medium,
    );
  }
  
  // Container transitions
  static Widget fadeTransition(
    Widget child, 
    Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
