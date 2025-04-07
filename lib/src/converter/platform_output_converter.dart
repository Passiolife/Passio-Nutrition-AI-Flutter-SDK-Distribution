import 'package:nutrition_ai/src/models/passio_advisor_response.dart';
import 'package:nutrition_ai/src/util/passio_result.dart';

import '../models/passio_advisor_food_info.dart';

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

List<String>? mapDynamicListToListOfString(List<dynamic>? dynamicList) {
  if (dynamicList == null) {
    return null;
  }
  List<String> stringList =
      dynamicList.map((dynamicItem) => dynamicItem.toString()).toList();
  return stringList;
}

PassioAdvisorResponse mapToPassioAdvisorResponse(Map<String, dynamic> inMap) {
  var response = PassioAdvisorResponse.fromJson(inMap.cast<String, dynamic>());
  return response;
}

extension PassioResultExtension on Map {
  PassioResult<T> toPassioResult<T>() {
    Map<String, dynamic> map = cast<String, dynamic>();
    String status = map["status"];
    String message = map["message"] ??= '';

    if (status == "success") {
      final value = map["value"];

      if (value is Map) {
        if (T == PassioAdvisorResponse) {
          final response =
              PassioAdvisorResponse.fromJson(value.cast<String, dynamic>());
          return Success<T>(response as T);
        }
      } else if (value is List) {
        if (T == List<PassioAdvisorFoodInfo>) {
          final list = mapListOfObjects(
              value, (inMap) => PassioAdvisorFoodInfo.fromJson(inMap));
          return Success<T>(list as T);
        }
      } else if (value is bool && T is bool) {
        return Success<T>(value as T);
      }
      return Success<T>(value as T);
    } else {
      return Error<T>(message);
    }
  }
}

PassioResult<T> mapToPassioResultGeneric<T, E>(
    Map<String, dynamic> map, T Function(E) converter) {
  String status = map["status"];
  String message = map["message"] ??= '';
  switch (status) {
    case "success":
      final value = map["value"];
      final result = converter(value);
      return Success<T>(result);
    case "error":
      return Error(message);
    default:
      return Error("Unknown status: $status");
  }
}
