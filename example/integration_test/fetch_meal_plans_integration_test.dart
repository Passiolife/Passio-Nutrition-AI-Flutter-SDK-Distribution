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
  group('fetchMealPlans tests', () {
    // Expected output: Validate that the meal plan retrieval functionality fetches exactly 10 meal plans
    test('Retrieve All Meal Plans with', () async {
      final List<PassioMealPlan> result =
          await NutritionAI.instance.fetchMealPlans();
      expect(result.length, equals(10));
    });

    // Expected output: Validate that the meal plan retrieval functionality fetches exactly 10 meal plans
    test('Retrieve All Meal Plans with Language', () async {
      final List<PassioMealPlan> result =
          await NutritionAI.instance.fetchMealPlans();
      expect(result.length, equals(10));
    });

    // Expected output: The meal plan list should have both "keto" and "diabetes" items
    test(
        'Verify that the list of retrieved meal plans contains options labeled as "keto" and "diabetes."',
        () async {
      final List<PassioMealPlan> result =
          await NutritionAI.instance.fetchMealPlans();
      expect(result.length, equals(10));
      expect(
          result,
          anyElement(
              (PassioMealPlan e) => e.mealPlanLabel.toLowerCase() == 'keto'));
      expect(
          result,
          anyElement((PassioMealPlan e) =>
              e.mealPlanLabel.toLowerCase() == 'diabetes'));
    });
  });
}
