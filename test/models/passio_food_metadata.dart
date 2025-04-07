import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_food_metadata.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioFoodMetadata passioFoodMetadata;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioFoodMetadata = PassioFoodMetadata.fromJson(jsonData);
  });

  group('PassioFoodMetadata Tests', () {
    test('toJson() test', () {
      expect(passioFoodMetadata.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioFoodMetadata.fromJson(jsonData);
      expect(data, passioFoodMetadata);
    });

    test('Equality operator test', () async {
      final data = PassioFoodMetadata.fromJson(jsonData);
      expect(passioFoodMetadata, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioFoodMetadata.fromJson(jsonData);
      expect(passioFoodMetadata.hashCode, equals(data.hashCode));
    });

    test('openFoodLicense() test', () {
      expect(passioFoodMetadata.openFoodLicense(), isNull);
    });

    test('openFoodLicense() with openFood test', () {
      final String fileName = 'passio_food_metadata_open_food.json';
      final String jsonString = fixture(fileName);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final PassioFoodMetadata passioFoodMetadata =
          PassioFoodMetadata.fromJson(jsonData);
      expect(passioFoodMetadata.openFoodLicense(), isNotNull);
    });
  });
}
