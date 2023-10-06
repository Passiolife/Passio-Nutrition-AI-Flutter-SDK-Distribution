import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';

abstract class FavoriteRepository {
  Future<({APIError? error, List<FoodRecord?>? response})> fetchFavorites();
  Future<({void response, APIError? error})> updateFavorite(FoodRecord foodRecord, bool isNew);
  Future<({void response, APIError? error})> deleteFavorite(FoodRecord foodRecord);
}
