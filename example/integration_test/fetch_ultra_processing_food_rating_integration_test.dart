import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

void main() {
  setUpAll(() async {
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  runTests();
}

void runTests() {
  group('fetchUltraProcessingFoodRating tests', () {
    // Expected Output: Result must be success, and chainOfThought should contain reasoning.
    test('Fetch UPF rating for a visual food item test', () async {
      final PassioFoodItem? foodItemResult = await NutritionAI.instance
          .fetchFoodItemForRefCode(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      if (foodItemResult == null) {
        fail('Failed to fetch food item for refCode');
      }
      final PassioResult<PassioUPFRating> upfRatingResult = await NutritionAI
          .instance
          .fetchUltraProcessingFoodRating(foodItemResult);
      switch (upfRatingResult) {
        case Success():
          expect(upfRatingResult.value.chainOfThought, isNotEmpty);
          expect(upfRatingResult.value.highlightedIngredients, isEmpty);
          expect(upfRatingResult.value.rating, greaterThanOrEqualTo(0));
          break;
        case Error():
          fail('Expected Success but got Error: ${upfRatingResult.message}');
      }
    });

    // Expected Output: Result must be non-null, chainOfThought and ingredients should not be empty, and rating should be >= 0.
    test('Fetch UPF rating for a barcode item test', () async {
      final PassioFoodItem? foodItemResult = await NutritionAI.instance
          .fetchFoodItemForProductCode('016000188853');
      if (foodItemResult == null) {
        fail('Failed to fetch food item for refCode');
      }
      final PassioResult<PassioUPFRating> upfRatingResult = await NutritionAI
          .instance
          .fetchUltraProcessingFoodRating(foodItemResult);
      switch (upfRatingResult) {
        case Success():
          expect(upfRatingResult.value, isNotNull);
          expect(upfRatingResult.value.chainOfThought, isNotEmpty);
          expect(upfRatingResult.value.highlightedIngredients, isNotEmpty);
          expect(upfRatingResult.value.rating, greaterThanOrEqualTo(0));
          break;
        case Error():
          fail('Expected Success but got Error: ${upfRatingResult.message}');
      }
    });
  });
}
