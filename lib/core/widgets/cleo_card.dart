import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// A reusable card widget that follows Cleo design guidelines.
class CleoCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;
  
  /// Optional callback when the card is tapped.
  final VoidCallback? onTap;
  
  /// Optional padding for the card content.
  final EdgeInsetsGeometry? padding;
  
  /// Optional margin for the card.
  final EdgeInsetsGeometry? margin;
  
  /// Optional elevation for the card.
  final double? elevation;
  
  /// Whether to show a shadow under the card.
  final bool showShadow;

  /// Constructor
  const CleoCard({
    super.key, 
    required this.child, 
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? (showShadow ? 2 : 0),
      shape: RoundedRectangleBorder(
        borderRadius: CleoSpacing.borderRadius,
      ),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: InkWell(
        borderRadius: CleoSpacing.borderRadius,
        onTap: onTap,
        child: Padding(
          padding: padding ?? CleoSpacing.cardPadding,
          child: child,
        ),
      ),
    );
  }
}
