import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_serving_unit.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioServingUnit passioServingUnit;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioServingUnit = PassioServingUnit.fromJson(jsonData);
  });

  group('PassioServingUnit Tests', () {
    test('toJson() test', () {
      expect(passioServingUnit.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioServingUnit.fromJson(jsonData);
      expect(data, passioServingUnit);
    });

    test('Equality operator test', () async {
      final data = PassioServingUnit.fromJson(jsonData);
      expect(passioServingUnit, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioServingUnit.fromJson(jsonData);
      expect(passioServingUnit.hashCode, equals(data.hashCode));
    });
  });
}
