part of 'predict_next_bloc.dart';

sealed class PredictNextIngredientEvent {
  const PredictNextIngredientEvent();
}

final class FetchPredictNextIngredientEvent extends PredictNextIngredientEvent {
  final List<String> nextIngredients;

  const FetchPredictNextIngredientEvent({required this.nextIngredients});
}
