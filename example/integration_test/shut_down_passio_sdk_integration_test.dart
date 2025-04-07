import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

void main() {
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  runTests();
}

void runTests() {
  group('shutDownPassioSDK tests', () {
    /*test('shutDownPassioSDK test', () async {
      try {
        await NutritionAI.instance.shutDownPassioSDK();
      } catch (e) {
        fail('Failed to shut down Passio SDK: $e');
      }
    });

    test('shutDownPassioSDK without configureSDK', () async {
      try {
        testWithoutConfigureSDK(() async {
          await NutritionAI.instance.shutDownPassioSDK();
        });
      } catch (e) {
        fail('Failed to shut down Passio SDK: $e');
      }
    });*/

    test('searchForFood call after shutDownPassioSDK', () async {
      try {
        await NutritionAI.instance.shutDownPassioSDK();
        final PassioSearchResponse response =
            await NutritionAI.instance.searchForFood('Apple');
        expect(response.results, isEmpty);
        expect(response.alternateNames, isEmpty);
      } catch (e) {
        fail('Failed to search for food after shutting down Passio SDK: $e');
      }
    });
  });
}
