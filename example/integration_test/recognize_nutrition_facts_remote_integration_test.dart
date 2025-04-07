import 'package:flutter/services.dart';
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
  group('recognizeNutritionFactsRemote tests', () {
    // Expected output: Successfully parses Hidden Valley nutrition facts with serving size of 2 tbsp and 100 calories.
    test('Pass nutrition facts image of "Hidden Valley"', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_hidden_valley.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final PassioFoodItem? result =
          await NutritionAI.instance.recognizeNutritionFactsRemote(bytes);
      expect(result?.amount.selectedQuantity, 2);
      expect(result?.amount.selectedUnit, 'tbsp');
      expect(result?.nutrientsSelectedSize().calories?.value.round(), 100);
    });

    // Expected output: Returns a result with no calorie information because banana image does not contain a nutrition facts label
    test('Pass "Banana" image with no visible nutrition facts test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_banana.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final PassioFoodItem? result =
          await NutritionAI.instance.recognizeNutritionFactsRemote(bytes);
      expect(result?.nutrientsSelectedSize().calories, isNull);
    });

    // Expected output: Returns empty name and null calorie values when processing a non-food image without a nutrition facts label
    test('Pass non-food image without nutrition facts label test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_passio.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final PassioFoodItem? result =
          await NutritionAI.instance.recognizeNutritionFactsRemote(bytes);
      expect(result?.name, isEmpty);
      expect(result?.nutrientsSelectedSize().calories, isNull);
    });
  });
}
