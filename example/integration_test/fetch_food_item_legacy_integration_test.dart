import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

/*
void main() {
  // This function is called once before all tests are run.
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });
}
*/

void runTests() {
  group('fetchFoodItemLegacy tests', () {
    setUp(() async {
      // Reset the SDK language to English before each test.
      await NutritionAI.instance.updateLanguage('en');
    });

    // Expected output: The returned food item name should be "apple".
    test('Pass "VEG0018" passioID that contains PassioFoodItem test', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemLegacy('VEG0018');
      expect(result?.name, equalsIgnoringCase('apple'));
    });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: The returned food item name should be "manzana".
    test('Set the SDK language to "es" and pass "VEG0018" passioID that contains PassioFoodItem test', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final PassioFoodItem? result = await NutritionAI.instance.fetchFoodItemLegacy('VEG0018');
      expect(result?.name, equalsIgnoringCase('manzana'));
    });
    */

    // Expected output: The returned food item should be null because "passioID" is invalid.
    test('Pass "AAAAAAAA" passioID that is not valid test', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForRefCode('AAAAAAAA');
      expect(result, isNull);
    });
  });
}
