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
  group('searchForFoodSemantic tests', () {
    setUp(() async {
      // Reset the SDK language to English before each test.
      await NutritionAI.instance.updateLanguage('en');
    });

    // Expected output: Empty list/array
    test('Empty string', () async {
      final result = await NutritionAI.instance.searchForFoodSemantic('');
      expect(result.alternateNames, isEmpty);
      expect(result.results, isEmpty);
    });

    // Expected output: Empty list/array
    test('String with less than 3 characters', () async {
      final result = await NutritionAI.instance.searchForFoodSemantic('Ap');
      expect(result.alternateNames, isEmpty);
      expect(result.results, isEmpty);
    });

    // Expected output: At least one item containing the foodName "apple", at least one suggestion containing the word "apple"
    test('Apple', () async {
      final result = await NutritionAI.instance.searchForFoodSemantic('Apple');
      expect(
          result.results,
          anyElement((PassioFoodDataInfo e) =>
              e.foodName.toLowerCase().contains('apple')));
      expect(result.alternateNames,
          anyElement((String e) => e.toLowerCase().contains('apple')));
    });

    // Expected output: At least one item containing the foodName "salad", , at least one suggestion containing the word "salad"
    test('Homemade Shrimp Cobb salad', () async {
      final result = await NutritionAI.instance
          .searchForFoodSemantic('Homemade Shrimp Cobb salad');
      expect(
          result.results,
          anyElement((PassioFoodDataInfo e) =>
              e.foodName.toLowerCase().contains('salad')));
      expect(result.alternateNames,
          anyElement((String e) => e.toLowerCase().contains('salad')));
    });

    // Expected output: At least one item containing the foodName "blueberries", at least one suggestion containing the word "blueberries"
    // test('blueberries', () async {
    //   final result = await NutritionAI.instance.searchForFoodSemantic('arándanos ');
    //   expect(result.results, anyElement((PassioFoodDataInfo e) => e.foodName.toLowerCase().contains('blueberries')));
    //   expect(result.alternateNames, anyElement((String e) => e.toLowerCase().contains('blueberries')));
    // });

    // Expected output: At least one item containing the foodName "pera", at least one suggestion containing the word "pera"
    test('Set SDK language to "es", search for "pera"', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);
      final result = await NutritionAI.instance.searchForFoodSemantic('pera');
      expect(
          result.results,
          anyElement((PassioFoodDataInfo e) =>
              e.foodName.toLowerCase().contains('pera')));
      expect(result.alternateNames,
          anyElement((String e) => e.toLowerCase().contains('pera')));
    });
  });
}
