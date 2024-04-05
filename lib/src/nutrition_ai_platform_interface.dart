import 'dart:math';
import 'dart:typed_data';

import 'package:nutrition_ai/src/models/enums.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/inflammatory_effect_data.dart';
import 'models/passio_food_item.dart';
import 'models/passio_search_response.dart';
import 'models/passio_search_result.dart';
import 'models/platform_image.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_detection.dart';
import 'nutrition_ai_method_channel.dart';

abstract class NutritionAIPlatform extends PlatformInterface {
  /// Constructs a NutritionAiPlatform.
  NutritionAIPlatform() : super(token: _token);

  static final Object _token = Object();

  static NutritionAIPlatform _instance = MethodChannelNutritionAI();

  /// The default instance of [NutritionAIPlatform] to use.
  ///
  /// Defaults to [MethodChannelNutritionAI].
  static NutritionAIPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NutritionAIPlatform] when
  /// they register themselves.
  static set instance(NutritionAIPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getSDKVersion() {
    throw UnimplementedError('getSDKVersion() has not been implemented.');
  }

  Future<PassioStatus> configureSDK(PassioConfiguration configuration) {
    throw UnimplementedError('configureSDK() has not been implemented.');
  }

  Future<void> startFoodDetection(FoodDetectionConfiguration detectionConfig,
      FoodRecognitionListener listener) {
    throw UnimplementedError('startFoodDetection() has not been implemented.');
  }

  Future<void> stopFoodDetection() {
    throw UnimplementedError('stopFoodDetection() has not been implemented.');
  }

  Future<PassioSearchResponse> searchForFood(String byText) {
    throw UnimplementedError('searchForFood() has not been implemented.');
  }

  Future<PassioFoodItem?> fetchFoodItemForSearchResult(
      PassioSearchResult searchResult) {
    throw UnimplementedError(
        'fetchFoodItemForSearchResult(PassioSearchResult searchResult) has not been implemented.');
  }

  Future<PassioFoodItem?> fetchFoodItemForPassioID(PassioID passioID) {
    throw UnimplementedError(
        'fetchFoodItemForPassioID() has not been implemented.');
  }

  Future<PlatformImage?> fetchIconFor(PassioID passioID, IconSize iconSize) {
    throw UnimplementedError('fetchIconFor() has not been implemented.');
  }

  Future<PassioFoodIcons> lookupIconsFor(
      PassioID passioID, IconSize iconSize, PassioIDEntityType type) {
    throw UnimplementedError('lookupIconsFor() has not been implemented.');
  }

  Future<String> iconURLFor(PassioID passioID, IconSize iconSize) {
    throw UnimplementedError('iconURLFor(PassioID passioID, IconSize size)');
  }

  Future<PassioFoodItem?> fetchFoodItemForProductCode(String productCode) {
    throw UnimplementedError('fetchFoodItemForProductCode(String productCode)');
  }

  Future<List<String>?> fetchTagsFor(PassioID passioID) {
    throw UnimplementedError('fetchTagsFor(PassioID passioID)');
  }

  Future<FoodCandidates?> detectFoodIn(
      Uint8List bytes, FoodDetectionConfiguration? config) {
    throw UnimplementedError('detectFoodIn(Uint8List bytes, String extension)');
  }

  Future<Rectangle<double>> transformCGRectForm(
      Rectangle<double> boundingBox, Rectangle<double> toRect) {
    throw UnimplementedError(
        'transformCGRectForm(Rectangle<double> boundingBox, Rectangle<double> toRect');
  }

  void setPassioStatusListener(PassioStatusListener? listener) {
    throw UnimplementedError(
        'setPassioStatusListener(PassioStatusListener? listener)');
  }

  Future<List<InflammatoryEffectData>?> fetchInflammatoryEffectData(
      PassioID passioID) {
    throw UnimplementedError('fetchInflammatoryEffectData(PassioID passioID)');
  }

  Future<List<PassioSearchResult>> fetchSuggestions(MealTime mealTime) {
    throw UnimplementedError('fetchSuggestions(MealTime mealTime)');
  }

  Future<PassioFoodItem?> fetchFoodItemForSuggestion(
      PassioSearchResult suggestion) {
    throw UnimplementedError(
        'fetchFoodItemForSuggestion(PassioSearchResult suggestion)');
  }
}
