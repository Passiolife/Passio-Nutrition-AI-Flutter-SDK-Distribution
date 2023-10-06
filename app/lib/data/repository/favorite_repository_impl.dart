import 'package:flutter_nutrition_ai_demo/data/datasources/favourite/favorite_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<({APIError? error, List<FoodRecord?>? response})> fetchFavorites() async {
    try {
      final response = await localDataSource.fetchFavorites();
      return (response: response, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }

  @override
  Future<({APIError? error, void response})> updateFavorite(FoodRecord foodRecord, bool isNew) async {
    try {
      await localDataSource.updateFavorite(foodRecord, isNew);
      return (response: null, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }

  @override
  Future<({APIError? error, void response})> deleteFavorite(FoodRecord foodRecord) async {
    try {
      await localDataSource.deleteFavorite(foodRecord);
      return (response: null, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }
}
