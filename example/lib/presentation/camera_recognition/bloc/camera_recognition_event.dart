part of 'camera_recognition_bloc.dart';

abstract class CameraRecognitionEvent {}

class FoodRecognizedEvent extends CameraRecognitionEvent {
  final FoodCandidates? candidates;
  final PlatformImage? image;

  FoodRecognizedEvent({required this.candidates, this.image});
}

class GetCameraZoomLevelEvent extends CameraRecognitionEvent {}
