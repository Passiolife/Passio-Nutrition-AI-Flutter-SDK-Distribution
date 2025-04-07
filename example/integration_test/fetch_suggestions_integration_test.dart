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
  group('fetchSuggestions tests', () {
    // Expected output: Verify that the breakfast suggestion API correctly processes the request and returns "Coffee" as a suggestion, with its calorie count specified as 2 kcal
    test('Pass Breakfast Suggestion - Return Coffee with 2 Kcal test',
        () async {
      final List<PassioFoodDataInfo> result =
          await NutritionAI.instance.fetchSuggestions(PassioMealTime.breakfast);
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.foodName.toLowerCase() == 'coffee'));
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.nutritionPreview.calories == 2));
    });

    // Expected output: Verify that the lunch suggestion API correctly processes the request and returns keyword with "rice" as a suggestion, with its calorie count specified as arround 200 (50) kcal
    test('Pass Lunch Suggestion - Return Rice with around 204 Kcal', () async {
      final List<PassioFoodDataInfo> result =
          await NutritionAI.instance.fetchSuggestions(PassioMealTime.lunch);
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.foodName.toLowerCase() == 'cooked white rice'));
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.nutritionPreview.calories == 204));
    });

    // Expected output: Verify that the dinner suggestion API correctly processes the request and returns keyword with "rice" as a suggestion, with its calorie count specified as arround 200 (50) kcal
    test('Pass Dinner Suggestion - Return Coffee with 204 Kcal', () async {
      final List<PassioFoodDataInfo> result =
          await NutritionAI.instance.fetchSuggestions(PassioMealTime.dinner);
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.foodName.toLowerCase() == 'cooked white rice'));
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.nutritionPreview.calories == 204));
    });

    // Expected output: Verify that the Snack suggestion API correctly processes the request and returns "banana" as a suggestion, with its calorie count specified as 200 kcal
    test('Pass Snack Suggestion - Return Banana with 200 Kcal', () async {
      final List<PassioFoodDataInfo> result =
          await NutritionAI.instance.fetchSuggestions(PassioMealTime.snack);
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioFoodDataInfo element) =>
              element.foodName.toLowerCase() == 'banana'));
    });
  });
}
