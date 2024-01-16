import 'dart:math';

import '../models/nutrition_ai_attributes.dart';
import '../models/nutrition_ai_measurement.dart';
import '../models/nutrition_ai_recipe.dart';
import '../models/nutrition_ai_serving.dart';
import '../models/nutrition_ai_nutrient.dart';
import '../nutrition_ai_detection.dart';
import '../nutrition_ai_configuration.dart';

Map<String, dynamic> mapOfPassioConfiguration(PassioConfiguration config) {
  return {
    'key': config.key,
    'debugMode': config.debugMode,
    'filesLocalURLs': config.filesLocalURLs,
    'sdkDownloadsModels': config.sdkDownloadsModels,
    'allowInternetConnection': config.allowInternetConnection,
    'overrideInstalledVersion': config.overrideInstalledVersion,
  };
}

Map<String, dynamic> mapOfFoodDetectionConfiguration(
    FoodDetectionConfiguration config) {
  return {
    'detectVisual': config.detectVisual,
    'detectBarcodes': config.detectBarcodes,
    'detectPackagedFood': config.detectPackagedFood,
    'detectNutritionFacts': config.detectNutritionFacts,
    'framesPerSecond': config.framesPerSecond.name,
    'volumeDetectionMode': config.volumeDetectionMode.name
  };
}

Map<String, double> mapRectangle(Rectangle<double> rectangle) {
  return {
    'left': rectangle.left,
    'top': rectangle.top,
    'width': rectangle.width,
    'height': rectangle.height
  };
}

Map<String, dynamic> mapOfPassioIDAttributes(PassioIDAttributes attributes) {
  return {
    'passioID': attributes.passioID,
    'name': attributes.name,
    'entityType': attributes.entityType.name,
    'foodItem': attributes.foodItem?.toJson(),
    'recipe': attributes.recipe?.toJson(),
    'parents': attributes.parents?.map((e) => e.toJson()).toList(),
    'siblings': attributes.siblings?.map((e) => e.toJson()).toList(),
    'children': attributes.children?.map((e) => e.toJson()).toList(),
  };
}

Map<String, dynamic> mapOfPassioFoodRecipe(PassioFoodRecipe foodRecipe) {
  return {
    'passioID': foodRecipe.passioID,
    'name': foodRecipe.name,
    'servingSizes': foodRecipe.servingSizes.map((e) => e.toJson()).toList(),
    'servingUnits': foodRecipe.servingUnits.map((e) => e.toJson()).toList(),
    'selectedUnit': foodRecipe.selectedUnit,
    'selectedQuantity': foodRecipe.selectedQuantity,
    'foodItems': foodRecipe.foodItems.map((e) => e.toJson()).toList(),
  };
}

Map<String, dynamic> mapOfPassioServingUnit(PassioServingUnit servingUnit) {
  return {
    'unitName': servingUnit.unitName,
    'weight': servingUnit.weight.toJson(),
  };
}

Map<String, dynamic> mapOfPassioServingSize(PassioServingSize servingSize) {
  return {
    'unitName': servingSize.unitName,
    'quantity': servingSize.quantity,
  };
}

Map<String, dynamic> mapOfPassioFoodOrigin(PassioFoodOrigin foodOrigin) {
  return {
    'id': foodOrigin.id,
    'source': foodOrigin.source,
    'licenseCopy': foodOrigin.licenseCopy,
  };
}

Map<String, dynamic> mapOfPassioAlternative(PassioAlternative alternative) {
  return {
    'passioID': alternative.passioID,
    'name': alternative.name,
    'quantity': alternative.quantity,
    'unitName': alternative.unitName,
  };
}

Map<String, dynamic> mapOfUnitMass(UnitMass unitMass) {
  return {'value': unitMass.value, 'unit': unitMass.unit.name};
}

Map<String, dynamic> mapOfUnitEnergy(UnitEnergy unitEnergy) {
  return {'value': unitEnergy.value, 'unit': unitEnergy.unit.name};
}

Map<String, dynamic> mapOfUnitIU(UnitIU unitIU) {
  return {'value': unitIU.value};
}

/// Converts a [PassioNutrient] object to a [Map].
///
/// This function takes a [PassioNutrient] instance and converts it into a [Map]
/// with keys representing nutrient properties and corresponding values.
///
/// Parameters:
/// - [nutrient]: The [PassioNutrient] object to be mapped.
///
/// Returns a [Map] containing nutrient information.
Map<String, dynamic> mapOfPassioNutrient(PassioNutrient nutrient) {
  return {
    'amount': nutrient.amount,
    'inflammatoryEffectScore': nutrient.inflammatoryEffectScore,
    'name': nutrient.name,
    'unit': nutrient.unit,
  };
}
