import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'meal_plan_event.dart';
part 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc() : super(const MealPlanInitial()) {
    on<DoDayUpdateEvent>(_handleOnDayUpdateEvent);
    on<DoFetchMealPlansEvent>(_handleDoFetchMealPlansEvent);
    on<DoFetchMealPlanForDayEvent>(_handleDoFetchMealPlanForDay);
  }

  Future<void> _handleOnDayUpdateEvent(
      DoDayUpdateEvent event, Emitter<MealPlanState> emit) async {
    emit(DayUpdateSuccessState(day: event.day));
  }

  Future<void> _handleDoFetchMealPlansEvent(
      DoFetchMealPlansEvent event, Emitter<MealPlanState> emit) async {
    final mealPlans = await NutritionAI.instance.fetchMealPlans();
    emit(FetchMealPlansSuccessState(data: mealPlans));
  }

  Future<void> _handleDoFetchMealPlanForDay(
      DoFetchMealPlanForDayEvent event, Emitter<MealPlanState> emit) async {
    emit(const FetchMealPlanItemsLoadingState());
    final mealPlanItems = await NutritionAI.instance
        .fetchMealPlanForDay(event.mealPlanLabel, event.day);
    emit(FetchMealPlanItemsSuccessState(data: mealPlanItems));
  }
}
