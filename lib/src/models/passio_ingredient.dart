import 'nutrition_ai_measurement.dart';
import 'passio_food_amount.dart';
import 'passio_food_metadata.dart';
import 'passio_nutrients.dart';

/// Represents an ingredient within a food item, including its amount, metadata,
/// name, and reference nutrients.
class PassioIngredient {
  /// The amount of the ingredient, including selected quantity and unit.
  final PassioFoodAmount amount;

  /// The ID of the icon associated with the ingredient.
  final String iconId;

  /// The unique identifier of the ingredient.
  final String id;

  /// Additional metadata about the ingredient.
  final PassioFoodMetadata metadata;

  /// The name of the ingredient.
  final String name;

  /// A reference code serving as a unique identifier for the ingredient.
  final String refCode;

  /// The reference nutrients of the ingredient, typically per 100 grams.
  final PassioNutrients referenceNutrients;

  /// Creates a new `PassioIngredient` object.
  const PassioIngredient({
    required this.amount,
    required this.iconId,
    required this.id,
    required this.metadata,
    required this.name,
    required this.refCode,
    required this.referenceNutrients,
  });

  /// Creates a `PassioIngredient` object from a JSON map.
  factory PassioIngredient.fromJson(Map<String, dynamic> json) =>
      PassioIngredient(
        amount: PassioFoodAmount.fromJson(
            (json['amount'] as Map<Object?, Object?>).cast<String, dynamic>()),
        iconId: json['iconId'],
        id: json['id'],
        metadata: PassioFoodMetadata.fromJson(
            (json['metadata'] as Map<Object?, Object?>)
                .cast<String, dynamic>()),
        name: json['name'],
        refCode: json["refCode"],
        referenceNutrients: PassioNutrients.fromJson(
            (json['referenceNutrients'] as Map<Object?, Object?>)
                .cast<String, dynamic>()),
      );

  /// Converts the `PassioIngredient` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'amount': amount.toJson(),
        'iconId': iconId,
        'id': id,
        'metadata': metadata.toJson(),
        'name': name,
        'refCode': refCode,
        'referenceNutrients': referenceNutrients.toJson(),
      };

  /// Compares two `PassioIngredient` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioIngredient) return false;
    return amount == other.amount &&
        iconId == other.iconId &&
        id == other.id &&
        metadata == other.metadata &&
        name == other.name &&
        refCode == other.refCode &&
        referenceNutrients == other.referenceNutrients;
  }

  /// Calculates the hash code for this `PassioIngredient` object.
  @override
  int get hashCode =>
      amount.hashCode ^
      iconId.hashCode ^
      id.hashCode ^
      metadata.hashCode ^
      name.hashCode ^
      refCode.hashCode ^
      referenceNutrients.hashCode;

  /// Calculates the weight of the ingredient by calling the `weight` method of its `amount`.
  UnitMass weight() => amount.weight();
}
