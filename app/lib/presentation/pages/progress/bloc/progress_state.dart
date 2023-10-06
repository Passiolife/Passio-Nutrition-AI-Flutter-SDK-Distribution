part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {}

class ProgressInitial extends ProgressState {
  @override
  List<Object?> get props => [];
}

class TimeUpdateSuccessState extends ProgressState {
  final List<TimeLog> data;
  final TimeEnum? selectedTimeEnum;
  final int selectedDays;

  TimeUpdateSuccessState({required this.data, required this.selectedDays, required this.selectedTimeEnum});

  @override
  List<Object?> get props => [data, selectedTimeEnum, selectedDays];
}
class TimeUpdateFailureState extends ProgressState {
  final String message;

  TimeUpdateFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}