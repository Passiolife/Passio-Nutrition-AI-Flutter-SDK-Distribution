part of 'camera_recognition_bloc.dart';

abstract class CameraRecognitionState {}

class SearchingState extends CameraRecognitionState {}

class UpdateFoodNameState extends CameraRecognitionState {
  final String name;

  UpdateFoodNameState({required this.name});
}

class UpdateFoodIconState extends CameraRecognitionState {
  final PlatformImage? image;

  UpdateFoodIconState({required this.image});
}
