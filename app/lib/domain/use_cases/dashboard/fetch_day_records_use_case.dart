import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/food_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/base_api_usecase.dart';

class FetchDayRecordsUseCase with BaseApiUseCase<List<FoodRecord?>?, ({DateTime dateTime})> {
  final FoodRepository foodRepository;

  FetchDayRecordsUseCase({required this.foodRepository});

  @override
  Future<({List<FoodRecord?>? response, APIError? error})> call(params) async {
    return await foodRepository.fetchDayRecords(params.dateTime);
  }
}
