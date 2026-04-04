import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.red);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, Colors.blue);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}