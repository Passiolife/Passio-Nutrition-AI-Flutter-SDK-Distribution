part of 'nutrition_facts_bloc.dart';

abstract class NutritionFactsState {}

class SearchingState extends NutritionFactsState {}

class UpdateNutritionFactsState extends NutritionFactsState {
  final String? text;
  final PassioNutritionFacts? nutritionFacts;

  UpdateNutritionFactsState({this.text, this.nutritionFacts});
}
