import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_food_item.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioFoodItem passioFoodItem;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioFoodItem = PassioFoodItem.fromJson(jsonData);
  });

  group('PassioFoodItem Tests', () {
    test('toJson() test', () {
      expect(passioFoodItem.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioFoodItem.fromJson(jsonData);
      expect(data, passioFoodItem);
    });

    test('Equality operator test', () async {
      final data = PassioFoodItem.fromJson(jsonData);
      expect(passioFoodItem, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioFoodItem.fromJson(jsonData);
      expect(passioFoodItem.hashCode, equals(data.hashCode));
    });

    test('nutrients function test', () {
      final UnitMass unitMass = UnitMass(200, UnitMassType.grams);
      final nutrients = passioFoodItem.nutrients(unitMass);
      expect(nutrients.weight, unitMass);
    });

    test('nutrientsSelectedSize function test', () {
      final UnitMass unitMass = passioFoodItem.amount.weight();
      final nutrients = passioFoodItem.nutrients(unitMass);
      final PassioNutrients nutrientsSize =
          passioFoodItem.nutrientsSelectedSize();
      expect(nutrients.weight, nutrientsSize.weight);
      expect(nutrients, nutrientsSize);
    });

    test('nutrientsReference function test', () {
      final UnitMass unitMass = UnitMass(100, UnitMassType.grams);
      final nutrients = passioFoodItem.nutrients(unitMass);
      final nutrientsReference = passioFoodItem.nutrientsReference();
      expect(unitMass, nutrientsReference.weight);
      expect(nutrients, nutrientsReference);
    });

    test('ingredientWeight function test', () {
      final ingredientWeight = passioFoodItem.ingredients.fold(
          UnitMass(0, UnitMassType.grams),
          (previousValue, element) => previousValue + element.amount.weight());
      expect(ingredientWeight, passioFoodItem.ingredientWeight());
    });

    test('isOpen function test', () {
      final isOpen = passioFoodItem.isOpenFood();
      expect(isOpen, isNull);
    });

    test('isOpen function with openFood test', () {
      final String fileName = 'passio_food_item_open_food.json';

      final String jsonString = fixture(fileName);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final PassioFoodItem passioFoodItem = PassioFoodItem.fromJson(jsonData);

      final isOpen = passioFoodItem.isOpenFood();
      expect(isOpen, isNotNull);
    });
  });
}
