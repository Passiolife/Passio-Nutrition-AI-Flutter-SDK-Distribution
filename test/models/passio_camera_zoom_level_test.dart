import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_camera_zoom_level.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioCameraZoomLevel passioCameraZoomLevel;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioCameraZoomLevel = PassioCameraZoomLevel.fromJson(jsonData);
  });

  group('PassioCameraZoomLevel tests', () {
    test('toJson() test', () {
      expect(passioCameraZoomLevel.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioCameraZoomLevel.fromJson(jsonData);
      expect(data, passioCameraZoomLevel);
    });

    test('Equality operator test', () async {
      final data = PassioCameraZoomLevel.fromJson(jsonData);
      expect(passioCameraZoomLevel, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioCameraZoomLevel.fromJson(jsonData);
      expect(passioCameraZoomLevel.hashCode, equals(data.hashCode));
    });

    test('toString test', () {
      expect(passioCameraZoomLevel.toString(),
          'PassioCameraZoomLevel{minZoomLevel: ${passioCameraZoomLevel.minZoomLevel}, maxZoomLevel: ${passioCameraZoomLevel.maxZoomLevel}}');
    });
  });
}
