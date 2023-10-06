part of 'edit_food_item_bloc.dart';

@immutable
abstract class EditFoodItemEvent {}


class DoUpdateServingUnitEvent extends EditFoodItemEvent {
  final PassioFoodItemData? data;
  final String updatedUnitName;

  DoUpdateServingUnitEvent({required this.data, required this.updatedUnitName});
}

class DoUpdateQuantityEvent extends EditFoodItemEvent {
  final PassioFoodItemData? data;
  final double updatedQuantity;

  DoUpdateQuantityEvent({required this.data, required this.updatedQuantity});
}

class DoSliderUpdateEvent extends EditFoodItemEvent {
  final PassioFoodItemData? data;

  DoSliderUpdateEvent({required this.data});
}

class DoAlternateEvent extends EditFoodItemEvent {
  final PassioID? passioID;

  DoAlternateEvent({required this.passioID});
}

class DoUpdateServingSizeEvent extends EditFoodItemEvent {
  final PassioFoodItemData? data;
  final String? updatedUnitName;
  final double? updatedQuantity;

  DoUpdateServingSizeEvent({required this.data, required this.updatedUnitName, required this.updatedQuantity});
}
