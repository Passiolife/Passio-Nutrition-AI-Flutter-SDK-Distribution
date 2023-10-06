import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/util/passio_food_item_data_extension.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

extension PassioIDAttributesExtension on PassioIDAttributes? {
  FoodRecord? toFoodRecord({DateTime? dateTime, PassioID? replaceVisualPassioID, String? replaceVisualName, double? scannedWeight}) {
    PassioID passioID = this?.passioID ?? '';

    final selectedDateTime = dateTime ?? DateTime.now();

    final foodRecord = FoodRecord(
      passioID: passioID,
      name: this?.name,
      uuid: '',
      entityType: this?.entityType,
      selectedQuantity: this?.recipe?.selectedQuantity ?? 0,
      parents: this?.parents,
      siblings: this?.siblings,
      children: this?.children,
      createdAt: selectedDateTime.millisecondsSinceEpoch.toDouble(),
      mealLabel: MealLabel.mealLabelBy(selectedDateTime),
    );
    // Below code is for [visualPassioID].
    if (replaceVisualPassioID != null) {
      foodRecord.visualPassioID = replaceVisualPassioID;
    } else {
      foodRecord.visualPassioID = foodRecord.passioID;
    }
    // Below code is for [replaceVisualName]
    if (replaceVisualName != null) {
      foodRecord.visualName = replaceVisualName;
    } else {
      foodRecord.visualName = foodRecord.name;
    }
    if (this?.entityType == PassioIDEntityType.recipe) {
      final recipe = this?.recipe;
      foodRecord
        ..ingredients = recipe?.foodItems
        ..nutritionalPassioID = recipe?.passioID
        ..selectedUnit = recipe?.selectedUnit
        ..selectedQuantity = recipe?.selectedQuantity ?? 0
        ..servingUnits = recipe?.servingUnits
        ..servingSizes = recipe?.servingSizes
        ..nutritionalPassioID = recipe?.passioID;
    } else if (this?.foodItem != null) {
      PassioFoodItemData foodItemData = this!.foodItem!;
      foodRecord
        ..ingredients = [foodItemData]
        ..nutritionalPassioID = foodItemData.passioID
        ..selectedUnit = foodItemData.selectedUnit
        ..selectedQuantity = foodItemData.selectedQuantity
        ..servingUnits = foodItemData.servingUnits
        ..servingSizes = foodItemData.servingSize;
    } else {
      foodRecord
        ..ingredients = []
        ..nutritionalPassioID = passioID
        ..selectedUnit = "gram"
        ..selectedQuantity = 0.0
        ..servingUnits = []
        ..servingSizes = [];
    }
    // Here, updating the ingredients [PassioID] and Name with food record data.
    foodRecord.ingredients?.asMap().forEach((index, ingredient) {
      foodRecord.ingredients?[index] = ingredient.copyWith(passioID: foodRecord.passioID, name: foodRecord.name);
    });
    if (scannedWeight != null) {
      foodRecord.addScannedWeight(scannedWeight);
    } else {
      foodRecord.setFoodRecordServing(foodRecord.selectedUnit ?? '', foodRecord.selectedQuantity);
    }
    return foodRecord;
  }
}
