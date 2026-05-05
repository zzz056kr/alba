import 'package:flutter/material.dart';

class AppFeedbackService {
  AppFeedbackService(this.messengerKey);

  final GlobalKey<ScaffoldMessengerState> messengerKey;

  void showError(String message) {
    final messenger = messengerKey.currentState;
    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF9E2F2F),
        ),
      );
  }
}
