import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  String fileName = 'unit_iu.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late UnitIU unit;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    unit = UnitIU.fromJson(jsonData);
  });

  group('UnitIU Tests', () {
    test('toJson() test', () {
      expect(unit.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      expect(unit.value, jsonData['value']);
    });

    test('Equality operator test', () async {
      final unit1 = UnitIU.fromJson(jsonData);

      expect(unit, equals(unit1));
    });

    test('hashCode test', () async {
      final unit1 = UnitIU.fromJson(jsonData);

      expect(unit.hashCode, equals(unit1.hashCode));
    });

    test('times function should return correct value for IU test', () {
      double multiplier = 2.0;
      UnitIU multipliedUnit = unit.times(multiplier);
      UnitIU operatorMultipliedUnit = unit * multiplier;

      expect(multipliedUnit, equals(operatorMultipliedUnit));
      expect(multipliedUnit.value, equals(unit.value * multiplier));
    });

    test('plus function should return correct value for IU test', () {
      double addValue = 2.0;
      UnitIU addUnit = UnitIU(addValue);
      UnitIU addedUnit = unit.plus(addUnit);
      UnitIU operatorAddedUnit = unit + addUnit;

      expect(addedUnit, equals(operatorAddedUnit));
      expect(addedUnit.value, equals(unit.value + addValue));
    });
  });
}
