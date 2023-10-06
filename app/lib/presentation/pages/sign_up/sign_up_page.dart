import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/app_button.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/app_button_loading_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/app_textfield.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/image_background_widget.dart';
import 'package:flutter_nutrition_ai_demo/util/alert_dialog.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/keyboard_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// [_emailController] is use to get the value of email text field.
  final TextEditingController _emailController = TextEditingController(text: kDebugMode ? '' : '');

  /// [_passwordController] is use to get the value of password text field.
  final TextEditingController _passwordController = TextEditingController(text: kDebugMode ? '' : '');

  /// [_bloc] is use to fire the appropriate event and bloc will emit the state.
  /// So, based on that we will display the widget.
  final _bloc = sl<SignUpBloc>();

  /// While API call is running, display the loading,
  /// So [_isLoading] flag will update. By default it is [false].
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SignUpValidEmailErrorState) {
          showDialogBox(context, context.localization?.enterValidEmailAddress ?? '');
        } else if (state is SignUpValidPasswordErrorState) {
          showDialogBox(context, context.localization?.enterValidPassword ?? '');
        }
      },
      builder: (context, state) {
        return ImageBackgroundWidget(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              title: context.localization?.signUp ?? '',
              isBackVisible: true,
              backPageName: context.localization?.welcome ?? '',
              onBackTap: () {
                context.pop();
              },
              leadingWidth: Dimens.w92,
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: context.height - context.safeAreaPadding - 56,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Dimens.h140.verticalSpace,
                      Text(
                        context.localization?.signUp ?? '',
                        style: AppStyles.style18.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: Dimens.fontSize28,
                        ),
                      ),
                      Dimens.h16.verticalSpace,
                      AppTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: context.localization?.email ?? '',
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          _bloc.add(ValidateEmailAddressEvent(email: _emailController.text));
                        },
                      ),
                      Dimens.h32.verticalSpace,
                      AppTextField(
                        obscureText: true,
                        controller: _passwordController,
                        hintText: context.localization?.password ?? '',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                        },
                      ),
                      const Spacer(),
                      Text(
                        context.localization?.youHaveReadThePrivacyPolicy ?? "",
                        style: AppStyles.style14.copyWith(fontSize: Dimens.fontSize18, color: AppColors.whiteColor, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      Dimens.h16.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              buttonName: context.localization?.privacyPolicy ?? '',
                              onTap: () {},
                              color: Colors.black12,
                              fontSize: Dimens.fontSize16,
                            ),
                          ),
                          Dimens.w8.horizontalSpace,
                          Expanded(
                            child: AppButton(
                              buttonName: context.localization?.termsOfService ?? '',
                              onTap: () {},
                              color: Colors.black12,
                              fontSize: Dimens.fontSize16,
                            ),
                          )
                        ],
                      ),
                      Dimens.h16.verticalSpace,
                      _isLoading
                          ? const AppButtonLoadingWidget()
                          : AppButton(
                              buttonName: context.localization?.acceptSignUp ?? '',
                              onTap: () {
                                context.hideKeyboard();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
