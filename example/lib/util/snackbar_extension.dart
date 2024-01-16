import 'package:flutter/material.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(getSnackBar(
      text: text,
      actionLabel: actionLabel,
      onPressAction: onPressAction,
      context: this,
    ));
  }
}

extension SnackbarStateExtension on ScaffoldMessengerState {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    showSnackBar(getSnackBar(
        text: text, actionLabel: actionLabel, onPressAction: onPressAction));
  }
}

SnackBar getSnackBar({
  String? text,
  String? actionLabel,
  VoidCallback? onPressAction,
  BuildContext? context,
}) {
  SnackBar? snackBar;
  if (actionLabel != null) {
    snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
      content: Text(
        text ?? '',
      ),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () => onPressAction?.call(),
      ),
    );
  } else {
    snackBar = SnackBar(
      content: Text(
        text ?? '',
        style: const TextStyle(color: AppColors.whiteColor),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    );
  }
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  return snackBar;
}
