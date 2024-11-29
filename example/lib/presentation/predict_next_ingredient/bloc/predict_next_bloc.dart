import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'predict_next_event.dart';
part 'predict_next_state.dart';

class PredictNextIngredientBloc
    extends Bloc<PredictNextIngredientEvent, PredictNextIngredientState> {
  PredictNextIngredientBloc() : super(PredictNextIngredientInitial()) {
    on<FetchPredictNextIngredientEvent>(_handleFetchSuggestionsEvent);
  }

  Future<void> _handleFetchSuggestionsEvent(
      FetchPredictNextIngredientEvent event,
      Emitter<PredictNextIngredientState> emit) async {
    emit(const FetchPredictNextIngredientLoadingState());
    final suggestions = await NutritionAI.instance
        .predictNextIngredients(event.nextIngredients);
    emit(FetchPredictNextIngredientSuccessState(data: suggestions));
  }
}
