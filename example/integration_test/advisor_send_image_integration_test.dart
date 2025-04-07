import 'package:flutter/services.dart';
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
  group('advisorSendImage tests', () {
    // Expected output: Verify that the result is Success, extractedIngredients is not empty, and markupContent, messageId, rawContent, and tools are empty.
    test('Pass valid food image test', () {
      testWithConfigureSDK(() async {
        final ByteData data =
            await rootBundle.load('assets/images/img_multiple_foods.jpg');
        final Uint8List bytes = data.buffer.asUint8List();
        final PassioResult<PassioAdvisorResponse> result =
            await NutritionAdvisor.instance.sendImage(bytes);
        switch (result) {
          case Success():
            expect(result.value.extractedIngredients, isNotEmpty);
            expect(result.value.markupContent, isEmpty);
            expect(result.value.messageId, isEmpty);
            expect(result.value.rawContent, isEmpty);
            expect(result.value.tools, null);
            break;
          case Error():
            fail('Expected Success but got Error: ${result.message}');
        }
      });
    });

    // Expected output: Verify that the result is Error, and the message is not empty.
    test('Pass Image not containing any food or food packaging test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_passio.jpg');
      final Uint8List bytes = data.buffer.asUint8List();
      final PassioResult<PassioAdvisorResponse> result =
          await NutritionAdvisor.instance.sendImage(bytes);
      switch (result) {
        case Success():
          fail('Expected Error but got Success.');
        case Error():
          expect(result.message, isNotEmpty);
      }
    });
  });
}
