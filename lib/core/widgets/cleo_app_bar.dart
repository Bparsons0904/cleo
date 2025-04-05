import 'package:flutter/material.dart';

/// Custom AppBar widget that follows Cleo design guidelines.
class CleoAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title of the app bar.
  final String title;
  
  /// Optional leading widget (shown before the title).
  final Widget? leading;
  
  /// Optional list of actions (shown after the title).
  final List<Widget>? actions;
  
  /// Whether to show the back button.
  final bool showBackButton;
  
  /// Whether to center the title.
  final bool centerTitle;
  
  /// Optional callback when the back button is pressed.
  final VoidCallback? onBackPressed;
  
  /// Optional elevation for the app bar.
  final double? elevation;

  /// Constructor
  const CleoAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.onBackPressed,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: elevation,
      leading: _buildLeading(context),
      actions: actions,
    );
  }

  /// Build the leading widget based on parameters
  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }
    
    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
