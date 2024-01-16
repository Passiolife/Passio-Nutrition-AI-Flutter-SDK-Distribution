import 'dart:typed_data';
import 'dart:math';

import 'nutrition_ai_detection.dart';
import 'nutrition_ai_platform_interface.dart';
import 'nutrition_ai_configuration.dart';
import 'models/nutrition_ai_attributes.dart';
import 'nutrition_ai_passio_id_name.dart';
import 'models/nutrition_ai_image.dart';
import 'models/nutrition_ai_nutrient.dart';

class NutritionAI {
  NutritionAI._privateConstructor();

  static final NutritionAI _instance = NutritionAI._privateConstructor();

  static NutritionAI get instance => _instance;

  /// Current version of the Passio SDK.
  Future<String?> getSDKVersion() {
    return NutritionAIPlatform.instance.getSDKVersion();
  }

  /// Initalizes the SDK based on the given [PassioConfiguration]
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
  Future<List<PassioIDAndName>> searchForFood(String byText) {
    return NutritionAIPlatform.instance.searchForFood(byText);
  }

  /// For a given [PassioID] returns the [PassioIDAttributes] of that food item.
  ///
  /// PassioIDAttributes object represents all of the nutritional data the SDK
  /// has on a food item corresponding to the passioID, null otherwise.
  Future<PassioIDAttributes?> lookupPassioAttributesFor(PassioID passioID) {
    return NutritionAIPlatform.instance.lookupPassioAttributesFor(passioID);
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

  /// Fetch PassioIDAttributes for barcodes.
  ///
  /// For a given [Barcode] creates a networking call to Passio's
  /// backend that tries to fetch the corresponding [PassioIDAttributes].
  Future<PassioIDAttributes?> fetchAttributesForBarcode(Barcode barcode) {
    return NutritionAIPlatform.instance.fetchAttributesForBarcode(barcode);
  }

  /// Fetch PassioIDAttributes for packaged food.
  ///
  /// For a given [PackagedFoodCode] creates a networking call to Passio's
  /// backend that tries to fetch the corresponding [PassioIDAttributes].
  Future<PassioIDAttributes?> fetchAttributesForPackagedFoodCode(
      PackagedFoodCode packagedFoodCode) {
    return NutritionAIPlatform.instance
        .fetchAttributesForPackagedFoodCode(packagedFoodCode);
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
  /// Runs object detection on a given image (respresented as a byte array). The
  /// process will run on the same background thread as object detection process
  /// from the [startFoodDetection] method. The results will be delivered on the
  /// main thread. The image extension should be one of: png, jpg, jpeg.
  Future<FoodCandidates?> detectFoodIn(Uint8List bytes, String extension,
      {FoodDetectionConfiguration? config}) {
    return NutritionAIPlatform.instance.detectFoodIn(bytes, extension, config);
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

  /// Fetches a list of [PassioNutrient] objects for a given [PassioID].
  ///
  /// Parameters:
  /// - [passioID]: The PassioID for which nutrients are to be fetched.
  ///
  /// Returns a [Future] containing a list of [PassioNutrient] objects or `null` if the response is empty.
  Future<List<PassioNutrient>?> fetchNutrientsFor(PassioID passioID) {
    return NutritionAIPlatform.instance.fetchNutrientsFor(passioID);
  }
}
