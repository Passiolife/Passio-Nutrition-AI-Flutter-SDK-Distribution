import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nutrition_ai/src/nutrition_ai_platform_interface.dart';
import 'package:nutrition_ai/src/nutrition_ai_method_channel.dart';
import 'package:nutrition_ai/src/models/nutrition_ai_nutrient.dart';

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
  Future<PassioIDAttributes?> lookupPassioAttributesFor(String passioID) {
    // TODO: implement lookupPassioAttributesFor
    throw UnimplementedError();
  }

  @override
  Future<List<PassioIDAndName>> searchForFood(String byText) {
    throw UnimplementedError('platformVersion() has not been implemented.');
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
  Future<PassioIDAttributes?> fetchAttributesForBarcode(Barcode barcode) {
    throw UnimplementedError('fetchPassioIDAttributesFor(Barcode barcode)');
  }

  @override
  Future<PassioIDAttributes?> fetchAttributesForPackagedFoodCode(
      PackagedFoodCode packagedFoodCode) {
    throw UnimplementedError('fetchPassioIDAttributesFor(Barcode barcode)');
  }

  @override
  Future<List<String>?> fetchTagsFor(PassioID passioID) {
    throw UnimplementedError('fetchTagsFor(PassioID passioID)');
  }

  @override
  Future<FoodCandidates?> detectFoodIn(
      Uint8List bytes, String extension, FoodDetectionConfiguration? config) {
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
  Future<List<PassioNutrient>?> fetchNutrientsFor(PassioID passioID) {
    throw UnimplementedError('fetchNutrientsFor(PassioID passioID)');
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
