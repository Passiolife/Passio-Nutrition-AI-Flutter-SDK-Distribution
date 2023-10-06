part of 'edit_food_item_bloc.dart';

@immutable
abstract class EditFoodItemState {}

class FoodDetailsInitial extends EditFoodItemState {}

class FoodDetailsLoadingState extends EditFoodItemState {}

class FoodDetailsSuccessState extends EditFoodItemState {
  final PassioIDAttributes? passioIDAttributes;
  final bool shouldUpdateSlider;

  FoodDetailsSuccessState({this.passioIDAttributes, this.shouldUpdateSlider = true});
}

class FoodDetailsErrorState extends EditFoodItemState {}

class FoodQuantityUpdateState extends EditFoodItemState {
  final double quantity;

  FoodQuantityUpdateState({required this.quantity});
}

class FoodServingSizeState extends EditFoodItemState {
  final PassioServingSize? servingSize;

  FoodServingSizeState(this.servingSize);
}

class FoodServingUnitKeepWeightState extends EditFoodItemState {
  final PassioServingUnit? servingUnit;

  FoodServingUnitKeepWeightState(this.servingUnit);
}

/// States for [DoLogEvent]
class FoodInsertSuccessState extends EditFoodItemState {}

// States for DoSliderUpdateEvent
class SliderUpdateState extends EditFoodItemState {
  final SliderData sliderData;

  SliderUpdateState({required this.sliderData});
}

class AlternateSuccessState extends EditFoodItemState {
  final PassioFoodItemData? data;

  AlternateSuccessState({this.data});
}

/// States for DoAddIngredientsEvent
class AddIngredientsSuccessState extends EditFoodItemState {

}
class AddIngredientsFailureState extends EditFoodItemState {

}

// DoRemoveIngredientsEvent
class RemoveIngredientsState extends EditFoodItemState {

}