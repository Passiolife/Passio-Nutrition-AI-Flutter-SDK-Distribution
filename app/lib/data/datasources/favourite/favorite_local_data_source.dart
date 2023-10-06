import 'package:flutter_nutrition_ai_demo/data/datasources/favourite/favorite_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/passio_connector.dart';

class FavoriteLocalDataSource extends FavoriteRecordDataSource {
  final PassioConnector connector;

  FavoriteLocalDataSource({required this.connector});

  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    return await connector.fetchFavorites();
  }

  @override
  Future<void> updateFavorite(FoodRecord foodRecord, bool isNew) async {
    await connector.updateFavorite(foodRecord, isNew);
  }

  @override
  Future<void> deleteFavorite(FoodRecord foodRecord) async {
    return await connector.deleteFavorite(foodRecord);
  }
}
