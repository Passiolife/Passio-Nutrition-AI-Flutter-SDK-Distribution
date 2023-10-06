import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';

abstract class FoodRecordDataSource {
  Future<List<FoodRecord>?> fetchDayRecords(DateTime dateTime);

  Future<void> deleteFoodRecord(FoodRecord foodRecord);

  Future<void> updateFoodRecord(FoodRecord foodRecord, bool isNew);
}
