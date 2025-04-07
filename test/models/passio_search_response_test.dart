import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_search_response.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioSearchResponse passioSearchResponse;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioSearchResponse = PassioSearchResponse.fromJson(jsonData);
  });

  group('PassioSearchResponse tests', () {
    test('toJson() test', () {
      expect(passioSearchResponse.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioSearchResponse.fromJson(jsonData);
      expect(data, passioSearchResponse);
    });

    test('Equality operator test', () async {
      final data = PassioSearchResponse.fromJson(jsonData);
      expect(passioSearchResponse, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioSearchResponse.fromJson(jsonData);
      expect(passioSearchResponse.hashCode, equals(data.hashCode));
    });
  });
}
