part of 'recognize_speech_bloc.dart';

sealed class RecognizeSpeechEvent {
  const RecognizeSpeechEvent();
}

final class DoRecognizeEvent extends RecognizeSpeechEvent {
  final String text;

  const DoRecognizeEvent(this.text);
}

final class DoFetchFoodItemEvent extends RecognizeSpeechEvent {
  final PassioFoodDataInfo foodDataInfo;

  const DoFetchFoodItemEvent(this.foodDataInfo);
}
