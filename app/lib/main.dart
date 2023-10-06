import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_theme.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/router/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await Injector.setup();

    runApp(const MyApp());
  }, (error, stackTrace) async {
    log('Error: ${error.toString()}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// [_themeMode] is use to define the theme like: Light theme or dark theme.
  /// By default it is [ThemeMode.light].
  final ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(Dimens.designWidth, Dimens.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          /// Here, we have defined light theme.
          theme: sl<AppTheme>().lightTheme,

          /// Here, we have defined dark theme.
          darkTheme: sl<AppTheme>().darkTheme,

          /// Here we have defined theme mode like: light or dark.
          themeMode: _themeMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (supportedLocales.map((e) => e.languageCode).contains(deviceLocale?.languageCode)) {
              return deviceLocale;
            } else {
              return const Locale('en', '');
            }
          },
          routeInformationProvider: Routes.router.routeInformationProvider,
          routeInformationParser: Routes.router.routeInformationParser,
          routerDelegate: Routes.router.routerDelegate,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
