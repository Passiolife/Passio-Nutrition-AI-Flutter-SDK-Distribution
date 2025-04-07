import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

import 'utils/sdk_utils.dart';

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
  group('fetchIngredients tests', () {
    late PassioAdvisorResponse messageResult0;

    setUpAll(() async {
      final PassioResult<void> result =
          await NutritionAdvisor.instance.initConversation();
      switch (result) {
        case Error():
          fail(
              'initConversation failed, cannot test fetchIngredients: ${result.message}');
        case Success():
      }
      PassioResult<PassioAdvisorResponse> messageResult =
          await NutritionAdvisor.instance.sendMessage('Coffee with milk');
      switch (messageResult) {
        case Error():
          fail(
              'sendMessage failed, cannot test fetchIngredients: ${messageResult.message}');
        case Success():
          messageResult0 = messageResult.value;
      }
    });

    // Expected output: Verify that the fetchIngredients returns a Success result where extractedIngredients is not empty.
    test('Fetch ingredients for a valid message test', () async {
      final ingredientsResult =
          await NutritionAdvisor.instance.fetchIngredients(messageResult0);
      switch (ingredientsResult) {
        case Success():
          expect(ingredientsResult.value.extractedIngredients, isNotEmpty);
          break;
        case Error():
          fail('Expected Success but got Error: ${ingredientsResult.message}');
      }
    });

    // Expected output: Verify that fetchIngredients returns Error and the message is not empty.
    test('Fetch ingredients for an invalid response test', () async {
      const PassioAdvisorResponse response = PassioAdvisorResponse(
        markupContent: '',
        messageId: '',
        rawContent: '',
        tools: null,
        extractedIngredients: null,
        threadId: '',
      );
      final PassioResult<PassioAdvisorResponse> ingredientsResult =
          await NutritionAdvisor.instance.fetchIngredients(response);
      switch (ingredientsResult) {
        case Success():
          fail('Expected Error but got Success.');
        case Error():
          expect(ingredientsResult.message, isNotEmpty);
      }
    });

    test('Fetch ingredients without configureSDK', () async {
      testWithoutConfigureSDK(() async {
        final ingredientsResult =
            await NutritionAdvisor.instance.fetchIngredients(messageResult0);
        switch (ingredientsResult) {
          case Success():
            fail('Expected Error but got Success.');
          case Error():
            expect(ingredientsResult.message, isNotEmpty);
        }
      });
    });
  });
}
