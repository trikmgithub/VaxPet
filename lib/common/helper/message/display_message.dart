import 'package:flutter/material.dart';

class DisplayMessage {
  static void errorMessage(String message, BuildContext context) {
    _showTopSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade50,
      borderColor: Colors.red,
      textColor: Colors.red.shade900,
      icon: Icons.error_outline,
    );
  }

  static void successMessage(String message, BuildContext context) {
    _showTopSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade50,
      borderColor: Colors.green,
      textColor: Colors.green.shade900,
      icon: Icons.check_circle_outline,
    );
  }

  static void _showTopSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
  }) {
    // Dismiss any existing SnackBars first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Get safe area padding to account for system UI
    final viewPadding = MediaQuery.of(context).viewPadding;

    // Calculate safe margins for top positioning
    final topMargin = viewPadding.top + 16; // Safe area top + padding
    final horizontalMargin = isSmallScreen ? 16.0 : 24.0;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      duration: const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
      // Position at top of screen with safe area consideration
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        top: topMargin,
        // Large bottom margin to push SnackBar to top
        bottom: screenSize.height - topMargin - 80,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
