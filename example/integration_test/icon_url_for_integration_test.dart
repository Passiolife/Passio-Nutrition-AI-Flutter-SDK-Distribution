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
  group('iconURLFor tests', () {
    // Expected output: The returned image url should not be empty.
    test('Pass the "VEG0018" as passioID test', () async {
      final String result = await NutritionAI.instance.iconURLFor('VEG0018');
      expect(result, isNotEmpty);
    });

    // Expected output: The returned image url should not be empty, and it should contains 360 in url.
    test('Pass the "VEG0018" as passioID with iconSize of 360px test',
        () async {
      final String result = await NutritionAI.instance
          .iconURLFor('VEG0018', iconSize: IconSize.px360);
      expect(result, isNotEmpty);
      expect(result, contains('360'));
    });
  });
}
