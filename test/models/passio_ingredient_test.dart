import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

void main() {
  group('PassioIngredient tests', () {
    test('toJson() test', () {
      final unit = UnitMass(150.0, UnitMassType.grams);

      final expectedJson = {
        'value': 150.0,
        'unit': 'grams',
      };

      expect(unit.toJson(), equals(expectedJson));
    });

    test('fromJson() test', () {
      final jsonData = {
        'value': 150.0,
        'unit': 'grams',
      };

      final unit = UnitMass.fromJson(jsonData);

      expect(unit.value, 150.0);
      expect(unit.symbol, 'g');
      expect(unit.unit, UnitMassType.grams);
    });
  });
}
