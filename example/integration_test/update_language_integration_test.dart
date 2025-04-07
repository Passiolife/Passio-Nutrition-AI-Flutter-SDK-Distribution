import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

void main() {
  // This function is called once before all tests are run.
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  runTests();
}

void runTests() {
  group('updateLanguage tests', () {
    // Expected output: Returns true with supported language code.
    test('Pass valid language code "es"', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);
    });

    // Expected output: Returns false with unsupported language code.
    test('Pass invalid language code "gj"', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('gj');
      expect(languageResult, isFalse);
    });

    /// Expected Output:
    /// 1. Language update to Hindi succeeds
    /// 2. Search results for "Apple" include the Hindi word "सेब"
    /// 3. Alternative names list includes the Hindi translation "सेब"
    test('Set SDK language to "hi", search for "Apple"', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('hi');
      expect(languageResult, isTrue);
      final result = await NutritionAI.instance.searchForFood('Apple');
      expect(
          result.results,
          anyElement((PassioFoodDataInfo e) =>
              e.foodName.toLowerCase().contains('सेब')));
      expect(result.alternateNames,
          anyElement((String e) => e.toLowerCase().contains('सेब')));
    });
  });
}
