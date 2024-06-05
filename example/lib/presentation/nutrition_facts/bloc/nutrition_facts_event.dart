part of 'nutrition_facts_bloc.dart';

abstract class NutritionFactsEvent {}

class NutritionFactsRecognizedEvent extends NutritionFactsEvent {
  final String? text;
  final PassioNutritionFacts? nutritionFacts;

  NutritionFactsRecognizedEvent({this.text, this.nutritionFacts});
}
