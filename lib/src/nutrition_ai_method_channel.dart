import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'converter/platform_input_converter.dart';
import 'converter/platform_output_converter.dart';
import 'models/inflammatory_effect_data.dart';
import 'models/passio_id_entity_types.dart';
import 'models/platform_image.dart';
import 'models/passio_food_item.dart';
import 'models/passio_search_response.dart';
import 'models/passio_search_result.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_detection.dart';
import 'nutrition_ai_platform_interface.dart';

/// An implementation of [NutritionAIPlatform] that uses method channels.
class MethodChannelNutritionAI extends NutritionAIPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nutrition_ai/method');
  @visibleForTesting
  final detectionChannel = const EventChannel('nutrition_ai/event/detection');

  /// This channel, named 'nutrition_ai/event/status', facilitates communication related to status events.
  ///
  /// This declaration is marked with `@visibleForTesting` to indicate that it is intended for testing purposes.
  @visibleForTesting
  final statusChannel = const EventChannel('nutrition_ai/event/status');

  StreamSubscription? _detectionStream;

  /// A subscription to a stream that listens for events related to Passio status changes.
  ///
  /// The [_statusStream] variable holds the subscription to a stream that listens for events related to Passio status changes.
  /// such as 'onPassioStatusChanged', 'onCompletedDownloadingAllFiles', 'onCompletedDownloadingFile', and 'onDownloadError'.
  StreamSubscription? _statusStream;

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
          debugMessage: e.message);
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
  Future<List<String>?> fetchTagsFor(PassioID passioID) async {
    var responseMap =
        await methodChannel.invokeMethod('fetchTagsFor', passioID);
    if (responseMap == null) {
      return null;
    }

    return mapDynamicListToListOfString(responseMap);
  }

  @override
  Future<FoodCandidates?> detectFoodIn(
      Uint8List bytes, FoodDetectionConfiguration? config) async {
    Map<String, dynamic> args = {'bytes': bytes};
    if (config != null) {
      args['config'] = mapOfFoodDetectionConfiguration(config);
    }
    var response = await methodChannel.invokeMethod('detectFoodIn', args);
    if (response == null) {
      return null;
    }

    Map<String, dynamic> resultMap = response.cast<String, dynamic>();
    return FoodCandidates.fromJson(resultMap);
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
      PassioID passioID) async {
    // Invoke native method to fetch nutrients for the given PassioID.
    final responseList = await methodChannel.invokeMethod<List<Object?>>(
        'fetchInflammatoryEffectData', passioID);

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
  Future<PassioFoodItem?> fetchSearchResult(
      PassioSearchResult searchResult) async {
    final args = searchResult.toJson();
    var responseMap =
        await methodChannel.invokeMethod('fetchSearchResult', args);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> foodItemMap = responseMap!.cast<String, dynamic>();
    return PassioFoodItem.fromJson(foodItemMap);
  }
}
