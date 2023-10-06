import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/favorite_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/base_api_usecase.dart';

class FetchFavoritesUseCase with BaseApiUseCase<List<FoodRecord?>?, dynamic> {
  final FavoriteRepository favoriteRepository;

  FetchFavoritesUseCase({required this.favoriteRepository});

  @override
  Future<({List<FoodRecord?>? response, APIError? error})> call(params) async {
    return await favoriteRepository.fetchFavorites();
  }
}
