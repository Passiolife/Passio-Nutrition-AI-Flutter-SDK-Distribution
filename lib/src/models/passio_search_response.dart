import 'package:flutter/foundation.dart';

import '../converter/platform_output_converter.dart';
import 'passio_food_data_info.dart';

/// Represents the response from a food search API, containing search results
/// and alternate names for the searched food item.
class PassioSearchResponse {
  /// A list of search results matching the query.
  final List<PassioFoodDataInfo> results;

  /// A list of possible alternative names for the searched food item.
  final List<String> alternateNames;

  /// Creates a new instance of `PassioSearchResponse`.
  const PassioSearchResponse({
    required this.results,
    required this.alternateNames,
  });

  /// Creates a new instance of `PassioSearchResponse` from a JSON map.
  factory PassioSearchResponse.fromJson(Map<String, dynamic> json) =>
      PassioSearchResponse(
        results: mapListOfObjects(
            json["results"], (inMap) => PassioFoodDataInfo.fromJson(inMap)),
        alternateNames:
            mapDynamicListToListOfString(json["alternateNames"]) ?? [],
      );

  /// Converts the `PassioSearchResponse` object to a JSON map.
  Map<String, dynamic> toJson() => {
        "results": results.map((e) => e.toJson()).toList(),
        "alternateNames": alternateNames,
      };

  /// Compares two `PassioSearchResponse` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioSearchResponse) return false;
    if (identical(this, other)) return true;
    return listEquals(results, other.results) &&
        listEquals(alternateNames, other.alternateNames);
  }

  /// Calculates the hash code for this `PassioSearchResponse` object.
  @override
  int get hashCode => results.hashCode ^ alternateNames.hashCode;
}
