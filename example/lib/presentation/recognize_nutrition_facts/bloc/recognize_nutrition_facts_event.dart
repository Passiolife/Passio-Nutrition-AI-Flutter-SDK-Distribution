part of 'recognize_nutrition_facts_bloc.dart';

abstract class RecognizeNutritionFactsEvent {}

class DoImagePickEvent extends RecognizeNutritionFactsEvent {
  final ImageSource source;

  DoImagePickEvent({required this.source});
}

class DoOnImageSelectEvent extends RecognizeNutritionFactsEvent {
  final XFile? image;
  final ImageSource source;

  DoOnImageSelectEvent({required this.image, required this.source});
}
