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
}

void runTests() {
  group('fetchFoodItemForPassioID tests', () {
    setUp(() async {
      // Reset the SDK language to English before each test.
      await NutritionAI.instance.updateLanguage('en');
    });

    // Expected output: The returned food item name should be "apple".
    test('Pass the "VEG0018" as passioID', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForPassioID('VEG0018');
      expect(result?.name, equalsIgnoringCase('apple'));
    });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: The returned food item name should be "manzana".
    test('Set the SDK language to "es" and pass "VEG0018" as passioID', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final PassioFoodItem? result = await NutritionAI.instance.fetchFoodItemForPassioID('VEG0018');
      expect(result?.name, equalsIgnoringCase('manzana'));
    });
    */

    // Expected output: The returned food item should be null because passioID is a barcode.
    test('Pass the "681131018098" as passioID', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForPassioID('681131018098');
      expect(result, isNull);
    });

    // Expected output: The returned food item should be null because passioID is invalid.
    test('Pass the "AAAAAAA" as passioID', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForPassioID('AAAAAAA');
      expect(result, isNull);
    });
  });
}
