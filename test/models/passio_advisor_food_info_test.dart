import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  String fileName = 'passio_advisor_food_info.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioAdvisorFoodInfo passioAdvisorFoodInfo;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioAdvisorFoodInfo = PassioAdvisorFoodInfo.fromJson(jsonData);
  });

  group('PassioAdvisorFoodInfo Tests', () {
    test('toJson() test', () {
      expect(passioAdvisorFoodInfo.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioAdvisorFoodInfo.fromJson(jsonData);
      expect(data, passioAdvisorFoodInfo);
    });

    test('Equality operator test', () async {
      final data = PassioAdvisorFoodInfo.fromJson(jsonData);
      expect(passioAdvisorFoodInfo, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioAdvisorFoodInfo.fromJson(jsonData);
      expect(passioAdvisorFoodInfo.hashCode, equals(data.hashCode));
    });
  });
}
