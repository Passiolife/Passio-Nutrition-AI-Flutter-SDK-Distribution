extension DynamicListExtension on List<dynamic>? {
  /// Converts each element of the list to a string and collects them into a new list.
  ///
  /// Returns a new list of strings or null if the original list was null.
  List<String>? toListOfString() {
    return this?.map((item) => item.toString()).toList();
  }
}

extension ObjectListExtension on List<Object?>? {
  /// Converts the list of objects to a list of type [T] using the provided [converter] function.
  ///
  /// The [converter] function must take a [Map<String, dynamic>] and return an instance of [T].
  /// Throws [ArgumentError] if the list is null or any item is not a [Map<String, dynamic>].
  List<T> toListOf<T>(T Function(Map<String, dynamic> inMap) converter) {
    if (this == null) throw ArgumentError('List is null');
    return this!.map((item) {
      if (item is Map<Object?, Object?>) {
        return converter(item.cast<String, dynamic>());
      } else {
        throw ArgumentError('Item is not a Map');
      }
    }).toList();
  }

  /// Converts the list to a list of type [T] using the provided [converter], returning an empty list if null.
  ///
  /// This method provides a non-throwing alternative to [toListOf] by returning an empty list if the original list is null,
  /// ensuring that the return type is always non-nullable.
  List<T>? toListOfOptional<T>(
      T Function(Map<String, dynamic> inMap) converter) {
    if (this == null) return [];
    return toListOf(converter);
  }
}
