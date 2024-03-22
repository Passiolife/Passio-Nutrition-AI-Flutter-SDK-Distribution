import 'dart:io';

import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/repository/nutrition_ai_wrapper.dart';

class NutritionAiSDKRepository extends NutritionAiWrapper {
  @override
  Future<FoodCandidates?> detectFoodIn(
      String? imagePath, FoodDetectionConfiguration configuration) async {
    if (imagePath == null) {
      return null;
    }

    var file = File(imagePath);
    var bytes = file.readAsBytesSync();
    return NutritionAI.instance.detectFoodIn(bytes, config: configuration);
  }
}
