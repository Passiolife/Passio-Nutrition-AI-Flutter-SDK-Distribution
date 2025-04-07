import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';
import 'package:collection/collection.dart';

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
  group('fetchTagsFor tests', () {
    // Expected output: Verify that the list is not empty.
    test('Pass "refCode" that contains tags test', () async {
      final List<String>? result = await NutritionAI.instance.fetchTagsFor(
          'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result, isNotEmpty);
    });

    // Expected output: Verify that the list is empty.
    test('Pass "refCode" that does not contain tags test', () async {
      final List<String>? result = await NutritionAI.instance.fetchTagsFor(
          'eyJsYWJlbGlkIjoiMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwIiwidHlwZSI6InJlZmVyZW5jZSIsInJlc3VsdGlkIjoib3BlbmZvb2QwMDE2MDAwMTg4ODUzIiwibWV0YWRhdGEiOnsic2hvcnROYW1lIjpmYWxzZX19');
      expect(result, isEmpty);
    });

    // Expected output: Verify that the list is not empty and same as the english version.
    test(
        'Set the SDK language to "es" and pass "refCode" that contains tags test',
        () async {
      final List<String>? englishResult = await NutritionAI.instance.fetchTagsFor(
          'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');

      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final List<String>? result = await NutritionAI.instance.fetchTagsFor(
          'eyJsYWJlbGlkIjoiOTBmODRjMWUtOWEwZC0xMWVhLTk4YTQtYjNlZWJhZTQ4NDFkIiwidHlwZSI6InN5bm9ueW0iLCJyZXN1bHRpZCI6IjE2MDMyMTE1ODU0NDMiLCJtZXRhZGF0YSI6bnVsbH0=');
      expect(result, isNotEmpty);

      final isMatched = const DeepCollectionEquality.unordered()
          .equals(englishResult, result);
      expect(isMatched, isTrue);
    });

    // Expected output: Verify that the list is null.
    test('Pass "refCode" that is not valid test', () async {
      final List<String>? result =
          await NutritionAI.instance.fetchTagsFor('AAAAAAAA');
      expect(result, isNull);
    });
  });
}
