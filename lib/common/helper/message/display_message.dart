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
    final viewInsets = MediaQuery.of(context).viewInsets;

    // Calculate positioning for just below the header/app bar
    final appBarHeight = kToolbarHeight; // Standard AppBar height (56.0)
    final statusBarHeight = viewPadding.top; // Status bar height
    final tabBarHeight = kTextTabBarHeight; // Standard TabBar height (48.0)

    // Position just below the header area
    final topPosition = statusBarHeight + appBarHeight + tabBarHeight + 8; // 8px padding
    final horizontalMargin = isSmallScreen ? 16.0 : 24.0;

    // Calculate available space for the SnackBar
    final availableHeight = screenSize.height - topPosition - viewInsets.bottom - 100;

    final snackBar = SnackBar(
      content: Container(
        constraints: BoxConstraints(
          maxHeight: availableHeight, // Allow expansion for long messages
          minHeight: 48, // Minimum height
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(icon, color: textColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4, // Better line height for readability
                ),
                maxLines: null, // Allow multiple lines for long messages
                softWrap: true,
              ),
            ),
          ],
        ),
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
      // Position right below the header/tab bar
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        top: topPosition,
        bottom: screenSize.height - topPosition - availableHeight.clamp(60.0, availableHeight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
