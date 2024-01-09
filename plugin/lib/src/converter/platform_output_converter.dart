import 'dart:math';
import 'package:flutter/foundation.dart';

import '../nutrition_ai_detection.dart';
import '../nutrition_ai_configuration.dart';
import '../nutrition_ai_passio_id_name.dart';
import '../models/nutrition_ai_attributes.dart';
import '../models/nutrition_ai_serving.dart';
import '../models/nutrition_ai_measurement.dart';
import '../models/nutrition_ai_fooditemdata.dart';
import '../models/nutrition_ai_recipe.dart';
import '../models/nutrition_ai_image.dart';
import '../models/nutrition_ai_nutrient.dart';

extension MapExt on Map {
  T? ifValueNotNull<T>(String key, T Function(Map<String, dynamic> map) op) {
    if (!containsKey(key)) {
      return null;
    }

    var value = (this[key] as Map<Object?, Object?>?)?.cast<String, dynamic>();
    if (value == null) {
      return null;
    }

    return op(value);
  }
}

List<T> mapListOfObjects<T>(
    List<Object?> inList, T Function(Map<String, dynamic> inMap) converter) {
  List<Map<String, dynamic>> objectList = inList
      .map((m) => (m as Map<Object?, Object?>).cast<String, dynamic>())
      .toList();
  return objectList.map((e) => converter(e)).toList();
}

List<T>? mapListOfObjectsOptional<T>(
    List<Object?>? inList, T Function(Map<String, dynamic> inMap) converter) {
  if (inList == null) {
    return null;
  }
  return mapListOfObjects(inList, converter);
}

PassioStatus mapToPassioStatus(Map<String, dynamic> inMap) {
  var status = PassioStatus(
      mode: PassioMode.values.byName(inMap['mode']),
      error: (inMap['error'] != null)
          ? PassioSDKError.values.byName(inMap['error'])
          : null,
      activeModels: inMap['activeModels'],
      debugMessage: inMap['debugMessage'],
      missingFiles: mapDynamicListToListOfString(inMap['missingFiles']));
  return status;
}

FoodCandidates mapToFoodCandidates(Map<String, dynamic> inMap) {
  var foodCandidates = FoodCandidates();
  var dcMaps = inMap['detectedCandidate'] as List<Object?>;
  if (dcMaps.isNotEmpty) {
    List<Map<String, dynamic>> detectedCandidatesMaps = dcMaps
        .map((m) => (m as Map<Object?, Object?>).cast<String, dynamic>())
        .toList();
    var detectedCandidates =
        detectedCandidatesMaps.map((e) => _mapToDetectedCandidate(e)).toList();
    foodCandidates.detectedCandidates = detectedCandidates;
  }

  if (inMap['barcodeCandidates'] != null) {
    var bcMaps = inMap['barcodeCandidates'] as List<Object?>;
    if (bcMaps.isNotEmpty) {
      List<Map<String, dynamic>> barcodeCandidatesMaps = bcMaps
          .map((m) => (m as Map<Object?, Object?>).cast<String, dynamic>())
          .toList();
      var barcodeCandidates =
          barcodeCandidatesMaps.map((e) => _mapToBarcodeCandidates(e)).toList();
      foodCandidates.barcodeCandidates = barcodeCandidates;
    }
  }

  if (inMap['packagedFoodCandidates'] != null) {
    var pfcMaps = inMap['packagedFoodCandidates'] as List<Object?>;
    if (pfcMaps.isNotEmpty) {
      List<Map<String, dynamic>> packagedFoodCandidateMaps = pfcMaps
          .map((m) => (m as Map<Object?, Object?>).cast<String, dynamic>())
          .toList();
      var packagedFoodCandidate = packagedFoodCandidateMaps
          .map((e) => _mapToPackagedFoodCandidate(e))
          .toList();
      foodCandidates.packagedFoodCandidates = packagedFoodCandidate;
    }
  }

  return foodCandidates;
}

DetectedCandidate _mapToDetectedCandidate(Map<String, dynamic> inMap) {
  List<double> boxArray = inMap['boundingBox'].cast<double>();
  var boundingBox =
      Rectangle(boxArray[0], boxArray[1], boxArray[2], boxArray[3]);
  var detected =
      DetectedCandidate(inMap['passioID'], inMap['confidence'], boundingBox);
  var mapEstimate = inMap['amountEstimate'];
  if (mapEstimate != null) {
    var amountEstimate = AmountEstimate();
    var volumeEstimate = mapEstimate["volumeEstimate"] as double?;
    if (volumeEstimate != null) {
      amountEstimate.volumeEstimate = volumeEstimate;
    }
    var weightEstimate = mapEstimate["weightEstimate"] as double?;
    if (weightEstimate != null) {
      amountEstimate.weightEstimate = weightEstimate;
    }
    var stringEstimationQuality = mapEstimate["estimationQuality"] as String?;
    if (stringEstimationQuality != null) {
      switch (stringEstimationQuality) {
        case "good":
          amountEstimate.estimationQuality = EstimationQuality.good;
          break;
        case "fair":
          amountEstimate.estimationQuality = EstimationQuality.fair;
          break;
        case "poor":
          amountEstimate.estimationQuality = EstimationQuality.poor;
          break;
        case "noEstimation":
          amountEstimate.estimationQuality = EstimationQuality.noEstimation;
          break;
        default:
          amountEstimate.estimationQuality = EstimationQuality.noEstimation;
      }
    }
    var stringMoveDevice = mapEstimate["moveDevice"] as String?;
    if (stringMoveDevice != null) {
      switch (stringMoveDevice) {
        case "away":
          amountEstimate.moveDevice = MoveDirection.away;
          break;
        case "ok":
          amountEstimate.moveDevice = MoveDirection.ok;
          break;
        case "up":
          amountEstimate.moveDevice = MoveDirection.up;
          break;
        case "down":
          amountEstimate.moveDevice = MoveDirection.down;
          break;
        case "around":
          amountEstimate.moveDevice = MoveDirection.around;
          break;
        default:
          amountEstimate.moveDevice = MoveDirection.ok;
      }
    }
    var viewingAngle = mapEstimate["viewingAngle"] as double?;
    if (viewingAngle != null) {
      amountEstimate.viewingAngle = viewingAngle;
    }
    detected.amountEstimate = amountEstimate;
  }
  return detected;
}

BarcodeCandidate _mapToBarcodeCandidates(Map<String, dynamic> inMap) {
  List<double> boxArray = inMap['boundingBox'].cast<double>();
  var boundingBox =
      Rectangle(boxArray[0], boxArray[1], boxArray[2], boxArray[3]);
  return BarcodeCandidate(inMap['value'], boundingBox);
}

PackagedFoodCandidate _mapToPackagedFoodCandidate(Map<String, dynamic> inMap) {
  return PackagedFoodCandidate(inMap['packagedFoodCode'], inMap['confidence']);
}

PassioIDAndName mapToPassioIDAndName(Map<String, dynamic> inMap) {
  return PassioIDAndName(inMap['passioID'], inMap['name']);
}

PassioAlternative mapToPassioAlternative(Map<String, dynamic> inMap) {
  return PassioAlternative(
      inMap['passioID'], inMap['name'], inMap['quantity'], inMap['unitName']);
}

PassioServingSize mapToPassioServingSize(Map<String, dynamic> inMap) {
  return PassioServingSize(inMap["quantity"], inMap["unitName"]);
}

PassioServingUnit mapToPassioServingUnit(Map<String, dynamic> inMap) {
  Map<String, dynamic> weightMap = inMap["weight"].cast<String, dynamic>();
  return PassioServingUnit(inMap["unitName"], mapToUnitMass(weightMap));
}

UnitMass mapToUnitMass(Map<String, dynamic> inMap) {
  return UnitMass(inMap["value"], UnitMassType.values.byName(inMap["unit"]));
}

UnitEnergy mapToUnitEnergy(Map<String, dynamic> inMap) {
  return UnitEnergy(
      inMap["value"], UnitEnergyType.values.byName(inMap["unit"]));
}

UnitIU mapToUnitIU(Map<String, dynamic> inMap) {
  return UnitIU(inMap["value"]);
}

PassioFoodOrigin mapToPassioFoodOrigin(Map<String, dynamic> inMap) {
  return PassioFoodOrigin(inMap["id"], inMap["source"], inMap["licenseCopy"]);
}

List<String>? mapDynamicListToListOfString(List<dynamic>? dynamicList) {
  if (dynamicList == null) {
    return null;
  }
  List<String> stringList =
      dynamicList.map((dynamicItem) => dynamicItem.toString()).toList();
  return stringList;
}

PassioFoodItemData mapToPassioFoodItemData(Map<String, dynamic> inMap) {
  var foodItemData = PassioFoodItemData(
    inMap["passioID"],
    inMap["name"],
    mapDynamicListToListOfString(inMap["tags"]),
    inMap["selectedQuantity"],
    inMap["selectedUnit"],
    PassioIDEntityType.values.byName(inMap["entityType"]),
    mapListOfObjects(
        inMap["servingUnits"], (inMap) => mapToPassioServingUnit(inMap)),
    mapListOfObjects(
        inMap["servingSizes"], (inMap) => mapToPassioServingSize(inMap)),
    inMap["ingredientsDescription"],
    inMap["barcode"],
    mapListOfObjectsOptional(
        inMap["foodOrigins"], (inMap) => mapToPassioFoodOrigin(inMap)),
    mapListOfObjectsOptional(
        inMap["parents"], (inMap) => mapToPassioAlternative(inMap)),
    mapListOfObjectsOptional(
        inMap["siblings"], (inMap) => mapToPassioAlternative(inMap)),
    mapListOfObjectsOptional(
        inMap["children"], (inMap) => mapToPassioAlternative(inMap)),
    inMap.ifValueNotNull("calories", (it) => mapToUnitEnergy(it)),
    inMap.ifValueNotNull("carbs", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("fat", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("proteins", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("saturatedFat", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("transFat", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("monounsaturatedFat", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("polyunsaturatedFat", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("cholesterol", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("sodium", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("fibers", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("sugars", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("sugarsAdded", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminD", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("calcium", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("iron", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("potassium", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminA", (it) => mapToUnitIU(it)),
    inMap.ifValueNotNull("vitaminC", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("alcohol", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("sugarAlcohol", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminB12Added", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminB12", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminB6", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminE", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("vitaminEAdded", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("magnesium", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("phosphorus", (it) => mapToUnitMass(it)),
    inMap.ifValueNotNull("iodine", (it) => mapToUnitMass(it)),
  );
  return foodItemData;
}

PassioIDAttributes mapToPassioIDAttributes(Map<String, dynamic> inMap) {
  return PassioIDAttributes(
      inMap["passioID"],
      inMap["name"],
      PassioIDEntityType.values.byName(inMap["entityType"]),
      inMap.ifValueNotNull("foodItem", (it) => mapToPassioFoodItemData(it)),
      inMap.ifValueNotNull("recipe", (it) => mapToPassioFoodRecipe(it)),
      mapListOfObjectsOptional(
          inMap["parents"], (inMap) => mapToPassioAlternative(inMap)),
      mapListOfObjectsOptional(
          inMap["siblings"], (inMap) => mapToPassioAlternative(inMap)),
      mapListOfObjectsOptional(
          inMap["children"], (inMap) => mapToPassioAlternative(inMap)));
}

PassioFoodRecipe mapToPassioFoodRecipe(Map<String, dynamic> inMap) {
  return PassioFoodRecipe(
    inMap["passioID"],
    inMap["name"],
    mapListOfObjects(
        inMap["servingSizes"], (inMap) => mapToPassioServingSize(inMap)),
    mapListOfObjects(
        inMap["servingUnits"], (inMap) => mapToPassioServingUnit(inMap)),
    inMap["selectedUnit"],
    inMap["selectedQuantity"],
    mapListOfObjects(
        inMap["foodItems"], (inMap) => mapToPassioFoodItemData(inMap)),
  );
}

PassioFoodIcons mapToPlatformImagePair(Map<String, dynamic> inMap) {
  Map<String, dynamic> defaultIconMap =
      inMap["defaultIcon"].cast<String, dynamic>();
  var defaultIcon = mapToPlatformImage(defaultIconMap);
  var cachedIcon =
      inMap.ifValueNotNull("cachedIcon", (map) => mapToPlatformImage(map));
  return PassioFoodIcons(defaultIcon, cachedIcon);
}

PlatformImage mapToPlatformImage(Map<String, dynamic> inMap) {
  var image = PlatformImage(inMap["width"] as int, inMap["height"] as int,
      inMap["pixels"] as Uint8List);
  return image;
}

/// Converts a [Map] to a [PassioNutrient] object.
///
/// This function takes a [Map] representing a PassioNutrient and constructs
/// a PassioNutrient instance using the values from the map.
///
/// Parameters:
/// - [inMap]: The input [Map] containing nutrient information.
///
/// Returns a [PassioNutrient] object constructed from the provided map.
PassioNutrient mapToPassioNutrient(Map<String, dynamic> inMap) {
  return PassioNutrient(
    inMap["amount"],
    inMap["inflammatoryEffectScore"],
    inMap["name"],
    inMap["unit"],
  );
}
