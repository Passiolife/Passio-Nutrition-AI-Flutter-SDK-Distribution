import 'dart:math';
import 'dart:typed_data';

import 'models/inflammatory_effect_data.dart';
import 'models/passio_id_entity_types.dart';
import 'models/platform_image.dart';
import 'models/passio_food_item.dart';
import 'models/passio_search_response.dart';
import 'models/passio_search_result.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_detection.dart';
import 'nutrition_ai_platform_interface.dart';

class NutritionAI {
  NutritionAI._privateConstructor();

  static final NutritionAI _instance = NutritionAI._privateConstructor();

  static NutritionAI get instance => _instance;

  /// Current version of the Passio SDK.
  Future<String?> getSDKVersion() {
    return NutritionAIPlatform.instance.getSDKVersion();
  }

  /// Initializes the SDK based on the given [PassioConfiguration]
  ///
  /// The initialization process includes downloading or reading a cached
  /// version of the license and loading the models into the runner. This
  /// process is being executed on a background thread, but the callback with
  /// the result of the configuration process will be called on the main thread.
  Future<PassioStatus> configureSDK(PassioConfiguration configuration) {
    return NutritionAIPlatform.instance.configureSDK(configuration);
  }

  /// Registers a listener for the food detection process using the stream of
  /// frames from the camera of the device.
  ///
  /// The results will be returned at a frequency defined in the
  /// [FoodDetectionConfiguration.framesPerSecond] field.
  Future<void> startFoodDetection(FoodDetectionConfiguration detectionConfig,
      FoodRecognitionListener listener) {
    return NutritionAIPlatform.instance
        .startFoodDetection(detectionConfig, listener);
  }

  /// Stops the food detection process.
  ///
  /// After this method is called no results should be delivered to a previously
  /// registered [FoodRecognitionListener].
  Future<void> stopFoodDetection() {
    return NutritionAIPlatform.instance.stopFoodDetection();
  }

  /// Search functions that uses the given [byText] to cross reference the names
  /// of the food items in the nutritional database.
  Future<PassioSearchResponse> searchForFood(String byText) {
    return NutritionAIPlatform.instance.searchForFood(byText);
  }

  /// For a given [PassioID] returns the [PassioFoodItem] of that food item.
  ///
  /// PassioFoodItem object represents all of the nutritional data the SDK
  /// has on a food item corresponding to the passioID, null otherwise.
  Future<PassioFoodItem?> fetchFoodItemForPassioID(PassioID passioID) {
    return NutritionAIPlatform.instance.fetchFoodItemForPassioID(passioID);
  }

  /// Fetch icons from Passio's backend.
  Future<PlatformImage?> fetchIconFor(PassioID passioID,
      {IconSize iconSize = IconSize.px90}) {
    return NutritionAIPlatform.instance.fetchIconFor(passioID, iconSize);
  }

  /// For a given [PassioID] returns the default image and cached image.
  ///
  /// The default image represents the generic image for that food type, shipped
  /// with the SDK. The cached image is stored from a previous [fetchIconFor]
  /// call, null otherwise.
  Future<PassioFoodIcons> lookupIconsFor(PassioID passioID,
      {IconSize iconSize = IconSize.px90,
      PassioIDEntityType type = PassioIDEntityType.item}) {
    return NutritionAIPlatform.instance
        .lookupIconsFor(passioID, iconSize, type);
  }

  /// URL to download a food icon.
  ///
  /// For a given [PassioID] and [IconSize] returns a URL to download a small
  /// food image form Passio's backend.
  Future<String> iconURLFor(PassioID passioID,
      {IconSize iconSize = IconSize.px90}) {
    return NutritionAIPlatform.instance.iconURLFor(passioID, iconSize);
  }

  /// Fetch PassioIDAttributes for product code.
  ///
  /// For a given [productCode] creates a networking call to Passio's
  /// backend that tries to fetch the corresponding [PassioFoodItem].
  Future<PassioFoodItem?> fetchFoodItemForProductCode(String productCode) {
    return NutritionAIPlatform.instance
        .fetchFoodItemForProductCode(productCode);
  }

  Future<PassioFoodItem?> fetchSearchResult(PassioSearchResult searchResult) {
    return NutritionAIPlatform.instance.fetchSearchResult(searchResult);
  }

  /// List of tags for food item.
  ///
  /// For a given [PassioID] returns a list of tags associated with that food
  /// item.
  Future<List<String>?> fetchTagsFor(PassioID passioID) {
    return NutritionAIPlatform.instance.fetchTagsFor(passioID);
  }

  /// Run detection on an image.
  ///
  /// Runs object detection on a given image (represented as a byte array). The
  /// process will run on the same background thread as object detection process
  /// from the [startFoodDetection] method. The results will be delivered on the
  /// main thread. The image extension should be one of: png, jpg, jpeg.
  Future<FoodCandidates?> detectFoodIn(Uint8List bytes,
      {FoodDetectionConfiguration? config}) {
    return NutritionAIPlatform.instance.detectFoodIn(bytes, config);
  }

  /// Transforms the bounding box of the camera frame to the coordinates
  /// of the preview view where it should be displayed.
  ///
  /// [boundingBox] is a bounding box of a detected food candidate
  /// [toRect] represents the bounds of the view where the camera preview is
  /// drawn.
  Future<Rectangle<double>> transformCGRectForm(
      Rectangle<double> boundingBox, Rectangle<double> toRect) {
    return NutritionAIPlatform.instance
        .transformCGRectForm(boundingBox, toRect);
  }

  /// If not null, the [PassioStatusListener] will provide callbacks
  /// when the internal state of the SDK's configuration process changes.
  /// Passing null will unregister the listener.
  void setPassioStatusListener(PassioStatusListener? listener) {
    NutritionAIPlatform.instance.setPassioStatusListener(listener);
  }

  /// Fetches a list of [InflammatoryEffectData] objects for a given [PassioID].
  ///
  /// Parameters:
  /// - [passioID]: The PassioID for which nutrients are to be fetched.
  ///
  /// Returns a [Future] containing a list of [InflammatoryEffectData] objects or `null` if the response is empty.
  Future<List<InflammatoryEffectData>?> fetchInflammatoryEffectData(
      PassioID passioID) {
    return NutritionAIPlatform.instance.fetchInflammatoryEffectData(passioID);
  }
}
