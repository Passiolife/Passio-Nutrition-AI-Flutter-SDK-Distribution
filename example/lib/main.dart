import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/advisor_image/advisor_image_page.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/camera_recognition_page.dart';
import 'package:nutrition_ai_example/presentation/food_analysis/food_analysis_page.dart';
import 'package:nutrition_ai_example/presentation/food_search/food_search_page.dart';
import 'package:nutrition_ai_example/presentation/meal_plan/meal_plan_page.dart';
import 'package:nutrition_ai_example/presentation/recognize_speech/recognize_speech_page.dart';
import 'package:nutrition_ai_example/presentation/static_image/static_image_page.dart';
import 'package:nutrition_ai_example/presentation/suggestion/suggestion_page.dart';
import 'package:nutrition_ai_example/router/routes.dart';

import 'presentation/advisor_message/advisor_message_page.dart';
import 'presentation/legacy_api/legacy_api_page.dart';
import 'presentation/nutrition_facts/nutrition_facts_page.dart';
import 'presentation/recognize_image/recognize_image_page.dart';

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
              Routes.suggestionsPage: (context) => const SuggestionPage(),
              Routes.mealPlansPage: (context) => const MealPlanPage(),
              Routes.legacyApiPage: (context) => const LegacyApiPage(),
              Routes.recognizedSpeechPage: (context) =>
                  const RecognizeSpeechPage(),
              Routes.recognizedImagePage: (context) =>
                  const RecognizeImagePage(),
              Routes.nutritionFactsPage: (context) =>
                  const NutritionFactsPage(),
              Routes.advisorMessagePage: (context) =>
                  const AdvisorMessagePage(),
              Routes.advisorImagePage: (context) => const AdvisorImagePage(),
              Routes.foodAnalysisPage: (context) => const FoodAnalysisPage(),
            },
            home: const MyApp(),
          );
        },
      ),
    );
  }, (error, stackTrace) async {
    if (kReleaseMode) {
      /// Here we can track our error into the crashlytics.
    } else {
      log('error: ${error.toString()}');
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
  String _advisorError = '';
  PassioStatus? _passioStatus;
  bool _sdkIsReady = false;
  bool _advisorSDKIsReady = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initPlatformState();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion =
          await NutritionAI.instance.getSDKVersion() ?? 'Unknown SDK version';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Passio SDK Plugin'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(height: 20), // Adds space of 20 units
            Center(
              child: Text(
                  "Advisor SDK: ${_advisorSDKIsReady ? 'is Ready' : _advisorError.isNotEmpty ? _advisorError : ''}"),
            ),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? // Adds space of 20 units
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, Routes.cameraRecognitionPage);
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
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.suggestionsPage);
                    },
                    child: const Text('Suggestions'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.mealPlansPage);
                    },
                    child: const Text('Meal Plans'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.legacyApiPage);
                    },
                    child: const Text('Legacy API'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.recognizedSpeechPage);
                    },
                    child: const Text('Recognize Speech'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.recognizedImagePage);
                    },
                    child: const Text('Recognize Image'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.nutritionFactsPage);
                    },
                    child: const Text('Nutrition Facts'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _sdkIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.foodAnalysisPage);
                    },
                    child: const Text('Food Analysis'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _advisorSDKIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.advisorMessagePage);
                    },
                    child: const Text('Advisor Message'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
            _advisorSDKIsReady
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.advisorImagePage);
                    },
                    child: const Text('Advisor Image'),
                  )
                : const SizedBox(),
            const SizedBox(height: 20), // Adds space of 20 units
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

    String advisorKey = AppSecret.advisorKey;
    final result = await NutritionAdvisor.instance.configure(advisorKey);
    switch (result) {
      case Error():
        _advisorError = result.message;
        _advisorSDKIsReady = false;
        break;
      case Success():
        _advisorSDKIsReady = true;
        break;
    }

    setState(() {
      _passioStatus = passioStatus;
    });
  }
}
