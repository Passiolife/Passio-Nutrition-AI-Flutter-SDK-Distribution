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

    final PassioResult<void> result =
        await NutritionAdvisor.instance.initConversation();
    switch (result) {
      case Error():
        expect(result.message, isNotEmpty);
      case Success():
    }
  });

  runTests();
}

void runTests() {
  group('advisorSendMessage tests', () {
    // Expected output: Verify that the result is Success, markupContent, messageId, rawContent, and tools are not empty, and extractedIngredients is null.
    test('Pass valid message "Coffee with milk" test', () async {
      testWithConfigureSDK(() async {
        final PassioResult<PassioAdvisorResponse> result =
            await NutritionAdvisor.instance.sendMessage('Coffee with milk');
        switch (result) {
          case Success():
            expect(result.value.extractedIngredients, isNull);
            expect(result.value.markupContent, isNotEmpty);
            expect(result.value.messageId, isNotEmpty);
            expect(result.value.rawContent, isNotEmpty);
            expect(result.value.tools, isNotEmpty);
            break;
          case Error():
            fail('Expected Success but got Error: ${result.message}');
        }
      });
    });

    // Expected output: Verify that the result is Error, and the message is not empty.
    test('Pass empty message test', () async {
      final PassioResult<PassioAdvisorResponse> result =
          await NutritionAdvisor.instance.sendMessage('');
      switch (result) {
        case Success():
          fail('Expected Error but got Success.');
        case Error():
          expect(result.message, isNotEmpty);
      }
    });
  });
}
