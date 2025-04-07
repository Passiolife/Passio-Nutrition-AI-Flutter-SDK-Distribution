import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_nutrients.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioNutrients passioNutrients;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioNutrients = PassioNutrients.fromJson(jsonData);
  });

  group('PassioNutrients tests', () {
    test('toJson() test', () {
      expect(passioNutrients.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioNutrients.fromJson(jsonData);
      expect(data, passioNutrients);
    });

    test('Equality operator test', () async {
      final data = PassioNutrients.fromJson(jsonData);
      expect(passioNutrients, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioNutrients.fromJson(jsonData);
      expect(passioNutrients.hashCode, equals(data.hashCode));
    });

    test('fromNutrients test', () {
      final PassioNutrients data = PassioNutrients.fromNutrients(
        alcohol: passioNutrients.alcohol,
        calcium: passioNutrients.calcium,
        calories: passioNutrients.calories,
        carbs: passioNutrients.carbs,
        cholesterol: passioNutrients.cholesterol,
        chromium: passioNutrients.chromium,
        fat: passioNutrients.fat,
        fibers: passioNutrients.fibers,
        folicAcid: passioNutrients.folicAcid,
        iodine: passioNutrients.iodine,
        iron: passioNutrients.iron,
        magnesium: passioNutrients.magnesium,
        monounsaturatedFat: passioNutrients.monounsaturatedFat,
        phosphorus: passioNutrients.phosphorus,
        polyunsaturatedFat: passioNutrients.polyunsaturatedFat,
        potassium: passioNutrients.potassium,
        proteins: passioNutrients.proteins,
        satFat: passioNutrients.satFat,
        selenium: passioNutrients.selenium,
        sodium: passioNutrients.sodium,
        sugars: passioNutrients.sugars,
        sugarsAdded: passioNutrients.sugarsAdded,
        sugarAlcohol: passioNutrients.sugarAlcohol,
        transFat: passioNutrients.transFat,
        vitaminA: passioNutrients.vitaminA,
        vitaminB6: passioNutrients.vitaminB6,
        vitaminB12: passioNutrients.vitaminB12,
        vitaminB12Added: passioNutrients.vitaminB12Added,
        vitaminC: passioNutrients.vitaminC,
        vitaminD: passioNutrients.vitaminD,
        vitaminE: passioNutrients.vitaminE,
        vitaminEAdded: passioNutrients.vitaminEAdded,
        vitaminKDihydrophylloquinone:
            passioNutrients.vitaminKDihydrophylloquinone,
        vitaminKMenaquinone4: passioNutrients.vitaminKMenaquinone4,
        vitaminKPhylloquinone: passioNutrients.vitaminKPhylloquinone,
        vitaminARAE: passioNutrients.vitaminARAE,
        zinc: passioNutrients.zinc,
      );
      expect(passioNutrients, equals(data));
    });

    test('fromReferenceNutrients test', () {
      final PassioNutrients data = PassioNutrients.fromReferenceNutrients(
        passioNutrients,
      );
      expect(passioNutrients, equals(data));
      expect(passioNutrients.referenceWeight, data.referenceWeight);
    });

    test('fromIngredientsData test', () {
      final currentWeight = passioNutrients.weight;

      final List<(PassioNutrients, double)> ingredientsData = [
        (passioNutrients, passioNutrients.weight / currentWeight)
      ];
      final PassioNutrients data = PassioNutrients.fromIngredientsData(
        ingredientsData,
        passioNutrients.weight,
      );
      expect(passioNutrients, equals(data));
    });
  });
}
