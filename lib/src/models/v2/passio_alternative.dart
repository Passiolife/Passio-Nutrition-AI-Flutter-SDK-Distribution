import '../../nutrition_ai_detection.dart';

/// Represents an alternative option for a food item.
class PassioAlternative {
  /// The unique identifier of the alternative.
  final PassioID passioID;

  /// The name of the alternative.
  final String name;

  /// The quantity of the alternative (optional).
  final double? quantity;

  /// The unit of measurement for the quantity (optional).
  final String? unitName;

  /// Creates a new `PassioAlternative` instance.
  const PassioAlternative(
    this.passioID,
    this.name,
    this.quantity,
    this.unitName,
  );

  /// Creates a `PassioAlternative` instance from a JSON map.
  factory PassioAlternative.fromJson(Map<String, dynamic> json) =>
      PassioAlternative(
        json['passioID'],
        json['name'],
        json['quantity'],
        json['unitName'],
      );

  /// Converts the `PassioAlternative` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'passioID': passioID,
        'name': name,
        'quantity': quantity,
        'unitName': unitName,
      };

  /// Compares two `PassioAlternative` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioAlternative) return false;
    return passioID == other.passioID &&
        name == other.name &&
        quantity == other.quantity &&
        unitName == other.unitName;
  }

  /// Calculates the hash code for this `PassioAlternative` object.
  @override
  int get hashCode => Object.hash(passioID, name, quantity, unitName);
}
