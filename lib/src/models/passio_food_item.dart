import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/src/models/nutrition_ai_measurement.dart';

import '../converter/platform_output_converter.dart';
import '../nutrition_ai_detection.dart';
import 'passio_food_amount.dart';
import 'passio_ingredient.dart';
import 'passio_nutrients.dart';

/// Represents a food item with its details, amount, ingredients, and nutritional information.
class PassioFoodItem {
  /// The amount of the food item including selected quantity and unit.
  final PassioFoodAmount amount;

  /// Additional details about the food item.
  final String details;

  /// The ID of the icon associated with the food item.
  final String iconId;

  /// The unique identifier of the food item.
  final String id;

  /// A list of ingredients that make up the food item.
  final List<PassioIngredient> ingredients;

  // final String licenseCopy;

  /// The name of the food item.
  final String name;

  /// Variable to store the final PassioID scanned during volume detection on iOS.
  final PassioID? scannedId;

  const PassioFoodItem({
    required this.amount,
    required this.details,
    required this.iconId,
    required this.id,
    required this.ingredients,
    // required this.licenseCopy,
    required this.name,
    this.scannedId,
  });

  /// Creates a `PassioFoodItem` object from a JSON map.
  factory PassioFoodItem.fromJson(Map<String, dynamic> json) => PassioFoodItem(
        amount: PassioFoodAmount.fromJson(
            (json['amount'] as Map<Object?, Object?>).cast<String, dynamic>()),
        details: json['details'],
        iconId: json['iconId'],
        id: json['id'],
        ingredients: mapListOfObjects(
            json["ingredients"], (inMap) => PassioIngredient.fromJson(inMap)),
        // licenseCopy: json['licenseCopy'],
        name: json['name'],
        scannedId: json['scannedId'],
      );

  /// Converts the `PassioFoodItem` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'amount': amount.toJson(),
        'details': details,
        'iconId': iconId,
        'id': id,
        'ingredients':
            ingredients.map((ingredient) => ingredient.toJson()).toList(),
        // 'licenseCopy': licenseCopy,
        'name': name,
        'scannedId': scannedId,
      };

  /// Compares two `PassioFoodItem` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioFoodItem) return false;
    if (identical(this, other)) return true;
    return amount == other.amount &&
        details == other.details &&
        iconId == other.iconId &&
        id == other.id &&
        listEquals(ingredients, other.ingredients) &&
        // licenseCopy == other.licenseCopy &&
        name == other.name &&
        scannedId == other.scannedId;
  }

  /// Calculates the hash code for this `PassioFoodItem` object.
  @override
  int get hashCode =>
      amount.hashCode ^
      details.hashCode ^
      iconId.hashCode ^
      id.hashCode ^
      ingredients.hashCode ^
      // licenseCopy.hashCode ^
      name.hashCode ^
      scannedId.hashCode;

  /// Calculates the nutrients based on the selected amount and unit.
  PassioNutrients nutrients(UnitMass unitMass) {
    final currentWeight = weight();
    final ingredientNutrients = ingredients
        .map((ingredient) => (
              ingredient.referenceNutrients,
              ingredient.weight() / currentWeight
            ))
        .toList();
    return PassioNutrients.fromIngredientsData(ingredientNutrients, unitMass);
  }

  /// Calculates the nutrients based on the selected size (using the selected quantity and unit).
  PassioNutrients nutrientsSelectedSize() {
    final currentWeight = weight();
    final ingredientNutrients = ingredients
        .map((ingredient) => (
              ingredient.referenceNutrients,
              ingredient.weight() / currentWeight
            ))
        .toList();
    return PassioNutrients.fromIngredientsData(
        ingredientNutrients, currentWeight);
  }

  /// Calculates the nutrients based on a reference weight of 100 grams.
  PassioNutrients nutrientsReference() {
    final currentWeight = weight();
    final ingredientNutrients = ingredients
        .map((ingredient) => (
              ingredient.referenceNutrients,
              ingredient.weight() / currentWeight
            ))
        .toList();
    return PassioNutrients.fromIngredientsData(
        ingredientNutrients, UnitMass(100, UnitMassType.grams));
  }

  /// Calculates the total weight of the food item by summing the weights of all ingredients.
  UnitMass weight() {
    return ingredients
        .map((e) => e.weight())
        .reduce((value, element) => (value + element) as UnitMass);
  }

  String? isOpenFood() {
    for (var ingredient in ingredients) {
      if (ingredient.metadata.openFoodLicense() != null) {
        return ingredient.metadata.openFoodLicense();
      }
    }
    return null;
  }
}
