/// Represents a nutrient associated with an inflammatory effect score.
class InflammatoryEffectData {
  /// The amount of the nutrient.
  final double amount;

  /// The score representing the nutrient's potential inflammatory effect.
  final double inflammatoryEffectScore;

  /// The name of the nutrient.
  final String nutrient;

  /// The unit of measurement for the nutrient amount.
  final String unit;

  /// Creates a new [InflammatoryEffectData] object.
  const InflammatoryEffectData(
    this.amount,
    this.inflammatoryEffectScore,
    this.nutrient,
    this.unit,
  );

  /// Creates a [InflammatoryEffectData] object from a JSON map.
  factory InflammatoryEffectData.fromJson(Map<String, dynamic> json) =>
      InflammatoryEffectData(
        json["amount"],
        json["inflammatoryEffectScore"],
        json["nutrient"],
        json["unit"],
      );

  /// Converts the `InflammatoryEffectData` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'inflammatoryEffectScore': inflammatoryEffectScore,
        'nutrient': nutrient,
        'unit': unit,
      };

  /// Compares two [InflammatoryEffectData] objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InflammatoryEffectData) return false;
    return amount == other.amount &&
        inflammatoryEffectScore == other.inflammatoryEffectScore &&
        nutrient == other.nutrient &&
        unit == other.unit;
  }

  /// Calculates the hash code for this [InflammatoryEffectData] object.
  @override
  int get hashCode =>
      Object.hash(amount, inflammatoryEffectScore, nutrient, unit);
}
