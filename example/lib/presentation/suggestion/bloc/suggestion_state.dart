part of 'suggestion_bloc.dart';

sealed class SuggestionState {
  const SuggestionState();
}

final class SuggestionInitial extends SuggestionState {}

final class FetchSuggestionLoadingState extends SuggestionState {
  const FetchSuggestionLoadingState();
}

final class FetchSuggestionSuccessState extends SuggestionState {
  final List<PassioSearchResult> data;

  const FetchSuggestionSuccessState({required this.data});
}

final class FetchFoodItemForSuggestionState extends SuggestionState {
  final PassioFoodItem? foodItem;

  const FetchFoodItemForSuggestionState({required this.foodItem});
}
