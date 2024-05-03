import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

void main() {
  group('PassioFoodItem', () {
    test('toJson() should correctly serialize to a JSON map', () {
      // Prepare a PassioFoodItem object
      final foodItem = PassioFoodItem(
        amount: PassioFoodAmount(
          selectedQuantity: 150.0,
          selectedUnit: 'g',
          servingSizes: [const PassioServingSize(1.5, 'serving')],
          servingUnits: [
            PassioServingUnit(
                UnitMassType.grams.symbol, UnitMass(150.0, UnitMassType.grams))
          ],
        ),
        details: 'Sample food item details',
        // foodItemName: 'Sample Food',
        iconId: 'sample_icon_id',
        id: 'sample_id',
        ingredients: [],
        // licenseCopy: 'Sample license copy',
        name: 'Sample Name',
        refCode: '',
        scannedId: '',
        // scannedId: 'sample_scanned_id',
      );

      // Serialize PassioFoodItem object to JSON
      final jsonData = foodItem.toJson();
      final jsonDataModel = PassioFoodItem.fromJson(jsonData);

      // Checking after converting json and json to back model then it still the same.
      bool equal = foodItem == jsonDataModel;
      expect(equal, true);

      // Assertions
      expect(jsonData['amount']['selectedQuantity'], 150.0);
      expect(jsonData['foodItemName'], 'Sample Food');
      expect(jsonData['id'], 'sample_id');
      expect(jsonData['scannedId'], 'sample_scanned_id');
    });

    test('fromJson() should correctly parse a JSON map', () {
      // Prepare sample JSON data
      final Map<String, dynamic> jsonData = {
        'amount': {
          'selectedQuantity': 100.0,
          'selectedUnit': 'g',
          'servingSizes': [
            {'quantity': 1.0, 'unitName': 'serving'}
          ],
          'servingUnits': [
            {
              'unitName': 'g',
              'weight': {'value': 100.0, 'unit': 'g'}
            }
          ]
        },
        'details': 'Sample food item details',
        'foodItemName': 'Sample Food',
        'iconId': 'sample_icon_id',
        'id': 'sample_id',
        'ingredients': [],
        'licenseCopy': 'Sample license copy',
        'name': 'Sample Name',
        'scannedId': {'value': 'sample_scanned_id'}
      };

      // Parse JSON into PassioFoodItem object
      final foodItem = PassioFoodItem.fromJson(jsonData);

      // Assertions
      expect(foodItem.amount.selectedQuantity, 100.0);
      // expect(foodItem.foodItemName, 'Sample Food');
      expect(foodItem.id, 'sample_id');
      // expect(foodItem.scannedId, 'sample_scanned_id');
      // Add more assertions as needed for other properties
    });
  });

  // Add test cases for other classes similarly
}
