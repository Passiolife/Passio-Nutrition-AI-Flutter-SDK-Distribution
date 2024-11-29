part of 'search_food_semantic_bloc.dart';

abstract class SearchFoodSemanticEvent {}

class DoFoodSearchEvent extends SearchFoodSemanticEvent {
  final String searchQuery;

  DoFoodSearchEvent({required this.searchQuery});
}

class DoFetchFoodItemEvent extends SearchFoodSemanticEvent {
  final PassioFoodDataInfo foodInfo;

  DoFetchFoodItemEvent({required this.foodInfo});
}

class DoSubmitUserFoodEvent extends SearchFoodSemanticEvent {
  final PassioFoodItem foodItem;

  DoSubmitUserFoodEvent({required this.foodItem});
}

class DoReportFoodItem extends SearchFoodSemanticEvent {
  final String refCode;
  final String productCode;
  final List<String>? notes;

  DoReportFoodItem({this.refCode = '', this.productCode = '', this.notes});
}
