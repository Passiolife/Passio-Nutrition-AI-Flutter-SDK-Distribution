/// Data class that represents the serving sizes of a food item.
class PassioServingSize {
  /// The quantity of the serving.
  final double quantity;

  /// The unit name for the quantity (e.g., "grams", "ounces").
  final String unitName;

  /// Creates a new `PassioServingSize` instance.
  const PassioServingSize(this.quantity, this.unitName);

  /// Creates a `PassioServingSize` instance from a JSON map.
  factory PassioServingSize.fromJson(Map<String, dynamic> json) =>
      PassioServingSize(
        json["quantity"],
        json["unitName"],
      );

  /// Converts the `PassioServingSize` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'unitName': unitName,
      };

  /// Compares two `PassioServingSize` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioServingSize) return false;
    return quantity == other.quantity && unitName == other.unitName;
  }

  /// Calculates the hash code for this `PassioServingSize` object.
  @override
  int get hashCode => Object.hash(quantity.hashCode, unitName.hashCode);
}
