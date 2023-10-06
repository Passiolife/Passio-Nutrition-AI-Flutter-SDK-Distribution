import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// [AppButtonLoadingWidget] is used to show loading when api is call.
class AppButtonLoadingWidget extends StatelessWidget {
  final Color? color;

  const AppButtonLoadingWidget({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r8)),
        backgroundColor: color ?? AppColors.buttonColor.withOpacity(0.50),
      ),
      onPressed: null,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 40,
          height: 20,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: [color ?? AppColors.buttonColor],
          ),
        ),
      ),
    );
  }
}
