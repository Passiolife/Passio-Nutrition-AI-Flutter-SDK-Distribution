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

  runTests();
}*/

void runTests() {
  group('fetchHiddenIngredients tests', () {
    // Expected output: The returned result should be success and not empty.
    test('Pass "apple" foodName that contains Hidden Ingredients test',
        () async {
      final PassioResult<List<PassioAdvisorFoodInfo>> result =
          await NutritionAI.instance.fetchHiddenIngredients('apple');
      switch (result) {
        case Success():
          expect(result.value, isNotEmpty);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });

    // Expected output: The returned result should be success and not empty.
    test(
        'Set the SDK language to "es" and pass "apple" foodName that contains Hidden Ingredients test',
        () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final PassioResult<List<PassioAdvisorFoodInfo>> result =
          await NutritionAI.instance.fetchHiddenIngredients('apple');
      switch (result) {
        case Success():
          expect(result.value, isNotEmpty);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });

    // Expected output: The returned food item should be null because "passioID" is invalid.
    test('Pass "AAAAAAAA" foodName that is not valid test', () async {
      final PassioResult<List<PassioAdvisorFoodInfo>> result =
          await NutritionAI.instance.fetchHiddenIngredients('AAAAAAAA');
      switch (result) {
        case Success():
          fail('Expected Error but got Success: ${result.value}');
        case Error():
          expect(result.message, isNotEmpty);
      }
    });
  });
}
