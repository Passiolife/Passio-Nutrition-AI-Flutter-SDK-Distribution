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
  group('fetchIconFor tests', () {
    // Expected output: The returned image should not be null.
    test('Pass the "VEG0018" as passioID test', () async {
      final PlatformImage? result =
          await NutritionAI.instance.fetchIconFor('VEG0018');
      expect(result, isNotNull);
    });

    // Expected output: The returned image should not be null, and its width and height should both be 360 pixels.
    test('Pass the "VEG0018" as passioID with iconSize of 360px test',
        () async {
      final PlatformImage? result = await NutritionAI.instance
          .fetchIconFor('VEG0018', iconSize: IconSize.px360);
      expect(result, isNotNull);
      expect(result?.width, equals(360));
      expect(result?.height, equals(360));
    });

    // Expected output: The returned image should be null.
    test('Pass the Empty as passioID test', () async {
      final PlatformImage? result = await NutritionAI.instance.fetchIconFor('');
      expect(result, isNull);
    });

    // Expected output: The returned image should be null.
    test('Pass the "AAAAAAA" as passioID test', () async {
      final PlatformImage? result =
          await NutritionAI.instance.fetchIconFor('AAAAAAA');
      expect(result, isNull);
    });
  });
}
