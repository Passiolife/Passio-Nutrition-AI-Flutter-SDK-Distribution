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
  group('submitUserCreatedFood tests', () {
    // Expected output: Verify that the result should be success and the value should be true.
    test('Pass PassioFoodItem to submitUserCreatedFood', () async {
      final PassioFoodItem? foodItem =
          await NutritionAI.instance.fetchFoodItemForPassioID('VEG0018');
      expect(foodItem, isNotNull);
      final PassioResult<bool> result =
          await NutritionAI.instance.submitUserCreatedFood(foodItem!);
      switch (result) {
        case Success():
          expect(result.value, isTrue);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });

    // Expected output: Verify that the result should be success and the value should be true.
    test(
        'Set the SDK language to "es" and pass PassioFoodItem to submitUserCreatedFood',
        () async {
      final bool languageResult =
          await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);
      final PassioFoodItem? foodItem =
          await NutritionAI.instance.fetchFoodItemForPassioID('VEG0018');
      expect(foodItem, isNotNull);
      final PassioResult<bool> result =
          await NutritionAI.instance.submitUserCreatedFood(foodItem!);
      switch (result) {
        case Success():
          expect(result.value, isTrue);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });
  });
}
