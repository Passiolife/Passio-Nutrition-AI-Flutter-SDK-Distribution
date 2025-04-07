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
  group('transformCGRectForm tests', () {
    /// TODO: Uncomment once fix is available
    /*
    // Expected output: Empty list/array
    test('Empty string', () async {
      const Rectangle<double> boundingBox = Rectangle<double>(10, 20, 30, 40);
      const Rectangle<double> toRect = Rectangle<double>(5, 15, 25, 35);

      final Rectangle<double> result = await NutritionAI.instance.transformCGRectForm(boundingBox, toRect);
      expect(result.left, greaterThanOrEqualTo(toRect.left));
      expect(result.top, lessThanOrEqualTo(toRect.top));
      expect(result.width, greaterThanOrEqualTo(toRect.width));
      expect(result.height, greaterThanOrEqualTo(toRect.height));
    });
    */
  });
}
