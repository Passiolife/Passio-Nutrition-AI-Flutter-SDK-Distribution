import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';

typedef OnTapLogout = VoidCallback;

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({this.onTapLogOut, super.key});

  final OnTapLogout? onTapLogOut;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapLogOut,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.w16),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            context.localization?.logout.toTitleCase ?? '',
            style: AppStyles.style17.copyWith(
              color: AppColors.customBase,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.customBase,
            ),
          ),
        ),
      ),
    );
  }
}
