import 'package:flutter/services.dart';
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
  group('recognizeImageRemote tests', () {
    setUp(() async {
      // Reset the SDK language to English before each test.
      await NutritionAI.instance.updateLanguage('en');
    });

    // Expected output: At least one item containing the foodName "banana"
    test('Image containing bananas test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_banana.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(
          result.any((e) =>
              e.foodDataInfo?.foodName.toLowerCase().contains('banana') ??
              false),
          isTrue);
    });

    // Expected output: Both clear ingredients recognized
    test(
        'Image with at least 5 different foods, two of them should be very clear in the image test',
        () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_multiple_foods.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(result, isNotEmpty);
    });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: Exact result type should be barcode
    test('Image of a barcode on a food packaging test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_food_package_barcode.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(result, isNotEmpty);
      expect(result.first.resultType, equals(PassioFoodResultType.barcode));
    });
    */

    // Expected output: Out of calories, carbs, protein and fat, 3 out of 4 marcos should be correct (we allow one mistake)
    test('Image of nutrition facts table on a food packaging test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_nutrition_facts.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(result, isNotEmpty);

      final int? actualCalories = result.first.packagedFoodItem
          ?.nutrientsSelectedSize()
          .calories
          ?.value
          .round();
      final int? actualCarbs = result.first.packagedFoodItem
          ?.nutrientsSelectedSize()
          .carbs
          ?.value
          .round();
      final int? actualProtein = result.first.packagedFoodItem
          ?.nutrientsSelectedSize()
          .proteins
          ?.value
          .round();
      final int? actualFat = result.first.packagedFoodItem
          ?.nutrientsSelectedSize()
          .fat
          ?.value
          .round();

      const int expectedCalories = 100;
      const double expectedCarbs = 2;
      const double expectedProtein = 0;
      const double expectedFat = 11;

      List<dynamic> actualValues = [
        actualCarbs,
        actualProtein,
        actualFat,
        actualCalories
      ];
      List<dynamic> expectedValues = [
        expectedCarbs,
        expectedProtein,
        expectedFat,
        expectedCalories
      ];

      int matchCount = 0;

      for (int i = 0; i < expectedValues.length; i++) {
        if (expectedValues[i] == actualValues[i]) {
          matchCount++;
        }
      }

      expect(matchCount, greaterThanOrEqualTo(3),
          reason: 'Only one value can be incorrect.');
    });

    // Expected output: Empty list/array
    test('Image not containing any food or food packaging test', () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_passio.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(result, isEmpty);
    });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: At least one item containing the foodName "soy"
    test(
        'Image of a burger, with message prompt This is not a meat burger, soy was used test',
        () async {
      final ByteData data =
          await rootBundle.load('assets/images/img_burger.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(
        bytes,
        message: 'This is not a meat burger, soy was used',
      );
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioAdvisorFoodInfo e) =>
              e.foodDataInfo?.foodName.toLowerCase().contains('soy') ?? false));
    });
*/
    // Expected output: At least one item containing the foodName "heuvo"
    test('Set SDK language to "es", image containing eggs test', () async {
      final languageResult = await NutritionAI.instance.updateLanguage('es');
      expect(languageResult, isTrue);

      final ByteData data = await rootBundle.load('assets/images/img_eggs.jpg');
      final Uint8List bytes = data.buffer.asUint8List();

      final List<PassioAdvisorFoodInfo> result =
          await NutritionAI.instance.recognizeImageRemote(bytes);
      expect(result, isNotEmpty);
      expect(
          result,
          anyElement((PassioAdvisorFoodInfo e) =>
              e.foodDataInfo?.foodName.toLowerCase().contains('huevo') ??
              false));
    });
  });
}
