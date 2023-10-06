import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';

abstract class FoodRepository {
  Future<({List<FoodRecord?>? response, APIError? error})> fetchDayRecords(DateTime dateTime);
  Future<({void response, APIError? error})> deleteFoodRecord(FoodRecord foodRecord);
  Future<({void response, APIError? error})> updateFoodRecord(FoodRecord foodRecord, bool isNew);
}
