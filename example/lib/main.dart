import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/languages.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/advisor_image/advisor_image_page.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/camera_recognition_page.dart';
import 'package:nutrition_ai_example/presentation/food_analysis/food_analysis_page.dart';
import 'package:nutrition_ai_example/presentation/food_search/food_search_page.dart';
import 'package:nutrition_ai_example/presentation/meal_plan/meal_plan_page.dart';
import 'package:nutrition_ai_example/presentation/predict_next_ingredient/predict_next_ingredient_page.dart';
import 'package:nutrition_ai_example/presentation/recognize_speech/recognize_speech_page.dart';
import 'package:nutrition_ai_example/presentation/suggestion/suggestion_page.dart';
import 'package:nutrition_ai_example/presentation/third_party_camera/third_party_camera_page.dart';
import 'package:nutrition_ai_example/router/routes.dart';

import 'presentation/advisor_message/advisor_message_page.dart';
import 'presentation/legacy_api/legacy_api_page.dart';
import 'presentation/nutrition_facts/nutrition_facts_page.dart';
import 'presentation/recognize_image/recognize_image_page.dart';
import 'presentation/recognize_nutrition_facts/recognize_nutrition_facts_page.dart';
import 'presentation/search_food_semantic/search_food_semantic_page.dart';

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
            debugShowCheckedModeBanner: false,
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
              Routes.recognizeNutritionFacts: (context) =>
                  const RecognizeNutritionFactsPage(),
              Routes.searchFoodSemantic: (context) =>
                  const SearchFoodSemanticPage(),
              Routes.predictNextIngredient: (context) =>
                  const PredictNextIngredientPage(),
              Routes.thirdPartyCamera: (context) =>
                  const ThirdPartyCameraPage(),
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
      log('error: ${error.toString()} stackTrace: $stackTrace');
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
  bool _advisorSDKIsReady = false;

  String _languageCode = 'en';

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
            const SizedBox(height: 20),
            // Adds space of 20 units
            Center(
              child: Text('SDK Version: $_platformVersion\n'),
            ),
            Center(
              child: _passioStatus == null
                  ? const Text("Configuring SDK")
                  : Text(
                      '${_passioStatus!.mode.name} - ${_passioStatus?.debugMessage ?? ''}',
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(height: 20),
            // Adds space of 20 units
            if (_passioStatus == null) const CircularProgressIndicator(),
            // Shows loading indicator if SDK is not ready
            if (_sdkIsReady) ...[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Theme(
                      data:
                          Theme.of(context).copyWith(primaryColor: Colors.pink),
                      child: LanguagePickerDialog(
                        isSearchable: true,
                        title: const Text('Select your language'),
                        onValuePicked: (Language language) async {
                          setState(() {
                            _languageCode = language.isoCode;
                          });
                          bool updated = await NutritionAI.instance
                              .updateLanguage(_languageCode);
                          if (!updated) {
                            _languageCode = 'en';
                          }
                        },
                        itemBuilder: _buildDialogItem,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Language Code: $_languageCode',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.cameraRecognitionPage);
                },
                child: const Text('Camera Recognition'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.foodSearchPage);
                },
                child: const Text('Text Search'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.suggestionsPage);
                },
                child: const Text('Suggestions'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.mealPlansPage);
                },
                child: const Text('Meal Plans'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.legacyApiPage);
                },
                child: const Text('Legacy API'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.recognizedSpeechPage);
                },
                child: const Text('Recognize Speech'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.recognizedImagePage);
                },
                child: const Text('Recognize Image'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.nutritionFactsPage);
                },
                child: const Text('Nutrition Facts'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.foodAnalysisPage);
                },
                child: const Text('Food Analysis'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.recognizeNutritionFacts);
                },
                child: const Text('Recognize Nutrition Facts'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.searchFoodSemantic);
                },
                child: const Text('Search food semantic'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.predictNextIngredient);
                },
                child: const Text('Predict Next Ingredient'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
            ],

            if (_advisorSDKIsReady) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.advisorMessagePage);
                },
                child: const Text('Advisor Message'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.advisorImagePage);
                },
                child: const Text('Advisor Image'),
              ),
              const SizedBox(height: 20), // Adds space of 20 units
            ],
          ],
        ),
      ),
    );
  }

  void configureSDK() async {
    String passioKey = AppSecret.passioKey;
    var configuration =
        PassioConfiguration(passioKey, debugMode: 1, remoteOnly: false);
    var passioStatus = await NutritionAI.instance.configureSDK(configuration);
    if (passioStatus.mode == PassioMode.isReadyForDetection) {
      _sdkIsReady = true;
      _advisorSDKIsReady = true;

      NutritionAI.instance.setAccountListener(const _AccountListener());
    }

    setState(() {
      _passioStatus = passioStatus;
    });
  }

  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(language.name),
          const SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})"))
        ],
      );
}

class _AccountListener implements PassioAccountListener {
  const _AccountListener();

  @override
  void onTokenBudgetUpdate(PassioTokenBudget tokenBudget) {
    log(tokenBudget.toString());
  }
}
