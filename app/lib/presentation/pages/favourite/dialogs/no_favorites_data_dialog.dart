import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/adaptive_action_button_widget.dart';

typedef OnTapPositive = VoidCallback;

class NoFavoritesDataDialog {
  NoFavoritesDataDialog.show({
    required BuildContext context,
    String? title,
    String? message,
    String? positiveButtonText,
    String? negativeButtonText,

    OnTapPositive? onTapPositive,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: Dimens.duration300),
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(a1),
          child: child,
        );
      },
      pageBuilder: (context, animation, animation2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog.adaptive(
            title: Text(
              title ?? '',
              style: AppStyles.style17.copyWith(),
            ),
            content: Text(
              message ?? '',
              style: AppStyles.style17.copyWith(),
            ),
            actions: <Widget>[
              adaptiveAction(
                context: context,
                onPressed: onTapPositive,
                child: Text(
                  positiveButtonText ?? '',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
