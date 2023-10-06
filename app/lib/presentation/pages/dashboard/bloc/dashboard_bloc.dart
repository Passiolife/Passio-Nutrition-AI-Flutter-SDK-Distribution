import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/delete_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/fetch_day_records_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/update_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/update_favorite_use_case.dart';
import 'package:flutter_nutrition_ai_demo/util/passio_id_attributes_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/user_session.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FetchDayRecordsUseCase fetchFoodRecordsUseCase;
  final DeleteFoodRecordUseCase? deleteFoodRecordUseCase;

  final UpdateFoodRecordUseCase? updateFoodRecordUseCase;
  final UserSession userSession;

  // Favourite use cases
  final UpdateFavoriteUseCase? updateFavouriteUseCase;

  DashboardBloc({
    required this.fetchFoodRecordsUseCase,
    required this.deleteFoodRecordUseCase,
    this.updateFoodRecordUseCase,
    required this.userSession,
    required this.updateFavouriteUseCase,
  }) : super(DashboardInitial()) {
    on<GetFoodRecordsEvent>(_handleGetFoodLogsEvent);
    on<RefreshFoodRecordEvent>(_handleRefreshFoodLogEvent);
    on<DeleteFoodRecordEvent>(_handleDeleteFoodRecordEvent);
    on<DoFoodInsertEvent>(_handleDoFoodInsertEvent);
    on<DoFoodUpdateEvent>(_handleDoFoodUpdateEvent);
    on<DoFavouriteEvent>(_handleDoFavouriteEvent);
  }

  Future _handleGetFoodLogsEvent(GetFoodRecordsEvent event, Emitter<DashboardState> emit) async {
    final result = await fetchFoodRecordsUseCase.call((dateTime: event.dateTime));
    if (result.error != null) {
      emit(GetFoodRecordFailureState(message: result.error?.message ?? ''));
    } else {
      emit(GetFoodRecordSuccessState(data: result.response ?? []));
    }
  }

  Future<void> _handleRefreshFoodLogEvent(RefreshFoodRecordEvent event, Emitter<DashboardState> emit) async {
    emit(RefreshFoodLogState());
  }

  Future<void> _handleDeleteFoodRecordEvent(DeleteFoodRecordEvent event, Emitter<DashboardState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await deleteFoodRecordUseCase?.call((foodRecord: foodRecord));
    if (result?.error != null) {
      emit(DeleteRecordFailureState(message: result?.error?.message ?? ''));
    }
  }

  FutureOr<void> _handleDoFoodInsertEvent(DoFoodInsertEvent event, Emitter<DashboardState> emit) async {
    try {
      if (event.data?.passioID.isNotEmpty ?? false) {
        // Get attribute data from SDK.
        final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.data?.passioID ?? '');

        // Convert passio attribute to food record.
        final foodRecord = attributes?.toFoodRecord(dateTime: event.dateTime);
        if (foodRecord == null) {
          emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
          return;
        }
        final result = await updateFoodRecordUseCase?.call((foodRecord: foodRecord, isNew: true));
        if (result?.error != null) {
          emit(FoodInsertFailureState(message: result?.error?.message ?? ''));
        } else if (foodRecord.id == null) {
          emit(FoodInsertFailureState(message: 'Something went wrong while inserting data.'));
        } else {
          emit(FoodInsertSuccessState(data: foodRecord));
        }
      }
    } catch (e) {
      emit(FoodInsertFailureState(message: e.toString()));
    }
  }

  Future<void> _handleDoFoodUpdateEvent(DoFoodUpdateEvent event, Emitter<DashboardState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      final result = await updateFoodRecordUseCase?.call((foodRecord: foodRecord, isNew: false));
      if (result?.error != null) {
        emit(FoodUpdateFailureState(message: result?.error?.message ?? ''));
      } else if (foodRecord.id == null) {
        emit(FoodUpdateFailureState(message: 'Something went wrong while inserting data.'));
      } else {
        emit(FoodUpdateSuccessState());
      }
    } catch (e) {
      emit(FoodInsertFailureState(message: e.toString()));
    }
  }

  Future<void> _handleDoFavouriteEvent(DoFavouriteEvent event, Emitter<DashboardState> emit) async {
    final foodRecord = event.data;
    if(foodRecord==null) {
      emit(FavoriteFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await updateFavouriteUseCase?.call((foodRecord: foodRecord, isNew: true));
    if (result?.error != null) {
      emit(FavoriteFailureState(message: result?.error?.message ?? ''));
    } else if (foodRecord.id == null) {
      emit(FavoriteFailureState(message: 'Something went wrong while inserting data.'));
    }
  }
}
