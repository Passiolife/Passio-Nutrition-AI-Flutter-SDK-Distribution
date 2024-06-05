part of 'advisor_message_bloc.dart';

sealed class AdvisorMessageState {
  const AdvisorMessageState();
}

final class AdvisorMessageInitial extends AdvisorMessageState {
  const AdvisorMessageInitial();
}

final class InitializationSuccessState extends AdvisorMessageState {
  const InitializationSuccessState();
}

final class InitializationErrorState extends AdvisorMessageState {
  final String message;

  const InitializationErrorState({required this.message});
}

final class SendMessageInitState extends AdvisorMessageState {
  const SendMessageInitState();
}

final class SendMessageErrorState extends AdvisorMessageState {
  final String message;

  const SendMessageErrorState({required this.message});
}

final class SendMessageSuccessState extends AdvisorMessageState {
  final PassioAdvisorResponse data;

  const SendMessageSuccessState({required this.data});
}

final class FetchIngredientsLoadingState extends AdvisorMessageState {
  const FetchIngredientsLoadingState();
}

final class FetchIngredientErrorState extends AdvisorMessageState {
  final String message;

  const FetchIngredientErrorState({required this.message});
}

final class FetchIngredientSuccessState extends AdvisorMessageState {
  final PassioAdvisorResponse response;

  const FetchIngredientSuccessState({required this.response});
}
