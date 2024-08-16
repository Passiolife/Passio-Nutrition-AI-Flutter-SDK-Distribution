part of 'food_analysis_bloc.dart';

sealed class FoodAnalysisEvent extends Equatable {
  const FoodAnalysisEvent();
}

class DoFoodSearchEvent extends FoodAnalysisEvent {
  final String foodName;
  final String type;

  const DoFoodSearchEvent({required this.foodName, required this.type});

  @override
  List<Object?> get props => [foodName, type];
}

final class FetchHiddenIngredientsEvent extends FoodAnalysisEvent {
  final String foodName;

  const FetchHiddenIngredientsEvent(this.foodName);

  @override
  List<Object?> get props => [foodName];
}

final class FetchVisualAlternativesEvent extends FoodAnalysisEvent {
  final String foodName;

  const FetchVisualAlternativesEvent(this.foodName);

  @override
  List<Object?> get props => [foodName];
}

final class FetchPossibleIngredientsEvent extends FoodAnalysisEvent {
  final String foodName;

  const FetchPossibleIngredientsEvent(this.foodName);

  @override
  List<Object?> get props => [foodName];
}
