import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_ai/src/models/passio_nutrition_facts.dart';
import 'package:nutrition_ai/src/models/passio_token_budget.dart';

import 'converter/platform_input_converter.dart';
import 'converter/platform_output_converter.dart';
import 'listeners/nutrition_facts_recognition_listener.dart';
import 'listeners/passio_account_listener.dart';
import 'models/enums.dart';
import 'models/inflammatory_effect_data.dart';
import 'models/passio_advisor_food_info.dart';
import 'models/passio_advisor_response.dart';
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

/// An implementation of [NutritionAIPlatform] that uses method channels.
class MethodChannelNutritionAI extends NutritionAIPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nutrition_ai/method');
  @visibleForTesting
  final advisorMethodChannel = const MethodChannel('nutrition_advisor/method');

  @visibleForTesting
  final detectionChannel = const EventChannel('nutrition_ai/event/detection');

  /// This channel, named 'nutrition_ai/event/status', facilitates communication related to status events.
  ///
  /// This declaration is marked with `@visibleForTesting` to indicate that it is intended for testing purposes.
  @visibleForTesting
  final statusChannel = const EventChannel('nutrition_ai/event/status');

  /// Event channel for nutrition facts events.
  ///
  /// This declaration is marked with `@visibleForTesting` to indicate that it is intended for testing purposes.
  @visibleForTesting
  final nutritionFactsChannel =
      const EventChannel('nutrition_ai/event/nutritionFact');

  @visibleForTesting
  final accountChannel = const EventChannel('nutrition_ai/event/account');

  StreamSubscription? _detectionStream;

  /// A subscription to a stream that listens for events related to Passio status changes.
  ///
  /// The [_statusStream] variable holds the subscription to a stream that listens for events related to Passio status changes.
  /// such as 'onPassioStatusChanged', 'onCompletedDownloadingAllFiles', 'onCompletedDownloadingFile', and 'onDownloadError'.
  StreamSubscription? _statusStream;

  /// A subscription to a stream that listens for events related to nutrition facts.
  ///
  /// The [_nutritionFactsStream] variable holds the subscription to a stream that listens for events related to nutrition facts.
  StreamSubscription? _nutritionFactsStream;

  StreamSubscription? _accountStream;

  @override
  Future<String?> getSDKVersion() async {
    final version = await methodChannel.invokeMethod<String>('getSDKVersion');
    return version;
  }

  @override
  Future<PassioStatus> configureSDK(PassioConfiguration configuration) async {
    var configMap = mapOfPassioConfiguration(configuration);

    try {
      var responseMap =
          await methodChannel.invokeMethod('configureSDK', configMap);
      Map<String, dynamic> statusMap = responseMap!.cast<String, dynamic>();
      return mapToPassioStatus(statusMap);
    } on PlatformException catch (e) {
      return PassioStatus(
        mode: PassioMode.failedToConfigure,
        error: PassioSDKError.platformException,
        debugMessage: e.message,
      );
    }
  }

  @override
  Future<void> startFoodDetection(FoodDetectionConfiguration detectionConfig,
      FoodRecognitionListener listener) async {
    var configMap = mapOfFoodDetectionConfiguration(detectionConfig);

    var args = {'method': 'startFoodDetection', 'args': configMap};
    _detectionStream =
        detectionChannel.receiveBroadcastStream(args).listen((event) {
      if (event == null) {
        return;
      }

      // Creating a mutable map to store results
      Map<String, dynamic> resultMap = event.cast<String, dynamic>();

      // Retrieving the "candidates" key from the resultMap and casting its value to a Map<String, dynamic>
      final candidatesMap = resultMap["candidates"].cast<String, dynamic>();
      // Converting the mapped candidates back to a FoodCandidates
      final foodCandidates = FoodCandidates.fromJson(candidatesMap);

      // Converting the mapped image properties to a PlatformImage
      final image = resultMap.ifValueNotNull('image',
          (map) => PlatformImage.fromJson(map.cast<String, dynamic>()));

      // Notifying the listener with recognition results, passing the FoodCandidates and the image
      listener.recognitionResults(foodCandidates, image);
    });
  }

  @override
  Future<void> stopFoodDetection() async {
    _detectionStream?.cancel();
    _detectionStream = null;
    return;
  }

  @override
  Future<PassioSearchResponse> searchForFood(String byText) async {
    final response = await methodChannel.invokeMethod('searchForFood', byText);

    if (response == null) {
      return const PassioSearchResponse(results: [], alternateNames: []);
    }

    Map<String, dynamic> responseMap = response!.cast<String, dynamic>();

    return PassioSearchResponse.fromJson(responseMap);
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForPassioID(PassioID passioID) async {
    var responseMap =
        await methodChannel.invokeMethod('fetchFoodItemForPassioID', passioID);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }

  @override
  Future<PlatformImage?> fetchIconFor(
      PassioID passioID, IconSize iconSize) async {
    var args = {
      'passioID': passioID,
      'iconSize': iconSize.name,
    };

    var responseMap = await methodChannel.invokeMethod('fetchIconFor', args);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> iconMap = responseMap!.cast<String, dynamic>();
    return PlatformImage.fromJson(iconMap);
  }

  @override
  Future<PassioFoodIcons> lookupIconsFor(
      PassioID passioID, IconSize iconSize, PassioIDEntityType type) async {
    var args = {
      'passioID': passioID,
      'iconSize': iconSize.name,
      'type': type.name
    };

    var responseMap = await methodChannel.invokeMethod('lookupIconsFor', args);
    Map<String, dynamic> iconMap = responseMap!.cast<String, dynamic>();
    return mapToPlatformImagePair(iconMap);
  }

  @override
  Future<String> iconURLFor(PassioID passioID, IconSize iconSize) async {
    var args = {'passioID': passioID, 'iconSize': iconSize.name};
    var responseMap = await methodChannel.invokeMethod('iconURLFor', args);

    return responseMap.toString();
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForProductCode(
      String productCode) async {
    var responseMap = await methodChannel.invokeMethod(
        'fetchFoodItemForProductCode', productCode);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }

  @override
  Future<List<String>?> fetchTagsFor(String refCode) async {
    var responseMap = await methodChannel.invokeMethod('fetchTagsFor', refCode);
    if (responseMap == null) {
      return null;
    }

    return mapDynamicListToListOfString(responseMap);
  }

  @override
  Future<Rectangle<double>> transformCGRectForm(
      Rectangle<double> boundingBox, Rectangle<double> toRect) async {
    var args = {
      'boundingBox': mapRectangle(boundingBox),
      'toRect': mapRectangle(toRect)
    };
    var response =
        await methodChannel.invokeMethod('transformCGRectForm', args);
    List<double> boxArray = response.cast<double>();
    var finalRect =
        Rectangle<double>(boxArray[0], boxArray[1], boxArray[2], boxArray[3]);
    return finalRect;
  }

  /// Sets a listener for Passio status changes.
  ///
  /// If [listener] is `null`, cancels the existing listener and closes the stream.
  ///
  /// The listener is notified when Passio status changes, when all files are downloaded,
  /// when a single file is completed, or when there's a download error.
  ///
  @override
  void setPassioStatusListener(PassioStatusListener? listener) {
    if (listener == null) {
      // Cancel the existing stream and set it to null if the listener is null.
      _statusStream?.cancel();
      _statusStream = null;
      return;
    }

    // Prepare arguments for setting up the Passio status listener.
    var args = {'method': 'setPassioStatusListener'};

    // Receive the broadcast stream and listen for events.
    _statusStream = statusChannel.receiveBroadcastStream(args).listen((event) {
      if (event == null) {
        return;
      }

      // Cast the event data to a map for processing.
      Map<String, dynamic> resultMap = event.cast<String, dynamic>();
      final String eventType = resultMap['event'];
      final dynamic eventData = resultMap['data'];

      // Process the event based on its type and invoke the corresponding listener method.
      switch (eventType) {
        case 'passioStatusChanged':
          final statusMap = eventData.cast<String, dynamic>();
          listener.onPassioStatusChanged(mapToPassioStatus(statusMap));
          break;
        case 'completedDownloadingAllFiles':
          final fileUris =
              List<String>.from(eventData).map((e) => Uri.parse(e)).toList();
          listener.onCompletedDownloadingAllFiles(fileUris);
          break;
        case 'completedDownloadingFile':
          final downloadMap = eventData.cast<String, dynamic>();
          final fileUri = Uri.parse(downloadMap["fileUri"]);
          final filesLeft = downloadMap["filesLeft"];
          listener.onCompletedDownloadingFile(fileUri, filesLeft);
          break;
        case 'downloadingError':
          listener.onDownloadError(eventData);
          break;
      }
    });
  }

  @override
  Future<List<InflammatoryEffectData>?> fetchInflammatoryEffectData(
      String refCode) async {
    // Invoke native method to fetch nutrients for the given PassioID.
    final responseList = await methodChannel.invokeMethod<List<Object?>>(
        'fetchInflammatoryEffectData', refCode);

    // Check if the response list is null.
    if (responseList == null) {
      return null;
    }

    // Map each object in the response list to a PassioNutrient using PassioNutrient.fromJson.
    var list = mapListOfObjects(
        responseList, (inMap) => InflammatoryEffectData.fromJson(inMap));

    // Return the resulting list of PassioNutrient objects.
    return list;
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForDataInfo(
      PassioFoodDataInfo passioFoodDataInfo,
      {double? servingQuantity,
      String? servingUnit}) async {
    final args = {
      'foodDataInfo': passioFoodDataInfo.toJson(),
      'servingQuantity': servingQuantity,
      'servingUnit': servingUnit,
    };
    var responseMap =
        await methodChannel.invokeMethod('fetchFoodItemForDataInfo', args);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }

  @override
  Future<List<PassioFoodDataInfo>> fetchSuggestions(
      PassioMealTime mealTime) async {
    var responseList = await methodChannel.invokeMethod<List<Object?>>(
        'fetchSuggestions', mealTime.name);

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioSearchResult using PassioSearchResult.fromJson.
    var list = mapListOfObjects(
        responseList, (inMap) => PassioFoodDataInfo.fromJson(inMap));

    // Return the resulting list of PassioSearchResult objects.
    return list;
  }

  @override
  Future<List<PassioMealPlan>> fetchMealPlans() async {
    var responseList =
        await methodChannel.invokeMethod<List<Object?>>('fetchMealPlans');

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioMealPlan using PassioMealPlan.fromJson.
    var list = mapListOfObjects(
        responseList, (inMap) => PassioMealPlan.fromJson(inMap));

    // Return the resulting list of PassioMealPlan objects.
    return list;
  }

  @override
  Future<List<PassioMealPlanItem>> fetchMealPlanForDay(
      String mealPlanLabel, int day) async {
    // Prepare arguments for method call
    var args = {'mealPlanLabel': mealPlanLabel, 'day': day};

    var responseList = await methodChannel.invokeMethod<List<Object?>>(
        'fetchMealPlanForDay', args);

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioMealPlanItem using PassioMealPlanItem.fromJson.
    var list = mapListOfObjects(
        responseList, (inMap) => PassioMealPlanItem.fromJson(inMap));

    // Return the resulting list of PassioMealPlanItem objects.
    return list;
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForRefCode(String refCode) async {
    var responseMap =
        await methodChannel.invokeMethod('fetchFoodItemForRefCode', refCode);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemLegacy(PassioID passioID) async {
    var responseMap =
        await methodChannel.invokeMethod('fetchFoodItemLegacy', passioID);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }

  @override
  Future<List<PassioSpeechRecognitionModel>> recognizeSpeechRemote(
      String text) async {
    // Call the platform method to perform remote speech recognition.
    var responseList = await methodChannel.invokeMethod<List<Object?>>(
        'recognizeSpeechRemote', text);

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioSpeechRecognitionModel using PassioSpeechRecognitionModel.fromJson.
    var list =
        mapListOfObjects(responseList, PassioSpeechRecognitionModel.fromJson);

    // Return the resulting list of PassioSpeechRecognitionModel objects.
    return list;
  }

  @override
  Future<List<PassioAdvisorFoodInfo>> recognizeImageRemote(Uint8List bytes,
      {required PassioImageResolution resolution, String? message}) async {
    // Prepare arguments for method call
    var args = {
      'bytes': bytes,
      'resolution': resolution.name,
      'message': message
    };

    // Call the platform method to perform remote image recognition.
    var responseList = await methodChannel.invokeMethod<List<Object?>>(
      'recognizeImageRemote',
      args,
    );

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioAdvisorFoodInfo using PassioAdvisorFoodInfo.fromJson.
    var list = mapListOfObjects(responseList, PassioAdvisorFoodInfo.fromJson);

    // Return the resulting list of PassioAdvisorFoodInfo objects.
    return list;
  }

  @override
  void startNutritionFactsDetection(
      NutritionFactsRecognitionListener listener) {
    // Prepare arguments for setting up the Passio status listener.
    var args = {'method': 'startNutritionFactsDetection'};

    // Receive the broadcast stream and listen for events.
    _nutritionFactsStream =
        nutritionFactsChannel.receiveBroadcastStream(args).listen((event) {
      if (event == null) {
        return;
      }

      // Creating a mutable map to store results
      Map<String, dynamic> resultMap = event.cast<String, dynamic>();

      // Retrieving the "candidates" key from the resultMap and casting its value to a Map<String, dynamic>
      final nutritionFactsMap =
          resultMap["nutritionFacts"]?.cast<String, dynamic>();
      // Converting the mapped candidates back to a FoodCandidates
      final nutritionFacts = nutritionFactsMap != null
          ? PassioNutritionFacts.fromJson(nutritionFactsMap)
          : null;

      final text = resultMap['text'] as String?;

      listener.onNutritionFactsRecognized(nutritionFacts, text);
    });
  }

  @override
  Future<void> stopNutritionFactsDetection() async {
    await _nutritionFactsStream?.cancel();
    _nutritionFactsStream = null;
    return;
  }

  /// Advisor
  @override
  Future<PassioResult> configure(String key) async {
    try {
      Map<String, dynamic> responseMap =
          (await advisorMethodChannel.invokeMethod('configure', key))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap);
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult> initConversation() async {
    try {
      Map<String, dynamic> responseMap =
          (await advisorMethodChannel.invokeMethod('initConversation'))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap);
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<PassioAdvisorResponse>> sendMessage(
      String message) async {
    try {
      Map<String, dynamic> responseMap =
          (await advisorMethodChannel.invokeMethod('sendMessage', message))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap)
          as PassioResult<PassioAdvisorResponse>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<PassioAdvisorResponse>> sendImage(Uint8List bytes) async {
    try {
      Map<String, dynamic> responseMap =
          (await advisorMethodChannel.invokeMethod('sendImage', bytes))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap)
          as PassioResult<PassioAdvisorResponse>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<PassioAdvisorResponse>> fetchIngredients(
      PassioAdvisorResponse response) async {
    try {
      final args = response.toJson();
      Map<String, dynamic> responseMap =
          (await advisorMethodChannel.invokeMethod('fetchIngredients', args))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap)
          as PassioResult<PassioAdvisorResponse>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchHiddenIngredients(
      String foodName) async {
    try {
      Map<String, dynamic> responseMap = (await methodChannel.invokeMethod(
              'fetchHiddenIngredients', foodName))!
          .cast<String, dynamic>();

      return mapToPassioResult(responseMap)
          as PassioResult<List<PassioAdvisorFoodInfo>>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchVisualAlternatives(
      String foodName) async {
    try {
      Map<String, dynamic> responseMap = (await methodChannel.invokeMethod(
              'fetchVisualAlternatives', foodName))!
          .cast<String, dynamic>();

      return mapToPassioResult(responseMap)
          as PassioResult<List<PassioAdvisorFoodInfo>>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchPossibleIngredients(
      String foodName) async {
    try {
      Map<String, dynamic> responseMap = (await methodChannel.invokeMethod(
              'fetchPossibleIngredients', foodName))!
          .cast<String, dynamic>();

      return mapToPassioResult(responseMap)
          as PassioResult<List<PassioAdvisorFoodInfo>>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  void setAccountListener(PassioAccountListener? listener) {
    if (listener == null) {
      // Cancel the existing stream subscription and set it to null
      _accountStream?.cancel();
      _accountStream = null;
      return;
    }

    var args = {'method': 'setAccountListener'};
    // Set up a new stream subscription to listen for account updates
    _accountStream =
        accountChannel.receiveBroadcastStream(args).listen((event) {
      if (event == null) {
        return;
      }

      // Convert the received event to a map with string keys and dynamic values
      Map<String, dynamic> eventMap = event.cast<String, dynamic>();

      // Convert the result data map to a PassioTokenBudget object
      final updatedTokenBudget = PassioTokenBudget.fromJson(eventMap);

      // Notify the listener about the updated token budget
      listener.onTokenBudgetUpdate(updatedTokenBudget);
    });
  }

  @override
  Future<void> enableFlashlight({
    required bool enabled,
    required double level,
  }) async {
    var args = {'enabled': enabled, 'level': level};
    await methodChannel.invokeMethod('enableFlashlight', args);
    return;
  }

  @override
  Future<void> setCameraZoomLevel({required double zoomLevel}) async {
    var args = {'zoomLevel': zoomLevel};
    await methodChannel.invokeMethod('setCameraZoom', args);
    return;
  }

  @override
  Future<PassioCameraZoomLevel> getMinMaxCameraZoomLevel() async {
    Map<String, dynamic> result =
        (await methodChannel.invokeMethod('getMinMaxCameraZoomLevel'))
            .cast<String, dynamic>();
    return PassioCameraZoomLevel.fromJson(result);
  }

  @override
  Future<PassioFoodItem?> recognizeNutritionFactsRemote(Uint8List bytes,
      {required PassioImageResolution resolution}) async {
    // Prepare arguments for method call
    var args = {
      'bytes': bytes,
      'resolution': resolution.name,
    };
    // Invoke the native method to recognize nutrition facts.
    var responseMap = await methodChannel.invokeMethod(
      'recognizeNutritionFactsRemote',
      args,
    );
    // If the response is null, return null, indicating no data was found.
    if (responseMap == null) {
      return null;
    }
    // Cast the response into a Map<String, dynamic> for JSON deserialization.
    Map<String, dynamic> foodItem = responseMap.cast<String, dynamic>();
    // Convert the map to a PassioFoodItem instance using the fromJson factory method.
    return PassioFoodItem.fromJson(foodItem);
  }

  @override
  Future<bool> updateLanguage(String languageCode) async {
    // Invoke the native method to update the language based on the provided language code.
    // The method returns a response, which is expected to indicate success (true/false).
    var response =
        await methodChannel.invokeMethod('updateLanguage', languageCode);
    // Cast the response to a boolean value to ensure the correct type is returned.
    return response as bool;
  }

  @override
  Future<PassioResult<bool>> reportFoodItem(
      {String refCode = '',
      String productCode = '',
      List<String>? notes}) async {
    try {
      final args = {
        'refCode': refCode,
        'productCode': productCode,
        'notes': notes,
      };
      Map<String, dynamic> responseMap =
          (await methodChannel.invokeMethod('reportFoodItem', args))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap) as PassioResult<bool>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioResult<bool>> submitUserCreatedFood(PassioFoodItem item) async {
    try {
      var args = item.toJson();
      Map<String, dynamic> responseMap =
          (await methodChannel.invokeMethod('submitUserCreatedFood', args))!
              .cast<String, dynamic>();
      return mapToPassioResult(responseMap) as PassioResult<bool>;
    } on PlatformException catch (e) {
      return Error(e.message ?? '');
    } on Exception catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<PassioSearchResponse> searchForFoodSemantic(String term) async {
    final response =
        await methodChannel.invokeMethod('searchForFoodSemantic', term);
    if (response == null) {
      return const PassioSearchResponse(results: [], alternateNames: []);
    }
    Map<String, dynamic> responseMap = response!.cast<String, dynamic>();
    return PassioSearchResponse.fromJson(responseMap);
  }

  @override
  Future<List<PassioFoodDataInfo>> predictNextIngredients(
      List<String> currentIngredients) async {
    final args = {'currentIngredients': currentIngredients};

    var responseList = await methodChannel.invokeMethod<List<Object?>>(
        'predictNextIngredients', args);

    // Check if the response list is null.
    if (responseList == null) {
      return [];
    }

    // Map each object in the response list to a PassioSearchResult using PassioSearchResult.fromJson.
    var list = mapListOfObjects(
        responseList, (inMap) => PassioFoodDataInfo.fromJson(inMap));

    // Return the resulting list of PassioSearchResult objects.
    return list;
  }
}
