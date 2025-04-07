import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:collection/collection.dart';

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
  group('fetchInflammatoryEffectData tests', () {
    // Expected output: Verify that the list is not empty.
    test('Pass "refCode" that contains inflammatory effect data test',
        () async {
      final List<InflammatoryEffectData>? result = await NutritionAI.instance
          .fetchInflammatoryEffectData(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result, isNotEmpty);
    });

    // Expected output: Verify that the list is not empty and same as the english version.
    test(
        'Set the SDK language to "es" and pass "refCode" that contains inflammatory effect data test',
        () async {
      final List<InflammatoryEffectData>? englishResult =
          await NutritionAI.instance.fetchInflammatoryEffectData(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final List<InflammatoryEffectData>? result = await NutritionAI.instance
          .fetchInflammatoryEffectData(
              'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result, isNotEmpty);

      final isMatched = const DeepCollectionEquality.unordered()
          .equals(englishResult, result);
      expect(isMatched, isTrue);
    });

    // Expected output: Verify that the list is null.
    test('Pass "refCode" that is not valid test', () async {
      final List<InflammatoryEffectData>? result =
          await NutritionAI.instance.fetchInflammatoryEffectData('AAAAAAAA');
      expect(result, isNull);
    });
  });
}
