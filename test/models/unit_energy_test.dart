import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  String fileName = 'unit_energy.json';
  late String jsonString;
  late Map<String, dynamic> jsonData;
  late UnitEnergy unit;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    unit = UnitEnergy.fromJson(jsonData);
  });

  group('UnitEnergy Tests', () {
    test('toJson() test', () {
      expect(unit.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      expect(unit.value, jsonData['value']);
      expect(unit.unit.name, jsonData['unit']);
    });

    test('Equality operator test', () async {
      final unit1 = UnitEnergy.fromJson(jsonData);

      expect(unit, equals(unit1));
    });

    test('hashCode test', () async {
      final unit1 = UnitEnergy.fromJson(jsonData);

      expect(unit.hashCode, equals(unit1.hashCode));
    });

    test('kcalValue function should return correct value for kcal test', () {
      expect(unit.kcalValue(), equals(unit.value * unit.unit.converter));
    });

    test('kcalValue function should return correct value for kcal test', () {
      expect(unit.kcalValue(), equals(unit.value * unit.unit.converter));
    });

    test('times function should return correct value for kcal test', () {
      double multiplier = 2.0;
      UnitEnergy multipliedUnit = unit.times(multiplier);
      UnitEnergy operatorMultipliedUnit = unit * multiplier;

      expect(multipliedUnit, equals(operatorMultipliedUnit));
      expect(multipliedUnit.value, equals(unit.value * multiplier));
      expect(multipliedUnit.unit, equals(unit.unit));
    });

    test('plus function should return correct value for kcal test', () {
      final UnitEnergy plusUnit = unit.plus(unit);
      final UnitEnergy operatorPlusUnit = unit + unit;

      expect(plusUnit, equals(operatorPlusUnit));
      expect(plusUnit.value, unit.value + unit.value);
      expect(plusUnit.unit, unit.unit);
    });

    test('plus function should return correct value for kcal test', () {
      final UnitEnergy plusUnit = unit.plus(null);
      final UnitEnergy operatorPlusUnit = unit + null;

      expect(plusUnit, equals(operatorPlusUnit));
      expect(plusUnit.value, unit.value);
      expect(plusUnit.unit, unit.unit);
    });
  });
}
