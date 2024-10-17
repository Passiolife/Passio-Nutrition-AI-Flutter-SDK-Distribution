import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'food_search_event.dart';
part 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  FoodSearchBloc() : super(FoodSearchInitial()) {
    on<DoFoodSearchEvent>(_doFoodSearchEvent);
    on<DoFetchFoodItemEvent>(_doFetchFoodItemEvent);
    on<DoSubmitUserFoodEvent>(_doSubmitUserFoodEvent);
    on<DoReportFoodItem>(_doReportFoodItem);
  }

  Future<void> _doFoodSearchEvent(
      DoFoodSearchEvent event, Emitter<FoodSearchState> emit) async {
    /// Here, checking the length of [searchQuery] and based on that we will do operations.
    ///
    /// If the [_searchQuery] is empty then do nothing.
    if (event.searchQuery.isEmpty) {
      emit(FoodSearchInitial());
      return;
    } else if (event.searchQuery.length < 3) {
      /// If [searchQuery] length is less than 3 then set "Keep Typing" text.
      emit(FoodSearchTypingState());
      return;
    } else {
      /// Here, we emitting the searching, So, user will get the Searching view on the screen.
      emit(FoodSearchLoadingState());
    }

    final searchResponse =
        await NutritionAI.instance.searchForFood(event.searchQuery);

    /// Here, worked with static data, so user types in the search then we are checking in the static list.
    /// If we found matches data then we will showing that data to the user.
    // final filterData = _foodItems.where((element) => element.name?.toLowerCase().contains(event.searchQuery.toLowerCase()) ?? false).toList();

    /// Here we are checking if filter data is empty or not.
    if (searchResponse.results.isNotEmpty &&
        searchResponse.alternateNames.isNotEmpty) {
      /// Here, we are checking if data is not empty then pass that data to the state.
      /// And filtered data will be visible to the user.
      emit(FoodSearchSuccessState(
          results: searchResponse.results,
          alternatives: searchResponse.alternateNames));
    } else {
      /// There is empty data in the filter. So, we will display no data screen to the user.
      emit(FoodSearchFailureState(searchQuery: event.searchQuery));
    }
  }

  FutureOr<void> _doFetchFoodItemEvent(
      DoFetchFoodItemEvent event, Emitter<FoodSearchState> emit) async {
    final foodInfo = event.foodInfo;
    final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
      foodInfo,
      servingQuantity: 350,
      servingUnit: 'ml',
    );
    if (foodItem != null) {
      add(DoSubmitUserFoodEvent(foodItem: foodItem));
      add(DoReportFoodItem(
          refCode: foodItem.refCode, productCode: '', notes: []));
    }
  }

  FutureOr<void> _doSubmitUserFoodEvent(
      DoSubmitUserFoodEvent event, Emitter<FoodSearchState> emit) async {
    final foodItem = event.foodItem;
    final result = await NutritionAI.instance.submitUserCreatedFood(foodItem);
    switch (result) {
      case Error():
        log(result.message);
      case Success<bool>():
        log('${result.value}');
    }
  }

  Future<void> _doReportFoodItem(
      DoReportFoodItem event, Emitter<FoodSearchState> emit) async {
    final result = await NutritionAI.instance.reportFoodItem(
        refCode: event.refCode,
        productCode: event.productCode,
        notes: event.notes);
    switch (result) {
      case Error():
        log(result.message);
      case Success<bool>():
        log('${result.value}');
    }
  }
}
