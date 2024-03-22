import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/repository/nutrition_ai_wrapper.dart';

class MockNutritionAiSDKRepository extends NutritionAiWrapper {
  @override
  Future<FoodCandidates?> detectFoodIn(
      String? imagePath, FoodDetectionConfiguration configuration) async {
    var foodCandidates = FoodCandidates();

    /*final candidate = [
      DetectedCandidate(
        'VEG3319',
        0.9951872825622559,
        const Rectangle(0.31723251938819885, 0.11209869384765625,
            0.4810682237148285, 0.8764012455940247),
        null,
      ),
    ];
    foodCandidates.detectedCandidates = candidate;*/

    return foodCandidates;
  }
}
