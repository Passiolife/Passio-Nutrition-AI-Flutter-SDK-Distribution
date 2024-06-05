import 'package:nutrition_ai/src/models/passio_advisor_response.dart';
import 'package:nutrition_ai/src/models/passio_result.dart';

import '../models/platform_image.dart';
import '../nutrition_ai_configuration.dart';

extension MapExt on Map {
  T? ifValueNotNull<T>(String key, T Function(Map<String, dynamic> map) op) {
    if (!containsKey(key)) {
      return null;
    }

    var value = (this[key] as Map<Object?, Object?>?)?.cast<String, dynamic>();
    if (value == null) {
      return null;
    }

    return op(value);
  }
}

List<T> mapListOfObjects<T>(
    List<Object?> inList, T Function(Map<String, dynamic> inMap) converter) {
  List<Map<String, dynamic>> objectList = inList
      .map((m) => (m as Map<Object?, Object?>).cast<String, dynamic>())
      .toList();
  return objectList.map((e) => converter(e)).toList();
}

List<T>? mapListOfObjectsOptional<T>(
    List<Object?>? inList, T Function(Map<String, dynamic> inMap) converter) {
  if (inList == null) {
    return null;
  }
  return mapListOfObjects(inList, converter);
}

PassioStatus mapToPassioStatus(Map<String, dynamic> inMap) {
  var status = PassioStatus(
      mode: PassioMode.values.byName(inMap['mode']),
      error: (inMap['error'] != null)
          ? PassioSDKError.values.byName(inMap['error'])
          : null,
      activeModels: inMap['activeModels'],
      debugMessage: inMap['debugMessage'],
      missingFiles: mapDynamicListToListOfString(inMap['missingFiles']));
  return status;
}

List<String>? mapDynamicListToListOfString(List<dynamic>? dynamicList) {
  if (dynamicList == null) {
    return null;
  }
  List<String> stringList =
      dynamicList.map((dynamicItem) => dynamicItem.toString()).toList();
  return stringList;
}

PassioFoodIcons mapToPlatformImagePair(Map<String, dynamic> inMap) {
  Map<String, dynamic> defaultIconMap =
      inMap["defaultIcon"].cast<String, dynamic>();
  var defaultIcon = PlatformImage.fromJson(defaultIconMap);
  var cachedIcon =
      inMap.ifValueNotNull("cachedIcon", (map) => PlatformImage.fromJson(map));
  return PassioFoodIcons(defaultIcon, cachedIcon);
}

PassioResult<dynamic> mapToPassioResult(Map<String, dynamic> map) {
  String status = map["status"];
  String message = map["message"] ??= '';
  if (status == "success") {
    if (map["value"] != null) {
      return Success<PassioAdvisorResponse>(
          PassioAdvisorResponse.fromJson(map["value"].cast<String, dynamic>()));
    }
    return const Success<VoidType>(VoidType());
  } else {
    return Error(message);
  }
}
