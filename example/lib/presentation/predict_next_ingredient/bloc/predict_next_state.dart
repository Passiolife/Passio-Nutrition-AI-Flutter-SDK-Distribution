part of 'predict_next_bloc.dart';

sealed class PredictNextIngredientState {
  const PredictNextIngredientState();
}

final class PredictNextIngredientInitial extends PredictNextIngredientState {}

final class FetchPredictNextIngredientLoadingState
    extends PredictNextIngredientState {
  const FetchPredictNextIngredientLoadingState();
}

final class FetchPredictNextIngredientSuccessState
    extends PredictNextIngredientState {
  final List<PassioFoodDataInfo> data;

  const FetchPredictNextIngredientSuccessState({required this.data});
}
