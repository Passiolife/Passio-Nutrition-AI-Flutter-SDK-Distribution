import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_status_success.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioStatus passioStatus;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioStatus = PassioStatus.fromJson(jsonData);
  });

  group('PassioStatus tests', () {
    test('fromJson() test', () {
      final data = PassioStatus.fromJson(jsonData);
      expect(data, passioStatus);
    });

    test('Equality operator test', () async {
      final data = PassioStatus.fromJson(jsonData);
      expect(passioStatus, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioStatus.fromJson(jsonData);
      expect(passioStatus.hashCode, equals(data.hashCode));
    });

    test('toString() test', () async {
      final data = PassioStatus.fromJson(jsonData);
      expect(passioStatus.toString(), equals(data.toString()));
    });

    test('fromJson() with invalid key test', () {
      final jsonString = fixture('passio_status_error.json');
      final jsonData = jsonDecode(jsonString);
      final data = PassioStatus.fromJson(jsonData);
      expect(PassioMode.failedToConfigure, data.mode);
    });
  });
}
