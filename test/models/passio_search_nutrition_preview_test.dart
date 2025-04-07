import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_search_nutrition_preview.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioSearchNutritionPreview passioSearchNutritionPreview;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioSearchNutritionPreview =
        PassioSearchNutritionPreview.fromJson(jsonData);
  });

  group('PassioSearchNutritionPreview tests', () {
    test('toJson() test', () {
      expect(passioSearchNutritionPreview.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioSearchNutritionPreview.fromJson(jsonData);
      expect(data, equals(passioSearchNutritionPreview));
    });

    test('Equality operator test', () async {
      final passioSearchNutritionPreview1 =
          PassioSearchNutritionPreview.fromJson(jsonData);

      expect(
          passioSearchNutritionPreview, equals(passioSearchNutritionPreview1));
    });

    test('hashCode test', () async {
      final passioSearchNutritionPreview1 =
          PassioSearchNutritionPreview.fromJson(jsonData);

      expect(passioSearchNutritionPreview.hashCode,
          equals(passioSearchNutritionPreview1.hashCode));
    });
  });
}
