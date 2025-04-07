import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_food_amount.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioFoodAmount passioFoodAmount;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioFoodAmount = PassioFoodAmount.fromJson(jsonData);
  });

  group('PassioFoodAmount Tests', () {
    test('toJson() test', () {
      expect(passioFoodAmount.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioFoodAmount.fromJson(jsonData);
      expect(data, passioFoodAmount);
    });

    test('Equality operator test', () async {
      final data = PassioFoodAmount.fromJson(jsonData);
      expect(passioFoodAmount, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioFoodAmount.fromJson(jsonData);
      expect(passioFoodAmount.hashCode, equals(data.hashCode));
    });

    test('weight test', () {
      final data = PassioFoodAmount.fromJson(jsonData);
      expect(passioFoodAmount.weight(), equals(data.weight()));
    });

    test('weight without unit test', () {
      final String fileName = 'passio_food_amount_without_unit.json';
      final String jsonString = fixture(fileName);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final PassioFoodAmount data = PassioFoodAmount.fromJson(jsonData);
      expect(UnitMass(0, UnitMassType.grams), equals(data.weight()));
    });
  });
}
