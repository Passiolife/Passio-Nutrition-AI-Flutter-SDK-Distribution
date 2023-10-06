part of 'edit_food_bloc.dart';

abstract class EditFoodEvent {}

class DoUpdateUnitKeepWeightEvent extends EditFoodEvent {
  final FoodRecord? data;
  final String selectedUnitName;

  DoUpdateUnitKeepWeightEvent({required this.data, required this.selectedUnitName});
}

class DoUpdateQuantityEvent extends EditFoodEvent {
  final FoodRecord? data;
  final double updatedQuantity;

  DoUpdateQuantityEvent({required this.data, required this.updatedQuantity});
}

class DoUpdateServingSizeEvent extends EditFoodEvent {
  final FoodRecord? data;
  final String? updatedUnitName;
  final double? updatedQuantity;

  DoUpdateServingSizeEvent({required this.data, required this.updatedUnitName, required this.updatedQuantity});
}

class DoSliderUpdateEvent extends EditFoodEvent {
  final FoodRecord? data;

  DoSliderUpdateEvent({required this.data});
}

class DoAlternateEvent extends EditFoodEvent {
  final PassioID? passioID;

  DoAlternateEvent({required this.passioID});
}

class DoAddIngredientsEvent extends EditFoodEvent {
  final FoodRecord? data;
  final PassioIDAndName? ingredientData;

  DoAddIngredientsEvent({this.data, this.ingredientData});
}

class DoRemoveIngredientsEvent extends EditFoodEvent {
  final int index;
  final FoodRecord? data;

  DoRemoveIngredientsEvent({required this.index, this.data});
}

class RefreshPageEvent extends EditFoodEvent {}

class DoUpdateIngredientEvent extends EditFoodEvent {
  final int atIndex;
  final FoodRecord? data;
  final PassioFoodItemData? updatedFoodItemData;

  DoUpdateIngredientEvent({required this.atIndex, this.data, this.updatedFoodItemData});
}

class DoUpdateAmountEditableEvent extends EditFoodEvent {
  bool isEditable;

  DoUpdateAmountEditableEvent({required this.isEditable});
}
