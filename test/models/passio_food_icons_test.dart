import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_food_icons.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioFoodIcons passioFoodIcons;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioFoodIcons = PassioFoodIcons.fromJson(jsonData);
  });

  group('PassioFoodIcons tests', () {
    test('fromJson() test', () {
      final data = PassioFoodIcons.fromJson(jsonData);
      expect(data, passioFoodIcons);
    });

    test('Equality operator test', () async {
      final data = PassioFoodIcons.fromJson(jsonData);
      expect(passioFoodIcons, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioFoodIcons.fromJson(jsonData);
      expect(passioFoodIcons.hashCode, equals(data.hashCode));
    });
  });
}
