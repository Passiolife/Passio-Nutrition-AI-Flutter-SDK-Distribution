import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_meal_plan_item.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioMealPlanItem passioMealPlanItem;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioMealPlanItem = PassioMealPlanItem.fromJson(jsonData);
  });

  group('PassioMealPlanItem Tests', () {
    test('toJson() test', () {
      expect(passioMealPlanItem.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioMealPlanItem.fromJson(jsonData);
      expect(data, passioMealPlanItem);
    });

    test('Equality operator test', () async {
      final data = PassioMealPlanItem.fromJson(jsonData);
      expect(passioMealPlanItem, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioMealPlanItem.fromJson(jsonData);
      expect(passioMealPlanItem.hashCode, equals(data.hashCode));
    });
  });
}
