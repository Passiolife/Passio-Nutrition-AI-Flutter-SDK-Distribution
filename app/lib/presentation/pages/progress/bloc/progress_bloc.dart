import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/domain/entity/time_log/time_log.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/fetch_day_records_use_case.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/progress/enum/progress_enums.dart';
import 'package:flutter_nutrition_ai_demo/util/date_time_utility.dart';
import 'package:flutter_nutrition_ai_demo/util/user_session.dart';

part 'progress_event.dart';

part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final UserSession userSession;
  final FetchDayRecordsUseCase fetchFoodRecordsUseCase;

  ProgressBloc({
    required this.userSession,
    required this.fetchFoodRecordsUseCase,
  }) : super(ProgressInitial()) {
    on<DoCalendarChangeEvent>(_handleDoCalendarChangeEvent);
    on<GetAllFoodDataEvent>(_handleGetAllFoodDataEvent);
  }

  FutureOr<void> _handleDoCalendarChangeEvent(DoCalendarChangeEvent event, Emitter<ProgressState> emit) async {
    // Getting selected time enum from selected time.
    final selectedTimeEnum =
        TimeEnum.values.cast<TimeEnum?>().firstWhere((element) => element?.name.toLowerCase() == event.time?.toLowerCase(), orElse: () => null);

    DateTime currentDateTime = DateTime.now();

    // start time for selected time enum for ex: if [selectedTimeEnum] is week then start time is currentDate-7.
    DateTime startTime;
    // end time for selected time enum for ex: if [selectedTimeEnum] is week then end time is currentDate.
    DateTime endTime;

    /// Here we are checking the selected time enum.
    /// Based on that we will update the [startTime] and [endTime].
    switch (selectedTimeEnum) {
      case TimeEnum.month:
        startTime = DateTime(currentDateTime.year, currentDateTime.month - 1, currentDateTime.day);
        endTime = currentDateTime;
        break;
      case TimeEnum.week:
        startTime = currentDateTime.subtract(const Duration(days: 7));
        endTime = currentDateTime;
        break;
      default:
        startTime = currentDateTime.subtract(const Duration(days: 1));
        endTime = currentDateTime;
        break;
    }

    /// [totalDays] counting total days between two dates.
    final totalDays = startTime.daysBetween(endTime);
    List<TimeLog> timeLogs = [];
    for (int i = 1; i <= totalDays; i++) {
      // Generating date based on loop.
      final dateTime = DateTime(startTime.year, startTime.month, startTime.day + i);
      // Fetching food record data from database.
      final result = await fetchFoodRecordsUseCase.call((dateTime: dateTime));
      // Checking is there any error while fetching food records.
      if (result.error != null) {
        // Emitting failure state to update the view.
        emit(TimeUpdateFailureState(message: result.error?.message ?? ''));
      } else {
        timeLogs.add(TimeLog(dateTime: dateTime, foodRecords: result.response ?? []));
      }
      // Emitting success state to update the view.
    }

    emit(TimeUpdateSuccessState(data: timeLogs, selectedDays: totalDays, selectedTimeEnum: selectedTimeEnum));
  }

  Future<void> _handleGetAllFoodDataEvent(GetAllFoodDataEvent event, Emitter<ProgressState> emit) async {}
}
