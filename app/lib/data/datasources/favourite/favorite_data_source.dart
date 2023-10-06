import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';

abstract class FavoriteRecordDataSource {
  Future<List<FoodRecord>?> fetchFavorites();

  Future<void> updateFavorite(FoodRecord foodRecord, bool isNew);

  Future<void> deleteFavorite(FoodRecord foodRecord);
}
