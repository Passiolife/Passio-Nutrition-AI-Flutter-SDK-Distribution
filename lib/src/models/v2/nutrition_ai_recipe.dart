import '../../converter/platform_output_converter.dart';
import '../../models/nutrition_ai_measurement.dart';
import '../passio_serving_size.dart';
import '../passio_serving_unit.dart';
import 'nutrition_ai_fooditemdata.dart';
import '../../nutrition_ai_detection.dart';

/// Data class the holds the nutritional information of a food item that is
/// classified as a recipe. A recipe has multiple ingredients, but their
/// quantity is controlled by a single [selectedUnit] and [selectedQuantity].
class PassioFoodRecipe {
  /// Identifier of food recipe.
  final PassioID passioID;

  /// Recipe name.
  final String name;

  /// List of predefined serving sizes.
  final List<PassioServingSize> servingSizes;

  /// List of predefined serving units.
  final List<PassioServingUnit> servingUnits;

  /// Currently selected unit.
  String selectedUnit;

  /// Currently selected quantity.
  double selectedQuantity;

  /// List of ingredients of the recipe.
  final List<PassioFoodItemData> foodItems;

  PassioFoodRecipe(
      this.passioID,
      this.name,
      this.servingSizes,
      this.servingUnits,
      this.selectedUnit,
      this.selectedQuantity,
      this.foodItems) {
    _computeQuantitiesForIngredients();
  }

  factory PassioFoodRecipe.fromJson(Map<String, dynamic> json) =>
      PassioFoodRecipe(
        json["passioID"],
        json["name"],
        mapListOfObjects(json["servingSizes"], PassioServingSize.fromJson),
        mapListOfObjects(json["servingUnits"], PassioServingUnit.fromJson),
        json["selectedUnit"],
        json["selectedQuantity"],
        mapListOfObjects(json["foodItems"], PassioFoodItemData.fromJson),
      );

  Map<String, dynamic> toJson() => {
        'passioID': passioID,
        'name': name,
        'servingSizes': servingSizes.map((e) => e.toJson()).toList(),
        'servingUnits': servingUnits.map((e) => e.toJson()).toList(),
        'selectedUnit': selectedUnit,
        'selectedQuantity': selectedQuantity,
        'foodItems': foodItems.map((e) => e.toJson()).toList(),
      };

  bool isOpenFood() {
    for (var item in foodItems) {
      if (item.isOpenFood()) {
        return true;
      }
    }

    return false;
  }

  String? openFoodLicense() {
    for (var item in foodItems) {
      if (item.openFoodLicense() != null) {
        return item.openFoodLicense();
      }
    }

    return null;
  }

  UnitMass computedWeigth() {
    PassioServingUnit? servingUnit = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element!.unitName == selectedUnit,
            orElse: () => null);
    if (servingUnit == null) {
      return UnitMass(0.0, UnitMassType.grams);
    }

    return (servingUnit.weight * selectedQuantity) as UnitMass;
  }

  void _computeQuantitiesForIngredients() {
    var totalWeight = foodItems
        .map((item) => item.computedWeight().gramsValue())
        .reduce((value, element) => value + element);

    var ratioMultiply = computedWeigth().gramsValue() / totalWeight;
    for (var item in foodItems) {
      item.selectedQuantity *= ratioMultiply;
    }
  }
}
