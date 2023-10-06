import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/app_button.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/image_background_widget.dart';
import 'package:flutter_nutrition_ai_demo/router/routes.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ImageBackgroundWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: context.localization?.welcome ?? '',
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dimens.h140.verticalSpace,
              Text(
                context.localization?.welcome ?? "",
                style: AppStyles.style18.copyWith(fontSize: Dimens.fontSize28, color: AppColors.whiteColor),
              ),
              const Spacer(),
              Hero(
                tag: context.localization?.signIn ?? '',
                child: AppButton(
                  buttonName: context.localization?.signIn ?? '',
                  onTap: _handleSignInTap,
                  color: Colors.black12,
                ),
              ),
              Dimens.h24.verticalSpace,
              Hero(
                tag: context.localization?.signUp ?? '',
                child: AppButton(
                  buttonName: context.localization?.signUp ?? '',
                  onTap: _handleSignUpTap,
                ),
              ),
              Dimens.h32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignInTap() {
    context.pushNamed(Routes.signInPage);
  }

  void _handleSignUpTap() {
    context.pushNamed(Routes.signUpPage);
  }
}
