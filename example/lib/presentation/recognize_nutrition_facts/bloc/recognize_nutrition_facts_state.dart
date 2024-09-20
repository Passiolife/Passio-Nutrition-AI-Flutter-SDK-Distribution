part of 'recognize_nutrition_facts_bloc.dart';

abstract class RecognizeNutritionFactsState {}

class RecognizeImageInitial extends RecognizeNutritionFactsState {}

/// states for DoImagePickEvent
class OnSelectImageState extends RecognizeNutritionFactsState {
  final XFile? image;

  OnSelectImageState({required this.image});
}

class OnSelectImageLoadingState extends RecognizeNutritionFactsState {
  final bool isLoading;

  OnSelectImageLoadingState({required this.isLoading});
}

class OnSelectImageFailureState extends RecognizeNutritionFactsState {
  final String message;

  OnSelectImageFailureState({required this.message});
}

class ImageRecognitionSuccessState extends RecognizeNutritionFactsState {
  final PassioFoodItem? data;

  ImageRecognitionSuccessState(this.data);
}
