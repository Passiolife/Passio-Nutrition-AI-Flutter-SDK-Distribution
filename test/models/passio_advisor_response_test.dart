import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_advisor_response.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioAdvisorResponse passioAdvisorResponse;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioAdvisorResponse = PassioAdvisorResponse.fromJson(jsonData);
  });

  group('PassioAdvisorResponse tests', () {
    test('toJson() test', () {
      expect(passioAdvisorResponse.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioAdvisorResponse.fromJson(jsonData);
      expect(data, passioAdvisorResponse);
    });

    test('Equality operator test', () async {
      final data = PassioAdvisorResponse.fromJson(jsonData);
      expect(passioAdvisorResponse, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioAdvisorResponse.fromJson(jsonData);
      expect(passioAdvisorResponse.hashCode, equals(data.hashCode));
    });
  });
}
