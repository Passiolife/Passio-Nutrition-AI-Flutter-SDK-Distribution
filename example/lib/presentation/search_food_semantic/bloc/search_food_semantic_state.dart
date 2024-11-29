part of 'search_food_semantic_bloc.dart';

abstract class SearchFoodSemanticState {}

class FoodSearchInitial extends SearchFoodSemanticState {}

class FoodSearchTypingState extends SearchFoodSemanticState {}

class FoodSearchLoadingState extends SearchFoodSemanticState {}

class FoodSearchSuccessState extends SearchFoodSemanticState {
  final List<PassioFoodDataInfo> results;
  final List<String> alternatives;

  FoodSearchSuccessState({required this.results, required this.alternatives});
}

class FoodSearchFailureState extends SearchFoodSemanticState {
  final String searchQuery;

  FoodSearchFailureState({required this.searchQuery});
}
