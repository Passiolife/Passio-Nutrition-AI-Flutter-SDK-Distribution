import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'food_analysis_event.dart';
part 'food_analysis_state.dart';

class FoodAnalysisBloc extends Bloc<FoodAnalysisEvent, FoodAnalysisState> {
  FoodAnalysisBloc() : super(const FoodAnalysisInitial()) {
    on<DoFoodSearchEvent>(_doFoodSearchEvent);
  }

  Future<void> _doFoodSearchEvent(
      DoFoodSearchEvent event, Emitter<FoodAnalysisState> emit) async {
    /// Here, checking the length of [searchQuery] and based on that we will do operations.
    ///
    /// If the [_searchQuery] is empty then do nothing.
    if (event.foodName.isEmpty) {
      emit(const FoodAnalysisInitial());
      return;
    } else if (event.foodName.length < 3) {
      /// If [searchQuery] length is less than 3 then set "Keep Typing" text.
      emit(const FoodAnalysisTypingState());
      return;
    } else {
      /// Here, we emitting the searching, So, user will get the Searching view on the screen.
      emit(const FoodAnalysisLoadingState());
    }

    final result = await ((event.type == 'fetchHiddenIngredients')
        ? NutritionAI.instance.fetchHiddenIngredients(event.foodName)
        : (event.type == 'fetchVisualAlternatives')
            ? NutritionAI.instance.fetchVisualAlternatives(event.foodName)
            : NutritionAI.instance.fetchPossibleIngredients(event.foodName));
    switch (result) {
      case Error():
        emit(FoodAnalysisFailureState(message: result.message));
        break;
      case Success<List<PassioAdvisorFoodInfo>>():
        emit(FoodAnalysisSuccessState(results: result.value));
        break;
    }
  }
}
