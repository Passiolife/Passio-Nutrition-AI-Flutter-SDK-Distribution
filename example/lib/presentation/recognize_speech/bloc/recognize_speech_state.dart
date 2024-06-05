part of 'recognize_speech_bloc.dart';

sealed class RecognizeSpeechState {
  const RecognizeSpeechState();
}

final class LegacyApiInitial extends RecognizeSpeechState {
  const LegacyApiInitial();
}

final class SpeechRecognitionSuccessState extends RecognizeSpeechState {
  final List<PassioSpeechRecognitionModel> data;

  const SpeechRecognitionSuccessState(this.data);
}
