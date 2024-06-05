import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'recognize_speech_event.dart';
part 'recognize_speech_state.dart';

class RecognizeSpeechBloc
    extends Bloc<RecognizeSpeechEvent, RecognizeSpeechState> {
  RecognizeSpeechBloc() : super(const LegacyApiInitial()) {
    on<DoRecognizeEvent>(_handleDoRecognizeEvent);
  }

  Future<void> _handleDoRecognizeEvent(
      DoRecognizeEvent event, Emitter<RecognizeSpeechState> emit) async {
    final result = await NutritionAI.instance.recognizeSpeechRemote(event.text);
    emit(SpeechRecognitionSuccessState(result));
  }
}
