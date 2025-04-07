import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_serving_size.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioServingSize passioServingSize;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioServingSize = PassioServingSize.fromJson(jsonData);
  });

  group('PassioServingSize Tests', () {
    test('toJson() test', () {
      expect(passioServingSize.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioServingSize.fromJson(jsonData);
      expect(data, passioServingSize);
    });

    test('Equality operator test', () async {
      final data = PassioServingSize.fromJson(jsonData);
      expect(passioServingSize, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioServingSize.fromJson(jsonData);
      expect(passioServingSize.hashCode, equals(data.hashCode));
    });
  });
}
