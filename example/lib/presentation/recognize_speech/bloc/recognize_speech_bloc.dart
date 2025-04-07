import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'recognize_speech_event.dart';
part 'recognize_speech_state.dart';

class RecognizeSpeechBloc
    extends Bloc<RecognizeSpeechEvent, RecognizeSpeechState> {
  RecognizeSpeechBloc() : super(const RecognizeSpeechInitial()) {
    on<DoRecognizeEvent>(_handleDoRecognizeEvent);
    on<DoFetchFoodItemEvent>(_handleDoFetchFoodItemEvent);
  }

  Future<void> _handleDoRecognizeEvent(
      DoRecognizeEvent event, Emitter<RecognizeSpeechState> emit) async {
    final result = await NutritionAI.instance.recognizeSpeechRemote(event.text);
    emit(SpeechRecognitionSuccessState(result));
  }

  FutureOr<void> _handleDoFetchFoodItemEvent(
      DoFetchFoodItemEvent event, Emitter<RecognizeSpeechState> emit) async {
    final result = await NutritionAI.instance.fetchFoodItemForDataInfo(
      event.foodDataInfo,
      servingQuantity: event.foodDataInfo.nutritionPreview.servingQuantity,
      servingUnit: event.foodDataInfo.nutritionPreview.servingUnit,
    );
    log(result.toString());
  }
}
