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
  group('recognizeSpeechRemote tests', () {
    setUp(() async {
      // Reset the SDK language to English before each test.
      await NutritionAI.instance.updateLanguage('en');
    });

    // Expected output: Exactly one item containing the foodName "egg"
    test('I had some eggs test', () async {
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote('I had some eggs');
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('egg') ??
              false));
    });

    // Expected output: Exactly two items, containing the words "chicken" or "spinach", also the meal time should be Lunch
    test('For lunch I had roasted chicken breast with spinach test', () async {
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote(
              'For lunch I had roasted chicken breast with spinach');
      expect(result, isNotEmpty);
      expect(result.length, equals(2));
      expect(result.first.mealTime, equals(PassioMealTime.lunch));
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('chicken') ??
              false));
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('spinach') ??
              false));
    });

    // Expected output: Exactly one item containing the serving unit "cup" and serving quantity 2
    test('I had two cups of blueberries test', () async {
      final List<PassioSpeechRecognitionModel> result = await NutritionAI
          .instance
          .recognizeSpeechRemote('I had two cups of blueberries');
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.nutritionPreview.servingUnit
                  .toLowerCase() ==
              'cup'));
    });

    // Expected output: Exactly three items, containing the words "egg" or "bacon" or "butter"
    test(
        'Para la cena comi huevos fritos con tocino y un poco de mantequilla test',
        () async {
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote(
              'Para la cena comí huevos fritos con tocino y un poco de mantequilla');
      expect(result, isNotEmpty);
      expect(result.length, equals(3));
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('egg') ??
              false));
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('bacon') ??
              false));
      expect(
          result,
          anyElement((PassioSpeechRecognitionModel e) =>
              e.advisorInfo.foodDataInfo?.foodName
                  .toLowerCase()
                  .contains('butter') ??
              false));
    });

    // Expected output: Exactly three items, containing the words "azúcar" or "avena" or "leche"
    test(
        'Set SDK language to "es", input "100 gramos de avena, 2 cucharadas de azucar, 100ml de leche" test',
        () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote(
              '100 gramos de avena, 2 cucharadas de azúcar, 100ml de leche');
      expect(result, isNotEmpty);
      expect(result.length, equals(3));

      List<String> searchTerms = ['azúcar', 'avena', 'leche'];
      expect(
        result,
        anyElement((PassioSpeechRecognitionModel e) => searchTerms.any((term) =>
            e.advisorInfo.foodDataInfo?.foodName.toLowerCase().contains(term) ??
            false)),
      );

      // expect(result, anyElement((PassioSpeechRecognitionModel e) => e.advisorInfo.foodDataInfo?.foodName.toLowerCase().contains('azúcar') ?? false));
      // expect(result, anyElement((PassioSpeechRecognitionModel e) => e.advisorInfo.foodDataInfo?.foodName.toLowerCase().contains('avena') ?? false));
      // expect(result, anyElement((PassioSpeechRecognitionModel e) => e.advisorInfo.foodDataInfo?.foodName.toLowerCase().contains('leche') ?? false));
    });

    // Expected output: Empty list/array
    test('Lorem ipsum text test', () async {
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote('Lorem ipsum text');
      expect(result, isEmpty);
    });

    // Expected output: Empty list/array
    test('Empty string test', () async {
      final List<PassioSpeechRecognitionModel> result =
          await NutritionAI.instance.recognizeSpeechRemote('Empty string');
      expect(result, isEmpty);
    });
  });
}
