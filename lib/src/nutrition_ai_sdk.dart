import 'dart:math';
import 'dart:typed_data';

import 'package:nutrition_ai/src/listeners/nutrition_facts_recognition_listener.dart';
import 'package:nutrition_ai/src/models/passio_advisor_food_info.dart';

import 'listeners/passio_account_listener.dart';
import 'models/enums.dart';
import 'models/inflammatory_effect_data.dart';
import 'models/passio_camera_zoom_level.dart';
import 'models/passio_food_data_info.dart';
import 'models/passio_food_item.dart';
import 'models/passio_meal_plan.dart';
import 'models/passio_meal_plan_item.dart';
import 'models/passio_result.dart';
import 'models/passio_search_response.dart';
import 'models/passio_speech_recognition_model.dart';
import 'models/platform_image.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_detection.dart';
import 'nutrition_ai_platform_interface.dart';

/// Singleton class to interact with NutritionAI SDK.
class NutritionAI {
  // Private constructor to enforce singleton pattern.
  NutritionAI._privateConstructor();

  // Singleton instance.
  static final NutritionAI _instance = NutritionAI._privateConstructor();

  // Getter to access the singleton instance.
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

  /// A function to fetch detailed information about a food item based on a search result.
  ///
  /// This function also takes an optional [weightGrams] parameter to provide information
  /// specific to the specified weight in grams. It returns a [Future] that resolves to a
  /// [PassioFoodItem] object with detailed information about the food item.
  ///
  /// Example usage:
  /// ```dart
  /// var foodItem = await fetchFoodItemForDataInfo(passioFoodDataInfo, weightGrams: 150);
  /// ```
  Future<PassioFoodItem?> fetchFoodItemForDataInfo(
      PassioFoodDataInfo passioFoodDataInfo,
      {double? weightGrams}) {
    return NutritionAIPlatform.instance
        .fetchFoodItemForDataInfo(passioFoodDataInfo, weightGrams: weightGrams);
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
  @Deprecated('No longer supported. Use recognizeImageRemote instead.')
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
    return NutritionAIPlatform.instance.setPassioStatusListener(listener);
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

  /// A function to fetch meal suggestions for a given meal time.
  ///
  /// This function takes a [PassioMealTime] parameter and returns a [Future] containing
  /// a list of [PassioFoodDataInfo] objects, representing meal suggestions.
  ///
  /// Example usage:
  /// ```dart
  /// var suggestions = await fetchSuggestions(MealTime.breakfast);
  /// ```
  Future<List<PassioFoodDataInfo>> fetchSuggestions(PassioMealTime mealTime) {
    return NutritionAIPlatform.instance.fetchSuggestions(mealTime);
  }

  /// Retrieves the list of all available meal plans.
  ///
  /// Returns a Future that resolves to a list of [PassioMealPlan] objects.
  Future<List<PassioMealPlan>> fetchMealPlans() {
    return NutritionAIPlatform.instance.fetchMealPlans();
  }

  /// Retrieves the meal plan for a specific day.
  ///
  /// [mealPlanLabel] is the label of the meal plan.
  /// [day] is the day for which the meal plan is requested.
  ///
  /// Returns a Future that resolves to a list of [PassioMealPlanItem] objects for the specified day.
  Future<List<PassioMealPlanItem>> fetchMealPlanForDay(
      String mealPlanLabel, int day) {
    return NutritionAIPlatform.instance.fetchMealPlanForDay(mealPlanLabel, day);
  }

  /// A function to fetch a PassioFoodItem using a reference code.
  ///
  /// This function asynchronously retrieves a PassioFoodItem using the provided reference code.
  ///
  /// Parameters:
  ///   refCode: The reference code of the food item to fetch.
  ///
  /// Returns:
  ///   A Future that completes with a PassioFoodItem if found, otherwise completes with null.
  Future<PassioFoodItem?> fetchFoodItemForRefCode(String refCode) {
    return NutritionAIPlatform.instance.fetchFoodItemForRefCode(refCode);
  }

  /// Fetches a food item using the legacy method.
  ///
  /// This function asynchronously retrieves a [PassioFoodItem] using the provided [PassioID].
  ///
  /// Parameters:
  /// - [passioID]: The PassioID of the food item to fetch.
  ///
  /// Returns:
  /// - A [Future] that completes with a [PassioFoodItem] if found, otherwise completes with `null`.
  Future<PassioFoodItem?> fetchFoodItemLegacy(PassioID passioID) {
    return NutritionAIPlatform.instance.fetchFoodItemLegacy(passioID);
  }

  /// Recognizes speech remotely using the provided text.
  ///
  /// This function sends the provided [text] to a remote service for speech recognition
  /// and returns a list of [PassioSpeechRecognitionModel] containing the recognition results.
  ///
  /// Parameters:
  /// - [text]: The text to be recognized.
  ///
  /// Returns:
  /// - A [Future] that completes with a [List] of [PassioSpeechRecognitionModel] containing the recognition results.
  Future<List<PassioSpeechRecognitionModel>> recognizeSpeechRemote(
      String text) {
    return NutritionAIPlatform.instance.recognizeSpeechRemote(text);
  }

  /// Recognizes an image remotely using the provided byte data.
  ///
  /// This function sends the provided [bytes] to a remote service for image recognition
  /// and returns a list of [PassioAdvisorFoodInfo] containing the recognition results.
  ///
  /// Parameters:
  /// - [bytes]: The byte data of the image to be recognized.
  /// - [resolution]: The resolution at which the image should be processed. Default is [PassioImageResolution.res_512].
  /// - [message]: An optional message providing additional context or information about the image.
  ///
  /// Returns:
  /// - A [Future] that completes with a [List] of [PassioAdvisorFoodInfo] containing the recognition results.
  Future<List<PassioAdvisorFoodInfo>> recognizeImageRemote(Uint8List bytes,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
      String? message}) {
    return NutritionAIPlatform.instance
        .recognizeImageRemote(bytes, resolution: resolution, message: message);
  }

  /// Starts the nutrition facts detection process.
  ///
  /// This function sets up a listener to receive nutrition facts recognition events
  /// and invokes the provided [listener] with the recognition results as they are received.
  ///
  /// Parameters:
  /// - [listener]: An instance of [NutritionFactsRecognitionListener] to handle recognition events.
  void startNutritionFactsDetection(
      NutritionFactsRecognitionListener listener) {
    return NutritionAIPlatform.instance.startNutritionFactsDetection(listener);
  }

  /// Stops the nutrition facts detection process.
  ///
  /// This function stops the ongoing nutrition facts detection and cleans up any resources
  /// associated with the detection process.
  ///
  /// Returns:
  /// - A [Future] that completes when the nutrition facts detection has been successfully stopped.
  Future<void> stopNutritionFactsDetection() async {
    return NutritionAIPlatform.instance.stopNutritionFactsDetection();
  }

  /// Fetches hidden ingredients for a given food item.
  ///
  /// This function interacts with the NutritionAIPlatform instance to fetch hidden ingredients
  /// for the specified [foodName] asynchronously.
  ///
  /// Parameters:
  /// - [foodName]: The name of the food item for which hidden ingredients are to be fetched.
  ///
  /// Returns:
  /// - A [Future] that resolves to a PassioResult containing the hidden ingredients.
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchHiddenIngredients(
      String foodName) async {
    return NutritionAIPlatform.instance.fetchHiddenIngredients(foodName);
  }

  /// Fetches visual alternatives for a given food item.
  ///
  /// This function interacts with the NutritionAIPlatform instance to fetch visual alternatives
  /// for the specified [foodName] asynchronously.
  ///
  /// Parameters:
  /// - [foodName]: The name of the food item for which visual alternatives are to be fetched.
  ///
  /// Returns:
  /// - A [Future] that resolves to a PassioResult containing the visual alternatives.
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchVisualAlternatives(
      String foodName) async {
    return NutritionAIPlatform.instance.fetchVisualAlternatives(foodName);
  }

  /// Fetches possible ingredients for a given food item.
  ///
  /// This function interacts with the NutritionAIPlatform instance to fetch possible ingredients
  /// for the specified [foodName] asynchronously.
  ///
  /// Parameters:
  /// - [foodName]: The name of the food item for which possible ingredients are to be fetched.
  ///
  /// Returns:
  /// - A [Future] that resolves to a PassioResult containing the possible ingredients.
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchPossibleIngredients(
      String foodName) async {
    return NutritionAIPlatform.instance.fetchPossibleIngredients(foodName);
  }

  /// Sets the account listener for receiving token budget updates.
  ///
  /// [listener] is an optional parameter that can be null. If provided, it should
  /// implement the [PassioAccountListener] interface to handle token budget updates.
  /// If null, any previously set listener will be removed.
  ///
  /// This method delegates the setting of the account listener to the instance of
  /// `NutritionAIPlatform` and ensures that the provided listener is used for
  /// receiving updates.
  void setAccountListener(PassioAccountListener? listener) {
    // Delegate the call to the NutritionAIPlatform instance to set the account listener
    return NutritionAIPlatform.instance.setAccountListener(listener);
  }

  /// Enables or disables the flashlight with a specified intensity level.
  ///
  /// This method controls the flashlight functionality on the device.
  /// It uses the `NutritionAIPlatform` instance to interact with the underlying
  /// platform-specific implementation.
  ///
  /// [enabled] A boolean flag that determines whether the flashlight should be
  ///           turned on or off. If `true`, the flashlight is turned on; if `false`,
  ///           it is turned off.
  ///
  /// [level] A double representing the intensity level of the flashlight when
  ///         turned on. The value should typically be between 0.0 (minimum brightness)
  ///         and 1.0 (maximum brightness). Ensure the value is within a valid range
  ///         supported by the device.
  ///
  /// Returns a `Future<void>` indicating the completion of the operation.
  Future<void> enableFlashlight({
    required bool enabled,
    double level = 1,
  }) {
    return NutritionAIPlatform.instance
        .enableFlashlight(enabled: enabled, level: level);
  }

  /// Sets the camera zoom level.
  ///
  /// [zoomLevel] A `double` representing the desired zoom level. The value should
  /// be within the range supported by the camera. This method calls the native
  /// platform code to apply the zoom level.
  Future<void> setCameraZoomLevel({required double zoomLevel}) {
    return NutritionAIPlatform.instance
        .setCameraZoomLevel(zoomLevel: zoomLevel);
  }

  /// Retrieves the minimum and maximum camera zoom levels supported.
  ///
  /// This method fetches the supported range of zoom levels for the camera,
  /// which can be useful for determining the boundaries of zoom operations.
  /// The implementation relies on native platform-specific code to obtain these values.
  ///
  /// Returns a [Future] that completes with a [PassioCameraZoomLevel] object,
  /// containing the minimum and maximum zoom levels supported by the camera.
  Future<PassioCameraZoomLevel> getMinMaxCameraZoomLevel() {
    return NutritionAIPlatform.instance.getMinMaxCameraZoomLevel();
  }

  /// Recognizes nutrition facts from an image remotely.
  ///
  /// This method sends the image data to a remote service to recognize and extract
  /// nutrition information. It uses platform-specific code to handle the remote call
  /// and retrieve the results. You can specify the image resolution for the analysis.
  ///
  /// [bytes] The image data in `Uint8List` format.
  /// [resolution] (optional) The desired resolution of the image for analysis.
  /// Defaults to `PassioImageResolution.res_1080`.
  ///
  /// Returns a [Future] that completes with a [PassioFoodItem] object containing
  /// the recognized food item and its nutrition facts, or `null` if no data was found.
  Future<PassioFoodItem?> recognizeNutritionFactsRemote(Uint8List bytes,
      {PassioImageResolution resolution =
          PassioImageResolution.res_1080}) async {
    return NutritionAIPlatform.instance
        .recognizeNutritionFactsRemote(bytes, resolution: resolution);
  }

  /// Updates the language setting for retrieving localized food data.
  ///
  /// This method updates the language preference used for fetching localized food data
  /// (e.g., food names, nutrition information) in the specified language.
  /// The language code provided is used to determine the appropriate localization for food data.
  ///
  /// [languageCode] A `String` representing a two-letter ISO 639-1 language code (e.g., "en" for English).
  ///
  /// Returns a [Future] that completes with a `bool`, indicating whether the language
  /// was successfully applied for retrieving localized food data. The method will return `true`
  /// if the language setting is applied successfully.
  Future<bool> updateLanguage(String languageCode) async {
    return NutritionAIPlatform.instance.updateLanguage(languageCode);
  }
}
