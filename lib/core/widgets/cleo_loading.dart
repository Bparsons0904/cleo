import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';

/// A custom loading indicator widget.
class CleoLoading extends StatelessWidget {
  /// Size of the loading indicator
  final double size;
  
  /// Color of the loading indicator (defaults to primary)
  final Color? color;
  
  /// Optional message to display below the indicator
  final String? message;
  
  /// Whether to show the loading indicator with a full-screen overlay
  final bool isFullScreen;
  
  /// Whether to use a circular progress indicator (true) or linear (false)
  final bool isCircular;
  
  /// Constructor
  const CleoLoading({
    Key? key,
    this.size = 40.0,
    this.color,
    this.message,
    this.isFullScreen = false,
    this.isCircular = true,
  }) : super(key: key);
  
  /// Convenience method for a full screen loading indicator
  factory CleoLoading.fullScreen({
    double size = 40.0,
    Color? color,
    String? message,
  }) => CleoLoading(
    size: size,
    color: color,
    message: message,
    isFullScreen: true,
  );

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = color ?? CleoColors.primary;
    
    Widget loadingIndicator = isCircular
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            strokeWidth: 3.0,
          )
        : LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          );
    
    if (isCircular) {
      loadingIndicator = SizedBox(
        width: size,
        height: size,
        child: loadingIndicator,
      );
    }
    
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loadingIndicator,
        if (message != null) ...[
          const SizedBox(height: CleoSpacing.md),
          Text(
            message!,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.dark 
                ? CleoColors.darkTextSecondary 
                : CleoColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
    
    if (isFullScreen) {
      return Container(
        color: Colors.black.withAlpha(76), // Changed from withOpacity(0.3)
        child: Center(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: CleoSpacing.borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(CleoSpacing.md),
              child: content,
            ),
          ),
        ),
      );
    }
    
    return Center(child: content);
  }
}
