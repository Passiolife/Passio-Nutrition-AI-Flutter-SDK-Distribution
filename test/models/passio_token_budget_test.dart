import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_token_budget.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioTokenBudget passioTokenBudget;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioTokenBudget = PassioTokenBudget.fromJson(jsonData);
  });

  group('PassioTokenBudget tests', () {
    test('toJson() test', () {
      expect(passioTokenBudget.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioTokenBudget.fromJson(jsonData);
      expect(data, passioTokenBudget);
    });

    test('Equality operator test', () async {
      final data = PassioTokenBudget.fromJson(jsonData);
      expect(passioTokenBudget, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioTokenBudget.fromJson(jsonData);
      expect(passioTokenBudget.hashCode, equals(data.hashCode));
    });

    test('toString test', () {
      expect(
          passioTokenBudget.toString(),
          equals(
              'PassioTokenBudget{apiName: ${passioTokenBudget.apiName}, budgetCap: ${passioTokenBudget.budgetCap}, periodUsage: ${passioTokenBudget.periodUsage}, tokensUsed: ${passioTokenBudget.tokensUsed}}'));
    });

    test('Percentage of the budget used so far test', () {
      final double usedPercentage = passioTokenBudget.usedPercent();
      final double expectedPercentage =
          passioTokenBudget.periodUsage / passioTokenBudget.budgetCap;

      expect(usedPercentage, equals(expectedPercentage));
    });
  });
}
