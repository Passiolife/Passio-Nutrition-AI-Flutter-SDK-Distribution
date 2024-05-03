import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai/src/models/passio_meal_plan.dart';
import 'package:nutrition_ai/src/models/passio_meal_plan_item.dart';
import 'package:nutrition_ai/src/nutrition_ai_method_channel.dart';
import 'package:nutrition_ai/src/nutrition_ai_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNutritionAiPlatform
    with MockPlatformInterfaceMixin
    implements NutritionAIPlatform {
  @override
  Future<String?> getSDKVersion() => Future.value('42');

  @override
  Future<PassioStatus> configureSDK(PassioConfiguration configuration) {
    // TODO: implement configureSDK
    throw UnimplementedError();
  }

  @override
  Future<void> startFoodDetection(FoodDetectionConfiguration detectionConfig,
      FoodRecognitionListener listener) {
    // TODO: implement startFoodDetection
    throw UnimplementedError();
  }

  @override
  Future<void> stopFoodDetection() {
    // TODO: implement stopFoodDetection
    throw UnimplementedError();
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForPassioID(String passioID) {
    // TODO: implement lookupPassioAttributesFor
    throw UnimplementedError();
  }

  @override
  Future<PlatformImage?> fetchIconFor(PassioID passioID, IconSize iconSize) {
    // TODO: implement fetchIconFor
    throw UnimplementedError();
  }

  @override
  Future<PassioFoodIcons> lookupIconsFor(
      PassioID passioID, IconSize iconSize, PassioIDEntityType type) {
    // TODO: implement lookupIconsFor
    throw UnimplementedError();
  }

  @override
  Future<String> iconURLFor(PassioID passioID, IconSize iconSize) {
    throw UnimplementedError('iconURLFor(PassioID passioID, IconSize size)');
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForProductCode(Barcode barcode) {
    throw UnimplementedError('fetchPassioIDAttributesFor(Barcode barcode)');
  }

  @override
  Future<List<String>?> fetchTagsFor(PassioID passioID) {
    throw UnimplementedError('fetchTagsFor(PassioID passioID)');
  }

  @override
  Future<FoodCandidates?> detectFoodIn(
      Uint8List bytes, FoodDetectionConfiguration? config) {
    // TODO: implement detectFoodIn
    throw UnimplementedError();
  }

  @override
  Future<Rectangle<double>> transformCGRectForm(
      Rectangle<double> boundingBox, Rectangle<double> toRect) {
    throw UnimplementedError(
        'transformCGRectForm(Rectangle<double> boundingBox, Rectangle<double> toRect');
  }

  @override
  void setPassioStatusListener(PassioStatusListener? listener) {
    throw UnimplementedError(
        'setPassioStatusListener(PassioStatusListener? listener)');
  }

  @override
  Future<PassioSearchResponse> searchForFood(String byText) {
    throw UnimplementedError('searchForFood(String byText)');
  }

  @override
  Future<List<InflammatoryEffectData>?> fetchInflammatoryEffectData(
      PassioID passioID) {
    throw UnimplementedError('fetchInflammatoryEffectData(PassioID passioID)');
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForDataInfo(
      PassioFoodDataInfo passioFoodDataInfo) {
    throw UnimplementedError(
        'fetchFoodItemForDataInfo(PassioFoodDataInfo passioFoodDataInfo)');
  }

  @override
  Future<List<PassioFoodDataInfo>> fetchSuggestions(PassioMealTime mealTime) {
    // TODO: implement fetchSuggestions
    throw UnimplementedError();
  }

  @override
  Future<List<PassioMealPlanItem>> fetchMealPlanForDay(
      String mealPlanLabel, int day) {
    // TODO: implement fetchMealPlanForDay
    throw UnimplementedError();
  }

  @override
  Future<List<PassioMealPlan>> fetchMealPlans() {
    // TODO: implement fetchMealPlans
    throw UnimplementedError();
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForRefCode(String refCode) {
    // TODO: implement fetchFoodItemForRefCode
    throw UnimplementedError();
  }
}

void main() {
  final NutritionAIPlatform initialPlatform = NutritionAIPlatform.instance;

  test('$MethodChannelNutritionAI is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNutritionAI>());
  });

  test('getSDKVersion', () async {
    NutritionAI nutritionAiPlugin = NutritionAI.instance;
    MockNutritionAiPlatform fakePlatform = MockNutritionAiPlatform();
    NutritionAIPlatform.instance = fakePlatform;

    expect(await nutritionAiPlugin.getSDKVersion(), '42');
  });
}
