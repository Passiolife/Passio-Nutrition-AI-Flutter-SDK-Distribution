import 'package:flutter/foundation.dart';

/// Represents the ultra-processing food rating (UPF rating) of a food item.
class PassioUPFRating {
  /// Explanation behind the rating.
  final String chainOfThought;

  /// List of highlighted ingredients.
  final List<String> highlightedIngredients;

  /// The food rating (0 to 10, where a higher rating means the food is more junk).
  final int? rating;

  /// Constructor to initialize the PassioUPFRating.
  const PassioUPFRating({
    required this.chainOfThought,
    required this.highlightedIngredients,
    this.rating,
  });

  factory PassioUPFRating.fromJson(Map<String, dynamic> json) {
    return PassioUPFRating(
      chainOfThought: json['chainOfThought'] as String,
      highlightedIngredients:
          List<String>.from(json['highlightedIngredients'] as List),
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chainOfThought': chainOfThought,
      'highlightedIngredients': highlightedIngredients,
      'rating': rating,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioUPFRating) return false;

    return chainOfThought == other.chainOfThought &&
        listEquals(highlightedIngredients, other.highlightedIngredients) &&
        rating == other.rating;
  }

  @override
  int get hashCode => Object.hash(
        chainOfThought.hashCode,
        Object.hashAllUnordered(highlightedIngredients),
        rating.hashCode,
      );

  @override
  String toString() {
    return 'PassioUPFRating{chainOfThought: $chainOfThought, highlightedIngredients: $highlightedIngredients, rating: $rating}';
  }
}
