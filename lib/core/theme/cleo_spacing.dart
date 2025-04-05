import 'package:flutter/material.dart';

/// Spacing constants for the Cleo application.
/// Provides consistent spacing values and reusable padding/margin methods.
class CleoSpacing {
  // Consistent spacing values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Reusable padding and margin methods
  static EdgeInsets get pagePadding => 
    const EdgeInsets.symmetric(horizontal: md, vertical: lg);

  static EdgeInsets get cardPadding => 
    const EdgeInsets.all(md);

  static EdgeInsets get listItemPadding =>
    const EdgeInsets.symmetric(horizontal: md, vertical: sm);

  static EdgeInsets get inputPadding =>
    const EdgeInsets.symmetric(horizontal: md, vertical: sm);

  static BorderRadius get borderRadius => 
    BorderRadius.circular(8.0);

  static BorderRadius get borderRadiusLarge => 
    BorderRadius.circular(12.0);

  // Responsive spacing helper
  static double responsiveSpacing(BuildContext context, double baseValue) {
    final double width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return baseValue * 1.25; // Larger spacing on desktop
    } else if (width > 600) {
      return baseValue * 1.1; // Slightly larger spacing on tablet
    }
    return baseValue; // Default spacing on mobile
  }
}
