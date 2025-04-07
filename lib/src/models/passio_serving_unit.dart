import '../models/nutrition_ai_measurement.dart';

/// Data class that represents the serving unit of a food item.
class PassioServingUnit {
  /// The name of the unit (e.g., "grams").
  final String unitName;

  /// The corresponding unit of mass ([UnitMass]) for the unit name.
  final UnitMass weight;

  /// Creates a new `PassioServingUnit` instance.
  const PassioServingUnit(this.unitName, this.weight);

  /// Creates a `PassioServingUnit` instance from a JSON map.
  factory PassioServingUnit.fromJson(Map<String, dynamic> json) =>
      PassioServingUnit(json["unitName"],
          UnitMass.fromJson(json["weight"].cast<String, dynamic>()));

  /// Converts the `PassioServingUnit` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'unitName': unitName,
        'weight': weight.toJson(),
      };

  /// Compares two `PassioServingUnit` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioServingUnit) return false;
    return weight == other.weight && unitName == other.unitName;
  }

  /// Calculates the hash code for this `PassioServingUnit` object.
  @override
  int get hashCode => Object.hash(weight, unitName);
}
