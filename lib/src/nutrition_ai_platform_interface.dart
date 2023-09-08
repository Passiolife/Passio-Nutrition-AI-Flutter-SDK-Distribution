import 'dart:typed_data';
import 'dart:math';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nutrition_ai_method_channel.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_detection.dart';
import 'models/nutrition_ai_attributes.dart';
import 'nutrition_ai_passio_id_name.dart';
import 'models/nutrition_ai_image.dart';

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

  Future<List<PassioIDAndName>> searchForFood(String byText) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<PassioIDAttributes?> lookupPassioAttributesFor(PassioID passioID) {
    throw UnimplementedError(
        'lookupPassioAttributesFor() has not been implemented.');
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

  Future<PassioIDAttributes?> fetchAttributesForBarcode(Barcode barcode) {
    throw UnimplementedError('fetchPassioIDAttributesFor(Barcode barcode)');
  }

  Future<PassioIDAttributes?> fetchAttributesForPackagedFoodCode(
      PackagedFoodCode packagedFoodCode) {
    throw UnimplementedError('fetchPassioIDAttributesFor(Barcode barcode)');
  }

  Future<List<String>?> fetchTagsFor(PassioID passioID) {
    throw UnimplementedError('fetchTagsFor(PassioID passioID)');
  }

  Future<FoodCandidates?> detectFoodIn(
      Uint8List bytes, String extension, FoodDetectionConfiguration? config) {
    throw UnimplementedError('detectFoodIn(Uint8List bytes, String extension)');
  }

  Future<Rectangle<double>> transformCGRectForm(
      Rectangle<double> boundingBox, Rectangle<double> toRect) {
    throw UnimplementedError(
        'transformCGRectForm(Rectangle<double> boundingBox, Rectangle<double> toRect');
  }
}
