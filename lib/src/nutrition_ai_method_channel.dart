import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'models/nutrition_ai_attributes.dart';

import 'nutrition_ai_detection.dart';
import 'nutrition_ai_platform_interface.dart';
import 'nutrition_ai_configuration.dart';
import 'nutrition_ai_passio_id_name.dart';
import 'converter/platform_input_converter.dart';
import 'converter/platform_output_converter.dart';
import 'models/nutrition_ai_image.dart';

/// An implementation of [NutritionAIPlatform] that uses method channels.
class MethodChannelNutritionAI extends NutritionAIPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nutrition_ai/method');
  @visibleForTesting
  final detectionChannel = const EventChannel('nutrition_ai/event/detection');

  StreamSubscription? _detectionStream;

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

      Map<String, dynamic> resultMap = event.cast<String, dynamic>();
      var foodCandidates = mapToFoodCandidates(resultMap);
      listener.recognitionResults(foodCandidates);
    });
  }

  @override
  Future<void> stopFoodDetection() async {
    _detectionStream?.cancel();
    _detectionStream = null;
    return;
  }

  @override
  Future<List<PassioIDAndName>> searchForFood(String byText) async {
    final responseList = await methodChannel.invokeMethod<List<Object?>>(
        'searchForFood', byText);

    if (responseList == null) {
      return [];
    }
    var list =
        mapListOfObjects(responseList, (inMap) => mapToPassioIDAndName(inMap));

    return list;
  }

  @override
  Future<PassioIDAttributes?> lookupPassioAttributesFor(
      PassioID passioID) async {
    var responseMap =
        await methodChannel.invokeMethod('lookupPassioAttributesFor', passioID);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> attrsMap = responseMap!.cast<String, dynamic>();
    return mapToPassioIDAttributes(attrsMap);
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
    return mapToPlatformImage(iconMap);
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
  Future<PassioIDAttributes?> fetchAttributesForBarcode(Barcode barcode) async {
    var responseMap =
        await methodChannel.invokeMethod('fetchAttributesForBarcode', barcode);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> attrsMap = responseMap!.cast<String, dynamic>();
    return mapToPassioIDAttributes(attrsMap);
  }

  @override
  Future<PassioIDAttributes?> fetchAttributesForPackagedFoodCode(
      PackagedFoodCode packagedFoodCode) async {
    var responseMap = await methodChannel.invokeMethod(
        'fetchAttributesForPackagedFoodCode', packagedFoodCode);
    if (responseMap == null) {
      return null;
    }

    Map<String, dynamic> attrsMap = responseMap!.cast<String, dynamic>();
    return mapToPassioIDAttributes(attrsMap);
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
  Future<FoodCandidates?> detectFoodIn(Uint8List bytes, String extension,
      FoodDetectionConfiguration? config) async {
    var cleanedExt = extension.replaceAll(".", "").toLowerCase();
    var args = {
      'bytes': bytes,
      'extension': cleanedExt,
    };
    if (config != null) {
      args['config'] = mapOfFoodDetectionConfiguration(config);
    }
    var response = await methodChannel.invokeMethod('detectFoodIn', args);
    if (response == null) {
      return null;
    }

    Map<String, dynamic> resultMap = response.cast<String, dynamic>();
    return mapToFoodCandidates(resultMap);
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
}
