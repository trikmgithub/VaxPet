import 'package:flutter/material.dart';

class DisplayMessage {
  static void errorMessage(String message, BuildContext context) {
    var snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void successMessage(String message, BuildContext context) {
    var snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.green),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}