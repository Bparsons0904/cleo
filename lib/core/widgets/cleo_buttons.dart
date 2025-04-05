import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// A collection of styled button widgets that follow Cleo design guidelines.
class CleoButtons {
  /// Primary button with background color
  static Widget primary({
    required VoidCallback onPressed,
    required Widget child,
    bool isFullWidth = false,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    String? tooltip,
  }) {
    return _buttonWrapper(
      tooltip: tooltip,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: CleoSpacing.md, 
            vertical: CleoSpacing.sm,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : child,
      ),
    );
  }

  /// Secondary button with outline
  static Widget secondary({
    required VoidCallback onPressed,
    required Widget child,
    bool isFullWidth = false,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    String? tooltip,
  }) {
    return _buttonWrapper(
      tooltip: tooltip,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: CleoSpacing.md, 
            vertical: CleoSpacing.sm,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(CleoColors.primary),
                ),
              )
            : child,
      ),
    );
  }

  /// Text button without background or outline
  static Widget text({
    required VoidCallback onPressed,
    required Widget child,
    bool isFullWidth = false,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    double? height,
    String? tooltip,
  }) {
    return _buttonWrapper(
      tooltip: tooltip,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: CleoSpacing.md, 
            vertical: CleoSpacing.sm,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(CleoColors.primary),
                ),
              )
            : child,
      ),
    );
  }
  
  /// Icon button with primary color
  static Widget icon({
    required VoidCallback onPressed,
    required IconData icon,
    double size = 24,
    Color? color,
    String? tooltip,
  }) {
    final Widget buttonWidget = IconButton(
      icon: Icon(
        icon,
        size: size,
        color: color ?? CleoColors.primary,
      ),
      onPressed: onPressed,
    );
    
    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: buttonWidget,
      );
    }
    
    return buttonWidget;
  }

  /// Helper method to wrap buttons with common styling
  static Widget _buttonWrapper({
    required Widget child,
    required bool isFullWidth,
    required bool isLoading,
    String? tooltip,
    double? height,
  }) {
    Widget result = child;
    
    if (height != null) {
      result = SizedBox(
        height: height,
        child: result,
      );
    }
    
    if (isFullWidth) {
      result = SizedBox(
        width: double.infinity,
        child: result,
      );
    }
    
    if (tooltip != null) {
      result = Tooltip(
        message: tooltip,
        child: result,
      );
    }
    
    return result;
}}
