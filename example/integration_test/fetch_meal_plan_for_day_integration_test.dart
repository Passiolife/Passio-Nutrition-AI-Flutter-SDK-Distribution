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
  group('fetchMealPlanForDay tests', () {
    // Expected output: Verify that the system retrieves the Day 1 meal plan for the keto diet, ensuring it includes meals specifically categorized under "Green Tea Plans
    test('Retrieve Day 1 Meal Plan for Keto Diet test', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final List<PassioMealPlanItem> result =
          await NutritionAI.instance.fetchMealPlanForDay('keto', 1);
      expect(result.first.dayTitle.toLowerCase(), 'day 1');
    });

    // Expected output: Verify that the system retrieves the Day 4 meal plan for the keto diet, ensuring it includes meals specifically categorized under "Water" Plans
    test('Retrieve Day 4 Meal Plan for Keto Diet test', () async {
      final List<PassioMealPlanItem> result =
          await NutritionAI.instance.fetchMealPlanForDay('keto', 4);
      expect(result.first.dayTitle.toLowerCase(), 'day 4');
    });

    // Expected output: Validate that the system returns a null response when attempting to retrieve the Day 4 meal plan for the "XYZ Outside Meal" category, as it is expected to be unavailable
    test('Retrieve Day 4 Meal Plan for XYZ Outside Meal - Expect Null test',
        () async {
      final List<PassioMealPlanItem> result =
          await NutritionAI.instance.fetchMealPlanForDay('XYZ', 4);
      expect(result, isEmpty);
    });
  });
}
