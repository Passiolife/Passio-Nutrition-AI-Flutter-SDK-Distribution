import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_upf_rating.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioUPFRating passioUPFRating;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioUPFRating = PassioUPFRating.fromJson(jsonData);
  });

  group('PassioUPFRating tests', () {
    test('toJson() test', () {
      expect(passioUPFRating.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioUPFRating.fromJson(jsonData);
      expect(data, passioUPFRating);
    });

    test('Equality operator test', () async {
      final data = PassioUPFRating.fromJson(jsonData);
      expect(passioUPFRating, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioUPFRating.fromJson(jsonData);
      expect(passioUPFRating.hashCode, equals(data.hashCode));
    });

    test('toString test', () {
      expect(
          passioUPFRating.toString(),
          equals(
              'PassioUPFRating{chainOfThought: ${passioUPFRating.chainOfThought}, highlightedIngredients: ${passioUPFRating.highlightedIngredients}, rating: ${passioUPFRating.rating}}'));
    });
  });
}
