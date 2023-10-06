part of 'edit_food_bloc.dart';

abstract class EditFoodState {}

class EditFoodInitial extends EditFoodState {}

// States for DoSliderUpdateEvent
class SliderUpdateState extends EditFoodState {
  final SliderData sliderData;

  SliderUpdateState({required this.sliderData});
}

class AlternateSuccessState extends EditFoodState {
  final FoodRecord? data;

  AlternateSuccessState({this.data});
}

/// States for DoAddIngredientsEvent
class AddIngredientsSuccessState extends EditFoodState {}

class AddIngredientsFailureState extends EditFoodState {}

// States for DoRemoveIngredientsEvent
class RemoveIngredientsState extends EditFoodState {}

class RefreshPageState extends EditFoodState {}

class UpdateAmountEditableState extends EditFoodState {
  final bool isEditable;

  UpdateAmountEditableState({required this.isEditable});
}
