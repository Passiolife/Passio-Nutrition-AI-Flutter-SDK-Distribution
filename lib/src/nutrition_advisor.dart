import 'dart:typed_data';

import 'package:nutrition_ai/src/util/passio_result.dart';
import 'package:nutrition_ai/src/nutrition_ai_platform_interface.dart';

import 'models/passio_advisor_response.dart';

/// A singleton class that provides access to the Nutrition AI Advisor API.
class NutritionAdvisor {
  // Private constructor
  const NutritionAdvisor._();

  // Singleton instance
  static const NutritionAdvisor _instance = NutritionAdvisor._();

  /// Gets the singleton instance of [NutritionAdvisor].
  static NutritionAdvisor get instance => _instance;

  /// Initializes a conversation with the Nutrition AI Advisor.
  ///
  /// Returns a [PassioResult] indicating the success or failure of the initialization.
  Future<PassioResult<void>> initConversation() async {
    return NutritionAIPlatform.instance.initConversation();
  }

  /// Sends a message to the Nutrition AI Advisor.
  ///
  /// [message] is the text message to send.
  /// Returns a [PassioResult] containing a [PassioAdvisorResponse] with the advisor's response.
  Future<PassioResult<PassioAdvisorResponse>> sendMessage(
      String message) async {
    return NutritionAIPlatform.instance.sendMessage(message);
  }

  /// Sends an image to the Nutrition AI Advisor.
  ///
  /// [bytes] is the image data in bytes.
  /// Returns a [PassioResult] containing a [PassioAdvisorResponse] with the advisor's response.
  Future<PassioResult<PassioAdvisorResponse>> sendImage(Uint8List bytes) async {
    return NutritionAIPlatform.instance.sendImage(bytes);
  }

  /// Fetches ingredients from a [PassioAdvisorResponse].
  ///
  /// [response] is the response received from the `sendMessage()` method.
  /// Returns a [PassioResult] containing a [PassioAdvisorResponse] with the fetched ingredients if the response contains tools.
  Future<PassioResult<PassioAdvisorResponse>> fetchIngredients(
      PassioAdvisorResponse response) async {
    return NutritionAIPlatform.instance.fetchIngredients(response);
  }
}
