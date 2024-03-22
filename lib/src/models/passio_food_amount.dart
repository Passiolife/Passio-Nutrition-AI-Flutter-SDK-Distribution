import '../converter/platform_output_converter.dart';
import 'nutrition_ai_measurement.dart';
import 'passio_serving_size.dart';
import 'passio_serving_unit.dart';

class PassioFoodAmount {
  /// The selected quantity of the food item.
  final double selectedQuantity;

  /// The selected unit of measurement for the quantity.
  final String selectedUnit;

  /// A list of available serving sizes for the food item.
  final List<PassioServingSize> servingSizes;

  /// A list of available serving units for the food item.
  final List<PassioServingUnit> servingUnits;

  /// Creates a new `PassioFoodAmount` object.
  const PassioFoodAmount({
    required this.selectedQuantity,
    required this.selectedUnit,
    required this.servingSizes,
    required this.servingUnits,
  });

  /// Creates a `PassioFoodAmount` object from a JSON map.
  factory PassioFoodAmount.fromJson(Map<String, dynamic> json) =>
      PassioFoodAmount(
        selectedQuantity: json['selectedQuantity'],
        selectedUnit: json['selectedUnit'],
        servingSizes: mapListOfObjects(
            json["servingSizes"], (inMap) => PassioServingSize.fromJson(inMap)),
        servingUnits: mapListOfObjects(
            json["servingUnits"], (inMap) => PassioServingUnit.fromJson(inMap)),
      );

  /// Converts the `PassioFoodAmount` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'selectedQuantity': selectedQuantity,
        'selectedUnit': selectedUnit,
        'servingSizes': servingSizes.map((e) => e.toJson()).toList(),
        'servingUnits': servingUnits.map((e) => e.toJson()).toList(),
      };

  /// Compares two `PassioFoodAmount` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioFoodAmount) return false;
    return selectedQuantity == other.selectedQuantity &&
        selectedUnit == other.selectedUnit &&
        servingSizes == other.servingSizes &&
        servingUnits == other.servingUnits;
  }

  /// Calculates the hash code for this `PassioFoodAmount` object.
  @override
  int get hashCode =>
      selectedQuantity.hashCode ^
      selectedUnit.hashCode ^
      servingSizes.hashCode ^
      servingUnits.hashCode;

  /// Calculates the weight of the selected quantity in grams.
  UnitMass weight() {
    // Iterates through the `servingUnits` list to find the unit matching
    // the `selectedUnit`.
    final unit = servingUnits.cast<PassioServingUnit?>().firstWhere(
        (element) => element?.unitName == selectedUnit,
        orElse: () => null);

    // If no matching unit is found, it returns a `UnitMass` object with 0 grams.
    if (unit == null) {
      return UnitMass(0, UnitMassType.grams);
    }

    // If a match is found, it multiplies the weight of that unit
    // by the `selectedQuantity` and returns the result as a `UnitMass` object.
    return (unit.weight * selectedQuantity) as UnitMass;
  }
}
