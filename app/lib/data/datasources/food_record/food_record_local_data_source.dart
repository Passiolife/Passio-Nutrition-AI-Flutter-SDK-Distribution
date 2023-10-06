import 'package:flutter_nutrition_ai_demo/data/datasources/food_record/food_record_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/passio_connector.dart';

class FoodRecordLocalDataSource extends FoodRecordDataSource {
  final PassioConnector connector;

  FoodRecordLocalDataSource({required this.connector});

  @override
  Future<List<FoodRecord>?> fetchDayRecords(DateTime dateTime) async {
    return connector.fetchDayRecords(dateTime);
  }

  @override
  Future<void> deleteFoodRecord(FoodRecord foodRecord) async {
    return connector.deleteRecord(foodRecord);
  }

  @override
  Future<void> updateFoodRecord(FoodRecord foodRecord, bool isNew) async {
    return await connector.updateRecord(foodRecord, isNew);
  }
}
