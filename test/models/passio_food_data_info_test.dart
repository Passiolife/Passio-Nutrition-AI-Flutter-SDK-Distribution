import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_food_data_info.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioFoodDataInfo passioFoodDataInfo;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioFoodDataInfo = PassioFoodDataInfo.fromJson(jsonData);
  });

  group('PassioFoodDataInfo tests', () {
    test('toJson() test', () {
      expect(passioFoodDataInfo.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioFoodDataInfo.fromJson(jsonData);

      expect(passioFoodDataInfo, data);
    });

    test('Equality operator test', () async {
      final data = PassioFoodDataInfo.fromJson(jsonData);

      expect(passioFoodDataInfo, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioFoodDataInfo.fromJson(jsonData);

      expect(passioFoodDataInfo.hashCode, equals(data.hashCode));
    });
  });
}
