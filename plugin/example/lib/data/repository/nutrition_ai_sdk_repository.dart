import 'dart:io';

import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/repository/nutrition_ai_wrapper.dart';

import 'package:path/path.dart' as p;

class NutritionAiSDKRepository extends NutritionAiWrapper {
  @override
  Future<FoodCandidates?> detectFoodIn(
      String? imagePath, FoodDetectionConfiguration config) async {
    if (imagePath == null) {
      return null;
    }

    var file = File(imagePath);
    var extension = p.extension(file.path);
    var bytes = file.readAsBytesSync();
    return NutritionAI.instance.detectFoodIn(bytes, extension, config: config);
  }
}
