import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'camera_recognition_event.dart';
part 'camera_recognition_state.dart';

class CameraRecognitionBloc extends Bloc<CameraRecognitionEvent, CameraRecognitionState> {
  PassioID? currentPassioID;

  CameraRecognitionBloc() : super(SearchingState()) {
    on<FoodRecognizedEvent>(_handleCameraRecognitionEvent);
  }

  Future _handleCameraRecognitionEvent(
      FoodRecognizedEvent event,
      Emitter<CameraRecognitionState> emit
  ) async {
    if (event.candidates == null) {
      emit(SearchingState());
      return;
    }

    var barcodeCandidate = event.candidates!.barcodeCandidates?.firstOrNull;
    var packagedFoodCandidate = event.candidates!.packagedFoodCandidates?.firstOrNull;
    var visualCandidate = event.candidates!.detectedCandidates.firstOrNull;

    PassioIDAttributes? attributes;
    if (barcodeCandidate != null) {
      if (barcodeCandidate.value == currentPassioID) {
        return;
      }

      attributes = await NutritionAI.instance.fetchAttributesForBarcode(barcodeCandidate.value);
      if (attributes != null) {
        currentPassioID = barcodeCandidate.value;
      }
    } else if (packagedFoodCandidate != null) {
      if (packagedFoodCandidate.packagedFoodCode == currentPassioID) {
        return;
      }

      attributes = await NutritionAI.instance.fetchAttributesForPackagedFoodCode(packagedFoodCandidate.packagedFoodCode);
      if (attributes != null) {
        currentPassioID = packagedFoodCandidate.packagedFoodCode;
      }
    } else if (visualCandidate != null) {
      if (visualCandidate.passioID == currentPassioID) {
        return;
      }

      attributes = await NutritionAI.instance.lookupPassioAttributesFor(visualCandidate.passioID);
      if (attributes != null) {
        currentPassioID = visualCandidate.passioID;
      }
    }

    if (attributes == null) {
      currentPassioID = null;
      emit(SearchingState());
      return;
    }

    emit(UpdateFoodNameState(name: attributes.name));

    if (event.image != null) {
      emit(UpdateFoodIconState(image: event.image));
      return;
    }

    var passioIcons = await NutritionAI.instance.lookupIconsFor(attributes.passioID, type: attributes.entityType);

    if (passioIcons.cachedIcon != null) {
      emit(UpdateFoodIconState(image: passioIcons.cachedIcon));
      return;
    }

    emit(UpdateFoodIconState(image: passioIcons.defaultIcon));

    var remoteIcon = await NutritionAI.instance.fetchIconFor(attributes.passioID);
    if (remoteIcon != null) {
      emit(UpdateFoodIconState(image: remoteIcon));
    }
  }
}