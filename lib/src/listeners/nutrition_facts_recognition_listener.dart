import 'package:nutrition_ai/src/models/passio_nutrition_facts.dart';

/// Interface for listening to nutrition facts recognition events.
///
/// Implement this interface to handle events when nutrition facts are recognized.
abstract interface class NutritionFactsRecognitionListener {
  /// Called when nutrition facts are recognized.
  ///
  /// This method is invoked with the recognized nutrition facts and any associated text.
  ///
  /// Parameters:
  /// - [nutritionFacts]: An instance of [PassioNutritionFacts] containing the recognized nutrition facts,
  ///   or `null` if no nutrition facts were recognized.
  /// - [text]: A [String] containing any associated text recognized, or `null` if no text was recognized.
  void onNutritionFactsRecognized(
      PassioNutritionFacts? nutritionFacts, String? text);
}
