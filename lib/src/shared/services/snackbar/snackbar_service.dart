import 'package:flutter/material.dart';

abstract class SnackbarService {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
    );
  }
}
