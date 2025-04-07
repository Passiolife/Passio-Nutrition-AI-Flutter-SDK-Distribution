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
  group('reportFoodItem tests', () {
    // Expected output: Verify that the result should be success and the value should be true.
    test('Pass valid "refCode" and "notes"', () async {
      final PassioResult<bool> result = await NutritionAI.instance.reportFoodItem(
          refCode:
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=',
          notes: ['This is a test note']);
      switch (result) {
        case Success():
          expect(result.value, isTrue);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });

    // Expected output: Verify that the result should be success and the value should be true.
    test('Pass valid "productCode" and "notes"', () async {
      final PassioResult<bool> result = await NutritionAI.instance
          .reportFoodItem(
              productCode: '016000188853', notes: ['This is a test note']);
      switch (result) {
        case Success():
          expect(result.value, isTrue);
          break;
        case Error():
          fail('Expected Success but got Error: ${result.message}');
      }
    });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: Verify that the result should be Error and the error should not be empty.
    test('Pass invalid refCode', () async {
      final PassioResult<bool> result = await NutritionAI.instance.reportFoodItem(refCode: 'AAAAA', notes: ['This is a test note']);
      switch (result) {
        case Success():
          fail('Expected Failure but got Success: ${result.value}');
        case Error():
          expect(result.message, isNotEmpty);
      }
    });
    */
  });
}
