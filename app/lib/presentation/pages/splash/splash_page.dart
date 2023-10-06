import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/splash/widgets/loading_widget.dart';
import 'package:flutter_nutrition_ai_demo/router/routes.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// [SplashBloc]
  final _bloc = sl<SplashBloc>();

  @override
  void initState() {
    _bloc.add(DoConfigureSdkEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is ConfigureSuccessState) {
          _setInitialRoute();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImages.imgLaunch,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: context.bottomPadding + Dimens.h16,
                left: 0,
                right: 0,
                child: (state is ConfigureLoadingState)
                    ? const LoadingWidget()
                    : (state is ConfigureFailureState)
                        ? Text(
                            state.message,
                            style: AppStyles.style18.copyWith(color: AppColors.errorColor),
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setInitialRoute() {
    context.goNamed(Routes.dashboardPage);
  }
}
