import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/user_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/base_api_usecase.dart';

class UpdateUserProfileUseCase with BaseApiUseCase<void, ({UserProfileModel userProfile, bool isNew})> {
  final UserRepository userRepository;

  UpdateUserProfileUseCase({required this.userRepository});

  @override
  Future<({void response, APIError? error})> call(params) async {
    return await userRepository.updateUserProfile(params.userProfile, params.isNew);
  }
}
