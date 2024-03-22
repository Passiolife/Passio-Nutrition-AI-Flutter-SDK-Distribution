/// The origin of the data for a given food item of the nutritional database.
class PassioFoodOrigin {
  /// The unique identifier of the food origin.
  final String id;

  /// The source of the food origin.
  final String source;

  /// An optional license copy associated with the source (can be null).
  final String? licenseCopy;

  /// Creates a new `PassioFoodOrigin` instance.
  const PassioFoodOrigin(this.id, this.source, this.licenseCopy);

  /// Creates a `PassioFoodOrigin` instance from a JSON map.
  factory PassioFoodOrigin.fromJson(Map<String, dynamic> json) =>
      PassioFoodOrigin(
        json["id"],
        json["source"],
        json["licenseCopy"],
      );

  /// Converts the `PassioFoodOrigin` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'source': source,
        'licenseCopy': licenseCopy,
      };

  /// Compares two `PassioFoodOrigin` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioFoodOrigin) return false;
    return id == other.id &&
        source == other.source &&
        licenseCopy == other.licenseCopy;
  }

  /// Calculates the hash code for this `PassioFoodOrigin` object.
  @override
  int get hashCode =>
      Object.hash(id.hashCode, source.hashCode, licenseCopy?.hashCode);
}
