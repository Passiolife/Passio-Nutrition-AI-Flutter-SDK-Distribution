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
  group('predictNextIngredients tests', () {
    // Expected output: Verify that the result should not empty.
    test('Pass "[cheese, tomato] to predictNextIngredients', () async {
      final List<PassioFoodDataInfo> foodItem = await NutritionAI.instance
          .predictNextIngredients(["cheese", "tomato"]);
      expect(foodItem, isNotEmpty);
    });

    // Expected output: Verify that the result should be success and the value should be true.
    test(
        'Set the SDK language to "es" and pass "[cheese, tomato] to predictNextIngredients',
        () async {
      final bool languageResult =
          await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);
      final List<PassioFoodDataInfo> foodItem = await NutritionAI.instance
          .predictNextIngredients(["cheese", "tomato"]);
      expect(foodItem, isNotEmpty);
    });

    // Expected output: Verify that the result should be empty.
    test('Pass empty list', () async {
      final List<PassioFoodDataInfo> foodItem =
          await NutritionAI.instance.predictNextIngredients([]);
      expect(foodItem, isEmpty);
    });
  });
}
