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
  group('lookupIconsFor tests', () {
    /// TODO: Uncomment once fix is available
    /*
    // Expected output: The returned image should not be null, and its width and height should both be 360 pixels.
    test('Pass the "VEG0018" as passioID with iconSize of 360px test',
        () async {
      final PassioFoodIcons result = await NutritionAI.instance
          .lookupIconsFor('VEG0023', iconSize: IconSize.px90);
      expect(result.defaultIcon, isNotNull);
      expect(result.defaultIcon.width, equals(360));
      expect(result.defaultIcon.height, equals(360));
    });
    */

    // Expected output: The returned image should not be null.
    test('Pass the "VEG0018" as passioID test', () async {
      await NutritionAI.instance.fetchIconFor('VEG0018');

      final PassioFoodIcons result = await NutritionAI.instance
          .lookupIconsFor('VEG0018', iconSize: IconSize.px90);
      expect(result.cachedIcon, isNotNull);
    });

    // Expected output: The returned image should be null.
    test('Pass the Empty as passioID test', () async {
      final PassioFoodIcons result =
          await NutritionAI.instance.lookupIconsFor('');
      expect(result.cachedIcon, isNull);
      expect(result.defaultIcon, isNotNull);
    });

    // Expected output: The returned image should be null.
    test('Pass the "AAAAAAA" as passioID test', () async {
      final PassioFoodIcons result =
          await NutritionAI.instance.lookupIconsFor('AAAAAAA');
      expect(result.cachedIcon, isNull);
      expect(result.defaultIcon, isNotNull);
    });
  });
}
