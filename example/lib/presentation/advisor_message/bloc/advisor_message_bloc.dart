import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'advisor_message_event.dart';
part 'advisor_message_state.dart';

class AdvisorMessageBloc
    extends Bloc<AdvisorMessageEvent, AdvisorMessageState> {
  AdvisorMessageBloc() : super(const AdvisorMessageInitial()) {
    on<DoInitConversionEvent>(_handleDoInitConversionEvent);
    on<DoSendMessageEvent>(_handleDoSendMessageEvent);
    on<DoFetchIngredientEvent>(_handleDoFetchIngredientEvent);
  }

  FutureOr<void> _handleDoInitConversionEvent(
      DoInitConversionEvent event, Emitter<AdvisorMessageState> emit) async {
    final result = await NutritionAdvisor.instance.initConversation();
    switch (result) {
      case Error():
        emit(InitializationErrorState(message: result.message));
        break;
      case Success():
        emit(const InitializationSuccessState());
        break;
    }
  }

  FutureOr<void> _handleDoSendMessageEvent(
      DoSendMessageEvent event, Emitter<AdvisorMessageState> emit) async {
    emit(const SendMessageInitState());
    final result = await NutritionAdvisor.instance.sendMessage(event.message);
    switch (result) {
      case Error():
        emit(SendMessageErrorState(message: result.message));
        break;
      case Success():
        emit(SendMessageSuccessState(data: result.value));
        break;
    }
  }

  FutureOr<void> _handleDoFetchIngredientEvent(
      DoFetchIngredientEvent event, Emitter<AdvisorMessageState> emit) async {
    if (event.response != null) {
      emit(const FetchIngredientsLoadingState());
      final result =
          await NutritionAdvisor.instance.fetchIngredients(event.response!);
      switch (result) {
        case Error():
          emit(FetchIngredientErrorState(message: result.message));
          break;
        case Success():
          emit(FetchIngredientSuccessState(response: result.value));
          break;
      }
    } else {
      emit(const FetchIngredientErrorState(message: 'Something went wrong.'));
    }
  }
}
