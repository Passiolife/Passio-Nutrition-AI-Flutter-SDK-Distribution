import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'platform_image.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PlatformImage platformImage;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    platformImage = PlatformImage.fromJson(jsonData);
  });

  group('PlatformImage tests', () {
    test('fromJson() test', () {
      final data = PlatformImage.fromJson(jsonData);
      expect(data, platformImage);
    });

    test('Equality operator test', () async {
      final data = PlatformImage.fromJson(jsonData);
      expect(platformImage, equals(data));
    });

    test('hashCode test', () async {
      final data = PlatformImage.fromJson(jsonData);
      expect(platformImage.hashCode, equals(data.hashCode));
    });
  });

  group('IconSizeExtension tests', () {
    test('sizeForURL test', () {
      expect(IconSize.px90.sizeForURL, equals('90'));
      expect(IconSize.px180.sizeForURL, equals('180'));
      expect(IconSize.px360.sizeForURL, equals('360'));
    });
  });

  group('passioFoodIcons tests', () {
    test('passioFoodIcons test', () {});
  });
}
