import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'suggestion_event.dart';
part 'suggestion_state.dart';

class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {
  SuggestionBloc() : super(SuggestionInitial()) {
    on<FetchSuggestionsEvent>(_handleFetchSuggestionsEvent);
    on<FetchFoodItemForSuggestionEvent>(_handleFetchFoodItemForSuggestionEvent);
  }

  Future<void> _handleFetchSuggestionsEvent(
      FetchSuggestionsEvent event, Emitter<SuggestionState> emit) async {
    emit(const FetchSuggestionLoadingState());
    final suggestions =
        await NutritionAI.instance.fetchSuggestions(event.mealTime);
    emit(FetchSuggestionSuccessState(data: suggestions));
  }

  Future<void> _handleFetchFoodItemForSuggestionEvent(
      FetchFoodItemForSuggestionEvent event,
      Emitter<SuggestionState> emit) async {
    final foodItem =
        await NutritionAI.instance.fetchFoodItemForDataInfo(event.result);
    emit(FetchFoodItemForSuggestionState(foodItem: foodItem));
  }
}
