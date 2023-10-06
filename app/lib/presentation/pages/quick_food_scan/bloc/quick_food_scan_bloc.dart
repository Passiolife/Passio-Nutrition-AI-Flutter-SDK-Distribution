import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/update_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/update_favorite_use_case.dart';
import 'package:flutter_nutrition_ai_demo/util/passio_id_attributes_extension.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'quick_food_scan_event.dart';

part 'quick_food_scan_state.dart';

class QuickFoodScanBloc extends Bloc<QuickFoodScanEvent, QuickFoodScanState> {
  final UpdateFoodRecordUseCase? updateFoodRecordUseCase;

  // Favourite use cases
  final UpdateFavoriteUseCase? updateFavouriteUseCase;

  QuickFoodScanBloc({
    this.updateFoodRecordUseCase,
    this.updateFavouriteUseCase,
  }) : super(QuickFoodScanInitial()) {
    on<RecognitionResultEvent>(_handleRecognitionResultEvent);
    on<ShowFoodDetailsViewEvent>(_handleShowFoodDetailsViewEvent);
    on<DoLogEvent>(_handleDoLogEvent);
    on<DoFavouriteEvent>(_handleDoFavouriteEvent);
  }

  Future _handleRecognitionResultEvent(RecognitionResultEvent event, Emitter<QuickFoodScanState> emit) async {
    /// [foodCandidates] from recognition result.
    final foodCandidates = event.foodCandidates;

    /// _displayed result
    final displayedResult = event.displayedResult;

    var passioID = foodCandidates.detectedCandidates.firstOrNull?.passioID;
    var barcode = foodCandidates.barcodeCandidates?.firstOrNull?.value;
    var packagedFoodCode = foodCandidates.packagedFoodCandidates?.firstOrNull?.packagedFoodCode;

    /// If the scan result is Bar code.
    if (barcode != null) {
      if (barcode != displayedResult) {
        final attributes = await NutritionAI.instance.fetchAttributesForBarcode(barcode);
        FoodRecord? foodRecord = attributes.toFoodRecord(dateTime: event.dateTime);
        emit(QuickFoodSuccessState(foodRecord: foodRecord, data: barcode));
      }
    }

    /// If the scan result is food package.
    else if (packagedFoodCode != null) {
      if (packagedFoodCode != displayedResult) {
        final attributes = await NutritionAI.instance.fetchAttributesForPackagedFoodCode(packagedFoodCode);
        FoodRecord? foodRecord = attributes.toFoodRecord(dateTime: event.dateTime);
        emit(QuickFoodSuccessState(foodRecord: foodRecord, data: packagedFoodCode));
      }
    }

    /// If the scan result is passioID.
    else if (passioID != null) {
      if (passioID != displayedResult) {
        final attributes = await NutritionAI.instance.lookupPassioAttributesFor(passioID);
        FoodRecord? foodRecord = attributes.toFoodRecord(dateTime: event.dateTime);
        emit(QuickFoodSuccessState(foodRecord: foodRecord, data: passioID));
      }
    }

    /// There is no any result then show searching UI.
    else {
      emit(QuickFoodLoadingState(isLoading: true));
    }
  }

  Future _handleShowFoodDetailsViewEvent(ShowFoodDetailsViewEvent event, Emitter<QuickFoodScanState> emit) async {
    emit(ShowFoodDetailsViewState(isVisible: event.isVisible));
  }

  FutureOr<void> _handleDoLogEvent(DoLogEvent event, Emitter<QuickFoodScanState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    if (event.data != null) {
      await updateFoodRecordUseCase?.call((foodRecord: foodRecord, isNew: true));
      emit(FoodInsertSuccessState());
    }
  }

  Future<void> _handleDoFavouriteEvent(DoFavouriteEvent event, Emitter<QuickFoodScanState> emit) async {
    final foodRecord = event.data;
    if (foodRecord == null) {
      emit(FavoriteFailureState(message: 'Something went wrong while parsing data.'));
      return;
    }
    final result = await updateFavouriteUseCase?.call((foodRecord: foodRecord, isNew: true));
    if (result?.error != null) {
      emit(FavoriteFailureState(message: result?.error?.message ?? ''));
    } else {
      emit(FavoriteSuccessState());
    }
  }
}
