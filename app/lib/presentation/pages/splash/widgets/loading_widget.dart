import 'package:flutter/cupertino.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(
          color: AppColors.passioInset,
          radius: Dimens.r18,
        ),
        SizedBox(width: Dimens.w8),
        Text(
          context.localization?.configuringSDK ?? '',
          style: AppStyles.style18.copyWith(
            color: AppColors.passioInset,
          ),
        ),
      ],
    );
  }
}
