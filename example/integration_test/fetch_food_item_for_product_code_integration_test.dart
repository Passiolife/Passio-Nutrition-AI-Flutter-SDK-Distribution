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
  group('fetchFoodItemForProductCode tests', () {
    // Expected output: The returned food item name should be "Reduced Sugar Cinnamon Granola".
    test('Pass the "016000188853" as productCode', () async {
      final PassioFoodItem? result = await NutritionAI.instance
          .fetchFoodItemForProductCode('016000188853');
      expect(
          result?.name, equalsIgnoringCase('Reduced Sugar Cinnamon Granola'));
    });

    // TODO: need to handle
    // Expected output: The returned food item name should be "Granola de Canela con Azúcar Reducida".
    test('Set the SDK language to "es" and pass "016000188853" as productCode',
        () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final PassioFoodItem? result = await NutritionAI.instance
          .fetchFoodItemForProductCode('016000188853');
      expect(
          result?.name, equalsIgnoringCase('Reduced Sugar Cinnamon Granola'));
    });

    // Expected output: The returned food item should be null because passioID is a food item.
    test('Pass the "VEG0018" as passioID', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForProductCode('VEG0018');
      expect(result, isNull);
    });

    // Expected output: The returned food item should be null because passioID is invalid.
    test('Pass the "AAAAAAA" as passioID', () async {
      final PassioFoodItem? result =
          await NutritionAI.instance.fetchFoodItemForProductCode('AAAAAAA');
      expect(result, isNull);
    });
  });
}
