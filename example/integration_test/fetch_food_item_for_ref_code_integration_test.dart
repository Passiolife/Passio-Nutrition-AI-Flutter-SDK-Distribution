import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

/*void main() {
  // This function is called once before all tests are run.
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });
}*/

void runTests() {
  group('fetchFoodItemForRefCode tests', () {
    // Expected output: The returned food item name should be "apple".
    test('Pass "refCode" that contains PassioFoodItem test', () async {
      final PassioFoodItem? result = await NutritionAI.instance
          .fetchFoodItemForRefCode(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result?.name, equalsIgnoringCase('apple'));
    });

    // Expected output: The returned food item name should be "manzana".
    test(
        'Set the SDK language to "es" and pass "refCode" that contains PassioFoodItem test',
        () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final PassioFoodItem? result = await NutritionAI.instance
          .fetchFoodItemForRefCode(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result?.name, equalsIgnoringCase('manzana'));
    });

    // Expected output: The returned food item should be null because "refCode" is invalid.
    test('Pass "refCode" that is not valid test', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForRefCode('AAAAAAAA');
      expect(result, isNull);
    });
  });
}
