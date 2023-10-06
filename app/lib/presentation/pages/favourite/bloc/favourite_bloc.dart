import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/update_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/delete_favorite_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/get_favourites_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/update_favorite_use_case.dart';

part 'favourite_event.dart';

part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FetchFavoritesUseCase? fetchFavouritesUseCase;
  final UpdateFavoriteUseCase? updateFavoriteUseCase;
  final DeleteFavoriteUseCase? deleteFavoriteUseCase;

  //
  final UpdateFoodRecordUseCase? updateFoodRecordUseCase;

  FavouriteBloc({
    this.fetchFavouritesUseCase,
    this.updateFavoriteUseCase,
    this.deleteFavoriteUseCase,
    this.updateFoodRecordUseCase,
  }) : super(FavouriteInitial()) {
    on<GetAllFavoritesEvent>(_handleGetAllFavouritesEvent);
    on<DoFavoriteUpdateEvent>(_handleDoFavoriteUpdateEvent);
    on<DoFavoriteDeleteEvent>(_handleDoFavoriteDeleteEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  FutureOr<void> _handleGetAllFavouritesEvent(GetAllFavoritesEvent event, Emitter<FavoriteState> emit) async {
    final result = await fetchFavouritesUseCase?.call(());
    // Checking is there error in result.
    if (result?.error != null) {
      // If found any error then emit the failure state.
      emit(GetAllFavouritesFailureState(message: result?.error?.message ?? ''));
    } else {
      // No any error, so emit the success state.
      emit(GetAllFavouritesSuccessState(data: result?.response));
    }
  }

  FutureOr<void> _handleDoFavoriteUpdateEvent(DoFavoriteUpdateEvent event, Emitter<FavoriteState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FavoriteUpdateFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await updateFavoriteUseCase?.call((foodRecord: foodRecord, isNew: false));
    // Checking is there error in result.
    if (result?.error != null) {
      // If found any error then emit the failure state.
      emit(FavoriteUpdateFailureState(message: result?.error?.message ?? ''));
    } else {
      // No any error, so emit the success state.
      emit(FavoriteUpdateSuccessState());
    }
  }

  FutureOr<void> _handleDoFavoriteDeleteEvent(DoFavoriteDeleteEvent event, Emitter<FavoriteState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FavoriteDeleteFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await deleteFavoriteUseCase?.call(foodRecord);
    // Checking is there error in result.
    if (result?.error != null) {
      // If found any error then emit the failure state.
      emit(FavoriteDeleteFailureState(message: result?.error?.message ?? ''));
    } else {
      // No any error, so emit the success state.
      emit(FavoriteDeleteSuccessState());
    }
  }

  FutureOr<void> _handleDoLogEvent(DoLogEvent event, Emitter<FavoriteState> emit) async {
    emit(FoodRecordLogLoadingState(index: event.index));
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FoodRecordLogFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await updateFoodRecordUseCase?.call((foodRecord: foodRecord, isNew: true));
    // Waiting for some time to finish the animation.
    await Future.delayed(const Duration(milliseconds: Dimens.duration500));
    if (result?.error != null) {
      // If found any error then emit the failure state.
      emit(FoodRecordLogFailureState(message: result?.error?.message ?? ''));
    } else {
      // No any error, so emit the success state.
      emit(FoodRecordLogSuccessState());
    }
  }
}
