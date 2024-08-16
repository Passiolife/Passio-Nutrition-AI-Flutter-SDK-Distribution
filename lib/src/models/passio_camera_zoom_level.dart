/// This class represents the camera zoom levels, including minimum and maximum values.
class PassioCameraZoomLevel {
  /// The minimum zoom level allowed.
  final double? minZoomLevel;

  /// The maximum zoom level allowed.
  final double? maxZoomLevel;

  /// Creates a new instance of [PassioCameraZoomLevel] with the provided values.
  const PassioCameraZoomLevel({
    this.minZoomLevel,
    this.maxZoomLevel,
  });

  /// Creates a [PassioCameraZoomLevel] instance from a JSON map.
  ///
  /// [json] is expected to be a map with string keys and dynamic values.
  factory PassioCameraZoomLevel.fromJson(Map<String, dynamic> json) =>
      PassioCameraZoomLevel(
        minZoomLevel: json['minZoomLevel'],
        maxZoomLevel: json['maxZoomLevel'],
      );

  /// Converts this [PassioCameraZoomLevel] instance to a JSON map.
  ///
  /// The resulting map can be used to serialize the instance to JSON.
  Map<String, dynamic> toJson() => {
        "minZoomLevel": minZoomLevel,
        "maxZoomLevel": maxZoomLevel,
      };

  @override
  bool operator ==(Object other) {
    // Checks if 'other' is a PassioCameraZoomLevel instance
    if (other is! PassioCameraZoomLevel) return false;

    // Checks if 'this' and 'other' refer to the same instance
    if (identical(this, other)) return true;

    // Compares all properties for equality
    return minZoomLevel == other.minZoomLevel &&
        maxZoomLevel == other.maxZoomLevel;
  }

  // Computes a hash code based on the properties
  @override
  int get hashCode => Object.hash(minZoomLevel, maxZoomLevel);

  // Provides a string representation of the instance
  @override
  String toString() {
    return 'PassioCameraZoomLevel{minZoomLevel: $minZoomLevel, maxZoomLevel: $maxZoomLevel}';
  }
}
