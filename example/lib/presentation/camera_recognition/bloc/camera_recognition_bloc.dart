import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'camera_recognition_event.dart';
part 'camera_recognition_state.dart';

class CameraRecognitionBloc
    extends Bloc<CameraRecognitionEvent, CameraRecognitionState> {
  PassioID? currentPassioID;

  CameraRecognitionBloc() : super(SearchingState()) {
    on<FoodRecognizedEvent>(_handleCameraRecognitionEvent);
  }

  Future _handleCameraRecognitionEvent(
      FoodRecognizedEvent event, Emitter<CameraRecognitionState> emit) async {
    if (event.candidates == null) {
      emit(SearchingState());
      return;
    }

    var barcodeCandidate = event.candidates!.barcodeCandidates?.firstOrNull;
    var packagedFoodCandidate =
        event.candidates!.packagedFoodCandidates?.firstOrNull;
    var visualCandidate = event.candidates!.detectedCandidates?.firstOrNull;

    PassioFoodItem? foodItem;
    if (barcodeCandidate != null) {
      if (barcodeCandidate.value == currentPassioID) {
        return;
      }

      foodItem = await NutritionAI.instance
          .fetchFoodItemForProductCode(barcodeCandidate.value);
      if (foodItem != null) {
        currentPassioID = barcodeCandidate.value;
      }
    } else if (packagedFoodCandidate != null) {
      if (packagedFoodCandidate.packagedFoodCode == currentPassioID) {
        return;
      }

      foodItem = await NutritionAI.instance
          .fetchFoodItemForProductCode(packagedFoodCandidate.packagedFoodCode);
      if (foodItem != null) {
        currentPassioID = packagedFoodCandidate.packagedFoodCode;
      }
    } else if (visualCandidate != null) {
      if (visualCandidate.passioID == currentPassioID) {
        return;
      }

      foodItem = await NutritionAI.instance
          .fetchFoodItemForPassioID(visualCandidate.passioID);
      if (foodItem != null) {
        currentPassioID = visualCandidate.passioID;
      }
    }

    if (foodItem == null) {
      currentPassioID = null;
      emit(SearchingState());
      return;
    }

    emit(UpdateFoodNameState(name: foodItem.name));

    if (event.image != null) {
      emit(UpdateFoodIconState(image: event.image));
      return;
    }

    var passioIcons = await NutritionAI.instance
        .lookupIconsFor(foodItem.iconId, type: PassioIDEntityType.item);

    if (passioIcons.cachedIcon != null) {
      emit(UpdateFoodIconState(image: passioIcons.cachedIcon));
      return;
    }

    emit(UpdateFoodIconState(image: passioIcons.defaultIcon));

    var remoteIcon = await NutritionAI.instance.fetchIconFor(foodItem.iconId);
    if (remoteIcon != null) {
      emit(UpdateFoodIconState(image: remoteIcon));
    }
  }
}
