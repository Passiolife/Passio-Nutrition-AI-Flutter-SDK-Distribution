part of 'recognize_speech_bloc.dart';

sealed class RecognizeSpeechState {
  const RecognizeSpeechState();
}

final class RecognizeSpeechInitial extends RecognizeSpeechState {
  const RecognizeSpeechInitial();
}

final class SpeechRecognitionSuccessState extends RecognizeSpeechState {
  final List<PassioSpeechRecognitionModel> data;

  const SpeechRecognitionSuccessState(this.data);
}
