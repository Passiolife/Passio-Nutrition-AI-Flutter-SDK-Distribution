import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/food_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/base_api_usecase.dart';

class UpdateFoodRecordUseCase with BaseApiUseCase<void, ({FoodRecord foodRecord, bool isNew})> {
  final FoodRepository foodRepository;

  UpdateFoodRecordUseCase({required this.foodRepository});

  @override
  Future<({void response, APIError? error})> call(params) async {
    return await foodRepository.updateFoodRecord(params.foodRecord, params.isNew);
  }
}
