part of 'suggestion_bloc.dart';

sealed class SuggestionEvent {
  const SuggestionEvent();
}

final class FetchSuggestionsEvent extends SuggestionEvent {
  final MealTime mealTime;

  const FetchSuggestionsEvent({required this.mealTime});
}

final class FetchFoodItemForSuggestionEvent extends SuggestionEvent {
  final PassioSearchResult result;

  const FetchFoodItemForSuggestionEvent({required this.result});
}
