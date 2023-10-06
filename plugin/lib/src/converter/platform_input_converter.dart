import 'dart:math';

import '../nutrition_ai_detection.dart';
import '../nutrition_ai_configuration.dart';

Map<String, dynamic> mapOfPassioConfiguration(PassioConfiguration config) {
  return {
    'key': config.key,
    'debugMode': config.debugMode,
    'filesLocalURLs': config.filesLocalURLs,
    'sdkDownloadsModels': config.sdkDownloadsModels,
    'allowInternetConnection': config.allowInternetConnection,
    'overrideInstalledVersion': config.overrideInstalledVersion,
  };
}

Map<String, dynamic> mapOfFoodDetectionConfiguration(
    FoodDetectionConfiguration config) {
  return {
    'detectVisual': config.detectVisual,
    'detectBarcodes': config.detectBarcodes,
    'detectPackagedFood': config.detectPackagedFood,
    'detectNutritionFacts': config.detectNutritionFacts,
    'framesPerSecond': config.framesPerSecond.name,
    'volumeDetectionMode': config.volumeDetectionMode.name
  };
}

Map<String, double> mapRectangle(Rectangle<double> rectangle) {
  return {
    'left': rectangle.left,
    'top': rectangle.top,
    'width': rectangle.width,
    'height': rectangle.height
  };
}
