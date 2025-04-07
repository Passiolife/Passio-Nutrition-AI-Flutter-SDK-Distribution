import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import 'utils/sdk_utils.dart';

void main() {
  runTests();
}

void runTests() {
  group('initConversation tests', () {
    // Expected output: Should return Success when the SDK is properly configured.
    test(
        'Calling initConversation after configuring the SDK should return Success.',
        () async {
      testWithConfigureSDK(() async {
        final PassioResult<void> result =
            await NutritionAdvisor.instance.initConversation();
        switch (result) {
          case Success():
            expect(result, isA<Success<void>>());
            break;
          case Error():
            fail('Expected Success but got Error: ${result.message}');
        }
      });
    });

    test('Calling initConversation without configureSDK', () async {
      testWithoutConfigureSDK(() async {
        final PassioResult<void> result =
            await NutritionAdvisor.instance.initConversation();
        switch (result) {
          case Success():
            fail('Expected Error but got Success.');
          case Error():
            expect(result.message, isNotEmpty);
        }
      });
    });
  });
}
