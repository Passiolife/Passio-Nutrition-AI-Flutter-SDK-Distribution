import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  String fileName = 'inflammatory_effect_data.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late InflammatoryEffectData inflammatoryEffectData;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    inflammatoryEffectData = InflammatoryEffectData.fromJson(jsonData);
  });

  group('InflammatoryEffectData Tests', () {
    test('toJson() test', () {
      expect(inflammatoryEffectData.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      expect(inflammatoryEffectData.amount, jsonData['amount']);
      expect(inflammatoryEffectData.inflammatoryEffectScore,
          jsonData['inflammatoryEffectScore']);
      expect(inflammatoryEffectData.nutrient, jsonData['nutrient']);
      expect(inflammatoryEffectData.unit, jsonData['unit']);
    });

    test('Equality operator test', () async {
      final inflammatoryEffectData1 = InflammatoryEffectData.fromJson(jsonData);

      expect(inflammatoryEffectData, equals(inflammatoryEffectData1));
    });

    test('hashCode test', () async {
      final inflammatoryEffectData1 = InflammatoryEffectData.fromJson(jsonData);

      expect(inflammatoryEffectData.hashCode,
          equals(inflammatoryEffectData1.hashCode));
    });
  });
}
