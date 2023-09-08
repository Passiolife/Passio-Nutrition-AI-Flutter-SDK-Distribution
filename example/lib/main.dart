import 'dart:async';

//import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/camera_recognition_page.dart';
import 'package:nutrition_ai_example/presentation/food_search/food_search_page.dart';
import 'package:nutrition_ai_example/presentation/static_image/static_image_page.dart';
import 'package:nutrition_ai_example/router/routes.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Injector.setup();

    runApp(
      ScreenUtilInit(
          designSize: const Size(Dimens.designWidth, Dimens.designHeight),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (supportedLocales
                    .map((e) => e.languageCode)
                    .contains(deviceLocale?.languageCode)) {
                  return deviceLocale;
                } else {
                  return const Locale('en', '');
                }
              },
              // Start the app with the "/" named route. In this case, the app starts
              // on the FirstScreen widget.
              initialRoute: Routes.initialRoute,
              routes: {
                // When navigating to the [Routes.foodSearchPage] route, build the [FoodSearchPage] widget.
                Routes.cameraRecognitionPage: (context) =>
                    const CameraRecognitionPage(),
                Routes.foodSearchPage: (context) => const FoodSearchPage(),
                Routes.staticImagePage: (context) => const StaticImagePage(),
              },
              home: const MyApp(),
            );
          }),
    );
  }, (error, stackTrace) async {
    if (kReleaseMode) {
      /// Here we can track our error into the crashlytics.
    } else {
      // log('error: ${error.toString()}');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  PassioStatus? _passioStatus;
  bool _sdkIsReady = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await NutritionAI.instance.getSDKVersion() ??
          'Unknown SDK version';
    } on PlatformException {
      platformVersion = 'Failed to get SDK version.';
    }

    configureSDK();

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Passio SDK Plugin'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20), // Adds space of 20 units
            Center(
              child: Text('SDK Version: $_platformVersion\n'),
            ),
            Center(
              child: _passioStatus == null
                  ? const Text("Configuring SDK")
                  : Text(_passioStatus!.mode.name),
            ),
            _sdkIsReady
                ? // Adds space of 20 units
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.cameraRecognitionPage);
                    },
                    child: const Text('Camera Recognition'),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.foodSearchPage);
                    },
                    child: const Text('Text Search'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.staticImagePage);
                    },
                    child: const Text('Static image'),
                  )
                : const SizedBox(),

            // Text(_passioStatus?.mode.toString() ?? 'Not setup yet')
          ],
        ),
      ),
    );
  }

  void configureSDK() async {
    String passioKey = AppSecret.passioKey;
    var configuration = PassioConfiguration(passioKey, debugMode: -333);
    var passioStatus = await NutritionAI.instance.configureSDK(configuration);
    if (passioStatus.mode == PassioMode.isReadyForDetection) {
      _sdkIsReady = true;
    }

    setState(() {
      _passioStatus = passioStatus;
    });
  }
}
