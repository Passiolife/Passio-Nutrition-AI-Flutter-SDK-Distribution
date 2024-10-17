part of 'food_search_bloc.dart';

abstract class FoodSearchEvent {}

class DoFoodSearchEvent extends FoodSearchEvent {
  final String searchQuery;

  DoFoodSearchEvent({required this.searchQuery});
}

class DoFetchFoodItemEvent extends FoodSearchEvent {
  final PassioFoodDataInfo foodInfo;

  DoFetchFoodItemEvent({required this.foodInfo});
}

class DoSubmitUserFoodEvent extends FoodSearchEvent {
  final PassioFoodItem foodItem;

  DoSubmitUserFoodEvent({required this.foodItem});
}

class DoReportFoodItem extends FoodSearchEvent {
  final String refCode;
  final String productCode;
  final List<String>? notes;

  DoReportFoodItem({this.refCode = '', this.productCode = '', this.notes});
}
