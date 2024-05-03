part of 'food_search_bloc.dart';

abstract class FoodSearchState {}

class FoodSearchInitial extends FoodSearchState {}

class FoodSearchTypingState extends FoodSearchState {}

class FoodSearchLoadingState extends FoodSearchState {}

class FoodSearchSuccessState extends FoodSearchState {
  final List<PassioFoodDataInfo> results;
  final List<String> alternatives;

  FoodSearchSuccessState({required this.results, required this.alternatives});
}

class FoodSearchFailureState extends FoodSearchState {
  final String searchQuery;

  FoodSearchFailureState({required this.searchQuery});
}
