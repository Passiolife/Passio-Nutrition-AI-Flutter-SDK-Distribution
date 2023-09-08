part of 'static_image_bloc.dart';

abstract class StaticImageState {}

class StaticImageInitial extends StaticImageState {}

/// states for DoImagePickEvent
class OnSelectImageState extends StaticImageState {
  final XFile? image;

  OnSelectImageState({required this.image});
}

class OnSelectImageLoadingState extends StaticImageState {
  final bool isLoading;

  OnSelectImageLoadingState({required this.isLoading});
}

class OnSelectImageFailureState extends StaticImageState {
  final String message;

  OnSelectImageFailureState({required this.message});
}

class OnImageAttributeFoundState extends StaticImageState {
  final double confidence;
  final math.Rectangle<double> relativeBoundingBox;
  final String foodName;

  OnImageAttributeFoundState(
      {required this.confidence,
      required this.relativeBoundingBox,
      required this.foodName});
}
