import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  String fileName = 'unit_mass_grams.json';
  String fileNameKilograms = 'unit_mass_kilograms.json';
  String fileNameMilligrams = 'unit_mass_milligrams.json';
  String fileNameMicrograms = 'unit_mass_micrograms.json';
  String fileNameMilliliter = 'unit_mass_milliliter.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late UnitMass unit;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    unit = UnitMass.fromJson(jsonData);
  });

  group('UnitMass Tests', () {
    test('toJson() test', () {
      expect(unit.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      expect(unit.value, jsonData['value']);
      expect(unit.unit.name, jsonData['unit']);
    });

    test('Equality operator test', () async {
      final unit1 = UnitMass.fromJson(jsonData);

      expect(unit, equals(unit1));
    });

    test('hashCode test', () async {
      final unit1 = UnitMass.fromJson(jsonData);

      expect(unit.hashCode, equals(unit1.hashCode));
    });

    test('gramsValue function should return correct value for grams test', () {
      final unit = UnitMass.fromJson(jsonData);
      expect(unit.gramsValue(),
          equals(unit.value * UnitMassType.grams.converter * 1000));
    });

    test('gramsValue function should return correct value for kilograms test',
        () {
      final String jsonString = fixture(fileNameKilograms);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final unit = UnitMass.fromJson(jsonData);
      expect(unit.gramsValue(),
          equals(unit.value * UnitMassType.kilograms.converter * 1000));
    });

    test('gramsValue function should return correct value for milligrams test',
        () {
      final String jsonString = fixture(fileNameMilligrams);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final unit = UnitMass.fromJson(jsonData);
      expect(unit.gramsValue(),
          equals(unit.value * UnitMassType.milligrams.converter * 1000));
    });

    test('gramsValue function should return correct value for micrograms test',
        () {
      final String jsonString = fixture(fileNameMicrograms);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final unit = UnitMass.fromJson(jsonData);
      expect(unit.gramsValue(),
          equals(unit.value * UnitMassType.micrograms.converter * 1000));
    });

    test('gramsValue function should return correct value for milliliter test',
        () {
      final String jsonString = fixture(fileNameMilliliter);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final unit = UnitMass.fromJson(jsonData);
      expect(unit.gramsValue(),
          equals(unit.value * UnitMassType.milliliter.converter * 1000));
    });

    test('times function should return correctly value', () {
      final double multiplier = 2.0;
      final UnitMass multipliedUnit = unit.times(multiplier);
      final UnitMass operatorMultipliedUnit = unit * multiplier;

      expect(multipliedUnit, equals(operatorMultipliedUnit));
      expect(multipliedUnit.value, equals(unit.value * multiplier));
      expect(multipliedUnit.unit, equals(unit.unit));
    });

    test('plus function should return correctly value', () {
      final UnitMass plusUnit = unit.plus(unit);
      final UnitMass operatorPlusUnit = unit + unit;

      expect(plusUnit, operatorPlusUnit);
      expect(plusUnit.value, equals(unit.value + unit.value));
      expect(plusUnit.unit, equals(unit.unit));
    });

    test('plus function with different units should return correctly value',
        () {
      final UnitMass newUnit = UnitMass(1.0, UnitMassType.kilograms);
      final UnitMass plusUnit = unit.plus(newUnit);
      final UnitMass operatorPlusUnit = unit + newUnit;

      expect(plusUnit, operatorPlusUnit);
      expect(plusUnit.value, equals(unit.value + newUnit.gramsValue()));
    });

    test('division function should return correctly value', () {
      final double value = unit.division(unit);
      final double operatorValue = unit / unit;

      expect(value, operatorValue);
      expect(value, equals(unit.value / unit.value));
    });
  });
}
