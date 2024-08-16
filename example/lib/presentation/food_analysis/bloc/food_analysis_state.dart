part of 'food_analysis_bloc.dart';

sealed class FoodAnalysisState extends Equatable {
  const FoodAnalysisState();
}

final class FoodAnalysisInitial extends FoodAnalysisState {
  const FoodAnalysisInitial();

  @override
  List<Object> get props => [];
}

class FoodAnalysisTypingState extends FoodAnalysisState {
  const FoodAnalysisTypingState();

  @override
  List<Object> get props => [];
}

class FoodAnalysisLoadingState extends FoodAnalysisState {
  const FoodAnalysisLoadingState();

  @override
  List<Object> get props => [];
}

class FoodAnalysisSuccessState extends FoodAnalysisState {
  final List<PassioAdvisorFoodInfo> results;

  const FoodAnalysisSuccessState({required this.results});

  @override
  List<Object> get props => [results];
}

class FoodAnalysisFailureState extends FoodAnalysisState {
  final String message;

  const FoodAnalysisFailureState({required this.message});

  @override
  List<Object> get props => [];
}
