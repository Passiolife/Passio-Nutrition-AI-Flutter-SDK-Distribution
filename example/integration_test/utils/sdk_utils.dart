import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

Future<void> testWithoutConfigureSDK(
    Future<void> Function() testFunction) async {
  await NutritionAI.instance.shutDownPassioSDK();

  await testFunction();
}

Future<void> testWithConfigureSDK(Future<void> Function() testFunction) async {
  await configureSDK();

  await testFunction();
}

Future<void> testWithLanguage(Future<void> Function() testFunction,
    {String languageCode = 'es'}) async {
  await updateLanguage(languageCode);
  try {
    await testFunction();
  } finally {
    await updateLanguage('en');
  }
}

Future<void> configureSDK() async {
  // Configure the Passio SDK with a key for testing.
  const configuration = PassioConfiguration(AppSecret.passioKey);
  final status = await NutritionAI.instance.configureSDK(configuration);
  expect(status.mode, PassioMode.isReadyForDetection);
}

Future<void> updateLanguage(String languageCode) async {
  // Update the SDK language to the specified language.
  final bool status = await NutritionAI.instance.updateLanguage(languageCode);
  expect(status, isTrue);
}
