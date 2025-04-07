import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_meal_plan.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioMealPlan passioMealPlan;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioMealPlan = PassioMealPlan.fromJson(jsonData);
  });

  group('PassioMealPlan Tests', () {
    test('toJson() test', () {
      expect(passioMealPlan.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioMealPlan.fromJson(jsonData);
      expect(data, passioMealPlan);
    });

    test('Equality operator test', () async {
      final data = PassioMealPlan.fromJson(jsonData);
      expect(passioMealPlan, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioMealPlan.fromJson(jsonData);
      expect(passioMealPlan.hashCode, equals(data.hashCode));
    });
  });
}
