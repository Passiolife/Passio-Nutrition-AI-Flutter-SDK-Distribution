part of 'camera_recognition_bloc.dart';

abstract class CameraRecognitionEvent {}

class FoodRecognizedEvent extends CameraRecognitionEvent {
  final FoodCandidates? candidates;

  FoodRecognizedEvent({required this.candidates});
}