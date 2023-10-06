import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';

mixin BaseApiUseCase<Response, Params> {
  Future<({Response? response, APIError? error})> call(Params params);
}
