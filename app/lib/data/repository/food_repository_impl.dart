import 'package:flutter_nutrition_ai_demo/data/core/network/network_info.dart';
import 'package:flutter_nutrition_ai_demo/data/datasources/food_record/food_record_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/food_repository.dart';

class FoodRepositoryImpl extends FoodRepository {
  final NetworkInfo networkInfo;

  final FoodRecordLocalDataSource localDataSource;

  FoodRepositoryImpl({required this.networkInfo, required this.localDataSource});

  @override
  Future<({APIError? error, List<FoodRecord?>? response})> fetchDayRecords(DateTime dateTime) async {
    try {
      final response = await localDataSource.fetchDayRecords(dateTime);
      return (response: response, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }

  @override
  Future<({APIError? error, void response})> deleteFoodRecord(FoodRecord foodRecord) async {
    try {
      await localDataSource.deleteFoodRecord(foodRecord);
      return (response: null, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }

  @override
  Future<({APIError? error, void response})> updateFoodRecord(FoodRecord foodRecord, bool isNew) async {
    try {
      await localDataSource.updateFoodRecord(foodRecord, isNew);
      return (response: null, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }
}
