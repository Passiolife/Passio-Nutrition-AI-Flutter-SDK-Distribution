part of 'recognize_image_bloc.dart';

abstract class RecognizeImageState {}

class RecognizeImageInitial extends RecognizeImageState {}

/// states for DoImagePickEvent
class OnSelectImageState extends RecognizeImageState {
  final XFile? image;

  OnSelectImageState({required this.image});
}

class OnSelectImageLoadingState extends RecognizeImageState {
  final bool isLoading;

  OnSelectImageLoadingState({required this.isLoading});
}

class OnSelectImageFailureState extends RecognizeImageState {
  final String message;

  OnSelectImageFailureState({required this.message});
}

class ImageRecognitionSuccessState extends RecognizeImageState {
  final List<PassioAdvisorFoodInfo> data;

  ImageRecognitionSuccessState(this.data);
}
