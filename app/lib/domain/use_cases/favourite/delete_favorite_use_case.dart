import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/favorite_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/base_api_usecase.dart';

class DeleteFavoriteUseCase with BaseApiUseCase<void, FoodRecord> {
  final FavoriteRepository favoriteRepository;

  DeleteFavoriteUseCase({required this.favoriteRepository});

  @override
  Future<({void response, APIError? error})> call(params) async {
    return await favoriteRepository.deleteFavorite(params);
  }
}
