import 'package:nutrition_ai/nutrition_ai.dart';

abstract class NutritionAiWrapper {
  Future<FoodCandidates?> detectFoodIn(
      String? imagePath, FoodDetectionConfiguration configuration);
}
